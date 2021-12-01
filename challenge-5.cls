@isTest
private class ProjectCalloutServiceTest {
  @isTest 
    static void testSuccess() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 

        /*
        List<Opportunity> opps = [
            select id
            from Opportunity
            where type =: 'New Project' and StageName =: 'Closed Won'
            limit 2];
        */
        List<Opportunity> opps = TestDataFactory.createLisOpp(3);
        List<id> idList = new List<id>();
        for(Opportunity a : opps){
            idList.add(a.id);
        }

        Test.startTest();
        ID jobId = ProjectCalloutService.PostOpportunityToPMS(idList);
        Test.stopTest();

        
        Opportunity opp = [select id, StageName from Opportunity where id =: idList[0]];
        
        System.assertEquals(opp.StageName, 'Submitted Project');
    }
  @isTest 
    static void testFailure() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 

        List<Opportunity> opps = TestDataFactory.createLisOpp(3);
        List<id> idList = new List<id>();
        for(Opportunity a : opps){
            idList.add(a.id);
        }

        Test.startTest();
        ID jobId = ProjectCalloutService.PostOpportunityToPMS(idList);
        Test.stopTest();

        
        Opportunity opp = [select id, StageName from Opportunity where id =: idList[0]];
        
        System.assertEquals(opp.StageName, 'Resubmit Project');
    }
}

@isTest
public class ProjectCalloutServiceMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatus('OK');
        response.setStatusCode(201);
        return response; 
    }
}


@isTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatus('Grave error!!');
        response.setStatusCode(500);
        return response; 
    }
}

@isTest
    public class TestDataFactory {
        public static List<Opportunity> createLisOpp(Integer numOpps) {
            Account acc = new Account(name='MasiAccount');
            List<Opportunity> opps = new List<Opportunity>();
            for (Integer j=0;j<numOpps;j++) {
                opps.add(new Opportunity(
                    Name='Opportunity ' + j,
                    StageName='Closed Won',
                    Type='New Project',
                    CloseDate=System.today().addMonths(1),
                    AccountId=acc.Id));
            }
            // Insert all opportunities for all accounts.
            insert opps;
            
            return opps;
        }
    }