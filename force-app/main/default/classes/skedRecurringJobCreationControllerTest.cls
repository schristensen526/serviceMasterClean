@isTest
private class skedRecurringJobCreationControllerTest {

	@isTest
	private static void saveRecurringJobsDaily1() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'DAILY';
		modal.repeatDay = 1;
		modal.skipHoliday = true;
		modal.ending = 'AFTER';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController ctr = new skedRecurringJobCreationController();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringDaily2() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'DAILY';
		modal.repeatDay = 1;
		modal.skipHoliday = true;
		modal.ending = 'ON';
		modal.endingOn = '02/28/2018';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringJobsWeekly1() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'WEEKLY';
		modal.repeatWeek = 1;
		modal.skipHoliday = true;
		modal.ending = 'AFTER';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };
		modal.daysOfWeek = new String[] { 'SUN', 'TUE' };

		Test.startTest();
		skedRecurringJobCreationController ctr = new skedRecurringJobCreationController();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringWeekly2() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'WEEKLY';
		modal.repeatWeek = 1;
		modal.skipHoliday = true;
		modal.ending = 'ON';
		modal.endingOn = '02/28/2018';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };
		modal.daysOfWeek = new String[] { 'SUN', 'TUE' };

		Test.startTest();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringJobsMonthly1() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'MONTHLY';
		modal.repeatMonth = 1;
		modal.skipHoliday = true;
		modal.ending = 'AFTER';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController ctr = new skedRecurringJobCreationController();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringMonthly2() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'MONTHLY';
		modal.repeatMonth = 1;
		modal.skipHoliday = true;
		modal.ending = 'ON';
		modal.endingOn = '02/28/2018';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringNthMonthly1() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/23/2018';
		modal.startTime = '12:00 AM';
		modal.day = 1;
		modal.repeat = 'NTH_DAY_OF_MONTH';
		modal.repeatMonth = 1;
		modal.skipHoliday = true;
		modal.ending = 'ON';
		modal.endingOn = '02/28/2018';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController ctr = new skedRecurringJobCreationController();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringNthMonthly2() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/23/2018';
		modal.startTime = '12:00 AM';
		modal.day = 1;
		modal.repeat = 'NTH_DAY_OF_MONTH';
		modal.repeatMonth = 1;
		modal.skipHoliday = true;
		modal.ending = 'AFTER';
		modal.endingOn = '02/28/2018';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController ctr = new skedRecurringJobCreationController();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringJobsYear1() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'YEARLY';
		modal.repeatYear = 1;
		modal.skipHoliday = true;
		modal.ending = 'AFTER';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController ctr = new skedRecurringJobCreationController();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void saveRecurringYear2() {
		skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'YEARLY';
		modal.repeatYear = 1;
		modal.skipHoliday = true;
		modal.ending = 'ON';
		modal.endingOn = '02/28/2018';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		Test.startTest();
		skedRecurringJobCreationController.doSave(modal);
		Test.stopTest();
	}

	@isTest
	private static void syncJobFiles() {
		List<sked__Region__c> regions = skedDataFactory.createRegions();
		Account acc = skedDataFactory.createAccount();
		Contact con = skedDataFactory.createContact();
		Order__c order = skedDataFactory.createOrder(acc.Id, con.Id);

		skedRecurringJobCreationController.skedRecurringJobModal modal = new skedRecurringJobCreationController.skedRecurringJobModal();
		modal.orderId = order.Id;
		modal.startDate = '02/21/2018';
		modal.startTime = '12:00 AM';
		modal.repeat = 'DAILY';
		modal.repeatDay = 1;
		modal.skipHoliday = true;
		modal.ending = 'AFTER';
		modal.endingOccurrence = 2;
		modal.skipDaysOfWeek = new String[] { 'SUN', 'MON' };

		skedRecurringJobCreationController.doSave(modal);

		List<sked__Job__c> lstJob = [select id, sked__Recurring_Schedule__c, Order__c from sked__Job__c];
		for (sked__Job__c job : lstJob) {
			job.sked__Job_Status__c = 'Complete';
		}
		update lstJob;

		System.debug('#lstJob# ' + lstJob);
		
		Test.startTest();
		skedDataFactory.createAttachment(lstJob.get(0).Id);
		skedDataFactory.createContentVersion(lstJob.get(0).Id);
		Test.stopTest();
	}
}