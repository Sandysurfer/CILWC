public class AccountContactBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator('SELECT Id,Name FROM Account');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accList) {
        
        //Create Contacts for those Account Which doesn't have Any related contact(Without Using Inner Query).....
        Set<Id> accIdSet = new Set<Id>();
        for(Account acc : accList){
            accIdSet.add(acc.Id);
        }
        
        Set<Id> contactAccountIds = new Set<Id>();
        for(Contact c : [Select Id,Name,AccountId From Contact Where AccountId IN : accIdSet]){
            contactAccountIds.add(c.AccountId);
        }
        
        Set<Id> createContactAccountIds = new Set<Id>();
        for(Id ids : accIdSet){
            if(!contactAccountIds.contains(ids)){
                createContactAccountIds.add(ids);
            }
        }
        
        List<Contact> conListToUpdate = new List<Contact>();
        
        for(Account ac : accList){
            if(createContactAccountIds.contains(ac.Id)){
                Contact con = new Contact();
                con.LastName = ac.Name;
                con.AccountId = ac.Id;
                conListToUpdate.add(con);
            }
        }
        
        // Handling DML Operation With Database Class (Insert) Methods........
        Database.SaveResult[] srList = Database.insert(conListToUpdate,false);
        
        //Iterate through Database.SaveResult.....
        for(Database.SaveResult result : srList){
            if(result.isSuccess()){
                //If Operation is Successful get the Id of records processed...
                System.debug('Successfully inserted Contact ID '+result.getId());
            }
            else
            {
                //If Operations is failed get all the errors ...
                for(Database.Error er : result.getErrors()){
                    System.debug('The Following Error has Occured');
                    System.debug(er.getStatusCode()+' '+er.getMessage());
                    System.debug('Contact field effected with error '+er.getFields());
                }
            }
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {
        
        system.debug('batch job id = '+bc.getJobId());
    }
    
}