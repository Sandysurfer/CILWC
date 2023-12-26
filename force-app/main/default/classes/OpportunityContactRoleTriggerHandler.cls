public class OpportunityContactRoleTriggerHandler {
    
//Task 37:Prevent Duplication of OpportunityContactRole on Opportunities and Avoid Insertion,
// if there are Closed Opportunities and also Avoid Duplicates if OpportunityContactRole Already Exists on Opportunity....    
    Public static void updateOpportunities(List<OpportunityContactRole> newRecordList){
        Set<Id> oppIdSet = new Set<Id>();
        Set<Id> conIdSet = new Set<Id>();
        Map<String,OpportunityContactRole> existingRolesMap = new Map<String,OpportunityContactRole>();
        
        if(!newRecordList.isEmpty()){
            for(OpportunityContactRole ocr : newRecordList){
                if(ocr.OpportunityId != null){
                    oppIdSet.add(ocr.OpportunityId);
                }
                if(ocr.ContactId != null){
                    conIdSet.add(ocr.ContactId);
                }
            }
        }
        //Query and Store in Map AccountId vs Related Opportunities Which are Closed.....
        Map<Id,Opportunity> opportunitiesMap = new Map<Id,Opportunity>([Select Id,IsClosed From Opportunity Where Id IN : oppIdSet]);
        
        for(OpportunityContactRole existingRole : [Select Id,ContactId,OpportunityId From OpportunityContactRole Where contactId IN : conIdSet
                                                   AND opportunityId IN : oppIdSet])
        {
            existingRolesMap.put(existingRole.opportunityId+'-'+existingRole.contactId, existingRole);
        }
        
        for(OpportunityContactRole ocrObj : newRecordList){
            Opportunity relatedOpp = opportunitiesMap.get(ocrObj.opportunityId);
            if(relatedOpp != null && relatedOpp.isClosed)
            {
                ocrObj.addError('Cannot Create OpportunityContactRole on Closed Opportunity');
            }
            String Key = ocrObj.OpportunityId+'-'+ocrObj.ContactId;
            if(existingRolesMap.containsKey(Key)){
                ocrObj.addError('OpportunityContactRole Already Exists on Opportunity Record');
            }
        }
    }
}