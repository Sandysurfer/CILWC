@isTest
private class AccountTriggerHandlerTest {
    
    @testSetup //used For creation of data that can be resused in another method in same class...
    static void setup(){
        List<Account> accList = new List<Account>();
        for(Integer i=1; i<=10; i++){  //Creating Bulk Data...
            Account acc = new Account();
            acc.Name = 'Test'+i;   //Dummy Data for Testing Purpose..
            acc.Active__c = 'yes';
            accList.add(acc);
        }
        Test.startTest();  //Use to refresh governor limit.
        insert accList;
        Test.stopTest();
    }
    
    @isTest
    public static void updateAccountDescriptionTest(){
        Account acc = new Account();
        acc.Name = 'Test Account Trigger';
        acc.Active__c = 'No';
        insert acc;
        
        List<Account> accList = [Select Id,Active__c From Account];
        
        Test.startTest();
        update accList;
        Test.stopTest();
        
        List<Account> accListUpdate = [Select Id,Description From Account Where Id =: accList[0].Id];
        System.assertEquals('Updated From Trigger', accListUpdate[0].Description, 'Description is not Updated');
        
    }
    
    @isTest
    static void createdRelatedContactTest(){
        List<Account> accList = new List<Account>();
        for(Integer i=1;i<=5;i++){
            Account acc = new Account();
            acc.Name = 'Test'+i;
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Contact> conList = [Select Id From Contact Where AccountId =: accList[0].Id];
        System.Assert(conList != null,'Contact is not Created');
    }
    
    @isTest
    private static void createRelatedOppTest(){
        List<Account> accList = new List<Account>();
        for(Integer i=1; i<=5; i++){  //Creating Bulk Data...
            Account acc = new Account();
            acc.Name = 'Test'+i;   //Dummy Data for Testing Purpose..
            acc.Active__c = 'yes';
            accList.add(acc);
        }
        Test.startTest();  //Use to refresh governor limit.
        //insert accList;
        Database.SaveResult[] srList = Database.insert(accList,false);
        Test.stopTest();
       
        //Calling The (DataFactory) utilityClass and Passing input Parameters to it...
        // List<Account> accDataList =  DataFactory.createAccountRecord('Test', 10, true); 
        
        List<Opportunity> oppList = [Select Id From Opportunity Where AccountId =: accList[0].Id];
        System.assert(oppList != Null, 'Opportunity is Not Created');
    }
    
    @isTest
    static void populateRatingInsertTest(){
        List<Account> accList = new List<Account>();
        //Creating Sample Data...
        for(Integer i=1; i<=10; i++){ 
            Account acc = new Account();
            acc.Name = 'Test'+i;   //Dummy Data for Testing Purpose..
            acc.Active__c = 'yes';
            acc.Industry = 'Media';
            accList.add(acc);
        }
        Test.startTest();  //Use to refresh governor limit.
        insert accList;
        Test.stopTest();
        
        List<Account> updatedAccList = [Select Rating from Account Where Id =: accList[0].id];
        System.assertEquals('Hot', updatedAccList[0].Rating);
    }
    
    @isTest
    static void populateRatingUpdateTest(){
        List<Account> accList = new List<Account>();
        //Creating Bulk Data...
        for(Integer i=1; i<=10; i++){  
            Account acc = new Account();
            acc.Name = 'Test'+ i;   //Dummy Data for Testing Purpose..
            acc.Active__c = 'yes';
            accList.add(acc);
        }
        Test.startTest();  //Use to refresh governor limit.
        insert accList;
        
        for(Account acc : accList){
            acc.Industry = 'Media';
        }
        update accList;
        Test.stopTest();
        
        List<Account> updatedAccList = [Select Id,Rating from Account Where Id =: accList[0].id];
        System.assertEquals('Hot', updatedAccList[0].Rating); //Check the outcome result and expected Results...
    }
    
    @isTest
    static void updatePhoneOnDescriptionTest(){
        List<Account> accList = new List<Account>();
        for(Integer i=1;i<=5;i++){
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Phone = '1245';
            accList.add(acc);
        }
        Test.startTest();
        insert accList;
        for(Account acc : accList){
            acc.Phone = '3030';
        }
        update accList;
        Test.stopTest();
        
        List<Account> updatedAccList = [Select Id, Phone From Account Where Id =: accList[0].Id];
        System.assertEquals('3030', updatedAccList[0].Phone, 'Phone is not Updated');
    } 
    
    @isTest
    public static void updateRelatedContactPhoneTest(){
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=1;i<=5;i++){
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Phone = '12345';
            accList.add(acc);
        }
        Test.startTest();
        insert accList;
        
        for(Account acc : accList){
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.Phone = acc.Phone;
            con.AccountId = acc.Id;
            conList.add(Con);
        }
        insert conList;
        
        for(Account acc : accList){
            acc.Phone = '54321';
        }
        update accList;
        Test.stopTest();
        
        List<Contact> updatedConList = [Select Id,HomePhone From Contact Where Id =: conList[0].Id];
        System.assertEquals('54321', updatedConList[0].HomePhone);
    }
    
    @isTest
    public static void updateRelatedContactMailingAddressTest(){
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=1;i<=5;i++){
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.BillingCity = 'TestCity';
            acc.BillingCountry = 'TestCountry';
            acc.BillingState = 'TestState';
            acc.BillingStreet = 'TestCountry';
            acc.BillingPostalCode = '123456';
            accList.add(acc);
        }
        Test.startTest();
        insert accList;
        
        for(Account acc : accList){
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.Phone = acc.Phone;
            con.AccountId = acc.Id;
            conList.add(Con);
        }
        insert conList;
        
        for(Account acc : accList){
            acc.BillingCity = 'Mumbai';
        }
        update accList;
        Test.stopTest();
        
        List<Contact> updatedConList = [Select Id,MailingCity From Contact Where Id =: conList[0].Id];
        System.assertEquals('Mumbai', updatedConList[0].MailingCity);
    }
    
    @isTest
    public static void updateRelatedOpportunityStageTest(){
        List<Account> accList = new List<Account>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i=1;i<=5;i++){
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        Test.startTest();
        insert accList;
        
        for(Account acc : accList){
            Opportunity opp = new Opportunity();
            opp.Name = 'TestOpp'+ acc.Name;
            opp.stageName = 'Prospecting';
            opp.closeDate = System.today();
            opp.Amount = 2000;
            opp.AccountId = acc.Id;
            oppList.add(opp);
        }
        insert oppList;
        
        for(Account acc : accList){
            acc.Active__c = 'No';
        }
        update accList;
        
        List<Opportunity> updatedOppList = [Select Id,StageName From Opportunity Where Id =: oppList[0].Id];
        System.assertEquals('Closed Lost', updatedOppList[0].StageName);  
    }
    
    @isTest
    public static void preventdeletionofAccountTest(){
        List<Account> accList = new List<Account>();
        for(Integer i=1;i<=5;i++){
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        Test.startTest();
        insert accList;
        Boolean exceptionThrown = false;
        try{
            delete accList;
        }catch(Exception ex){
            exceptionThrown = true;
            Boolean expectedExceptionThrown = (ex.getMessage().contains('Active Account Cannot be Deleted'))? true : false;
            System.assertEquals(true, expectedExceptionThrown, ex.getMessage());
        }
        Test.stopTest();
    }
}