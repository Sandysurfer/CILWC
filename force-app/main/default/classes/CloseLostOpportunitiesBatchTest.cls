@isTest
private class CloseLostOpportunitiesBatchTest {
    
    @isTest
    static void testBatchJob() {
        // Create test data: Active Account with Open Opportunities
        Account testAccount = TestDataUtility.createActiveAccount('Test Account');
        Opportunity testOpportunity = TestDataUtility.createOpenOpportunity(testAccount, 'Test Opportunity', 29, 'Prospecting');
        
        // Create test data: Inactive Account with Open Opportunities
        Account inactiveAccount = TestDataUtility.createActiveAccount('Inactive Account');
        Opportunity inactiveOpportunity = TestDataUtility.createOpenOpportunity(inactiveAccount, 'Inactive Opportunity', 29, 'Prospecting');
        
        // Create test data: Closed Opportunities
        Account closedAccount = TestDataUtility.createActiveAccount('Closed Account');
        Opportunity closedOpportunity = TestDataUtility.createClosedOpportunity(closedAccount, 'Closed Opportunity', 31, 'Closed Won');
        
        // Test the batch job
        Test.startTest();
        CloseLostOpportunitiesBatch batchJob = new CloseLostOpportunitiesBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        // Verify that the Open Opportunity was updated to Closed Lost
        Opportunity updatedOpportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :testOpportunity.Id];
        System.assertEquals('Closed Lost', updatedOpportunity.StageName, 'The StageName of the open Opportunity should be updated to Closed Lost');
        
        // Verify that the Inactive Opportunity was not updated
        Opportunity unchangedOpportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :inactiveOpportunity.Id];
        System.assertNotEquals('Closed Lost', unchangedOpportunity.StageName, 'The StageName of the inactive Opportunity should not be updated');
        
        // Verify that the Closed Opportunity was not updated
        Opportunity closedOpportunityAfterBatch = [SELECT Id, StageName FROM Opportunity WHERE Id = :closedOpportunity.Id];
        System.assertNotEquals('Closed Lost', closedOpportunityAfterBatch.StageName, 'The StageName of the closed Opportunity should not be updated');
    }
}