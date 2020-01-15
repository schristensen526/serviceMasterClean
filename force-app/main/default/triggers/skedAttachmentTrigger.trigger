trigger skedAttachmentTrigger on Attachment(after insert) {

	if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			skedAttachmentTriggerHandler.updateSyncJobFiles(Trigger.new);
		}
	}
}