trigger AccountTrigger on Account (before insert,before update,after insert, after update,before delete, after delete,after undelete) {
    
    if(trigger.isBefore)
    {
        if(trigger.isInsert){
            // System.debug(trigger.new+'---Before Insert---'+trigger.old);
            // AccountTriggerHandler.preventDuplicateAccountRecords(trigger.new);
            // AccountTriggerHandler.deleteContactsOnAccountInsert(trigger.new);
            // AccountTriggerHandler.updateSalesRepField(trigger.new);
        }
        if(trigger.isUpdate){
            //System.debug(trigger.new+'---Before update---'+trigger.old);
            // AccountTriggerHandler.updateSalesRepField(trigger.new);

        }
        if(trigger.isDelete){
            // System.debug(trigger.new+'---Before Delete---'+trigger.old);
            // AccountTriggerHandler.checkProfileForDeletion(trigger.old);
        }
    }
    
    if(trigger.isAfter)
    {
        if(trigger.isInsert){
            //System.debug(trigger.new+'---After Insert---'+trigger.old);
            // AccountTriggerHandler.createMultipleContact(trigger.new);
            // AccountTriggerHandler.updateClientContactLookupField(trigger.new);
            
        }
        if(trigger.isUpdate){
            // System.debug(trigger.new+'---After Update---'+trigger.old);
            // AccountTriggerHandler.updateMultipleContact(trigger.new,trigger.oldMap);
             AccountTriggerHandler.updateRelatedContactPhone(trigger.new, trigger.oldMap);
            // AccountTriggerHandler.updateRelatedContactOwner(trigger.new,trigger.oldMap);
            // AccountTriggerHandler.closeOpportunity(trigger.new,trigger.oldMap);
            //   AccountTriggerHandler.changeStatus(trigger.new,trigger.oldMap);
        }
        if(trigger.isDelete){
            // System.debug(trigger.new+'---After Delete---'+trigger.old);
            // AccountTriggerHandler.deleteAccountRelatedContacts(trigger.old);    
            
        } 
        if(trigger.isUndelete){
            // System.debug(trigger.new+'---After Undelete---'+trigger.old);
            
        }
    }
    
}