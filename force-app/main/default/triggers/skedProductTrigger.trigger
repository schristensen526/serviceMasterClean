trigger skedProductTrigger on Product__c(after update, after insert) {

	if (Trigger.isAfter) {
		if (Trigger.isUpdate) {
			//skedProductTriggerHandler.syncProductsAndOrderLineItems(Trigger.newMap);
		} 
		else if (Trigger.isInsert) {
			//skedProductTriggerHandler.updateShadowProduct(Trigger.new);
		}
	}

}