public class skedOrderLineItemTriggerHandler  {
	public static void onBeforeInsert(List<OrderLineItem__c> triggerNew) {
		updateProduct(triggerNew);
	}

	public static void onBeforeUpdate(List<OrderLineItem__c> triggerNew) {
		updateProduct(triggerNew);
	}

	public static void updateProduct(List<OrderLineItem__c> triggerNew) {
		
		Map<Id, Id> mapProduct = new Map<Id, Id>();
		Map<Id, Id> mapShadowProduct = new Map<Id, Id>();

		for (OrderLineItem__c item : triggerNew) {
			if (String.isNotBlank(item.Shadow_Product__c)) {
				mapShadowProduct.put(item.Shadow_Product__c, null);
			}
			if (String.isNotBlank(item.Product2__c)) {
				mapProduct.put(item.Product2__c, null);
			}
		}
		System.debug('#mapProduct# ' + mapProduct);
		System.debug('#mapShadowProduct# ' + mapShadowProduct);
		if (mapShadowProduct.isEmpty() && mapProduct.isEmpty()) return;

		for (Shadow_Product__c sp : [SELECT Id, ProductId__c FROM Shadow_Product__c 
									 WHERE Id IN: mapShadowProduct.keySet()
									 OR ProductId__c IN: mapProduct.keySet()]) {
			mapProduct.put(sp.ProductId__c, sp.Id);
			mapShadowProduct.put(sp.Id, sp.ProductId__c);
		}

		for (OrderLineItem__c item : triggerNew) {
			if (String.isBlank(item.Shadow_Product__c)) {
				item.Shadow_Product__c = mapProduct.get(item.Product2__c);
			}
			if (String.isBlank(item.Product2__c)) {
				item.Product2__c = mapShadowProduct.get(item.Shadow_Product__c);
			}
		}
	}

}