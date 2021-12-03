@isTest
global class BillingCalloutServiceMock implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        BillingServiceProxy.billProjectResponse_element billingResponse = 
            new BillingServiceProxy.billProjectResponse_element();
        billingResponse.status = 'OK';
        // end
        response.put('billingResponse', billingResponse); 
   }
}


@isTest
global class BillingCalloutServiceMockFailure implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        // start - specify the response you want to send
        BillingServiceProxy.billProjectResponse_element billingResponse = 
            new BillingServiceProxy.billProjectResponse_element();
        billingResponse.status = 'Error!!';
        // end
        response.put('billingResponse', billingResponse); 
   }
}


@isTest
private class BillingCalloutServiceTest {
    @isTest static void testCallout() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        TestDataFactory.createProject();
        BillingCalloutService.callBillingService();
        // Verify that a fake result is returned
        System.assertEquals(3.0, result); 
    }
}