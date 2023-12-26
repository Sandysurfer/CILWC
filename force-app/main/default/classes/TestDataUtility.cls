public class TestDataUtility {
    
    public static Account createTestAccount(String accountName, String activeStatus) {
        Account testAccount = new Account(Name = accountName, Active__c = activeStatus);
        insert testAccount;
        return testAccount;
    }
    
    public static Opportunity createTestOpportunity(Account account, String opportunityName, Date closeDate, String stageName) {
        Opportunity testOpportunity = new Opportunity(
            Name = opportunityName,
            CloseDate = closeDate,
            StageName = stageName,
            AccountId = account.Id
        );
        insert testOpportunity;
        return testOpportunity;
    }
    
    public static Account createActiveAccount(String accountName) {
        Account activeAccount = new Account(Name = accountName, Active__c = 'Yes');
        insert activeAccount;
        return activeAccount;
    }
    
    public static Opportunity createOpenOpportunity(Account parentAccount, String opportunityName, Integer daysUntilCloseDate, String stageName) {
        Opportunity openOpportunity = new Opportunity(
            Name = opportunityName,
            CloseDate = Date.today().addDays(-daysUntilCloseDate),
            StageName = stageName,
            AccountId = parentAccount.Id
        );
        insert openOpportunity;
        return openOpportunity;
    }
    
    public static Opportunity createClosedOpportunity(Account parentAccount, String opportunityName, Integer daysUntilCloseDate, String stageName) {
        Opportunity closedOpportunity = new Opportunity(
            Name = opportunityName,
            CloseDate = Date.today().addDays(-daysUntilCloseDate),
            StageName = stageName,
            AccountId = parentAccount.Id
        );
        insert closedOpportunity;
        return closedOpportunity;
    }
    
    
}