public class skedJobTriggerHandler {
	private static final String STR_PROPERTY_MANAGER = 'Property Manager';

	public static void onBeforeInsert(List<sked__Job__c> triggerNew) {
		Set<Id> accountIds = new Set<Id>();
		for (sked__Job__c skedJob : triggerNew) {
			accountIds.add(skedJob.sked__Account__c);
		}
		Map<Id, Id> mapAccount_Contact = new Map<Id, Id>();
		for (AccountContactRelation relation : [SELECT Contact.Id, Roles, Account.Id 
                                                FROM AccountContactRelation
                                                WHERE Roles =: STR_PROPERTY_MANAGER
                                                AND Account.Id =: accountIds
                                                ORDER BY Contact.CreatedDate DESC]) {
			if (!mapAccount_Contact.containsKey(relation.Account.Id)) {
				mapAccount_Contact.put(relation.Account.Id, relation.Contact.Id);
			}
		}
		for (sked__Job__c skedJob : triggerNew) {
			if (mapAccount_Contact.containsKey(skedJob.sked__Account__c)) {
				skedJob.PrimaryContact__c = mapAccount_Contact.get(skedJob.sked__Account__c);
			}
		}
	} 

	public static void onBeforeUpdate(List<sked__Job__c> triggerNew, Map<Id, sked__Job__c> oldMap) {
		Set<Id> setJobIds = new Set<Id> ();
		Set<Id> setRSIds = new Set<Id> ();
		Set<Id> setTempRSIds = new Set<Id> ();
		Map<Id, Id> mapOrderIds = new Map<Id, Id> ();

		for (sked__Job__c newJob : triggerNew) {
			if (newJob.sked__Job_Status__c == 'Complete' && oldMap.get(newJob.id).sked__Job_Status__c != newJob.sked__Job_Status__c) {
				if (!String.isBlank(newJob.sked__Recurring_Schedule__c)) {
					setRSIds.add(newJob.sked__Recurring_Schedule__c);
				} else {
					setJobIds.add(newJob.Id);
					mapOrderIds.put(newJob.Id, newJob.Order__c);
				}
				newJob.Is_Synced_Job_Files__c = true;
			}
		}

		for (AggregateResult agr :[select max(sked__Finish__c), sked__Recurring_Schedule__c
		     from sked__Job__c where sked__Recurring_Schedule__c IN :setRSIds group by sked__Recurring_Schedule__c]) {
			for (sked__Job__c newJob : triggerNew) {
				if ((newJob.sked__Recurring_Schedule__c != agr.get('sked__Recurring_Schedule__c')) || newJob.sked__Finish__c != agr.get('expr0')) {
					continue;
				}
				setTempRSIds.add(newJob.sked__Recurring_Schedule__c);
			}
		}

		for (sked__Job__c newJob :[select Id, sked__Recurring_Schedule__c, Order__c from sked__Job__c where sked__Recurring_Schedule__c IN :setTempRSIds]) {
			setJobIds.add(newJob.Id);
			mapOrderIds.put(newJob.Id, newJob.Order__c);
		}

		if (!setJobIds.isEmpty()) {
			moveAttachmentToOrder(setJobIds, mapOrderIds);
		}
	}

	public static void onAfterUpdate(List<sked__Job__c> triggerNew, Map<Id, sked__Job__c> oldMap) {
		Set<Id> setRSIds = new Set<Id> ();
		for (sked__Job__c newJob : triggerNew) {
			sked__Job__c oldData = oldMap.get(newJob.Id);
			if (newJob.sked__Job_Status__c != oldData.sked__Job_Status__c) {
				if (!String.isBlank(newJob.sked__Recurring_Schedule__c)) {
					setRSIds.add(newJob.sked__Recurring_Schedule__c);
				}
			}
		}

		if (!setRSIds.isEmpty()) {
			updateCompletionSeries(setRSIds);
		}
	}

	private static void updateCompletionSeries(Set<Id> setRSIds){
		List<sked__Recurring_Schedule__c> recurrings = new List<sked__Recurring_Schedule__c>();
		for (sked__Recurring_Schedule__c rs : [select Id, (select id, sked__Job_Status__c, Order__c from sked__Jobs__r) 
											   from sked__Recurring_Schedule__c 
											   where Id IN: setRSIds]) {
			Boolean isCompleted = true;
			for (sked__Job__c job : rs.sked__Jobs__r) {
				if (job.sked__Job_Status__c != 'Complete' && job.sked__Job_Status__c != 'Cancelled') {
					isCompleted = false;
					break;
				}
			}
			rs.sked_Is_Completed__c = isCompleted;
			recurrings.add(rs);
		}

		update recurrings;
	}

	@Future
	private static void moveAttachmentToOrder(Set<Id> setJobIds, Map<Id, Id> mapOrderIds) {
		Savepoint sp;
		try {
			sp = Database.setSavepoint();

			// Clone Attachments
			List<Attachment> lstAtt = new List<Attachment> ();

			for (Attachment att :[SELECT Id, ParentId, Body, BodyLength, ContentType, Description, Name FROM Attachment WHERE ParentId IN :setJobIds]) {
				Attachment newAtt = att.clone(false, false);
				newAtt.ParentId = mapOrderIds.get(att.ParentId);

				lstAtt.add(newAtt);
			}

			if (!lstAtt.isEmpty()) {
				insert lstAtt;
			}

			// Clone Files
			Set<Id> cdIds = new Set<Id> ();
			List<Id> orderIds = mapOrderIds.values();

			for (ContentDocumentLink lk :[SELECT ContentDocumentId, Id, IsDeleted, LinkedEntityId, ShareType, SystemModstamp, Visibility FROM ContentDocumentLink
			     WHERE LinkedEntityId IN :orderIds]) {
				cdIds.add(lk.ContentDocumentId);
			}

			List<ContentDocumentLink> lstLks = new List<ContentDocumentLink> ();
			for (ContentDocumentLink lk :[SELECT ContentDocumentId, Id, IsDeleted, LinkedEntityId, ShareType, SystemModstamp, Visibility FROM ContentDocumentLink
			     WHERE LinkedEntityId IN :setJobIds AND ContentDocumentId != :cdIds]) {
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

		} catch(Exception ex) {
			Database.rollback(sp);
			System.debug('##### Error: ' + ex.getMessage());
		}
	}

}