@isTest
    public class TestDataFactory {
        public static ServiceTokens__c createToken(){
            ServiceTokens__c token = new ServiceTokens__c(
                Name='ProjectServiceToken',
                Token__c='27');
            insert token;
            return token;
        }
        public static ServiceCredentials__c createCredential(){
            ServiceCredentials__c credential = new ServiceCredentials__c(
                Username__c = 'masi',
                Password__c = '27',
                name = 'BillingServiceCredential'
            );
            insert credential;
            return credential;
        }
        public static List<Opportunity> createLisOpp(Integer numOpps) {
            Account acc = new Account(name='MasiAccount');
            insert acc;
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
        public static Project__c createProject(){
            Opportunity opp = createLisOpp(1)[0];
            Project__c project = new Project__c(
                Status__c = 'Running',
                ProjectRef__c = 'hola',
                Billable_Amount__c = 44,
                Opportunity__c = opp.id
            );
            insert project;
            return project;
        }
    }