/*
public class ProjectRESTService {
    public static void postProjectData(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse response = http.send(request); 

        if(response.getStatusCode() == 200) {    
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for(Object animal: animals) {
                System.debug(animal);
            }
        }
    }
}
*/

@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    
    @HttpPost
    global static String postProjectData(
    String projectRef,
    String projectName,
    String opportunityId,
    Date startDate,
    Date endDate,
    Double amount,
    String status){
        
        Savepoint sPoint = Database.setSavepoint();
        
        try{
            Project__c project = new Project__c();
            project.ProjectRef__c = projectRef;
            project.Name = projectName;
            project.Opportunity__c = opportunityId;
            project.Start_Date__c = startDate;
            project.End_Date__c = endDate;
            project.Billable_Amount__c = amount;
            project.Status__c = status;            
            upsert project;
            
            Opportunity opp = new Opportunity();
            opp.Id = opportunityId;
            opp.DeliveryInstallationStatus__c = 'In progress';
            update opp;
            
            return 'OK';
            
        }catch(Exception ex){
            Database.rollback(sPoint);
            return ex.getMessage();
        }      
    }   
}

/*

The @RestResource annotation is used at the class level and enables you to expose an Apex class as a REST resource.

These are some considerations when using this annotation:
The URL mapping is relative to https://instance.salesforce.com/services/apexrest/.
A wildcard character (*) may be used.
The URL mapping is case-sensitive. A URL mapping for my_url will only match a REST resource containing my_url and not My_Url.
To use this annotation, your Apex class must be defined as global.

*/