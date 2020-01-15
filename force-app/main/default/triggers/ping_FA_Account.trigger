trigger ping_FA_Account on Account (after insert, after update) {
String oid = 'ServiceMaster';
    for(Account ac: Trigger.new)
    {
        if(ac.Sync_to_FieldAware__c=='Ready to Sync'){
            String acID = ac.Id; 
            system.debug('acID :'+acID );
             if(!Test.isRunningTest())       
                fieldAware.doCallout('Account',acID,oid);
        }
    }
}