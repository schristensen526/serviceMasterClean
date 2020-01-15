@isTest
private class CalloutClassTest {
     @isTest static void testCallout() {
       // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
  
       // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        fieldAware.doCallout('1','2','3');
  
        // Verify response received contains fake values
         //String contentType = res.getHeader('Content-Type');
         //System.assert(contentType == 'application/json');
         //String actualResponseBody = res.getBody();
         //String expectedResponseBody = '{"foo":"bar"}';
         //System.assertEquals(actualResponseBody, expectedResponseBody);
        //System.assertEquals(200, res.getStatusCode());
    }
}