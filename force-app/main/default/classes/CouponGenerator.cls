public with sharing class CouponGenerator {

public map<string,string> ConfigMap{
    get {
        if(ConfigMap == null) {
            ConfigMap = new map<string,string>{
                'COUPONCODE' => 'null'
            };
        }
        return ConfigMap;
    }
    private set;
}

public Lead lead {
    get {
        if(lead == null) {
            lead = new Lead(
                LeadSource = 'Coupon Generator',
                Company = 'N/A'
            );
        }
        return lead;
    }
    private set;
}

public void submit(){
    try {
        CouponCode__c c = new CouponCode__c(
            name = getRandomString(7),
            DiscountPercent__c = decimal.valueOf(ConfigMap.get('DEFAULT_DISCOUNT'))
        );
        insert c;
        lead.CouponCode__c = c.id;
        insert lead;
        ConfigMap.put('COUPONCODE',c.Id);
    } catch (exception e) {
        ApexPages.addMessages(e);
        ConfigMap.put('COUPONCODE','null');
        Lead = null;
    }
}

////////////// GET RANDOM STRING //////////////
//This function generates random strings in 2 modes (alpha: only alphabet are used, 
// all: numbers and alphabet,  except for 0,1, O and I )
private final String ALPHA_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
private final String RANDOM_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
private final String PUNCTUATION_CHARS = '`~!@#$%^&*()_+-={}[]:";\'<>?,\\./\"';
   
private final String RANDOM_ALPHA = '25';
private final String RANDOM_ALL = '31';

// Generate random strings.
private String getRandomAlphaString(Integer len){
    return getRandomString(len, RANDOM_ALPHA);
} 
private String getRandomString(Integer len){
    return getRandomString(len, RANDOM_ALL);
} 
private String getRandomString(Integer len, String mode){
    String retVal = '';
    if (len != null && len >= 1){
        Integer chars = 0;
        Integer random;
        do {
            random = Math.round(Math.random() * Integer.valueOf(mode));
            retVal += RANDOM_CHARS.substring(random, random + 1);
            chars++;
        } while (chars < len);
   }
   return retVal;
}

}