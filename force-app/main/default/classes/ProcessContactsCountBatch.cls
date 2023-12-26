global class ProcessContactsCountBatch implements Database.Batchable<sObject>,Database.Stateful {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id,No_of_Contacts__c,(Select Id From Contacts) FROM Account Where No_of_Contacts__c = Null');
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accList) {
        for(Account acc : accList){
            if(acc.Contacts != null){
                acc.No_of_Contacts__c = acc.Contacts.size();
            }
            update accList;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
        system.debug('batch job id = '+bc.getJobId());
    }
    
}