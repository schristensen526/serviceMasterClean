@isTest
private class TEST_CouponGenerator{

static testMethod void test01(){
    
    CouponGenerator c = new CouponGenerator();
    
    //The config map is populated by the user (probably just a VF component)
    c.ConfigMap.put('DEFAULT_DISCOUNT','10');
    
    //The user inputs his details to the form
    c.lead.FirstName = 'testFirstName';
    c.lead.LastName = 'testLastName';
    c.lead.Phone = '1234567890';
    c.lead.Email = 'test@email.com';
    
    //And calls the submit
    c.submit();
    
    //This generates a random string, and inserts the lead and coupon code
    system.assert(lead.id != null);
    system.assert(lead.CouponCode__c != null);
}

}