@isTest
private class TEST_Coupon_ctrl{

static testMethod void test01(){
    CouponCode__c c = TEST_Helper.testCouponCode00;
    
    //The code is currently valid
    system.assert(c.Valid__c);
    
    c.Uses__c = 0;
    update c;
    
    c = [SELECT Valid__c FROM CouponCode__c WHERE id = :c.id];
    system.assert(!c.valid__c);
}

}