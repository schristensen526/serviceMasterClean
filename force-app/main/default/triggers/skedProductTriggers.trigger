trigger skedProductTriggers on Product2 (after insert, after update)  {
	if (Trigger.isAfter) {
		if (Trigger.isUpdate) {
			skedProductTriggerHandler.updateShadowProduct(Trigger.new);
		} 
		else if (Trigger.isInsert) {
			skedProductTriggerHandler.updateShadowProduct(Trigger.new);
		}
	}
}