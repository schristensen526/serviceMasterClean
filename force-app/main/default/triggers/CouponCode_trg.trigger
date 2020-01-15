trigger CouponCode_trg on CouponCode__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

CouponCode_ctrl c = new CouponCode_ctrl(Trigger.new, trigger.Old, trigger.newmap,trigger.oldmap, trigger.isbefore, trigger.isafter, trigger.isinsert, trigger.isupdate, trigger.isdelete, trigger.isundelete);

}