public class CallApexUsingImperative {
    
    @AuraEnabled
    public static List<Account> getAccounts(){
        List<Account> accountList = [Select Id, Name From Account]; 
        return accountList;
    }
    @AuraEnabled
    public static List<Contact> getContacts(String selectedAccountId){
        List<Contact> contactList = [Select Id,Name,Email,Phone,AccountId From Contact Where AccountId =: selectedAccountId];
        return contactList;
    }
    @AuraEnabled
    public static List<Client__c> getClientsAddress(){
        List<Client__c> clientList = [Select Id,First_Name__c,(Select Id,Country__c From Addresses__r) From Client__c];
        //System.debug('--1--'+clientList);
        return clientList;
    }
    
    @AuraEnabled
    public static List<Contact> findContactList(String searchTerm){
        String searchQuery = '%' + searchTerm + '%';
        List<Contact> contactList = [SELECT Id, lastName,firstName, Phone,Email FROM Contact WHERE firstName LIKE : searchQuery LIMIT 10];
        //System.debug('Contacts--->'+contactList);
        return contactList;
    }
    
    @AuraEnabled
    public static Id insertClientRecord(String clFirstName, String clLastName,String clEmailId){
        Client__c clRec = new Client__c();
        clRec.First_Name__c = clFirstName;
        clRec.Last_Name__c = clLastName;
        clRec.Email_Id__c = clEmailId;
        insert clRec;
        //System.debug(clRec);
        return cLRec.Id;
    }
    
    @AuraEnabled
    public static List<String> passAccountList(List<String> newAccountList){
        System.debug('Recieved AccountArray-->'+newAccountList);
        return newAccountList;
    }
    
}