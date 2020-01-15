trigger skedContentVersionTrigger on ContentVersion(after insert) {

	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			skedContentVersionTriggerHandler.updateSyncJobFiles(Trigger.new);
		}
	}
}