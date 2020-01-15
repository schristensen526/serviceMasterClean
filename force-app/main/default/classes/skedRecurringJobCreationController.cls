global class skedRecurringJobCreationController {

	public skedRecurringJobCreationController() {

	}

	public skedRecurringJobCreationController(ApexPages.StandardController con) {

	}

	@RemoteAction
	public static skedResult doSave(skedRecurringJobModal modal) {
		skedResult result = new skedResult();
		result.status = 'SUCCESS';

		Savepoint sp;
		try {

			sp = Database.setSavepoint();

			sked__Region__c region = [SELECT Id, Name, sked__Timezone__c FROM sked__Region__c WHERE Name = 'SMC' LIMIT 1];

			if (region == null) {
				result.status = 'ERROR';
				result.message = 'Error: Invalid region.';
				return result;
			}

			Order__c order = [SELECT Id, Account__c, ActualTime__c, AddressLine1__c, AddressLine2__c, Building_Notice__c, City__c,
			                  Comments__c, Contact__c, Contact__r.Email, Country__c, Crew__c, Date__c, Duration__c, Email__c, FirstName__c, Job_Type__c,
			                  LastName__c, Parent_Account__c, Phone__c, PrimaryContact__c, Reference_Info__c, StateProvince__c,
			                  ZipPostalCode__c
			                  FROM Order__c
			                  WHERE Id = :modal.orderId
			                  LIMIT 1];

			string timezoneSidId = region.sked__Timezone__c;
			
			
			List<String> lstStartDate = modal.startDate.split('/');
			String strStartDate = '"' + lstStartDate[2] + '-' + lstStartDate[0] + '-' + lstStartDate[1] + '"';
			
			DateTime jobStartTime = DateTime.newInstance((Date) JSON.deserialize(strStartDate, Date.class), getStartTime(modal.startTime));

			if (modal.Repeat == 'NTH_DAY_OF_MONTH') {
				Date jobStartDate = (Date) JSON.deserialize(strStartDate, Date.class);
				if (modal.day < jobStartDate.day()) {
					Integer jobMonth = (jobStartDate.month() == 12) ? 1 : (jobStartDate.month() + 1);
					Integer jobYear = (jobStartDate.month() == 12) ? (jobStartDate.year() + 1) : jobStartDate.year();
					jobStartTime = DateTime.newInstance(Date.newInstance(jobYear, jobMonth, modal.day), getStartTime(modal.startTime));
				}
				else {
					System.debug('#jobStartDate# ' + jobStartDate);
					System.debug('#modal.day# ' + modal.day);
					System.debug('#modal.startTime# ' + modal.startTime);
					jobStartTime = DateTime.newInstance(Date.newInstance(jobStartDate.year(), jobStartDate.month(), modal.day), getStartTime(modal.startTime));
				}
			}

			sked__Recurring_Schedule__c schedule = prepareScheduleData(modal, jobStartTime, timezoneSidId, order.Contact__c, order.Contact__r.Email);
			System.debug(schedule);
			insert schedule;

			List<sked__Job__c> allJobs = new List<sked__Job__c> ();

			sked__Job__c job = new sked__Job__c(
			                                    Order__c = order.Id,
			                                    sked__Account__c = order.Account__c,
			                                    Actual_Time__c = jobStartTime,
			                                    AddressLine1__c = order.AddressLine1__c,
			                                    AddressLine2__c = order.AddressLine2__c,
			                                    Building_Notice__c = order.Building_Notice__c,
			                                    City__c = order.City__c,
			                                    Comments__c = order.Comments__c,
			                                    sked__Contact__c = order.Contact__c,
			                                    Country__c = order.Country__c,
			                                    Crew__c = order.Crew__c,
			                                    Date__c = order.Date__c,
			                                    sked__Duration__c = order.Duration__c,
			                                    Email__c = order.Email__c,
			                                    First_Name__c = order.FirstName__c,
			                                    Job_Type__c = order.Job_Type__c,
			                                    Last_Name__c = order.LastName__c,
			                                    Parent_Account__c = order.Parent_Account__c,
			                                    Phone__c = order.Phone__c,
			                                    PrimaryContact__c = order.PrimaryContact__c,
			                                    Reference_Info__c = order.Reference_Info__c,
			                                    State_Province__c = order.StateProvince__c,
			                                    Status__c = 'Queued',
			                                    Zip_Postal_Code__c = order.ZipPostalCode__c,
			                                    sked__Region__c = region.Id,
			                                    sked__Recurring_Schedule__c = schedule.Id,
			                                    sked__Start__c = jobStartTime,
												sked__Finish__c = jobStartTime.addMinutes(Integer.valueOf(order.Duration__c)),
                                                sked__Description__c = order.Reference_Info__c,
                                                sked__Address__c	= order.AddressLine1__c,
                                                sked__Type__c		= order.Job_Type__c
			);

			allJobs.add(job);

			List<sked__Job__c> recurringJobs = new List<sked__Job__c> ();

			System.debug('#this.modal#' + modal);

			if (modal.Repeat == 'DAILY') {
				recurringJobs = getDailyRecurringJobs(modal, job, timezoneSidId, region.Name);
			}
			else if (modal.Repeat == 'WEEKLY') {
				recurringJobs = getWeeklyRecurringJobs(modal, job, timezoneSidId, region.Name);
			}
			else if (modal.Repeat == 'NTH_DAY_OF_MONTH') {
				recurringJobs = getNthMonthlyRecurringJobs(modal, job, timezoneSidId, region.Name);
			}
			else if (modal.Repeat == 'YEARLY') {
				recurringJobs = getYearlyRecurringJobs(modal, job, timezoneSidId, region.Name);
			}
			else if (modal.Repeat == 'MONTHLY') {
				recurringJobs = getMonthlyRecurringJobs(modal, job, timezoneSidId, region.Name);
			}
			allJobs.addAll(recurringJobs);

			insert allJobs;
			System.debug('' + allJobs);

			Set<Id> jobIds = new Set<Id>();
			for (sked__Job__c newJob : allJobs) {
				jobIds.add(newJob.Id);
			}

			sked__Recurring_Schedule__c resultRS = [SELECT Id, Name, sked__Summary__c FROM sked__Recurring_Schedule__c WHERE Id=: schedule.Id];
			
			result.rs = new skedObj(resultRS.Name, resultRS.Id, resultRS.sked__Summary__c);
			result.lstJob = new List<skedObj>();
			for (sked__Job__c newJob : [SELECT Id, Name, sked__Start__c, sked__Finish__c FROM sked__Job__c WHERE Id IN: jobIds ORDER BY sked__Start__c ASC LIMIT 10]) {
				result.lstJob.add(new skedObj(newJob.Name, newJob.Id, newJob.sked__Start__c.format('MM/dd/yyyy h:mm a', timezoneSidId), newJob.sked__Finish__c.format('MM/dd/yyyy h:mm a', timezoneSidId)));
			}
			return result;
		} catch(Exception ex) {
			Database.rollback(sp);

			result.status = 'ERROR';
			result.message = ex.getMessage();
			System.debug('#Error# ' + ex.getStackTraceString());
			System.debug('#ErrorMessage# ' + ex.getMessage());
			return result;
		}
	}

	public static Time getStartTime(String jobStartTimeString)
    {
        boolean isAfterNoon = false;
        if(jobStartTimeString.indexOf('PM') > - 1 || jobStartTimeString.indexOf('pm') > -1){
            isAfterNoon = true;
        }
        integer hour    = Integer.valueOf(jobStartTimeString.split(':')[0]);
        if(hour == 12 && (jobStartTimeString.indexOf('am') > -1 || jobStartTimeString.indexOf('AM') > -1)) hour = 0;
        integer minute  = Integer.valueOf(jobStartTimeString.split(':')[1].remove('AM').remove('am').remove('PM').remove('pm').trim());
        if(isAfterNoon && hour != 12) hour = hour + 12;

        return time.newInstance(hour, minute, 0, 0);
    }

	private static sked__Recurring_Schedule__c prepareScheduleData(skedRecurringJobModal wrapper, DateTime jobStartDate, string timezoneSidId, string contactId, string contactEmail) {
		string summary = '';
		DateTime dt = jobStartDate;
		if (wrapper.repeat == 'DAILY') {
			if (wrapper.repeatDay == 1) {
				summary = 'Repeats daily';
			} else {
				summary = 'Repeats every ' + wrapper.repeatDay + ' days';
			}
		}
		else if (wrapper.repeat == 'WEEKLY') {
			if (wrapper.repeatWeek == 1) {
				summary = 'Repeats weekly on ' + wrapper.daysOfWeek;
			} else {
				summary = 'Repeats every ' + wrapper.repeatWeek + ' weeks on ' + wrapper.daysOfWeek;
			}
		}
		else if (wrapper.repeat == 'MONTHLY') {
			if (wrapper.repeatMonth == 1) {
				summary = 'Repeats monthly on the ' + jobStartDate.day() + ' day of the month';
			} else {
				summary = 'Repeats every ' + wrapper.repeatMonth + ' months on the ' + jobStartDate.day() + ' day of the month';
			}
		}
		else if (wrapper.repeat == 'NTH_DAY_OF_MONTH') {
			if (wrapper.repeatMonth == 1) {
				summary = 'Repeats monthly on the ' + wrapper.day + ' day of the month';
			} else {
				summary = 'Repeats every ' + wrapper.repeatMonth + ' months on the ' + wrapper.day + ' day of the month';
			}
		}
		else if (wrapper.repeat == 'YEARLY') {
			if (wrapper.repeatYear == 1) {
				summary = 'Repeats yearly on ' + dt.format('MMMM dd', timezoneSidId);
			} else {
				summary = 'Repeats every ' + wrapper.repeatYear + ' years on ' + dt.format('MMMM dd', timezoneSidId);
			}
		}

		summary += '. Starting on ' + jobStartDate.format('MMMM dd, yyyy', timezoneSidId);
		if (wrapper.ending == 'AFTER') {
			summary += ', ending after ' + wrapper.endingOccurrence + ' occurrences.';
		}
		else if (wrapper.ending == 'ON') {
			List<String> lstEndingOn = wrapper.endingOn.split('/');
			String strEndingOn = '"' + lstEndingOn[2] + '-' + lstEndingOn[0] + '-' + lstEndingOn[1] + '"';
			Date endingOn = (Date) JSON.deserialize(strEndingOn, Date.class);
			DateTime endingOnDt = DateTime.newInstance(endingOn, time.newInstance(0, 0, 0, 0));
			summary += ', ending on ' + endingOnDt.format('MMMM dd, yyyy', timezoneSidId) + ' .';
		}

		sked__Recurring_Schedule__c schedule = new sked__Recurring_Schedule__c(
			sked__Summary__c = summary,
			sked_Contact__c = contactId,
			sked_Contact_Email__c = contactEmail
		);
		return schedule;
	}

	private static List<sked__Job__c> getDailyRecurringJobs(skedRecurringJobModal wrapper, sked__Job__c sourceJob, string timezoneSidId, string regionName) {
		List<sked__Job__c> recurringJobs = new List<sked__Job__c> ();
		integer jobDuration = integer.valueOf(sourceJob.sked__Duration__c);
		integer every = integer.valueOf(wrapper.repeatDay);
		Set<Date> skipDates = new Set<Date> ();

		if (wrapper.skipHoliday) {
			skipDates.addAll(skedUtils.getRegionHolidays(System.Today(), regionName));
		}

		System.debug('#skipDates#' + skipDates);
		System.debug('#excludeHolidays#' + wrapper.skipHoliday);
		if (wrapper.ending == 'AFTER') {
			integer dayCount = every;
			integer count = 1;
			while (count<wrapper.endingOccurrence) {
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, dayCount, timezoneSidId);
				if ((wrapper.skipHoliday == true && !skipDates.contains(recurringJobStart.date())) || wrapper.skipHoliday == false) {
					integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
					recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
					dayCount += increasedDays;

					sked__Job__c recurringJob = sourceJob.clone();
					recurringJob.sked__Start__c = recurringJobStart;
					recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
					recurringJobs.add(recurringJob);
					count++;
				}
				dayCount += every;
			}
		}
		else if (wrapper.ending == 'ON') {
			System.debug('#sourceJob#' + sourceJob);
			Date sourceJobDate = (Date) Json.deserialize(sourceJob.sked__Start__c.format('"yyyy-MM-dd"', timezoneSidId), Date.class);
			List<String> lstEndingOn = wrapper.endingOn.split('/');
			String strEndingOn = '"' + lstEndingOn[2] + '-' + lstEndingOn[0] + '-' + lstEndingOn[1] + '"';
			Date endingOn = (Date) JSON.deserialize(strEndingOn, Date.class);
			integer daysToEnding = sourceJobDate.daysBetween(endingOn);
			integer dayCount = every;

			System.debug('#daysToEnding#' + daysToEnding);

			while (dayCount <= daysToEnding) {
				System.debug('#dayCount#' + dayCount);
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, dayCount, timezoneSidId);
				System.debug('#recurringJobStart.date()#' + recurringJobStart.date());

				if ((wrapper.skipHoliday == true && !skipDates.contains(recurringJobStart.date())) || wrapper.skipHoliday == false) {
					integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
					recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
					dayCount += increasedDays;

					if (dayCount <= daysToEnding) {
						sked__Job__c recurringJob = sourceJob.clone();
						recurringJob.sked__Start__c = recurringJobStart;
						recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
						recurringJobs.add(recurringJob);
					}
				}
				dayCount += every;
			}
		}

		return recurringJobs;
	}

	private static List<sked__Job__c> getWeeklyRecurringJobs(skedRecurringJobModal wrapper, sked__Job__c sourceJob, string timezoneSidId, string regionName) {
		List<sked__Job__c> recurringJobs = new List<sked__Job__c> ();
		integer jobDuration = integer.valueOf(sourceJob.sked__Duration__c);
		integer every = integer.valueOf(wrapper.repeatWeek);
		Set<Date> skipDates = new Set<Date> ();

		if (wrapper.skipHoliday) {
			skipDates.addAll(skedUtils.getRegionHolidays(System.Today(), regionName));
		}

		if (wrapper.ending == 'AFTER') {
			integer count = 1;
			integer dayCount = 1;
			while (count<wrapper.endingOccurrence) {
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, dayCount, timezoneSidId);
				string recurringJobWeekday = recurringJobStart.format('EEE', timezoneSidId).toUpperCase();
				if (recurringJobWeekday == 'MON') {
					recurringJobStart = skedUtils.addDays(recurringJobStart, 7 * (every - 1), timezoneSidId);
					dayCount = dayCount + 7 * (every - 1);
				}

				if (wrapper.daysOfWeek.contains(recurringJobWeekday)) {
					if ((wrapper.skipHoliday == true && !skipDates.contains(recurringJobStart.date())) || wrapper.skipHoliday == false) {
						integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
						recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
						dayCount += increasedDays;

						sked__Job__c recurringJob = sourceJob.clone();
						recurringJob.sked__Start__c = recurringJobStart;
						recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
						recurringJobs.add(recurringJob);
						count++;
					}
				}
				dayCount++;
			}
		}
		else if (wrapper.Ending == 'ON') {
			Date sourceJobDate = (Date) Json.deserialize(sourceJob.sked__Start__c.format('"yyyy-MM-dd"', timezoneSidId), Date.class);
			List<String> lstEndingOn = wrapper.EndingOn.split('/');
			String strEndingOn = '"' + lstEndingOn[2] + '-' + lstEndingOn[0] + '-' + lstEndingOn[1] + '"';
			Date endingOn = (Date) JSON.deserialize(strEndingOn, Date.class);
			integer daysToEnding = sourceJobDate.daysBetween(endingOn);
			integer dayCount = 1;
			while (dayCount <= daysToEnding) {
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, dayCount, timezoneSidId);
				string recurringJobWeekday = recurringJobStart.format('EEE', timezoneSidId).toUpperCase();
				if (recurringJobWeekday == 'MON') {
					recurringJobStart = skedUtils.addDays(recurringJobStart, 7 * (every - 1), timezoneSidId);
					dayCount = dayCount + 7 * (every - 1);
					if (dayCount> daysToEnding) {
						break;
					}
				}
				if (wrapper.DaysOfWeek.contains(recurringJobWeekday)) {
					if ((wrapper.skipHoliday == true && !skipDates.contains(recurringJobStart.date())) || wrapper.skipHoliday == false) {
						integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
						recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
						dayCount += increasedDays;
						if (dayCount <= daysToEnding) {
							sked__Job__c recurringJob = sourceJob.clone();
							recurringJob.sked__Start__c = recurringJobStart;
							recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
							recurringJobs.add(recurringJob);
						}
					}
				}
				dayCount++;
			}
		}
		return recurringJobs;
	}

	private static List<sked__Job__c> getMonthlyRecurringJobs(skedRecurringJobModal wrapper, sked__Job__c sourceJob, string timezoneSidId, string regionName) {
		Date sourceJobDate = (Date) Json.deserialize(sourceJob.sked__Start__c.format('"yyyy-MM-dd"', timezoneSidId), Date.class);
		integer sourceJobDay = sourceJobDate.day();
		integer sourceJobMonth = sourceJobDate.month() + 1;
		integer sourceJobYear = sourceJobDate.year();

		integer tempDay = skedUtils.getValidDay(sourceJobDay, sourceJobMonth, sourceJobYear);

		List<sked__Job__c> recurringJobs = new List<sked__Job__c> ();
		integer jobDuration = integer.valueOf(sourceJob.sked__Duration__c);
		integer every = integer.valueOf(wrapper.repeatMonth);
		Set<Date> skipDates = new Set<Date> ();

		if (wrapper.skipHoliday) {
			skipDates.addAll(skedUtils.getRegionHolidays(System.Today(), regionName));
		}

		if (wrapper.Ending == 'AFTER') {
			integer count = 1;
			while (count<wrapper.endingOccurrence) {
				System.debug('@@@@:count: ' + count);
				Date recurringJobDate = Date.newInstance(sourceJobYear, sourceJobMonth, tempDay);
				integer daysBetween = sourceJobDate.daysBetween(recurringJobDate);
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, daysBetween, timezoneSidId);
				integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
				recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
				sked__Job__c recurringJob = sourceJob.clone();
				recurringJob.sked__Start__c = recurringJobStart;
				recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
				recurringJobs.add(recurringJob);

				sourceJobMonth += every;
				System.debug('@@@@' + sourceJobMonth);
				if (sourceJobMonth> 12) {
					sourceJobYear += integer.valueOf(sourceJobMonth / 12);
					sourceJobMonth = Math.mod(sourceJobMonth, 12);
				}
				tempDay = skedUtils.getValidDay(sourceJobDay, sourceJobMonth, sourceJobYear);
				count++;
			}
		}
		else if (wrapper.Ending == 'ON') {
			Date tempDate = Date.newInstance(sourceJobYear, sourceJobMonth, tempDay);
			List<String> lstEndingOn = wrapper.EndingOn.split('/');
			String strEndingOn = '"' + lstEndingOn[2] + '-' + lstEndingOn[0] + '-' + lstEndingOn[1] + '"';
			Date endingOn = (Date) JSON.deserialize(strEndingOn, Date.class);
			while (tempDate <= endingOn) {
				integer daysBetween = sourceJobDate.daysBetween(tempDate);
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, daysBetween, timezoneSidId);
				integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
				recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
				if (recurringJobStart.date() <= endingOn) {
					sked__Job__c recurringJob = sourceJob.clone();
					recurringJob.sked__Start__c = recurringJobStart;
					recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
					recurringJobs.add(recurringJob);
				}

				sourceJobMonth += every;
				if (sourceJobMonth> 12) {
					sourceJobYear += integer.valueOf(sourceJobMonth / 12);
					sourceJobMonth = Math.mod(sourceJobMonth, 12);
				}
				tempDay = skedUtils.getValidDay(sourceJobDay, sourceJobMonth, sourceJobYear);
				tempDate = Date.newInstance(sourceJobYear, sourceJobMonth, tempDay);
			}
		}

		return recurringJobs;
	}

	private static List<sked__Job__c> getNthMonthlyRecurringJobs(skedRecurringJobModal wrapper, sked__Job__c sourceJob, string timezoneSidId, string regionName) {
		Date sourceJobDate = (Date) Json.deserialize(sourceJob.sked__Start__c.format('"yyyy-MM-dd"', timezoneSidId), Date.class);
		integer sourceJobDay = sourceJobDate.day();
		integer sourceJobMonth = sourceJobDate.month();
		integer sourceJobYear = sourceJobDate.year();

		integer tempMonth = sourceJobDay<wrapper.day ? sourceJobMonth : sourceJobMonth + 1;
		integer tempYear = sourceJobYear;
		if (tempMonth> 12) {
			tempYear += integer.valueOf(tempMonth / 12);
			tempMonth = Math.mod(tempMonth, 12);
		}
		integer tempDay = skedUtils.getValidDay(wrapper.day, tempMonth, tempYear);

		List<sked__Job__c> recurringJobs = new List<sked__Job__c> ();
		integer jobDuration = integer.valueOf(sourceJob.sked__Duration__c);
		integer every = integer.valueOf(wrapper.repeatMonth);
		Set<Date> skipDates = new Set<Date> ();

		if (wrapper.skipHoliday) {
			skipDates.addAll(skedUtils.getRegionHolidays(System.Today(), regionName));
		}

		if (wrapper.Ending == 'AFTER') {
			integer count = 1;
			while (count<wrapper.endingOccurrence) {
				Date recurringJobDate = Date.newInstance(tempYear, tempMonth, tempDay);
				integer daysBetween = sourceJobDate.daysBetween(recurringJobDate);
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, daysBetween, timezoneSidId);
				integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
				recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
				sked__Job__c recurringJob = sourceJob.clone();
				recurringJob.sked__Start__c = recurringJobStart;
				recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
				recurringJobs.add(recurringJob);
				tempMonth += every;
				if (tempMonth> 12) {
					tempYear += integer.valueOf(tempMonth / 12);
					tempMonth = Math.mod(tempMonth, 12);
				}
				tempDay = skedUtils.getValidDay(wrapper.day, tempMonth, tempYear);
				count++;
			}
		}
		else if (wrapper.Ending == 'ON') {
			Date tempDate = Date.newInstance(tempYear, tempMonth, tempDay);
			List<String> lstEndingOn = wrapper.EndingOn.split('/');
			String strEndingOn = '"' + lstEndingOn[2] + '-' + lstEndingOn[0] + '-' + lstEndingOn[1] + '"';
			Date endingOn = (Date) JSON.deserialize(strEndingOn, Date.class);
			while (tempDate <= endingOn) {
				integer daysBetween = sourceJobDate.daysBetween(tempDate);
				DateTime recurringJobStart = skedUtils.addDays(sourceJob.sked__Start__c, daysBetween, timezoneSidId);
				integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
				recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
				if (recurringJobStart.date() <= endingOn) {
					sked__Job__c recurringJob = sourceJob.clone();
					recurringJob.sked__Start__c = recurringJobStart;
					recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
					recurringJobs.add(recurringJob);
				}

				tempMonth += every;
				if (tempMonth> 12) {
					tempYear += integer.valueOf(tempMonth / 12);
					tempMonth = Math.mod(tempMonth, 12);
				}
				tempDay = skedUtils.getValidDay(wrapper.day, tempMonth, tempYear);
				tempDate = Date.newInstance(tempYear, tempMonth, tempDay);
			}
		}

		return recurringJobs;
	}

	private static List<sked__Job__c> getYearlyRecurringJobs(skedRecurringJobModal wrapper, sked__Job__c sourceJob, string timezoneSidId, string regionName) {
		List<sked__Job__c> recurringJobs = new List<sked__Job__c> ();
		integer jobDuration = integer.valueOf(sourceJob.sked__Duration__c);
		integer every = integer.valueOf(wrapper.repeatYear);
		Set<Date> skipDates = new Set<Date> ();

		if (wrapper.skipHoliday) {
			skipDates.addAll(skedUtils.getRegionHolidays(System.Today(), regionName));
		}

		if (wrapper.Ending == 'AFTER') {
			integer yearCount = every;
			integer count = 1;
			while (count<wrapper.endingOccurrence) {
				DateTime recurringJobStart = skedUtils.addYears(sourceJob.sked__Start__c, yearCount, timezoneSidId);
				integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
				recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
				sked__Job__c recurringJob = sourceJob.clone();
				recurringJob.sked__Start__c = recurringJobStart;
				recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
				recurringJobs.add(recurringJob);
				count++;
				yearCount += every;
			}
		}
		else if (wrapper.Ending == 'ON') {
			Date tempDate = (Date) Json.deserialize(sourceJob.sked__Start__c.format('"yyyy-MM-dd"', timezoneSidId), Date.class);
			List<String> lstEndingOn = wrapper.EndingOn.split('/');
			String strEndingOn = '"' + lstEndingOn[2] + '-' + lstEndingOn[0] + '-' + lstEndingOn[1] + '"';
			Date endingOn = (Date) JSON.deserialize(strEndingOn, Date.class);
			integer yearCount = every;
			while (tempDate <= endingOn) {
				DateTime recurringJobStart = skedUtils.addYears(sourceJob.sked__Start__c, yearCount, timezoneSidId);
				integer increasedDays = skedUtils.increaseDays(0, true, recurringJobStart, timezoneSidId, wrapper.skipDaysOfWeek, skipDates);
				recurringJobStart = skedUtils.addDays(recurringJobStart, increasedDays, timezoneSidId);
				system.debug(recurringJobStart); system.debug(endingOn);
				if (recurringJobStart.date() <= endingOn) {
					sked__Job__c recurringJob = sourceJob.clone();
					recurringJob.sked__Start__c = recurringJobStart;
					recurringJob.sked__Finish__c = recurringJobStart.addMinutes(jobDuration);
					recurringJobs.add(recurringJob);
				}
				yearCount += every;
				tempDate = tempDate.addYears(every);
			}
		}

		return recurringJobs;
	}

	global class skedRecurringJobModal {
		public skedRecurringJobModal() { }

		public String orderId { get; set; }
		public String repeat { get; set; }
		public Integer repeatDay { get; set; }
		public Integer repeatWeek { get; set; }
		public Integer repeatMonth { get; set; }
		public Integer repeatYear { get; set; }
		public String ending { get; set; }
		public Integer endingOccurrence { get; set; }
		public String endingOn { get; set; }
		public Boolean skipHoliday { get; set; }
		public List<String> skipDaysOfWeek { get; set; }
		public List<String> daysOfWeek { get; set; }
		public Integer day { get; set; }
		public String startDate { get; set; }
		public String startTime { get; set; }
	}

	global class skedResult {
		public String status { get; set; }
		public String message { get; set; }
		public skedObj rs { get; set; }
		public List<skedObj> lstJob { get; set; }
	}

	global class skedObj {
		public String name { get; set; }
		public String id { get; set; }
		public String summary { get; set; }
		public String start { get; set; }
		public String finish { get; set; }

		public skedObj (String strName, String strId) {
			name = strName;
			id = strId;
		}
		public skedObj (String strName, String strId, String strSummary) {
			name = strName;
			id = strId;
			summary = strSummary;
		}
		public skedObj (String strName, String strId, String startTime, String finishTime) {
			name = strName;
			id = strId;
			start = startTime;
			finish = finishTime;
		}
	}
}