trigger FATaskSync on Product__c (after insert,after update) {
/*
    if(FLDAWR.shouldIRun.canIRunTaskImplementationTrigger() ){
       
            list<FLDAWR__ClientFieldMapping__c>fmList = new list<FLDAWR__ClientFieldMapping__c>([select FLDAWR__ClientFieldName__c,FLDAWR__ClientObjectName__c,FLDAWR__FAFieldName__c,FLDAWR__FAObjectName__c,FLDAWR__IsActive__c,FLDAWR__isFASF__c from FLDAWR__ClientFieldMapping__c where FLDAWR__IsActive__c=:true and FLDAWR__isFASF__c =:false]);
            
            map<string,string> taskMapping = new map<string,string>();
            
            for(FLDAWR__ClientFieldMapping__c m:fmList){
                
                if(m.FLDAWR__FAObjectName__c == 'Task__c' && m.FLDAWR__IsActive__c ){
                    taskMapping.put(m.FLDAWR__FAFieldName__c,m.FLDAWR__ClientFieldName__c);
                }
            }
            list<FLDAWR__Task__c> tasks = new list<FLDAWR__Task__c>();
            
            for(Product__c a:trigger.new){ 
                    FLDAWR__Task__c t = new FLDAWR__Task__c();
                    t.FLDAWR__clientObjectId__c = a.id;
                    t.FLDAWR__isReady__c = true;
                    if(a.FieldAwareID__c != null)
                        t.FLDAWR__UUID__c = a.FieldAwareID__c;
                    for(string fAFieldName:taskMapping.keySet()){
                        String sFFieldName = taskMapping.get(fAFieldName);
                        t.put(fAFieldName,a.get(sFFieldName));
                    }
                    tasks.add(t);  
            }
            insert tasks;
    }
    */
}