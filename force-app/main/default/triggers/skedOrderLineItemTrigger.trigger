trigger skedOrderLineItemTrigger on OrderLineItem__c (before insert, before update)  {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			skedOrderLineItemTriggerHandler.onBeforeInsert(Trigger.new);
		} else if (Trigger.isUpdate) {
			skedOrderLineItemTriggerHandler.onBeforeUpdate(Trigger.new);
		}
	}
}