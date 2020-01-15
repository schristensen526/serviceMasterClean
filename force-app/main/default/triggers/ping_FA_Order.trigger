trigger ping_FA_Order on Order__c (after insert, after update)
{
    String oid = 'ServiceMaster';//System.UserInfo.getOrganizationName();
   
    for(Order__c ord: Trigger.new)
    {
        Boolean doCall = false;
        Order__c oldOrd;
        if(Trigger.isUpdate)
        {
            oldOrd = Trigger.oldMap.get(ord.Id);
            if(oldOrd.Status__c !='Scheduled' && ord.Status__c=='Scheduled')
            {
                doCall = true;
            }
        }
        if(Trigger.isInsert)
        {
            
            if(ord.Status__c=='Scheduled')
            {
                doCall = true;
            }
        }
         if(doCall)
        {
            String ordID = ord.Id;
                   
            if(!Test.isRunningTest())   
                fieldAware.doCallout('Job',ordID,oid);
            
        } 
        
           
        
        
        
    }
}