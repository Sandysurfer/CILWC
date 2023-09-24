trigger ClientTrigger on Client__c (before insert,after insert,before update, after update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            // System.debug(trigger.new+'---Before Insert---'+trigger.old);
            
            
        }
        if(trigger.isUpdate){
            System.debug(trigger.new+'---Before Update---'+trigger.old);
            
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            System.debug(trigger.new+'---After Insert---'+trigger.old);
            clientHandler.createContactIfClientNotExists(trigger.new);
            
            
        }
        if(trigger.isUpdate){
            System.debug(trigger.new+'---After Update---'+trigger.old);
            
        }
    }
    
}