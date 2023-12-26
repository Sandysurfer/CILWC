public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static Account getSingleAccount() {
        return [
            SELECT Id, Name, AccountNumber, Industry
            FROM Account
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
}