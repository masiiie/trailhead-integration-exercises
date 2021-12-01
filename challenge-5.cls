@isTest
private class ProjectCalloutServiceTest {
  @isTest 
    static void testSuccess() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 

        Opportunity opps = [select id frm Opportunity]

        ID jobId = ProjectCalloutService.PostOpportunityToPMS()

        
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        String expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, response.getStatusCode());
    }
}

@isTest
public class ProjectCalloutServiceMock implements HttpCalloutMock {
   // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
        response.setStatusCode(200);
        return response; 
    }
}

@isTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout failure here 
}