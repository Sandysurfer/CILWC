public class LeadHandler {
    //Sceanrio:-8 Write Apex Class that will prevent a user from creating a lead that already exists as a contact.
    // We will use the lead contact email address to detect duplicates....
    
    public static void preventduplicatesEmail(List<Lead> newList){
        Set<String> emailSet = new Set<String>();
        for(Lead l : newList){
            emailSet.add(l.Email);
        }
        
        Set<String> duplicateEmailSet = new Set<String>();
        for(Contact con : [Select Id,Email From Contact Where Email IN : emailSet]){
            duplicateEmailSet.add(con.Email);
        }
        
        for(Lead le : newList){
            if(duplicateEmailSet.contains(le.Email)){
                le.addError('Lead Email Already Exist in Contacts');
            }
        }
    }
    //Task 27:-Automatically create followup task with additional info in description, whenever lead is converted to Account,Contact,Opportunity......
    public static void createFollowTask(List<Lead> newLeadList,Map<Id,Lead> oldLeadMap){
        List<Lead> convertedLeadsList = new List<Lead>();
        Set<Id> convertedAccIdSet = new Set<Id>();
        Set<Id> convertedConIdSet = new Set<Id>();
        Set<Id> convertedOppIdSet = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
        List<Task> tasksToUpdate = new List<Task>();
        
        if(newLeadList.isEmpty()){
            for(Lead newlead : newLeadList){
                if(!oldLeadMap.isEmpty())
                {
                    Lead oldLead = oldLeadMap.get(newLead.Id);
                    if(newLead.IsConverted && !oldLead.IsConverted)
                    {
                        convertedLeadsList.add(newLead);
                        
                        if(newLead.ConvertedAccountId != null){
                            convertedAccIdSet.add(newLead.ConvertedAccountId);
                        }
                        if(newLead.ConvertedContactId != null){
                            convertedConIdSet.add(newLead.ConvertedContactId);
                        }
                        if(newLead.ConvertedOpportunityId != null){
                            convertedOppIdSet.add(newLead.ConvertedOpportunityId);
                        }
                    }
                }
            }
        }
        if(!convertedLeadsList.isEmpty()){
            if(!convertedAccIdSet.isEmpty()){
                accMap = new Map<Id,Account>([Select Id,Name From Account Where Id IN : convertedAccIdSet]);
            }
            if(!convertedConIdSet.isEmpty()){
                conMap = new Map<Id,Contact>([Select Id,Name,Email From Contact Where Id IN : convertedConIdSet]);
            }
            if(!convertedOppIdSet.isEmpty()){
                oppMap = new Map<Id,Opportunity>([Select Id,Name,closeDate From Opportunity Where Id IN : convertedOppIdSet]);
            }
            
            for(Lead leadObj : convertedLeadsList){
                Task newTask = new Task();
                newTask.subject =   'Follow Up With Converted Leads';
                newTask.Priority =  'Normal';
                newTask.Status =    'Not Started';
                newTask.ActivityDate = Date.today()+7;
                newTask.WhoId = leadObj.ConvertedContactId;
                newTask.WhatId = leadObj.ConvertedOpportunityId;
                
                //Store Task Description in Seperate String Variable.....
                String taskDescription = 'Lead Name :'+leadObj.FirstName + '\n';
                taskDescription += 'Lead Email :'+leadObj.Email + '\n';
                taskDescription += 'Lead Phone :'+leadObj.Phone +'\n';
                
                if(accMap.containsKey(leadObj.ConvertedAccountId)){
                    Account acc = accMap.get(leadObj.ConvertedAccountId);
                    taskDescription += 'Account Name :'+acc.Name + '\n';
                }
                if(conMap.containsKey(leadObj.ConvertedContactId)){
                    Contact con = conMap.get(leadObj.ConvertedContactId);
                    taskDescription += 'Contact Name :'+con.Name +'\n';
                    taskDescription += 'Contact Email :'+con.Email +'\n';
                }
                if(oppMap.containsKey(leadObj.ConvertedOpportunityId)){
                    Opportunity opp = oppMap.get(leadObj.ConvertedOpportunityId);
                    taskDescription += 'Opportunity Name :'+opp.Name +'\n';
                    taskDescription += 'Opportunity Close Date :'+opp.CloseDate +'\n';
                }
                newTask.Description = taskDescription;
                tasksToUpdate.add(newTask);
            }
        }
        if(!tasksToUpdate.isEmpty()){
            insert tasksToUpdate;
        }
    }
    //Task 31: When Lead is Converted, Update Related 1.Account Active Picklist Field and Related, 2.Contact field Do_Not_Contact__c Checkbox,
    //and Related 3.Opportunity Description With newly Created Lead Record Values...
    public static void updateAccConOpp(List<Lead> newLeadList){
        Set<Id> convertedLeadIdSet = new Set<Id>();
        
        if(!newLeadList.isEmpty()){
            for(Lead leadObj : newLeadList){
                if(leadObj.isConverted){
                    convertedLeadIdSet.add(leadObj.Id);
                }
            }
        }
        if(!convertedLeadIdSet.isEmpty()){
            Map<Id,Lead> leadMap = new Map<Id,Lead>([Select Id, ConvertedAccountId, ConvertedContactId, ConvertedOpportunityId 
                                                     From Lead Where Id IN : convertedLeadIdSet]);
            List<Account> accListToUpdate = new  List<Account>();
            List<Contact> conListToUpdate = new List<Contact>();
            List<Opportunity> oppListToUpdate = new List<Opportunity>();
            
            for(Lead leadRcd : leadMap.Values()){
                if(leadRcd.ConvertedAccountId != null){
                    Account acc = new Account();
                    acc.Id = leadRcd.ConvertedAccountId;
                    acc.Active__c = 'Yes';
                    accListToUpdate.add(acc);
                }
                if(leadRcd.ConvertedContactId != null){
                    Contact con = new Contact();
                    con.Id = leadRcd.ConvertedContactId;
                    con.Do_Not_Contact__c = true;
                    conListToUpdate.add(con);
                }
                if(leadRcd.ConvertedOpportunityId != null){
                    Opportunity opp = new Opportunity();
                    opp.Id = leadRcd.ConvertedOpportunityId;
                    opp.Description = 'Lead Record Name--->'+leadRcd.Name;
                    oppListToUpdate.add(opp);
                }
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }
            if(!conListToUpdate.isEmpty()){
                update conListToUpdate;
            }
            if(!oppListToUpdate.isEmpty()){
                update oppListToUpdate;
            }
        }
    }  
}