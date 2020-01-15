@isTest 
private class TriggerAccountTestClass {
    static testMethod void accountTriggerTest() {
        Contact c = new Contact();
        c.lastName = 'test contact ';
        insert c;       
       Account ac = new Account(Name='dummy',Sync_to_FieldAware__c='Ready to Sync');
        insert ac;
       String oid = System.UserInfo.getOrganizationName();
       System.debug('oid' + oid);
        System.assertEquals('ServiceMaster Residential', oid);

    }
}