trigger FAContactSync on Contact(before insert,before update,after insert, after update) {
    /*
    if(Trigger.isBefore)
    {
         map<string,string> conAcctMap = new map<string,string>();  
         list<string> accountIDs = new list<string>(); 
         
         for(contact c:trigger.new){
            accountIDs.add(c.accountId);
         }  
         
         list<account> act = [select FieldAwareID__c from account where id in :accountIDs];  
         if(act.size() > 0){
            for(account a: act){
                if(a.FieldAwareID__c != null)   
                    conAcctMap.put(a.id,a.FieldAwareID__c); 
            }
         }
              
         for(contact c:trigger.new)
         {
              if(conAcctMap.get(c.accountId) != null)
                c.CustomerUUID__c = conAcctMap.get(c.accountId);     
         }
    }
    else
    {    
    
        if(FLDAWR.shouldIRun.canIRunContactImplementationTrigger())
        {    
            
            System.debug('*******Here*******');
            list<FLDAWR__contact__c> contacts = new list<FLDAWR__contact__c>();
            list<contact> syncContacts = new list<contact>();
            for(Contact a:trigger.new)
            {
                if(a.CustomerUUID__c != null && a.CustomerUUID__c != '')
                {
                    syncContacts.add(a);                   
                }   
            }
            if(syncContacts != null && syncContacts.size() > 0)
            {
                
                list<FLDAWR__ClientFieldMapping__c>fmList = new list<FLDAWR__ClientFieldMapping__c>([select FLDAWR__ClientFieldName__c,FLDAWR__ClientObjectName__c,FLDAWR__FAFieldName__c,FLDAWR__FAObjectName__c,FLDAWR__IsActive__c,FLDAWR__isFASF__c from FLDAWR__ClientFieldMapping__c where FLDAWR__IsActive__c=:true and FLDAWR__isFASF__c=:false]);
            
                map<string,string> customerMapping = new map<string,string>();
                map<string,string> contactMapping = new map<string,string>();
                map<string,string> locationMapping = new map<string,string>();
                map<string,string> jobMapping = new map<string,string>();
                
                map<string,string> acctCustMap = new map<string,string>();
                
                map<string,string> acctLocMap = new map<string,string>();
                
                for(FLDAWR__ClientFieldMapping__c m:fmList) 
                {
                             
                    if(m.FLDAWR__FAObjectName__c == 'Contact__c')
                    {
                        contactMapping.put(m.FLDAWR__FAFieldName__c,m.FLDAWR__ClientFieldName__c);
                    }   
                }
                
                for(Contact a:syncContacts)
                {
                    FLDAWR__contact__c c = new FLDAWR__contact__c();
                    c.FLDAWR__clientObjectId__c = a.id;
                    for(string fAFieldName:contactMapping.keyset())
                    {
                        String sFFieldName = contactMapping.get(fAFieldName);
                        System.debug('fAFieldName :'+ fAFieldName + '     sFFieldName :'+sFFieldName);
                        c.put(fAFieldName,a.get(sFFieldName));                
                    }
                     c.FLDAWR__isReady__c = true;           
                    contacts.add(c);
                }
            }
            insert contacts;             
        }    
    }  */   
}