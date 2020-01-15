public class skedDataFactory {

	public static Order__c createOrder(Id accountId, Id contactId) {
		Order__c order = new Order__c();
		order.Account__c = accountId;
		order.Contact__c = contactId;
		order.ActualTime__c = System.now();
		order.AddressLine1__c = '324 San Jose Avenue San Francisco, CA 94110';
		order.City__c = 'San Francisco';
		order.Email__c = 'test@skedulo.com';
		order.Phone__c = '122344566777';
		order.Duration__c = 60;

		insert order;
		return order;
	}

	public static Account createAccount() {
		Account acc = new Account();
		acc.Name = 'Test ServiceMaster';

		insert acc;
		return acc;
	}

	public static Contact createContact() {
		Contact con = new Contact();
		con.LastName = 'Test Contact 01';

		insert con;
		return con;
	}

	public static List<sked__Region__c> createRegions() {
		list<sked__Region__c> lstReg = new list<sked__Region__c> ();
		sked__Region__c reg = new sked__Region__c();
		reg.Name = 'SMC';
		reg.sked__Timezone__c = 'Canada/Pacific';
		reg.sked__Country_Code__c = 'CA';

		lstReg.add(reg);

		insert lstReg;

		List<sked__Holiday__c> holidays = createHolidays();
		createRegionHolidays(holidays.get(0).Id, lstReg.get(0).Id);

		return lstReg;
	}

	public static sked__Job__c createJob(Order__c order, Id regionId) {
		sked__Job__c job = new sked__Job__c();
		job.Order__c = order.Id;
		job.sked__Account__c = order.Account__c;
		job.Actual_Time__c = order.ActualTime__c;
		job.AddressLine1__c = order.AddressLine1__c;
		job.AddressLine2__c = order.AddressLine2__c;
		job.Building_Notice__c = order.Building_Notice__c;
		job.City__c = order.City__c;
		job.Comments__c = order.Comments__c;
		job.sked__Contact__c = order.Contact__c;
		job.Country__c = order.Country__c;
		job.Crew__c = order.Crew__c;
		job.Date__c = order.Date__c;
		job.sked__Duration__c = order.Duration__c;
		job.Email__c = order.Email__c;
		job.First_Name__c = order.FirstName__c;
		job.Job_Type__c = order.Job_Type__c;
		job.Last_Name__c = order.LastName__c;
		job.Parent_Account__c = order.Parent_Account__c;
		job.Phone__c = order.Phone__c;
		job.PrimaryContact__c = order.PrimaryContact__c;
		job.Reference_Info__c = order.Reference_Info__c;
		job.State_Province__c = order.StateProvince__c;
		job.sked__Job_Status__c = 'Queued';
		job.Zip_Postal_Code__c = order.ZipPostalCode__c;
		job.sked__Region__c = regionId;
		job.sked__Description__c = order.Reference_Info__c;
		job.sked__Address__c = order.AddressLine1__c;
		job.sked__Type__c = order.Job_Type__c;
		job.sked__Start__c = order.ActualTime__c;
		job.sked__Finish__c = order.ActualTime__c.addMinutes(Integer.valueOf(order.Duration__c));
		job.Is_Synced_Job_Files__c = false;

		insert job;
		return job;
	}

	public static Attachment createAttachment(Id parentId) {
		Attachment att = new Attachment();
		att.Name = 'Test Attachment';
		att.Body = Blob.valueOf('Test Data');
		att.ParentId = parentId;

		insert att;
		return att;
	}

	public static ContentVersion createContentVersion(Id parentId) {
		ContentVersion cv = new ContentVersion();
		cv.title = 'Test content version';
		cv.PathOnClient = 'test';
		cv.VersionData = Blob.valueOf('Test Data 01');
		cv.FirstPublishLocationId = parentId;
		insert cv;
		return cv;
	}

	public static OrderLineItem__c createOrderLineItem(Id orderId, Id jobId) {
		Product2 product = new Product2();
		product.Name = 'Test Product';
		insert product;

		OrderLineItem__c item = new OrderLineItem__c();
		item.Order__c = orderId;
		item.Product2__c = product.Id;
		item.Quantity__c = 1;

		insert item;
		update item;
		return item;
	}

	public static List<sked__Holiday__c> createHolidays() {
		list<sked__Holiday__c> lstHoliday = new list<sked__Holiday__c> ();
		sked__Holiday__c holiday = new sked__Holiday__c();
		holiday.sked__Global__c = true;
		holiday.sked__Start_Date__c = Date.newInstance(2018, 2, 23);
		holiday.sked__End_Date__c = Date.newInstance(2018, 2, 23);

		lstHoliday.add(holiday);

		insert lstHoliday;
		return lstHoliday;
	}

	public static List<sked__Holiday_Region__c> createRegionHolidays(Id holidayId, Id regionId) {
		list<sked__Holiday_Region__c> lstHoliday = new list<sked__Holiday_Region__c> ();
		sked__Holiday_Region__c holiday = new sked__Holiday_Region__c();
		holiday.sked__Holiday__c = holidayId;
		holiday.sked__Region__c = regionId;

		lstHoliday.add(holiday);

		insert lstHoliday;
		return lstHoliday;
	}
}