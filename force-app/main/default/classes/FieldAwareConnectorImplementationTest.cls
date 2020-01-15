@isTest()
public class FieldAwareConnectorImplementationTest {

 static testMethod void testFASFCustomerTrigger() {
     
    test.startTest(); 
     /*
     FLDAWR__ClientFieldMapping__c cfm = new FLDAWR__ClientFieldMapping__c();
     cfm.FLDAWR__FAObjectName__c = 'Customer__c';
     cfm.FLDAWR__FAFieldName__c = 'Name';
     cfm.FLDAWR__ClientObjectName__c = 'Account';
     cfm.FLDAWR__ClientFieldName__c  =   'Name';
     cfm.FLDAWR__IsActive__c = true;
     
     cfm.FLDAWR__FAObjectName__c = 'Customer__c';
     cfm.FLDAWR__FAFieldName__c = 'FLDAWR__UUID__c';
     cfm.FLDAWR__ClientObjectName__c = 'Account';
     cfm.FLDAWR__ClientFieldName__c  = 'FieldAwareId__c';
     cfm.FLDAWR__IsActive__c = true;
         
     insert cfm;
     */
     Account a = new Account();
     a.name = 'test';
     a.Sync_to_FieldAware__c = 'Ready to Sync';
     insert a;
     
     
     
     /*FLDAWR__Location__c  loc = new FLDAWR__Location__c();
     loc.FLDAWR__isSFPush__c = true;
     loc.FLDAWR__clientObjectId__c = 'dfg';
     
     insert loc;
     
     FLDAWR__Customer__c cu = new FLDAWR__Customer__c();
     
     cu.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';
     cu.Name = 'test';
     cu.FLDAWR__clientObjectId__c = a.Id;
     cu.FLDAWR__isSFPush__c = true;
     
     insert cu;
     
     FLDAWR__Customer__c cu1 = new FLDAWR__Customer__c();
     
     cu1.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';
     cu1.Name = 'test';
     cu1.FLDAWR__isSFPush__c = true;
     
     insert cu1;*/
      
    test.stopTest();
    }
   
    
    static testMethod void testFASFAttachmentTrigger() {
     
    test.startTest(); 
     Account a = new Account();
     a.name = 'test';
     //a.LocationUUID__c = 'adasadadasd';
     insert a;
        
     Order__c ord = new Order__c();
     ord.Account__c   = a.Id;
     ord.Date__c = date.today();
     ord.FieldAwareID__c = '123456';
     ord.Job_Type__c  = 'In-Home';
     ord.Email__c   = 'n@r.com';
     ord.Phone__c   = '23456789801';
     ord.AddressLine1__c = '1234 test Street';
     ord.City__c = 'san fran';   
     insert ord;   
     /*
     FLDAWR__ClientFieldMapping__c cfm = new FLDAWR__ClientFieldMapping__c();
     cfm.FLDAWR__FAObjectName__c = 'Job__c';
     cfm.FLDAWR__FAFieldName__c = 'Description__c';
     cfm.FLDAWR__ClientObjectName__c = 'Order__c';
     cfm.FLDAWR__ClientFieldName__c  =   'Comments__c';       
     cfm.FLDAWR__IsActive__c = true;    
      insert cfm;
     FLDAWR__Attachment__c at = new FLDAWR__Attachment__c();
     
     at.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';
     at.FLDAWR__ParentObjectName__c = 'Job/Task';
     at.FLDAWR__ParentObjectUUID__c = '123456/asdadsasdasda';     
     at.FLDAWR__isSFPush__c = true;
     
     insert at;*/
    test.stopTest();
    }
    
