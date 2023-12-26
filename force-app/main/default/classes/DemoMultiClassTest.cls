@isTest(seeAllData=false)
public class DemoMultiClassTest {
    //To make setup of data throughout the class(resusabiltiy)
    @testsetup
    public static void testsetupMethod(){
        Account acc = new Account();
        acc.Name = 'Test Class Account';
        insert acc;
    }
    //Positive Scenario...
    @isTest
    public static void createAccountRecordSuccess(){
        Test.startTest();
        DemoMultiClass.createRecord('Account');
        Test.stopTest();
        
        List<Account> accList = [Select Id,Name From Account];
        System.debug('Account Size'+accList.size());
        System.assertEquals('Test Class Account',accList[0].Name,'Account Name is not Same');
    }
    
    @isTest
    public static void createContactRecordSuccess(){
        Test.startTest();
        DemoMultiClass.createRecord('Contact');
        Test.stopTest();
        
        List<Contact> conList = [Select Id,LastName From Contact];
        System.debug('Contact Size'+conList.size());
        System.assertEquals('Test Class Contact',conList[0].LastName,'Contact LastName is not Same');
    }
    
    //Negative Scenario..
    @isTest
    public static void createRecordFailure(){
        Test.startTest();
        DemoMultiClass.createRecord('Opportunity');
        Test.stopTest();
        
        List<Opportunity> oppList =[Select Id From Opportunity];
        System.assertEquals(0, oppList.size(),'Opportunity is Created');
        
    }
    
    @isTest
    public static void getAccountDetailsSuccess(){
        
        List<Account> accInsertList = [Select Id,Name From Account];
        
        List<Account> accList = [Select Id,Name From Account Where Id =: accInsertList[0].Id];
        
        Test.startTest();
        DemoMultiClass.getAccountDetails(accList[0].Id);
        Test.stopTest();
        
    }
    
    
}