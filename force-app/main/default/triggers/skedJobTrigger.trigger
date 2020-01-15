trigger skedJobTrigger on sked__Job__c(before insert, before update, after update) {

	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			skedJobTriggerHandler.onBeforeInsert(Trigger.new);
		}
		else if (Trigger.isUpdate) {
			skedJobTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
		}
	} else if (Trigger.isAfter) {
		if (Trigger.isUpdate) {
			skedJobTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
		}
	}
}