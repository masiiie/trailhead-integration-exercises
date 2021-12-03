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
        BillingServiceProxy.billProjectResponse_element response_x = 
            new BillingServiceProxy.billProjectResponse_element();
        response_x.status = 'OK';
        // end
        response.put('response_x', response_x); 
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
        BillingServiceProxy.billProjectResponse_element response_x = 
            new BillingServiceProxy.billProjectResponse_element();
        response_x.status = 'Error!!';
        // end
        response.put('response_x', response_x); 
   }
}


@isTest
private class BillingCalloutServiceTest {
    @isTest static void testSuccess() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Project__c project = TestDataFactory.createProject();
        TestDataFactory.createCredential();


        Test.startTest();
        project.Status__c = 'Billable';
        update project;
        Test.stopTest();

        System.assertEquals('Billed', project.Status__c);
    }

    @isTest static void testFailure() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        Project__c project = TestDataFactory.createProject();
        TestDataFactory.createCredential();

        Test.startTest();
        project.Status__c = 'Billable';
        update project;
        Test.stopTest();

        System.assertNotEquals('Billed', project.Status__c);
    }
}