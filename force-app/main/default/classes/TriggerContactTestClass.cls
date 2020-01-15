@isTest 
private class TriggerContactTestClass {
    static testMethod void validateContactTrigger() {
     
       Contact co = new Contact(FirstName='Ewe',LastName='Dummy');
        insert co;
       String oid = System.UserInfo.getOrganizationName();
       System.debug('oid' + oid);
        System.assertEquals('ServiceMaster Residential', oid);

    }
}