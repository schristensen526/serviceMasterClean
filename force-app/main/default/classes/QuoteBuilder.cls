public with sharing class QuoteBuilder {
public QuoteBuilder getThis(){
    return this;
}
/* QUOTE BUILDER VF INTERFACE
 *
 * Specifically handles the quote builder interface functions on the QuoteBuilder.page
 */

public map<string,string> ConfigMap{
    get {
        if(ConfigMap == null) {
            ConfigMap = new map<string,string>();
        }
        return ConfigMap;
    }
    private set;
}

//TIME SLOTS
public string TimeSlotsJSON {
    get {
        return JSON.serialize(TimeSlots);
    }
    private set;
}
private TimeSlot__c[] TimeSlots{
    get {
        if(TimeSlots == null) {
            TimeSlots = database.query('SELECT ' + ConfigMap.get('TIMESLOT_QUERY_FIELDS') + 
            ', (SELECT ' + ConfigMap.get('TIMESLOT_ORDER_QUERY_FIELDS') +
            ' FROM Orders__r WHERE Status__c IN(' + ConfigMap.get('TIMESLOT_ORDER_QUERY_STATUS_CLAUSE') +')' + 
            (Order.Id != null ? ' AND Id != \'' + Order.Id + '\'' : '') +
            ') FROM TimeSlot__c ORDER BY Order__c ASC');
        }
        return TimeSlots;
    }
    private set;
}

//ORDER
//The main order object that the user will be filling out
public Order__c Order{
    get {
        if(Order == null) {
            //We can attempt to recover the order from the cookie
            Cookie orderCookie = ApexPages.currentPage().getCookies().get('serviceMaster_orderId');
            system.debug('QuoteBuilder.Order: got cookie: ' + orderCookie);
            if(orderCookie != null && orderCookie.getValue() != null && orderCookie.getValue().deleteWhiteSpace() != '') {
                try {
                    Order = database.query('SELECT ' + ConfigMap.get('ORDER_QUERY_FIELDS') + ' FROM Order__c WHERE id = \'' + orderCookie.getValue() + '\' LIMIT 1');
                } catch (exception e) {
                    system.debug('QuoteBuilder.Order: got an exception when attempting to get the Order from the cookie: ' + e.getMessage());
                    Order = new Order__c();
                }
            } else {
                Order = new Order__c();
            }
        }
        return Order;
    }
    private set;
}

//Set Date time
public void setDateTime(){
    Order.Date__c = Date.ValueOf(ConfigMap.get('SELECTED_DATE'));
    Order.TimeSlot__c = ConfigMap.get('SELECTED_TIMESLOT_ID');
    upsertOrder();
}

//PRODUCT SELECT OPTIONS
//Builds a map of product config key to lists of select options
//Intelligently determines that if we have 1 product in the config key, then it is un-quantified (the user tells us how many he wants) or
//    will create a list of 10 options
public map<string,SelectOption[]> ProductSelects{
    get {
        if(ProductSelects == null) {
            ProductSelects = new map<string, SelectOption[]>();
            for(string s : Products.keySet()){
                ProductSelects.put(s,new SelectOption[]{});
                ProductSelects.get(s).add(new SelectOption('0','0'));
                if(Products.get(s).size() == 1){
                    //We create a set of 10 select options with the SAME product id, and incrementing quantities
                    for(integer i = 0; i < 10; i++) {
                        ProductSelects.get(s).add(new SelectOption(
                            Products.get(s)[0].Id + '-' + (i+1), //The quantity incrememnts
                            string.valueOf(i+1)
                        ));
                    }
                } else if(Products.get(s).size() > 1){
                    //We create a different select option for each product
                    for(Product__c p : Products.get(s)) {
                        ProductSelects.get(s).add(new SelectOption(
                            p.Id + '-1', //Look its a single quantity
                                (p.Quantity__c != null ? string.valueOf(p.Quantity__c): '0')
                        ));
                    }
                }
            }
        }
        return ProductSelects;
    }
    private set;
}

//SELECT PRODUCTS JSON
//The payload of Order Lines (array) will be delivered here
public string SelectedOrderLinesJSON {get;set;}
public OrderLineItem__c[] SelectedProducts {
    get {
        OrderLineItem__c[] r = new OrderLineItem__c[]{};
        if(SelectedOrderLinesJSON != null && SelectedOrderLinesJSON.deleteWhiteSpace() != '') {
            r = (OrderLineItem__c[])JSON.deserializeStrict(SelectedOrderLinesJSON, List<OrderLineItem__c>.class);
        }
        return r;
    }
}

//TO SCHEDULE
public PageReference toSchedule(){
    pageReference p = new ApexPages.PageReference('/apex/QuoteBuilder_schedule').setRedirect(true);
    if(!upsertOrder()){
        p = null;
    }
    return p;
}

//FINISH AND SUBMIT
public string submitMessage {get;private set;}
public void Submit(){
    try {
        //We set the status to scheduled
        Order.Status__c = 'Scheduled';
        map<string,object> m = getCouponCodeResponse();
        if(m.get('couponcode') != null) {
            Order.CouponCode__c = ((CouponCode__c)m.get('couponcode')).Id;
        }
        UpsertOrder();
        //We REMOVE the cookie iwth a 0 second lifespan
        ApexPages.currentPage().setCookies(new Cookie[]{
            new Cookie('serviceMaster_orderId', Order.id,null,0,false)
        });
        
        OrderLineItem__c[] lines = SelectedProducts;
        if(lines != null && lines.size() > 0){
            for(OrderLineItem__c o : lines) {
                o.Order__c = Order.Id;
            }
            insert lines;
        }
        submitMessage = 'success';
    } catch (exception e) {
        ApexPages.addMessages(e);
    }
}

//UPSERT ORDER
//Tries to upsert the order
private boolean upsertOrder(){
    boolean b = true;
    try {
        upsert Order;
        //Create a cookie with the order id for one hour -->
        ApexPages.currentPage().setCookies(new Cookie[]{
            new Cookie('serviceMaster_orderId', Order.id,null,86400,false)
        });
    } catch (exception e) {
        ApexPages.addMessages(e);
        b = false;
    }
    return b;
}


///////////////////////////// COUPON CODE //////////////////////////////
//Coupon Code JSON - converts the getCouponCodeResponse to JSON to be interpreted by VF
public string CouponCodeJSON {
    get {
        return JSON.serialize(getCouponCodeResponse());
    }
    set;
}
//GET COUPON CODE RESPONSE
//Creates a map of response data when a coupon code has been submutted
private map<string,object> getCouponCodeResponse(){
    CouponCode__c c = getCouponCode(); 
    map<string,object> m = new map<string,object>();
    m.put('message',c == null ? 'notfound' : !c.Valid__c ? 'invalid' : 'success');
    m.put('couponcode',m.get('message') == 'success' ? c : null);
    return m;
}
//GET COUPON CODE
//Finds the config maps coupon code name, and attempts to query the DB for the value and return it. Returns null if not found
private CouponCode__c getCouponCode(){
    string s = ConfigMap.get('COUPONCODE') != null ? ConfigMap.get('COUPONCODE').trim() : null;
    CouponCode__c c = null;
    if(s != null) {
        CouponCode__c[] cs = (CouponCode__c[])database.query('SELECT ' + ConfigMap.get('COUPON_CODE_QUERY_FIELDS') + ' FROM CouponCode__c WHERE Name = \'' + s + '\' LIMIT 1');
        c = !cs.isEmpty() ? cs[0] : null;
    }
    return c;
}


//PRODUCTS
//A Map of product key: (record type, service, type) to list of products ordered by ORDER
public map<string,Product__c[]> Products {
    get {
        if(Products == null) {
            Products = new map<string,Product__c[]>();
            Product__c[] ps = (Product__c[])database.Query(ConfigMap.get('PRODUCT_QUERY_STRING'));

            for(Product__c p : ps) {
                string key = Utilities.SystemizeString(p.RecordType.Name) + '_' + Utilities.SystemizeString(p.Service__c) + '_' + Utilities.SystemizeString(p.Type__c);
                if(Products.get(key) == null) {
                    Products.put(key, new Product__c[]{});
                }
                Products.get(key).add(p);
            }
        }
        return Products;
    }
    private set;
}
public string ProductsJSON {
    get {
        return JSON.serialize(Products);
    }
    private set;
}

}