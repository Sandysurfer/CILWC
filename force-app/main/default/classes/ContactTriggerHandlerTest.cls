@isTest
public class ContactTriggerHandlerTest {
    
    @isTest
    public static void updateAccountPhoneTest(){
        //Only For Update Scenario....
        Account acc = TestUtilityClass.createAccount('CheckBalance');
        insert acc;
        
        List<Contact> conList = TestUtilityClass.createContact('conTest1', 'Deposit', 500, acc.Id, 1);
        conList[0].Phone = '12345';
        insert conList;
        conList[0].Phone = '123456789';
        update conList;
        
        String phone = [Select Phone From Account Where Id =: acc.Id].Phone;
        System.assertEquals('123456789', phone);
    }
    
    @isTest
    public static void updateCustomerAccountBalanceTest(){
        Account acc = TestUtilityClass.createAccount('CheckBalance');
        insert acc;
        
        List<Contact> conList = TestUtilityClass.createContact('conTest1', 'Deposit', 500, acc.Id, 5);
        insert conList;
        
        List<Contact> conList2 = TestUtilityClass.createContact('conTest2', 'Withdraw', 250, acc.Id, 2);
        insert conList2;
        
        List<Account> accList = [Select Balance__c From Account Where Id =:acc.Id];
        
        System.assertEquals(2000, accList[0].Balance__c);
    }
}