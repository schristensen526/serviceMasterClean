@isTest 
private class skedJobCreationControllerTest {

	@isTest
	private static void createJob() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		Test.startTest();
		skedJobCreationController.doCreateJob(order.Id);
		Test.stopTest();
	}

	@isTest
	private static void syncJobFiles() {
		List<sked__Region__c> regions = skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);
		sked__Job__c job = skedDataFactory.createJob(order, regions.get(0).Id);
		job.sked__Job_Status__c = 'Complete';
		update job;

		skedDataFactory.createOrderLineItem(order.Id, job.Id);

		List<Product__c> products = [SELECT Id FROM Product__c];
		update products;
		
		Test.startTest();
		skedDataFactory.createAttachment(job.Id);
		skedDataFactory.createContentVersion(job.Id);
		Test.stopTest();
	}
}