@IsTest
private class ProjectRESTServiceTest {  
     @isTest static void testCreateCase() {
        Opportunity opp = TestDataFactory.createLisOpp(1)[0];
        date date1 = Date.newInstance(2016, 12, 9);
        date date2 = Date.newInstance(2026, 12, 9);
        String res = ProjectRESTService.postProjectData('27', 'Project Name', (String)opp.id, date1, date2, 5, 'Running');
        
        
        System.assertEquals(res, 'OK');
        
        Project__c thisCase = [SELECT Id,Subject FROM Project__c WHERE Opportunity__c=:opp.id];
        System.assert(thisCase != null);
        System.assertEquals(thisCase.Subject, 'Ferocious chipmunk');
    }
          
}