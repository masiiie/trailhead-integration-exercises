public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Make REST Callout' description='Inserts' category= 'Opportunity')
	public static void PostOpportunityToPMS(List<id> opId){
        Opportunity opp = [
            select id, name, Account.Name, closeDate, amount  
            from Opportunity
            where id =: opId[0]]; 
        ID jobID = System.enqueueJob(new QueueablePMSCall(opp));
    }

    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        private String jsonBody;
        private Opportunity opp;
        private String token = 'f2785df4-45e8-4d7c-8456-de005fb86e7f';

        public QueueablePMSCall(Opportunity oppObj){
            opp = oppObj;
            jsonBody = string.format(
                '{"opportunityId": {0}, "opportunityName": {1}, "accountName": {2}, "closeDate": {3}, "amount": {4}}', 
                new string[]{
                    opp.id, 
                    opp.name,
                    opp.Account.Name,
                    String.valueOf(opp.closeDate),
                    String.valueOf(opp.amount)});
        }
        
        public void execute(QueueableContext context) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://sb-integration-pms-2.herokuapp.com/projects');
            request.setMethod('POST');
            request.setHeader('token', token);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            
            request.setBody(jsonBody);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if(response.getStatusCode() == 201) {
                opp.StageName = 'Submitted Project';
                update opp;
            } else if(response.getStatusCode() == 500) {
                opp.StageName = 'Resubmit Project';
                update opp;
            }
        }
    }
}