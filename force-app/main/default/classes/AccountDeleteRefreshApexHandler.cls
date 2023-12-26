public with sharing class AccountDeleteRefreshApexHandler {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Phone FROM Account ORDER BY Createddate desc LIMIT 10];
    }
    
    @AuraEnabled
    public static void deleteAccount(String accountId) {
        Database.delete(accountId);
    }
}