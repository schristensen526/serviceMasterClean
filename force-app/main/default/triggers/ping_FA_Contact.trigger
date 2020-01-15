trigger ping_FA_Contact on Contact (after insert, after update) {

String oid = 'ServiceMaster';//System.UserInfo.getOrganizationName();
    for(Contact co: Trigger.new){
         
            String coID = co.Id; 
            system.debug('coID :'+coID );
            if(!Test.isRunningTest())       
                fieldAware.doCallout('Contact',coID,oid);
    }
}