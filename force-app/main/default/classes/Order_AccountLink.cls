public with sharing class Order_AccountLink {

Public Order__c order {get;private set;}    
public Order_AccountLink(ApexPages.StandardController c) {
    order = (Order__c)c.GetRecord();
}

public map<string,string> ConfigMap {
    get {
        if(ConfigMap == null) {
            ConfigMap = new map<string,string>{
                'SELECT_SUCCESS' => 'null'
            };
        }
        return ConfigMap;
    }
    private set;
}

public Contact[] Contacts{
    get {
        Contacts = new Contact[]{};
        string q = ConfigMap.get('CONTACT_QUERY');
        if(q != null && q.deleteWhiteSpace() != ''){
            Contacts = (Contact[])database.Query(q);
        }
        return Contacts;
    }
    private set;
}

public void SelectContact(){
    ConfigMap.put('SELECT_SUCCESS','true');
    string ctcId = ConfigMap.get('CONTACT_ID');
    string accId = ConfigMap.get('ACCOUNT_ID');
    if(ctcId != null && ctcId.deleteWhiteSpace() != ''){
        Order.Contact__c = ctcId;
        Order.Account__c = accId != null && accId.deleteWhiteSpace() != '' ? accId : Order.Account__c;
        try {
            update Order;
        } catch (exception e) {
            ApexPAges.addMessages(e);
            ConfigMap.put('SELECT_SUCCESS','false');
        }
    }
}

public void CreateContact(){
    ConfigMap.put('SELECT_SUCCESS','true');
    string acc = ConfigMap.get('NEW_ACCOUNT');
    string ctc = ConfigMap.get('NEW_CONTACT');
    try {
        Contact c = (Contact)JSON.deserializeStrict(ctc,Contact.class);
        Account a = (Account)JSON.deserializeStrict(acc,Account.class);
        insert a;
        c.AccountId = a.id;
        insert c;
        ConfigMap.put('CONTACT_ID',c.id);
        ConfigMap.put('ACCOUNT_ID',a.id);
        SelectContact();
    } catch (exception e) {
        ApexPages.addMessages(e);
        ConfigMap.put('SELECT_SUCCESS','false');
    }
}

}