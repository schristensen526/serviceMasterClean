Public class CouponCode_ctrl{

public CouponCode__c[] NewRecords {get;private set;}
public CouponCode__c[] OldRecords {get;private set;}
public map<id,CouponCode__c> NewMap {get;private set;}
public map<id,CouponCode__c> OldMap {get;private set;}
public boolean IsBefore {get;private set;}
public boolean IsAfter {get;private set;}
public boolean IsInsert {get;private set;}
public boolean IsUpdate {get;private set;}
public boolean IsDelete {get;private set;}
public boolean IsUndelete {get;private set;}

//CONSTRUCTED FROM A TRIGGER
//Pass in all the trigger variables, and this will fire off our workflow
public CouponCode_ctrl(sObject[] pNew, sObject[] pOld, map<id,sObject> pNewMap, map<id,sObject> pOldMap, boolean pIsBefore, boolean pIsAfter, boolean pIsInsert, boolean pIsUpdate, boolean pIsDelete, boolean pIsUndelete){
    NewRecords = pNew != null ? (CouponCode__c[])pNew : null;
    OldRecords = pOld != null ? (CouponCode__c[])pOld : null;
    NewMap = pNewMap != null ? (map<id,CouponCode__c>)pNewMap : null;
    OldMap = pOldMap != null ? (map<id,CouponCode__c>)pOldMap : null;
    IsBefore = pIsBefore;
    IsAfter  = pIsAfter;
    IsInsert = pIsInsert;
    IsUpdate = pIsUpdate;
    IsDelete = pIsDelete;
    IsUndelete = pIsUndelete;
    TriggerHandle();
}

public void TriggerHandle(){
    if(IsBefore && IsUpdate) {
        Validate();
    }
}

//VALIDATE CODES
//Checks to see if the Uses__c are 0 or less and invalidates the code otherwise valdates it
public void Validate(){
    for(CouponCode__c r : NewRecords){
        r.Uses__c = r.Uses__c != null && r.Uses__c > -1 ? r.Uses__c : 0;
        r.Valid__c = r.Uses__c > 0 ? true : false;
    }
}


}