    static testMethod void testFASFJobTrigger() {
     
    test.startTest();
    
    //FLDAWR__FieldAwareSetting__c myCS1 = FLDAWR__FieldAwareSetting__c.getValues('NoProductUUID');
    //String noProductUUID = myCS1.FLDAWR__Value__c;
   /* 
    FLDAWR__FieldAwareSetting__c aSetting = new  FLDAWR__FieldAwareSetting__c();
    aSetting.name = 'NoProductUUID';
    aSetting.FLDAWR__Value__c = '2342342423423423';
    
    insert aSetting;
    
     */
     Account a = new Account();
     a.name = 'test';
     a.BillingStreet = '123 street';
     a.BillingCity = 'Miami';
     a.BillingState = 'Florida';
     a.BillingCountry = 'USA';   
     a.LocationUUID__c = '234234234';
     a.FieldAwareID__c = 'szffsdfsdfs';
     insert a;
        
     Order__c ord = new Order__c();
     ord.Account__c   = a.Id;
     ord.Date__c = date.today();
     ord.FieldAwareID__c = '123456';
     ord.Job_Type__c  = 'In-Home';
     ord.Email__c   = 'n@r.com';
     ord.Phone__c   = '23456789801';
     ord.AddressLine1__c = '1234 test Street';
     ord.City__c = 'san fran';
     ord.Status__c = 'Scheduled';
     insert ord; 
     
     
     
     OrderLineItem__c oli = new OrderLineItem__c();
     oli.Order__c = ord.Id;
     oli.Quantity__c = 2;
     oli.Description__c = 'Some Description';
     oli.FieldAwareId__c = 'aoliid';
     oli.Price__c = 23.34;
     
     insert oli;  
     
     //ord.Comments__c = 'updated';
     ord.put('Comments__c','updated');
     
     update ord;
     /*
     list<FLDAWR__ClientFieldMapping__c> cfmList = new list<FLDAWR__ClientFieldMapping__c>();
     FLDAWR__ClientFieldMapping__c cfm = new FLDAWR__ClientFieldMapping__c();
     cfm.FLDAWR__FAObjectName__c = 'Job__c';
     cfm.FLDAWR__FAFieldName__c = 'FLDAWR__JobDescription__c';
     cfm.FLDAWR__ClientObjectName__c = 'Order__c';
     cfm.FLDAWR__ClientFieldName__c  =   'Comments__c';       
     cfm.FLDAWR__IsActive__c = true;
     cfmList.add(cfm); 
     FLDAWR__ClientFieldMapping__c cfm2 = new FLDAWR__ClientFieldMapping__c();
     cfm2.FLDAWR__FAObjectName__c = 'TaskLine__c';
     cfm2.FLDAWR__FAFieldName__c = 'FLDAWR__UUID__c';
     cfm2.FLDAWR__ClientObjectName__c = 'OrderLineItem__c';
     cfm2.FLDAWR__ClientFieldName__c  =   'FieldAwareId__c';       
     cfm2.FLDAWR__IsActive__c = true;
     cfmList.add(cfm2);
     FLDAWR__ClientFieldMapping__c cfm3 = new FLDAWR__ClientFieldMapping__c();
     cfm3.FLDAWR__FAObjectName__c = 'TaskLine__c';
     cfm3.FLDAWR__FAFieldName__c = 'FLDAWR__Notes__c';
     cfm3.FLDAWR__ClientObjectName__c = 'OrderLineItem__c';
     cfm3.FLDAWR__ClientFieldName__c  =   'Description__c';       
     cfm3.FLDAWR__IsActive__c = true;
     cfmList.add(cfm3);
     
     FLDAWR__ClientFieldMapping__c cfm4 = new FLDAWR__ClientFieldMapping__c();     
     cfm4.FLDAWR__FAObjectName__c = 'Task__c';
     cfm4.FLDAWR__FAFieldName__c = 'Name';
     cfm4.FLDAWR__ClientObjectName__c = 'Product__c';
     cfm4.FLDAWR__ClientFieldName__c  =   'Name';
     cfm4.FLDAWR__IsActive__c = true;
     cfmList.add(cfm4);
     FLDAWR__ClientFieldMapping__c cfm5 = new FLDAWR__ClientFieldMapping__c();
     cfm5.FLDAWR__FAObjectName__c = 'Task__c';
     cfm5.FLDAWR__FAFieldName__c = 'FLDAWR__UUID__c';
     cfm5.FLDAWR__ClientObjectName__c = 'Product__c';
     cfm5.FLDAWR__ClientFieldName__c  = 'FieldAwareId__c';
     cfm5.FLDAWR__IsActive__c = true;
     cfmList.add(cfm5);
     insert cfmList;
     FLDAWR__Job__c j = new FLDAWR__Job__c();     
     j.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';     
     j.FLDAWR__isSFPush__c = true;
     //j.FLDAWR__isReady__c = true;
     j.FLDAWR__ScheduledOn__c = Date.today();
     j.FLDAWR__State__c = 'Completed';
     j.FLDAWR__JobDescription__c = 'Some description';
     j.FLDAWR__Locationuuid__c  = '234234234'; 
     FLDAWR.shouldIRun.allowJobImplementationTrigger = true;
     insert j;
     
     FLDAWR__TaskLine__c tl1 = new FLDAWR__TaskLine__c();
     tl1.FLDAWR__UUID__c = '234234242342a3423'; 
     tl1.FLDAWR__TaskUUID__c = '2342342423423423'; 
     tl1.FLDAWR__isSFPush__c = true;
     tl1.FLDAWR__Job__c = j.Id;    
     tl1.FLDAWR__Notes__c = 'dfdsfsdfsd';
     
     insert tl1;
     
     j.FLDAWR__isReady__c =true;
     FLDAWR.shouldIRun.allowJobImplementationTrigger = true;
     update j;
        
     FLDAWR__Job__c j2 = new FLDAWR__Job__c();     
     j2.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';     
     j2.FLDAWR__isSFPush__c = true;
     //j2.FLDAWR__isReady__c =true;
     j2.FLDAWR__ScheduledOn__c = Date.today();
     j2.FLDAWR__clientObjectId__c = ord.Id;
     j2.FLDAWR__State__c = 'Completed';
     j2.FLDAWR__Locationuuid__c = '234234234';   
     
     insert j2;
     
     FLDAWR__TaskLine__c tl = new FLDAWR__TaskLine__c();
     tl.FLDAWR__UUID__c = 'jb5lc83sdfsdme0534534dfgdgli'; 
     tl.FLDAWR__isSFPush__c = true;
     tl.FLDAWR__Job__c = j2.Id;
     tl.FLDAWR__clientObjectId__c = oli.Id;
     tl.FLDAWR__Notes__c = 'dfdsfsdfsd';
     
     insert tl;
     
     j2.FLDAWR__isReady__c =true;
     FLDAWR.shouldIRun.allowJobImplementationTrigger = true;
     update j2;
     */
    test.stopTest();
    }
    static testMethod void testFAJobSync() {
     
    test.startTest();
    
    //FLDAWR__FieldAwareSetting__c myCS1 = FLDAWR__FieldAwareSetting__c.getValues('NoProductUUID');
    //String noProductUUID = myCS1.FLDAWR__Value__c;
    
    /*FLDAWR__FieldAwareSetting__c aSetting = new  FLDAWR__FieldAwareSetting__c();
    aSetting.name = 'NoProductUUID';
    aSetting.FLDAWR__Value__c = '2342342423423423';
    
    insert aSetting;
    list<FLDAWR__ClientFieldMapping__c> cfmList = new list<FLDAWR__ClientFieldMapping__c>();
     FLDAWR__ClientFieldMapping__c cfm = new FLDAWR__ClientFieldMapping__c();
     cfm.FLDAWR__FAObjectName__c = 'Job__c';
     cfm.FLDAWR__FAFieldName__c = 'FLDAWR__JobDescription__c';
     cfm.FLDAWR__ClientObjectName__c = 'Order__c';
     cfm.FLDAWR__ClientFieldName__c  =   'Comments__c';       
     cfm.FLDAWR__IsActive__c = true;
     cfmList.add(cfm); 
     FLDAWR__ClientFieldMapping__c cfm2 = new FLDAWR__ClientFieldMapping__c();
     cfm2.FLDAWR__FAObjectName__c = 'TaskLine__c';
     cfm2.FLDAWR__FAFieldName__c = 'FLDAWR__UUID__c';
     cfm2.FLDAWR__ClientObjectName__c = 'OrderLineItem__c';
     cfm2.FLDAWR__ClientFieldName__c  =   'FieldAwareId__c';       
     cfm2.FLDAWR__IsActive__c = true;
     cfmList.add(cfm2);
     FLDAWR__ClientFieldMapping__c cfm3 = new FLDAWR__ClientFieldMapping__c();
     cfm3.FLDAWR__FAObjectName__c = 'TaskLine__c';
     cfm3.FLDAWR__FAFieldName__c = 'FLDAWR__Notes__c';
     cfm3.FLDAWR__ClientObjectName__c = 'OrderLineItem__c';
     cfm3.FLDAWR__ClientFieldName__c  =   'Description__c';       
     cfm3.FLDAWR__IsActive__c = true;
     cfmList.add(cfm3);
     
     FLDAWR__ClientFieldMapping__c cfm4 = new FLDAWR__ClientFieldMapping__c();     
     cfm4.FLDAWR__FAObjectName__c = 'Task__c';
     cfm4.FLDAWR__FAFieldName__c = 'Name';
     cfm4.FLDAWR__ClientObjectName__c = 'Product__c';
     cfm4.FLDAWR__ClientFieldName__c  =   'Name';
     cfm4.FLDAWR__IsActive__c = true;
     cfmList.add(cfm4);
     FLDAWR__ClientFieldMapping__c cfm5 = new FLDAWR__ClientFieldMapping__c();
     cfm5.FLDAWR__FAObjectName__c = 'Task__c';
     cfm5.FLDAWR__FAFieldName__c = 'FLDAWR__UUID__c';
     cfm5.FLDAWR__ClientObjectName__c = 'Product__c';
     cfm5.FLDAWR__ClientFieldName__c  = 'FieldAwareId__c';
     cfm5.FLDAWR__IsActive__c = true;
     cfmList.add(cfm5);
     insert cfmList;
     */
     Account a = new Account();
     a.name = 'test';
     a.BillingStreet = '123 street';
     a.BillingCity = 'Miami';
     a.BillingState = 'Florida';
     a.BillingCountry = 'USA';   
     a.LocationUUID__c = '234234234';
     a.FieldAwareID__c = 'szffsdfsdfs';
     insert a;
        
     Order__c ord = new Order__c();
     ord.Account__c   = a.Id;
     ord.Date__c = date.today();
     ord.FieldAwareID__c = '123456';
     ord.Job_Type__c  = 'In-Home';
     ord.Email__c   = 'n@r.com';
     ord.Phone__c   = '23456789801';
     ord.AddressLine1__c = '1234 test Street';
     ord.City__c = 'san fran';
     ord.Status__c = 'Scheduled';
     
     //FLDAWR.shouldIRun.allowJobImplementationTrigger = true;
     insert ord; 
     
     
     
     OrderLineItem__c oli = new OrderLineItem__c();
     oli.Order__c = ord.Id;
     oli.Quantity__c = 2;
     oli.Description__c = 'Some Description';
     oli.FieldAwareId__c = 'aoliid';
     oli.Price__c = 23.34;
     
     insert oli;  
     
     //ord.Comments__c = 'updated';
     ord.put('Comments__c','updated');
     
    // FLDAWR.shouldIRun.allowJobImplementationTrigger = true;
     update ord;
     
    test.stopTest();
    }
    
