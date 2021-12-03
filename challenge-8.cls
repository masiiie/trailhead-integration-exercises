public class BillingCalloutService {
    @future
    public static void callBillingService(String username, String password, String projectid, Double billAmount){
        salesforceComThInvoiceWebService.project project_request = new salesforceComThInvoiceWebService.project();
        project_request.username = username;
        project_request.password = password;
        project_request.projectid = projectid;
        project_request.billAmount = billAmount;


        salesforceComThInvoiceWebService.InvoicesPortSoap11 invoice = new salesforceComThInvoiceWebService.InvoicesPortSoap11();
        string res = invoice.billProject(project_request);
    }
}