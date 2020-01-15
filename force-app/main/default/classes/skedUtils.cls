public class skedUtils {

	public static Set<Date> getRegionHolidays(Date startDate, string regionName) {
		Map<string, Set<Date>> mapHoliday = skedUtils.getHolidays(startDate);
		Set<Date> allHolidays = new Set<Date> ();
		Set<Date> globalHoidays = mapHoliday.get('global');
		allHolidays.addAll(globalHoidays);
		if (mapHoliday.containsKey(regionName)) {
			Set<Date> regionHolidays = mapHoliday.get(regionName);
			allHolidays.addAll(regionHolidays);
		}
		return allHolidays;
	}

	public static Map<string, Set<Date>> getHolidays(Date currentDate) {
		Map<string, Set<Date>> mapHolidays = new Map<string, Set<Date>> ();
		List<sked__Holiday__c> skedGlobalHolidays = [SELECT Id, sked__Start_Date__c, sked__End_Date__c
		                                             FROM sked__Holiday__c
		                                             WHERE sked__Global__c = TRUE
		                                             AND sked__End_Date__c >= :currentDate];
		List<sked__Holiday_Region__c> skedRegionHolidays = [SELECT Id, sked__Holiday__r.sked__Start_Date__c, sked__Holiday__r.sked__End_Date__c,
		                                                    sked__Region__r.Name
		                                                    FROM sked__Holiday_Region__c
		                                                    WHERE sked__Holiday__r.sked__End_Date__c >= :currentDate];

		Set<Date> globalHolidays = new Set<Date> ();
		for (sked__Holiday__c globalHoliday : skedGlobalHolidays) {
			Date tempDate = globalHoliday.sked__Start_Date__c;
			while (tempDate <= globalHoliday.sked__End_Date__c) {
				globalHolidays.add(tempDate);
				tempDate = tempDate.addDays(1);
			}
		}
		mapHolidays.put('global', globalHolidays);

		for (sked__Holiday_Region__c regionHoliday : skedRegionHolidays) {
			Set<Date> regionHolidays;
			if (mapHolidays.containsKey(regionHoliday.sked__Region__r.Name)) {
				regionHolidays = mapHolidays.get(regionHoliday.sked__Region__r.Name);
			} else {
				regionHolidays = new Set<Date> ();
			}

			Date tempDate = regionHoliday.sked__Holiday__r.sked__Start_Date__c;
			while (tempDate <= regionHoliday.sked__Holiday__r.sked__End_Date__c) {
				regionHolidays.add(tempDate);
				tempDate = tempDate.addDays(1);
			}

			if (!mapHolidays.containsKey(regionHoliday.sked__Region__r.Name)) {
				mapHolidays.put(regionHoliday.sked__Region__r.Name, regionHolidays);
			}
		}
		return mapHolidays;
	}

	public static DateTime addDays(DateTime inputDt, integer days, string timezoneSidId) {
		DateTime result = inputDt.addDays(days);
		Timezone tz = Timezone.getTimezone(timezoneSidId);
		integer inputDtOffset = tz.getOffset(inputDt) / 60000;
		integer resultOffset = tz.getOffset(result) / 60000;

		result = result.addMinutes(inputDtOffset - resultOffset);

		return result;
	}

	public static integer increaseDays(integer days, boolean isIncreasing, DateTime inputDt, string timezoneSidId, String[] skipDaysOfWeek, Set<Date> skipDates) {
		DateTime tempDt = inputDt.addDays(days);
		string weekday = tempDt.format('EEE', timezoneSidId).toUpperCase();
		Boolean isSkip = false;

		for (String dt : skipDaysOfWeek) {
			if (weekday == dt) {
				isSkip = true;
				break;
			}
		}

		if (skipDates.contains(tempDt.date())) {
			isSkip = true;
		}

		if (isSkip) {
			days = isIncreasing ? days + 1 : days - 1;
		} else {
			return days;
		}

		return increaseDays(days, isIncreasing, inputDt, timezoneSidId, skipDaysOfWeek, skipDates);
	}

	public static DateTime addYears(DateTime inputDt, integer years, string timezoneSidId) {
		DateTime result = inputDt.addYears(years);
		Timezone tz = Timezone.getTimezone(timezoneSidId);
		integer inputDtOffset = tz.getOffset(inputDt) / 60000;
		integer resultOffset = tz.getOffset(result) / 60000;

		result = result.addMinutes(inputDtOffset - resultOffset);

		return result;
	}

	public static integer getValidDay(integer day, integer month, integer year) {
		integer result = day;

		boolean leapYear = isLeapYear(year);
		Set<integer> monthWith30days = new Set<integer> { 4, 6, 9, 11 };

		if (month == 2) {
			if (leapYear) {
				if (result > 29) {
					result = 29;
				}
			}
			else {
				if (result > 28) {
					result = 28;
				}
			}
		}
		else if (monthWith30days.contains(month)) {
			if (result > 30) {
				result = 30;
			}
		}

		return result;
	}

	public static boolean isLeapYear(integer year) {
		boolean leapYear;
		if (Math.mod(year, 4) == 0) {
			if (Math.mod(year, 4) == 100) {
				if (Math.mod(year, 4) == 400) {
					leapYear = true;
				}
				else {
					leapYear = false;
				}
			}
			else {
				leapYear = true;
			}
		}
		else {
			leapYear = false;
		}
		return leapYear;
	}
}