    static testMethod void testFASFContactTrigger() {
     
    test.startTest(); 
     Account a = new Account();
     a.name = 'test';
     a.FieldAwareID__c = '567567567';    
     insert a;
     
     Contact c = new Contact();
     c.FirstName = 'test';
     c.lastName = 'test2';
     c.accountId = a.id;
     insert c;
     
     /*FLDAWR__ClientFieldMapping__c cfm = new FLDAWR__ClientFieldMapping__c();
     cfm.FLDAWR__FAObjectName__c = 'Contact__c';
     cfm.FLDAWR__FAFieldName__c = 'Name';
     cfm.FLDAWR__ClientObjectName__c = 'Contact';
     cfm.FLDAWR__ClientFieldName__c  =   'LastName';
     cfm.FLDAWR__IsActive__c = true;
        
     cfm.FLDAWR__FAObjectName__c = 'Contact__c';
     cfm.FLDAWR__FAFieldName__c = 'FLDAWR__UUID__c';
     cfm.FLDAWR__ClientObjectName__c = 'Contact';
     cfm.FLDAWR__ClientFieldName__c  =   'FieldAwareId__c';
     cfm.FLDAWR__IsActive__c = true;   
         
     insert cfm;     
     
     FLDAWR__Contact__c cu = new FLDAWR__Contact__c();
     
     cu.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';     
     cu.FLDAWR__clientObjectId__c = c.Id;
     cu.FLDAWR__isSFPush__c = true;
     
     insert cu;
     
     FLDAWR__Contact__c cu1 = new FLDAWR__Contact__c();
     
     cu1.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';     
     cu1.FLDAWR__isSFPush__c = true;
     
     insert cu1;
      */
    test.stopTest();
    }
    
