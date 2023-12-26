@isTest
private class OpportunityControllerTest {

    @isTest
    static void testCloseOpportunity() {
        // Create a test account with Active__c = 'Yes'
        Account testAccount = TestDataUtility.createTestAccount('Test Account', 'Yes');

        // Create a test opportunity with CloseDate 30 days ago
        Opportunity testOpportunity = TestDataUtility.createTestOpportunity(testAccount, 'Test Opportunity', Date.today().addDays(-30), 'Prospecting');

        Test.startTest();

        // Call the OpportunityController method
        OpportunityController controller = new OpportunityController();
        controller.closeOpportunity(new List<Opportunity>{testOpportunity});

        Test.stopTest();

        // Verify that the StageName is updated to 'Closed Lost'
        Opportunity updatedOpportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :testOpportunity.Id];
        System.assertEquals('Closed Lost', updatedOpportunity.StageName, 'The StageName should be updated to Closed Lost');
    }
}