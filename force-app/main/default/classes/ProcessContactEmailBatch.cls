global class ProcessContactEmailBatch implements Database.Batchable<sObject>,Database.Stateful {
    //1st Method Start():-
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, AccountId, Email FROM Contact WHERE AccountId != null AND Email = null');
    }
    //2nd Method Execute():-
    global void execute(Database.BatchableContext bc, List<Contact> conList) {
        
        //1.)Copy Email From Account If Contact Email is Null....
        Map<Id,Account> accConMap = new Map<Id,Account>();
        List<Account> accList = [Select Id,Email__c From Account Where Email__c != null];
        for(Account ac : accList){
            accConMap.put(ac.Id,ac);
        }
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact ct : conList){
            if(accConMap.containsKey(ct.AccountId)){
                ct.Email = accConMap.get(ct.AccountId).Email__c;
                conListToUpdate.add(ct);
            }
        }
        update conListToUpdate;
        
       //2.)Copy Email From Opportunity, If Contact Related Account Email is also null.....
        Map<Id,Account> accOppMap = new Map<Id,Account>();
        List<Contact> conListUpdate = new List<Contact>();
        
        for(Account ac : [Select Id,Email__c,(Select Id,Email__c From Opportunities Where AccountId != null AND Email__c != null) 
                          From Account Where Email__c = null]){
           // System.debug('--1--'+ac);
            if(ac.Opportunities != null){
                accOppMap.put(ac.Id,ac);
            }
        }
        if(!accOppMap.isEmpty()){
            for(Contact c : conList){
                if(accOppMap.containsKey(c.AccountId)){
                    Account acc = accOppMap.get(c.AccountId);
                    //  System.debug('--3--'+acc.Opportunities);
                    if(acc.Email__c != null){
                        c.Email = acc.Email__c;
                    }
                    else if(acc.Opportunities!= null && !acc.Opportunities.isEmpty()){
                        //System.debug('--4--'+acc.Opportunities[0].Email__c);
                        c.Email = acc.Opportunities[0].Email__c;
                    }
                    conListUpdate.add(c);
                }   
            }
        }
        if(!conListUpdate.isEmpty()){
            update conListUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
        system.debug('batch job id = '+bc.getJobId());
    }
    
}