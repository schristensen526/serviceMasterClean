@isTest
private class TEST_Order_ctrl{

static testMethod void test01(){
    Order__c o = TEST_Helper.testOrder00;
    CouponCode__c c = TEST_Helper.testCouponCode00;
    
    //The order is inserted without a coupon code and is subsequently updated with one
    o.CouponCode__c = TEST_Helper.testCouponCode00.id;
    o.TimeSlot__c = TEST_Helper.testTimeSlot00.id;
    //The status is also changed from 'draft' to 'scheduled'
    o.Status__c = 'Scheduled';
    update o;
    
    //This causes the coupon codes to be queried - and updated
}

}