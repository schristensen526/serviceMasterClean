public class fieldAware{
   @future(callout=true)
    public static void doCallout(String entity,String sfKey,String sfOName)
    {
HttpRequest req = new HttpRequest();
HttpResponse res = new HttpResponse();
Http http = new Http();

String FAurl = 'http://beta-connector.fieldaware.net/services/faNotice/' + entity + '/' + sfKey + '/' + sfOName;

req.setEndpoint(FAurl);
req.setMethod('POST');

//these parts of the POST you may want to customize
//req.setCompressed(false);
req.setBody('{<hello:world>}');
req.setHeader('Content-Type','application/xml');  
req.setHeader('Accept','application/xml');


try {
    res = http.send(req);
    System.debug('Callout Result: ' + res);
} catch(System.CalloutException e) {
    System.debug('Callout error: '+ e);
}

    //return res;
}
}