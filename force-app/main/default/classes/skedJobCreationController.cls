public class skedJobCreationController {

	@AuraEnabled
	public static String[] doCreateJob(String orderId) {
		try {
			List<sked__Region__c> regions = [SELECT Id, Name FROM sked__Region__c WHERE Name = 'SMC'];

			if (regions.isEmpty()) return new String[]{ 'Error: Invalid region.', '' };

			Order__c order = [SELECT Id, Account__c, ActualTime__c, AddressLine1__c, AddressLine2__c, Building_Notice__c, City__c,
									Comments__c, Contact__c, Country__c, Crew__c, Date__c, Duration__c, Email__c, FirstName__c, Job_Type__c, 
									LastName__c, Parent_Account__c, Phone__c, PrimaryContact__c, Reference_Info__c, StateProvince__c,
									ZipPostalCode__c
							  FROM Order__c
							  WHERE Id =: orderId
							  LIMIT 1];

			if (order == null) return new String[]{ 'Error: Invalid Order.', '' };

			sked__Job__c job = new sked__Job__c(
				Order__c			= order.Id,
				sked__Account__c	= order.Account__c,
				Actual_Time__c		= order.ActualTime__c,
				AddressLine1__c		= order.AddressLine1__c,
				AddressLine2__c		= order.AddressLine2__c,
				Building_Notice__c	= order.Building_Notice__c,
				City__c				= order.City__c,
				Comments__c			= order.Comments__c,
				sked__Contact__c	= order.Contact__c,
				Country__c			= order.Country__c,
				Crew__c				= order.Crew__c,
				Date__c				= order.Date__c,
				sked__Duration__c	= (order.Duration__c != null) ? order.Duration__c : 60,
				Email__c			= order.Email__c,
				First_Name__c		= order.FirstName__c,
				Job_Type__c			= order.Job_Type__c,
				Last_Name__c		= order.LastName__c,
				Parent_Account__c	= order.Parent_Account__c,
				Phone__c			= order.Phone__c,
				PrimaryContact__c	= order.PrimaryContact__c,
				Reference_Info__c	= order.Reference_Info__c,
				State_Province__c	= order.StateProvince__c,
				sked__Job_Status__c	= 'Queued',
				Zip_Postal_Code__c	= order.ZipPostalCode__c,
				sked__Region__c		= regions.get(0).Id,
				sked__Description__c = order.Reference_Info__c,
				sked__Address__c	= order.AddressLine1__c,
				sked__Type__c		= order.Job_Type__c
			);

			insert job;

			job = [SELECT Id, Name FROM sked__Job__c WHERE Id =: job.Id LIMIT 1];

			return new String[]{ job.Id, job.Name };
		} catch (Exception ex) {
			return new String[]{ 'Error: ' + ex.getMessage(), '' };
		}
	}
}