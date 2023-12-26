public class CallApexUsingWireMethod {
    
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccountList(){
        List<Account> accountList = [Select Id, Name From Account]; 
        return accountList;
    }
    
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactList(){
        List<Contact> contactList = [Select Id,FirstName,LastName,Phone,Email From Contact]; 
        return contactList;
    }
    
    
    @AuraEnabled(cacheable = true)
    public static List<Contact> findContactList(String searchContacts){
        String searchQuery = '%' + searchContacts + '%';
        List<Contact> contactList = [SELECT Id, lastName,firstName, Phone,Email FROM Contact WHERE firstName LIKE : searchQuery LIMIT 10];
        //System.debug('Contacts--->'+contactList);
        return contactList;
    } 
    
    @AuraEnabled(cacheable = true)
    public static List<Account> findAccountList(String searchAccounts){
        String searchQuery = '%' + searchAccounts + '%';
        List<Account> accountList = [SELECT Id, Name, Industry FROM Account WHERE Name LIKE : searchQuery LIMIT 10];
        //System.debug('Accounts--->'+AccountList);
        return accountList;
    }  
    
    @AuraEnabled(cacheable = true)
    public static List<String> passAccountList(List<String> newAccountList){
        System.debug('Recieved AccountArray-->'+newAccountList);
        return newAccountList;
    }
}