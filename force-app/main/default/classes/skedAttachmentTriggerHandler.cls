public class skedAttachmentTriggerHandler  {
	public static void updateSyncJobFiles(List<Attachment> lstNew) {
		Set<Id> jobIds = new Set<Id>();

		for (Attachment att : lstNew) {
			jobIds.add(att.ParentId);
		}

		List<sked__Job__c> lstJob = [select id, sked__Recurring_Schedule__c, Order__c from sked__Job__c where id IN: jobIds and sked__Job_Status__c = 'Complete'];
		System.debug('#lstJob# ' + lstJob);
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

			// Clone Attachments
			List<Attachment> lstAtt = new List<Attachment>();

			for(Attachment att : lstNew) {
				if (invalidJobIds.contains(att.ParentId)) continue;

				Attachment newAtt = att.clone(false, false);
				newAtt.ParentId = mapOrderIds.get(att.ParentId);

				lstAtt.add(newAtt);
			}

			if (!lstAtt.isEmpty()) {
				insert lstAtt;
			}

		} catch (Exception ex) {
			Database.rollback(sp);
			System.debug('##### Error: ' + ex.getMessage());
		}
	}
}