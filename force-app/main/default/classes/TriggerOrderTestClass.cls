@isTest 
private class TriggerOrderTestClass {
    static testMethod void TestMetod1() {
    
        Account a = new Account(name='testAccount');
        insert a;
        
        Contact c = new Contact(accountid= a.id);        
        c.lastName = 'test contact ';
        insert c;  
        
        TimeSlot__c ts = new TimeSlot__c(FromHour__c=9, FromMinute__c = 15, ToHour__c =  12, ToMinute__c = 15);
        insert ts;
        order__c ord = new order__c(Job_Type__c = 'Exterior',Email__c = 'd@g.com' ,Phone__c = '4555555555',AddressLine1__c = 'test street 1',City__c= 'Dallas',Contact__c=c.Id,account__c=a.id,Status__c='Scheduled',Date__c = Date.today(),TimeSlot__c = ts.id);
        insert ord;
       String oid = System.UserInfo.getOrganizationName();
       System.debug('oid' + oid);
        System.assertEquals('ServiceMaster Residential', oid);

    }
}