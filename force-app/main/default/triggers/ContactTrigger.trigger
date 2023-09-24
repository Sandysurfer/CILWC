trigger ContactTrigger on Contact (before insert,before update,after insert, after update,before delete, after delete,after undelete) {
    
    if(trigger.isBefore)
    {
        if(trigger.isInsert){
            // System.debug(trigger.new+'---Before Insert---'+trigger.old);
            // ContactTriggerHandler.duplicateRecordsInsert(trigger.new);
            // ContactTriggerHandler.validatePhoneValue(trigger.new);
            // ContactTriggerHandler.createRelatedAccount(trigger.new);
            // ContactTriggerHandler.preventcreationofContact(trigger.new);
            // ContactTriggerHandler.updateRelatedAccountPhone(trigger.new);
            // ContactTriggerHandler.preventDuplicatePhoneonAccount(trigger.new);
            // ContactTriggerHandler.updateCustomerAccountBalance(trigger.new);
            // ContactTriggerHandler.enforcePrimaryContactOnAccount(trigger.new,null);
            // ContactTriggerHandler.limitNoOfContacts(trigger.new);
            // ContactTriggerHandler.preventduplicateofEmailAndPhone(trigger.new, new Map<Id, Contact>());
            // ContactTriggerHandler.copyAccountPhoneToOtherPhone(trigger.new);
            // ContactTriggerHandler.updateOpportunityLookUpField(trigger.new);
            // ContactTriggerHandler.updateAccountRecordType(trigger.new,null);
            //   ContactTriggerHandler.updateCostCode(trigger.new);

            
        }
        if(trigger.isUpdate){
            // System.debug(trigger.new+'---Before update---'+trigger.old);
            // ContactTriggerHandler.enforcePrimaryContactOnAccount(trigger.new,trigger.oldMap); 
            // ContactTriggerHandler.limitNoOfContacts(trigger.new);
            // ContactTriggerHandler.preventduplicateofEmailAndPhone(trigger.new,trigger.oldMap);
            // ContactTriggerHandler.updateAccountRecordType(trigger.new,trigger.oldMap);

        }
        if(trigger.isDelete){
            //System.debug(trigger.new+'---Before Delete---'+trigger.old);
            
        }
    }
    
    if(trigger.isAfter)
    {
        if(trigger.isInsert){
            // System.debug(trigger.new+'---After Insert---'+trigger.old);
            // ContactTriggerHandler.updateRelatedAccountPhone(trigger.new, null);
            // ContactTriggerHandler.updateAccountPhone(trigger.new,null);
               ContactTriggerHandler.updateAccountTotalAmount(trigger.new, null);
            // ContactTriggerHandler.rollUpCountofContacts(trigger.new,null);
        }
        if(trigger.isUpdate){
            // System.debug(trigger.new+'---After Update---'+trigger.old);
            // ContactTriggerHandler.updateRelatedAccountPhone(trigger.new,trigger.oldMap);
            // ContactTriggerHandler.updateAccountPhone(trigger.new,trigger.oldMap);
               ContactTriggerHandler.updateAccountTotalAmount(trigger.new, trigger.oldMap);
            // ContactTriggerHandler.rollUpCountofContacts(trigger.new,trigger.oldMap);
            
            
        }
        if(trigger.isDelete){
            // System.debug(trigger.new+'---After Delete---'+trigger.old);
            //  ContactTriggerHandler.rollUpCountofContacts(trigger.old,null);
            //  ContactTriggerHandler.rollUpSummaryUsingMap(trigger.old);
            
            
        } 
        if(trigger.isUndelete){
            //System.debug(trigger.new+'---After Undelete---'+trigger.old);
            
        }
    }
    
}