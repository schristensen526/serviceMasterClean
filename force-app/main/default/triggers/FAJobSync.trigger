trigger FAJobSync on Order__c(after insert, after update) {

/*
    if (FLDAWR.shouldIRun.canIRunJobImplementationTrigger() == true) {
        
        list<Order__c> processOrders = new list<Order__c>();
        for (Order__c ord: Trigger.new) {
            Boolean doCall = false;
            Order__c oldOrd;
            if (Trigger.isUpdate) {
                //oldOrd = Trigger.oldMap.get(ord.Id);
                if (ord.Location_UUID__c != null) {
                    doCall = true;
                }
            }
            if (Trigger.isInsert) {
                if (ord.Location_UUID__c != null) {
                    doCall = true;
                }
            }
            if (doCall) 
            { 
                processOrders.add(ord);
            }
         }
         if(processOrders != null && processOrders.size() > 0)
         {
                list < FLDAWR__ClientFieldMapping__c > fmList = new list < FLDAWR__ClientFieldMapping__c > ([select FLDAWR__ClientFieldName__c, FLDAWR__ClientObjectName__c, FLDAWR__FAFieldName__c, FLDAWR__FAObjectName__c, FLDAWR__IsActive__c,FLDAWR__isFASF__c from FLDAWR__ClientFieldMapping__c where FLDAWR__IsActive__c = : true and FLDAWR__isFASF__c=:false]);

                map < string, string > jobMapping = new map < string, string > ();
                map<string,string> taskLineMapping = new map<string,string>();
                for (FLDAWR__ClientFieldMapping__c m: fmList) {
                    if (m.FLDAWR__FAObjectName__c == 'Job__c') {
                        jobMapping.put(m.FLDAWR__FAFieldName__c, m.FLDAWR__ClientFieldName__c);
                    }
                    if(m.FLDAWR__FAObjectName__c == 'TaskLine__c')
                    {
                        taskLineMapping.put(m.FLDAWR__FAFieldName__c,m.FLDAWR__ClientFieldName__c);
                    }
                }

                list < FLDAWR__Job__c > jobs = new list < FLDAWR__Job__c > ();
                list < Id > orderIds = new list < Id > ();
                for (Order__c o: processOrders) {
                    FLDAWR__Job__c j = new FLDAWR__Job__c();
                    j.FLDAWR__clientObjectId__c = o.id;
                    j.FLDAWR__LocationUUID__c = o.Location_UUID__c;
                    Date ordDate = o.date__c;
                    Datetime dt = datetime.newInstance(ordDate.year(), ordDate.month(),ordDate.day());
                    j.FLDAWR__ScheduledOn__c = dt;
                    //j.FLDAWR__isReady__c = true;
                    System.debug('o.Location_UUID__c : ' + o.Location_UUID__c);

                    for (string fAFieldName: jobMapping.keyset()) {
                        String sFFieldName = jobMapping.get(fAFieldName);
                        System.debug('fAFieldName :' + fAFieldName + '     sFFieldName :' + sFFieldName);
                        j.put(fAFieldName, o.get(sFFieldName));
                    }                    
                    jobs.add(j);
                    orderIds.add(o.Id);                    
                }
                FLDAWR.shouldIRun.stopJobImplementationTrigger();
                            
                    //insert jobs;
                    //FLDAWR.shouldIRun.stopJobImplementationTrigger();
            if(Trigger.isInsert)
            {
                for(FLDAWR__Job__c j:jobs)        
                {
                    j.FLDAWR__isReady__c = true;
                }
                insert jobs;
            }
            else if(Trigger.isUpdate)
            {
                if(jobs != null && jobs.size() >0)
                {
                                    
                    insert jobs;
                    map<string,string> orderJobMap = new map <string,string>();
                    for(FLDAWR__Job__c jb:jobs)
                    {
                        orderJobMap.put(jb.FLDAWR__clientObjectId__c,jb.Id);
                    } 
                    
                    list<FLDAWR__TaskLine__c> taskLines = new list<FLDAWR__TaskLine__c>();    
                                
                    string orderitemquery = 'Select '+FAUtils.createQueryFieldString('OrderLine')+',Product__r.FieldAwareId__c From OrderLineItem__c o where Order__c in :orderIds order by CreatedDate';
                    list<OrderLineItem__c> ordItems = Database.query(orderitemquery);
                    System.debug(' ordItems : '+ordItems);
                    map<string,list<FLDAWR__TaskLine__c>>  orderTasks = new map<string,list<FLDAWR__TaskLine__c>>();
                    
                    //Read the Custom setting "DefaultTaskLinePriceBookID"to create a taskLine equivalent order product 
                    FLDAWR__FieldAwareSetting__c myCS1 = FLDAWR__FieldAwareSetting__c.getValues('NoProductUUID');
            
                    String NoProdUUID = myCS1.FLDAWR__Value__c;
            
                   
                      
                    for(OrderLineItem__c oi:ordItems)
                    {
                             FLDAWR__TaskLine__c atl = new  FLDAWR__TaskLine__c();
                             for(string fAFieldName:taskLineMapping.keyset())
                             {
                                String sFFieldName = taskLineMapping.get(fAFieldName);
                                System.debug('fAFieldName :'+ fAFieldName + '     sFFieldName :'+sFFieldName);
                                atl.put(fAFieldName,oi.get(sFFieldName));                
                             }   
                            
                             atl.FLDAWR__Job__c = orderJobMap.get(oi.Order__c);
                             if(oi.Product__c == null)
                             {
                                atl.FLDAWR__TaskUUID__c = NoProdUUID;
                             }
                             else                   
                             atl.FLDAWR__TaskUUID__c = oi.Product__r.FieldAwareId__c;                   
                             
                             atl.FLDAWR__clientObjectId__c = oi.Id; 
                             taskLines.add(atl);
                             
                            list<FLDAWR__TaskLine__c> tlines = orderTasks.get(oi.Order__c);
                            if(tlines == null )
                            {                       
                                tlines = new list<FLDAWR__TaskLine__c>();
                            }
                            tlines.add(atl);
                            orderTasks.put(oi.Order__c,tlines);
                        
                    }
                    
                    insert taskLines;
                    System.debug('taskLines '+taskLines);
                    
                    for(FLDAWR__Job__c jb:jobs)
                    {
                        jb.FLDAWR__isReady__c = true;
                    }
                    
                    update jobs;
                }
            }         
        }
    }  */   
}