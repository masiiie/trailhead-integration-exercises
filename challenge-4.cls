public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
	public static void postOpportunityToPMS(id opId){
        Opportunity opp = [
            select id, name, cuenta.name, closeDate, amount  
            from Opportunity opp, opp.AccountId cuenta
            where id = opId];  

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://sb-integration-pms-2.herokuapp.com/projects');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        String jsonBody = string.format(
            '{"opportunityId": {0}, "opportunityName": {1}, "accountName": {2}, "closeDate": {3}, "amount": {4}}', 
            new string[]{
                opp.id, 
                opp.name,
                opp.cuenta.name,
                opp.closeDate,
                opp.amount});
        request.setBody(jsonBody);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
}


public class QueueablePMSCall implements Queueable {
    public void execute(QueueableContext context) {
        // awesome code here
    }
}

public class ProjectCalloutServiceMock {
   //Implement http mock callout here
}