    static testMethod void testFASFTaskTrigger() {
     
    test.startTest(); 
    /*
     list<FLDAWR__ClientFieldMapping__c> cfmList = new list<FLDAWR__ClientFieldMapping__c>();
     FLDAWR__ClientFieldMapping__c cfm = new FLDAWR__ClientFieldMapping__c();
     
     cfm.FLDAWR__FAObjectName__c = 'Task__c';
     cfm.FLDAWR__FAFieldName__c = 'Name';
     cfm.FLDAWR__ClientObjectName__c = 'Product__c';
     cfm.FLDAWR__ClientFieldName__c  =   'Name';
     cfm.FLDAWR__IsActive__c = true;
     cfmList.add(cfm);
     FLDAWR__ClientFieldMapping__c cfm2 = new FLDAWR__ClientFieldMapping__c();
     cfm2.FLDAWR__FAObjectName__c = 'Task__c';
     cfm2.FLDAWR__FAFieldName__c = 'FLDAWR__UUID__c';
     cfm2.FLDAWR__ClientObjectName__c = 'Product__c';
     cfm2.FLDAWR__ClientFieldName__c  = 'FieldAwareId__c';
     cfm2.FLDAWR__IsActive__c = true;
     cfmList.add(cfm2);    
     insert cfmList;
     */
     Product__c p = new Product__c();
     p.name = 'test';
     //a.Sync_to_FieldAware__c = 'Ready to Sync';
     insert p;
     FAUtils a = new FAUtils();
       /*   
     FLDAWR__Task__c t = new FLDAWR__Task__c();
     
     t.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';
     t.Name = 'test';
     t.FLDAWR__clientObjectId__c = p.Id;
     t.FLDAWR__isSFPush__c = true;
     t.FLDAWR__isReady__c = true;
     insert t;
     
     FLDAWR__Task__c t2 = new FLDAWR__Task__c();
     
     t2.FLDAWR__UUID__c = 'jb5lc83b9eme0534534dfgdgli';
     t2.Name = 'test';
     t2.FLDAWR__isSFPush__c = true;
     t2.FLDAWR__isReady__c = true;
     insert t2;
 */     
    test.stopTest();
    }
    
}