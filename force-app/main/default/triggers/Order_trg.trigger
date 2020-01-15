trigger Order_trg on Order__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

Order_ctrl c = new Order_ctrl(Trigger.new, trigger.Old, trigger.newmap,trigger.oldmap, trigger.isbefore, trigger.isafter, trigger.isinsert, trigger.isupdate, trigger.isdelete, trigger.isundelete);

}