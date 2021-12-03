public class BillingCalloutService {
    @future
    public static void callBillingService(String projectid, Double billAmount){
        ServiceCredentials__c credentials = ServiceCredentials__c.getValues('BillingServiceCredential');
        salesforceComThInvoiceWebService.project project_request = new salesforceComThInvoiceWebService.project();
        project_request.username = credentials.Username__c;
        project_request.password = credentials.Password__c;
        project_request.projectid = projectid;
        project_request.billAmount = billAmount;


        salesforceComThInvoiceWebService.InvoicesPortSoap11 invoice = new salesforceComThInvoiceWebService.InvoicesPortSoap11();
        string res = invoice.billProject(project_request);
    }
}

trigger ProjectTrigger on Project__c (after update) {
    List<Project__c> proyects = [
        SELECT id, Status__c, ProjectRef__c, Billable_Amount__c 
        from Project__c 
        where id IN :Trigger.New and Status__c =: 'Billable'];
    
    for(Project__c a : proyects) {
        string ref = String.valueOf(a.ProjectRef__c);
        double amount = a.Billable_Amount__c;
        BillingCalloutService.callBillingService(ref, amount);
    } 
}