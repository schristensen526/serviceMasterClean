public class skedContentVersionTriggerHandler  {
	
	public static void updateSyncJobFiles(List<ContentVersion> lstNew) {
		Set<Id> jobIds = new Set<Id>();

		for (ContentVersion cv : lstNew) {
			System.debug('#FirstPublishLocationId# ' + cv);
			jobIds.add(cv.FirstPublishLocationId);
		}

		List<sked__Job__c> lstJob = [select id, sked__Recurring_Schedule__c, Order__c from sked__Job__c where id IN: jobIds and sked__Job_Status__c = 'Complete'];

		if(lstJob.isEmpty()) return;
		
		Set<Id> setRSIds = new Set<Id>();
		Map<Id, Id> mapOrderIds = new Map<Id, Id>();

		for (sked__Job__c job : lstJob) {
			if (!String.isBlank(job.sked__Recurring_Schedule__c)) {
				// RS Jobs
				setRSIds.add(job.sked__Recurring_Schedule__c);
			}
			mapOrderIds.put(job.Id, job.Order__c);
		}

		Set<Id> validJobIds = new Set<Id>();
		Set<Id> invalidJobIds = new Set<Id>();
		for (sked__Recurring_Schedule__c rs : [select Id, (select id, sked__Job_Status__c, Order__c from sked__Jobs__r) from sked__Recurring_Schedule__c where Id IN: setRSIds]) {
			Boolean isCompleted = true;
			Set<Id> tempIds = new Set<Id>();

			for (sked__Job__c job : rs.sked__Jobs__r) {
				tempIds.add(job.Id);
				if (job.sked__Job_Status__c != 'Complete') {
					isCompleted = false;
				}
			}

			if (isCompleted) {
				validJobIds.addAll(tempIds);
			} else {
				invalidJobIds.addAll(tempIds);
			}
		}

		Savepoint sp;
		try {
			sp = Database.setSavepoint();

			// Clone Files
			Set<Id> cdIds = new Set<Id>();
			Set<Id> setJobIds = mapOrderIds.keySet();
			List<Id> orderIds = mapOrderIds.values();

			for (ContentDocumentLink lk : [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink
										   WHERE LinkedEntityId IN: orderIds]) {
				cdIds.add(lk.ContentDocumentId);
			}

			List<ContentDocumentLink> lstLks = new List<ContentDocumentLink>();
			for (ContentDocumentLink lk : [SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility FROM ContentDocumentLink
										   WHERE LinkedEntityId IN: setJobIds AND ContentDocumentId !=: cdIds]) {
				if (invalidJobIds.contains(lk.LinkedEntityId)) continue;

				ContentDocumentLink tempLk = new ContentDocumentLink();
				tempLk.ContentDocumentId = lk.ContentDocumentId;
				tempLk.LinkedEntityId = mapOrderIds.get(lk.LinkedEntityId); 
				tempLk.ShareType = 'V';
				tempLk.Visibility = 'AllUsers';
				lstLks.add(tempLk);
			}

			if (!lstLks.isEmpty()) {
				insert lstLks;
			}

		} catch (Exception ex) {
			Database.rollback(sp);
			System.debug('##### Error: ' + ex.getMessage());
		}

	}

}