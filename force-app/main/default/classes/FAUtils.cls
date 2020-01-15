public class FAUtils {
    
  /*  
    public class FATokensException extends Exception {}
    private static Map<Schema.SObjectType,Map<String,Id>> rtypesCache;
    public class NoPreReqSyncException extends Exception {}
    static {
        rtypesCache = new Map<Schema.SObjectType,Map<String,Id>>();
    }


    /*public static Map<String, Id> GetRecordTypeIdsByDeveloperName( Schema.SObjectType token) {

        Map<String, Id> mapRecordTypes = rtypesCache.get(token);

        if (mapRecordTypes == null) {
            mapRecordTypes = new Map<String, Id>();
            rtypesCache.put(token,mapRecordTypes);
        } else {

            return mapRecordTypes;
        }


        Schema.DescribeSObjectResult obj = token.getDescribe();

        String soql =
            'SELECT Id, Name, DeveloperName '
            + 'FROM RecordType '
            + 'WHERE SObjectType = \'' + String.escapeSingleQuotes(obj.getName()) + '\' '
            + 'AND IsActive = TRUE';
        List<SObject> results;
        try {
            results = Database.query(soql);
        } catch (Exception ex) {
            results = new List<SObject>();
        }

        Map<Id,Schema.RecordTypeInfo> recordTypeInfos = obj.getRecordTypeInfosByID();

        for (SObject rt : results) {
            if (recordTypeInfos.get(rt.Id).isAvailable()) {
                mapRecordTypes.put(String.valueOf(rt.get('DeveloperName')),rt.Id);
            }
        }
        return mapRecordTypes;
    }*//*
    public static string createQueryFieldString(string objName) {
        sObject newObj;
        if(objName == 'Customer') {
            newObj = new FLDAWR__Customer__c();
        }
        if(objName == 'Contact') {
            newObj = new FLDAWR__Contact__c();
        }
        if(objName == 'Location') {
            newObj = new FLDAWR__Location__c();
        }
        if(objName == 'Job') {
            newObj = new FLDAWR__Job__c();
        }
        if(objName == 'TaskLine') {
            newObj = new FLDAWR__TaskLine__c();
        }
        if(objName == 'ItemLine') {
            newObj = new FLDAWR__ItemLine__c();
        }
        if(objName == 'Item') {
            newObj = new FLDAWR__Item__c();
        }
        if(objName == 'Task') {
            newObj = new FLDAWR__Task__c();
        }
          if(objName == 'OrderLine') {
            newObj = new OrderLineItem__c();
        }
        if(objName == 'Order') {
            newObj = new Order__c();
        }
        if(objName == 'Product') {
            newObj = new Product__c();
        }

        string query ='';
        Map<String, Schema.SObjectField> M;

        M = newObj.getSObjectType().getDescribe().fields.getMap();
        for(Schema.SObjectField field:M.values()) {
            string fldName  = field.getDescribe().getName();
            query = query + fldName+',';
        }
        query = query.substring(0,query.length()-1);
        return query;
    }
   */ 
}