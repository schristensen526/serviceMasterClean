@isTest
private class TEST_QuoteBuilder{

static testMethod void test01(){
    TimeSlot__c t = TEST_Helper.testTimeSlot00;
    Product__c p = TEST_Helper.testProduct00;
    CouponCode__c cc = TEST_Helper.testCouponCode00;

    QuoteBuilder c = new QuoteBuilder();
    
    //The config map is populated when implemented (probably a vf component)
    c.ConfigMap.put('PRODUCT_QUERY_STRING', 'SELECT Id, Name, RecordType.Name, Type__c, Service__c, Price__c, Quantity__c FROM Product__c ORDER BY Quantity__c ASC');
    c.ConfigMap.put('AREA_RUG_HANDLING_FEE', '25');
    c.ConfigMap.put('MINIMUM_CALL_FEE', '99');
    c.ConfigMap.put('MINIMUM_CALL_FEE_AREA_RUG', '125');
    c.ConfigMap.put('TIMESLOT_QUERY_FIELDS', 'Id, Name, MaxBookings__c');
    c.ConfigMap.put('TIMESLOT_ORDER_QUERY_FIELDS', 'id, Date__c');
    c.ConfigMap.put('TIMESLOT_ORDER_QUERY_STATUS_CLAUSE', '\'Scheduled\',\'Confirmed\',\'Complete\'');
    c.ConfigMap.put('ORDER_QUERY_FIELDS', 'Id, Name, FirstName__c, LastName__c, Email__c, Phone__c, AddressLine1__c, AddressLine2__c, City__c, StateProvince__c, Country__c, ZipPostalCode__c, Date__c, TimeSlot__c');
    c.ConfigMap.put('COUPON_CODE_QUERY_FIELDS', 'Id, Name, Valid__c, DiscountPercent__c');
    
    //The user first views all products
    system.assert(c.ProductsJSON != null);
    
    //he then navigates to the order page, and fills out information in the order
    c.Order.FirstName__c = 'testFirstName';
    c.Order.LastName__c = 'testLastName';
    c.Order.Email__c = 'test@email.com';
    c.Order.Phone__c = '1234567890';
    c.Order.AddressLine1__c = 'testAddress1';
    c.Order.City__c = 'testCity';
    c.Order.StateProvince__c = 'Ablerta';
    c.Order.ZipPostalCode__c = 'A1A1A1';
    c.Order.Country__c = 'Canada';
    
    //He then calls the save function to go to the next page
    system.assert(c.toSchedule() != null);
    
    //Once on this page - he chooses the time slot and date
    system.assert(c.TimeSlotsJSON != null);
    c.ConfigMap.put('SELECTED_DATE','2015-01-01');
    c.ConfigMap.put('SELECTED_TIMESLOT_ID',t.Id);
    c.setDateTime();
    
    //The user can apply a coupon code as well
    c.ConfigMap.put('COUPONCODE',cc.Name);
    system.assert(c.CouponCodeJSON != null);
    
    //He then reviews the order, and submits it
    string s = JSON.serialize(new OrderLineItem__c[]{
        new OrderLineItem__c(
            Product__c = p.id,
            Price__c = p.Price__c,
            Quantity__c = 1
        )
    });
    c.SelectedOrderLinesJSON = s;
    
    c.submit();
    
    
    system.assert(c.TimeSlotsJSON != null);
    system.assert(c.Order != null);
    system.assert(c.ProductSelects != null);
    system.assert(c.SelectedProducts != null);
    
    
}

}