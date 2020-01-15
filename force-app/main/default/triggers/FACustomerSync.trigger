trigger FACustomerSync on Account(after insert, after update) {
/*

    if (FLDAWR.shouldIRun.canIRunCustomerImplementationTrigger() == true) {
        list < Account > syncAccounts = new List < Account > ();
        for (Account a: trigger.new) {
            //if (a.Sync_to_FieldAware__c == 'Ready to Sync') {
                syncAccounts.add(a);
            //}
        }
        if (syncAccounts != null && syncAccounts.size() > 0) {

            list < FLDAWR__ClientFieldMapping__c > fmList = new list < FLDAWR__ClientFieldMapping__c > ([select FLDAWR__ClientFieldName__c, FLDAWR__ClientObjectName__c, FLDAWR__FAFieldName__c, FLDAWR__FAObjectName__c, FLDAWR__IsActive__c from FLDAWR__ClientFieldMapping__c where FLDAWR__IsActive__c = : true]);

            map < string, string > customerMapping = new map < string, string > ();
            map < string, string > contactMapping = new map < string, string > ();
            map < string, string > locationMapping = new map < string, string > ();
            map < string, string > jobMapping = new map < string, string > ();

            map < string, string > acctCustMap = new map < string, string > ();

            map < string, string > acctLocMap = new map < string, string > ();

            list < FLDAWR__customer__c > newCustomers = new list < FLDAWR__customer__c > ();

            for (FLDAWR__ClientFieldMapping__c m: fmList) {
                if (m.FLDAWR__FAObjectName__c == 'Customer__c' && m.FLDAWR__IsActive__c) {
                    customerMapping.put(m.FLDAWR__FAFieldName__c, m.FLDAWR__ClientFieldName__c);
                }

                if (m.FLDAWR__FAObjectName__c == 'Location__c' && m.FLDAWR__IsActive__c && m.FLDAWR__ClientObjectName__c != 'Address__c') {
                    locationMapping.put(m.FLDAWR__FAFieldName__c, m.FLDAWR__ClientFieldName__c);
                }

            }

            list < FLDAWR__location__c > locs = new list < FLDAWR__location__c > ();
            list < FLDAWR__customer__c > customers = new list < FLDAWR__customer__c > ();

            for (Account a: syncAccounts) {

                FLDAWR__Location__c l = new FLDAWR__Location__c();
                l.FLDAWR__clientObjectId__c = a.id;
                if (a.LocationUUID__c != null) l.FLDAWR__UUID__c = a.LocationUUID__c;
                if (a.BillingStreet != null) l.name = a.BillingStreet;
                for (string fAFieldName: locationMapping.keySet()) {
                    String sFFieldName = locationMapping.get(fAFieldName);
                    l.put(fAFieldName, a.get(sFFieldName));
                    //  l.CustomerUUID__c = a.id;
                    l.FLDAWR__CustomerUUID__c = a.FieldAwareID__c;
                    l.FLDAWR__type__c = 'billing';
                    l.FLDAWR__isBilling__c = true;
                }
                locs.add(l);

            }

            insert locs;

            for (FLDAWR__location__c l: locs) {
                acctLocMap.put(l.FLDAWR__CustomerUUID__c, l.id);
            }
            for (Account a: trigger.new) {

                FLDAWR__customer__c c = new FLDAWR__customer__c();
                c.FLDAWR__clientObjectId__c = a.id;
                if (a.FieldAwareID__c != null) c.FLDAWR__UUID__c = a.FieldAwareID__c;
                for (string fAFieldName: customerMapping.keyset()) {
                    String sFFieldName = customerMapping.get(fAFieldName);
                    c.put(fAFieldName, a.get(sFFieldName));
                }
                c.FLDAWR__location__c = acctLocMap.get(a.FieldAwareID__c);
                c.FLDAWR__isReady__c = true;
                customers.add(c);
            }

            insert customers;

        }
    }    */
}