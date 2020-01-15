Public class Order_ctrl{

public Order__c[] NewRecords {get;private set;}
public Order__c[] OldRecords {get;private set;}
public map<id,Order__c> NewMap {get;private set;}
public map<id,Order__c> OldMap {get;private set;}
public boolean IsBefore {get;private set;}
public boolean IsAfter {get;private set;}
public boolean IsInsert {get;private set;}
public boolean IsUpdate {get;private set;}
public boolean IsDelete {get;private set;}
public boolean IsUndelete {get;private set;}

//CONSTRUCTED FROM A TRIGGER
//Pass in all the trigger variables, and this will fire off our workflow
public Order_ctrl(sObject[] pNew, sObject[] pOld, map<id,sObject> pNewMap, map<id,sObject> pOldMap, boolean pIsBefore, boolean pIsAfter, boolean pIsInsert, boolean pIsUpdate, boolean pIsDelete, boolean pIsUndelete){
    NewRecords = pNew != null ? (Order__c[])pNew : null;
    OldRecords = pOld != null ? (Order__c[])pOld : null;
    NewMap = pNewMap != null ? (map<id,Order__c>)pNewMap : null;
    OldMap = pOldMap != null ? (map<id,Order__c>)pOldMap : null;
    IsBefore = pIsBefore;
    IsAfter  = pIsAfter;
    IsInsert = pIsInsert;
    IsUpdate = pIsUpdate;
    IsDelete = pIsDelete;
    IsUndelete = pIsUndelete;
    TriggerHandle();
}

public void TriggerHandle(){
    if(IsAfter && IsUpdate) {
        UseCouponCode();
        UpdateCouponCodes();
    }
    if(isBefore && IsInsert){
        SetPrimaryContact();
    }
}


//SET PRIMARY CONTACT
//Locates the contact role listed as 'primary' under the related account and sets it on the PrimaryContact field
public void SetPrimaryContact(){
    map<Id,Order__c[]> orderAccounts = new map<Id,Order__c[]>();
    for(Order__c r : NewRecords){
        if(r.Account__c != null && r.PrimaryContact__c == null){
            if(orderAccounts.get(r.Account__c) == null){
                orderAccounts.put(r.Account__c, new Order__c[]{});
            }
            OrderAccounts.get(r.Account__c).add(r);
        }
    }
    system.debug('UDBG::Order_ctrl.SetPrimaryContact: we have accountIds: ' + OrderAccounts.keySet());
    if(!orderAccounts.keySet().isEmpty()){
        AccountContactRole[] roles = [SELECT AccountId, ContactId FROM AccountContactRole WHERE AccountId IN :orderAccounts.keySet() AND IsPrimary = true];
        //Now we can find the primary ones
        for(AccountContactRole r : roles){
            for(Order__c o : OrderAccounts.get(r.AccountId)){
                o.PrimaryContact__c = r.ContactId;
            }
        }
    }
}

//USE COUPONCODE
//If an Order is updated from Draft to Scheduled, and it has a promo code: then the promo code must be used
public void UseCouponCode(){
    //Find all the orders that have gone from draft to scheduled that have promocodes, and update their uses
    for(Order__c r : NewRecords){
        string status = r.Status__c != null ? r.Status__c.toUpperCase() : null;
        string oldStatus = OldMap.get(r.Id).Status__c != null ? OldMap.get(r.Id).Status__c.toUpperCase() : null;
        if(status == 'SCHEDULED' && oldStatus == 'DRAFT' && r.CouponCode__c != null){ //We don't need to check the validity here because the validation rule on Order__c will do this for us
            CouponCode__c c = CouponCodes.get(r.CouponCode__c);
            //We will check that the coupon code supplied has a use left, and decrement it
            integer currentUsage = c.Uses__c != null ? integer.valueOf(c.Uses__c) : 0;
            c.Uses__c = currentUsage-1 > -1 ? currentUsage-1 : 0;
            CouponCodeUpdates.add(c.Id);
        }
    }
}

//UPDATE COUPON CODES
//Fires the update on any promocode id that is in the CouponCodeUpdates param
public void UpdateCouponCodes(){
    CouponCode__c[] r = new CouponCode__c[]{};
    for(id i : CouponCodeUpdates){
        if(CouponCodes.get(i) != null) {
            r.add(CouponCodes.get(i));
        }
    }
    
    if(!r.isEmpty()){
        Update r;
    }
}

//COUPONCODES to update
//Populate this set with the ids of promo codes that need updates.
//The UpdateCouponCodes method will then use these ids to pull out the promocode records
//    from the CouponCodes property to update those records
private set<id> CouponCodeUpdates{
    get {
        if(CouponCodeUpdates == null) {
            CouponCodeUpdates = new set<id>();
        }
        return CouponCodeUpdates;
    }
    private set;
}


//COUPONCODES
//A map of id->CouponCode
//Use this map to make updates to the promo code records sepcified on an Order - then add its id to 
//    to the CouponCodeUpdates set and call the UpdateCouponCodes method - do not manually update these records
public map<id,CouponCode__c> CouponCodes {
    get {
        if(CouponCodes == null) {
            CouponCodes = new map<id,CouponCode__c>(); 
            id[] ids = new id[]{};
            for(Order__c r : NewRecords) {
                if(r.CouponCode__c != null) {
                    ids.add(r.CouponCode__c);
                }
            }   
            string q = 'SELECT id, name, Valid__c, Uses__c FROM CouponCode__c WHERE id IN (\'' + String.join(ids,'\',\'') + '\')';
            system.debug('UDBG:Order_ctrl.CouponCodes: built query string: ' + q);
            sObject[] s = database.query('SELECT id, name, Valid__c, Uses__c FROM CouponCode__c WHERE id IN (\'' + String.join(ids,'\',\'') + '\')');
            system.debug('UDBG:Order_ctrl.CouponCodes: returned: ' + s);
            for(sObject o : s) {
                CouponCodes.put(o.Id,(CouponCode__c)o);
            }
        }
        return CouponCodes;
    }
    private set;
}
}