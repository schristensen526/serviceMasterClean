public class TEST_Helper{
/* TEST_Helper
 * This is not a test class. This class is used to house all needed records to be created inside test classes.
 * Create entries (if needed) in the style as the other ones below - and listed alphabetically by property name.
 * DO NOT create records inside test classes!
 * If you do, Liam Neeson from Taken will come after you. To kill you - not to be your friend...
 * Jay-Nicolas Hackleman - NexPATH Solutions - Feb 2015
*/

//A Coupon code
public static CouponCode__c testCouponCode00{
    get {
        if(testCouponCode00 == null) {
            testCouponCode00 = new CouponCode__c(
                name = 'TESTCOUPONCODE00',
                Valid__c = true,
                DiscountPercent__c = 10,
                Uses__c = 1
            );
            insert testCouponCode00;
        }
        return testCouponCode00;
    }
    private set;
}

//An Order record
public static Order__c testOrder00{
    get {
        if(testOrder00 == null) {
            testOrder00 = new Order__c(
                LastName__c = 'testLastName',
                Email__c = 'test@email.com',
                Phone__c = '1234567890',
                AddressLine1__c = 'testAddressLine1',
                City__c = 'testCity',
                Date__c = Date.today()
            );
            insert testOrder00;
        }
        return testOrder00;
    }
    private set;
}

//A Product
public static Product__c testProduct00{
    get {
        if(testProduct00 == null) {
            testProduct00 = new Product__c(
                RecordtypeId = productRecordTypes.get('Carpet Cleaning').Id,
                Service__c = 'Clean',
                Type__c = 'Room',
                Price__c = 1,
                Quantity__c = 1
            );
            insert testProduct00;
        }
        return testProduct00;
    }
    private set;
}

public static map<string,RecordType> productRecordTypes {
    get {
        if(productRecordTypes == null) {
            productRecordTypes = new map<string,RecordType>();
            RecordType[] rs = [SELECT Id, name FROM RecordType WHERE sObjectType = 'Product__c'];
            for(RecordType r : rs) {
                productRecordTypes.put(r.name,r);
            }
        }
        return productRecordTypes;
    }
    private set;
}

//A time slot
public static TimeSlot__c testTimeSlot00{
    get {
        if(testTimeSlot00 == null) {
            testTimeSlot00 = new TimeSlot__c(
                name = 'testTimeSlot00',
                FromHour__c = 8,
                FromMinute__c = 0,
                FromAMPM__c = 'AM',
                ToHour__c = 9,
                ToMinute__c = 0,
                ToAMPM__c = 'AM',
                Order__c = 1
            );
            insert testTimeSlot00;
        }
        return testTimeSlot00;
    }
    private set;
}

}