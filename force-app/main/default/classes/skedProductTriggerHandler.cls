public class skedProductTriggerHandler {
	public static void updateShadowProduct(List<Product2> products) {
		list<Shadow_Product__c> lstProducts = new list<Shadow_Product__c> ();
		for (Product2 p : products) {
			Shadow_Product__c SP = new Shadow_Product__c(
			                                             ProductId__c = p.id,
			                                             Product_Name__c = p.Name,
			                                             Product_Code__c = p.ProductCode,
			                                             IsActive__c = p.IsActive,
			                                             Description__c = p.Description,
			                                             Product_Family__c = p.Family
			);
			lstProducts.add(SP);
		}
		upsert lstProducts ProductId__c;
	}

}