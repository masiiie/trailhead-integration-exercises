@IsTest
private class ProjectRESTServiceTest {  
     @isTest static void testCreateCase() {
        Opportunity opp = TestDataFactory.createLisOpp(1)[0];
        date date1 = Date.newInstance(2016, 12, 9);
        date date2 = Date.newInstance(2026, 12, 9);
        String res = ProjectRESTService.postProjectData('27', 'Project Name', (String)opp.id, date1, date2, 5, 'Running');
        
        
        System.assertEquals(res, 'OK');
        
        Project__c thisProject = [
            SELECT Id, ProjectRef__c, Name, Opportunity__c, Start_Date__c, End_Date__c, Status__c, Billable_Amount__c
            FROM Project__c 
            WHERE Opportunity__c=:opp.id 
            limit 1];
        System.assert(thisProject != null);
        System.assertEquals(thisProject.ProjectRef__c, '27');
        System.assertEquals(thisProject.name, 'Project Name');
        System.assertEquals(thisProject.Opportunity__c, opp.id);
        System.assertEquals(thisProject.Start_Date__c, date1);
        System.assertEquals(thisProject.End_Date__c, date2);
        System.assertEquals(thisProject.Status__c, 'Running');
        System.assertEquals(thisProject.Billable_Amount__c, 5);
    }   

    @isTest static void testFailure() {
        date date1 = Date.newInstance(2016, 12, 9);
        date date2 = Date.newInstance(2026, 12, 9);
        String res = ProjectRESTService.postProjectData('27', 'Project Name', null, date1, date2, 5, 'Running');  
        
        System.assertNOtEquals(res, 'OK');
    }        
}