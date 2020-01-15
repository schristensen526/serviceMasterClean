trigger skedContentDocumentTrigger on ContentDocument (after insert)  {
	boolean isAfterInsert = Trigger.isAfter && Trigger.isInsert;

    if(isAfterInsert){
		//skedContentDocumentTriggerHandler.updateSyncJobFiles(Trigger.new);
    } 
}