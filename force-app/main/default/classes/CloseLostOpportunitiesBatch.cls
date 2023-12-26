/*
*********************************************************
Apex Class Name    : CloseLostOpportunitiesBatch
Created Date       : Nov 17, 2023
@description       : This Batch Apex class is used to mark Opportunities as Closed Lost after 30 days for Accounts with Active__c = 'Yes'
@author            : Sandeep Yadav
Modification Log:
Ver   Date         Author                               Modification
1.0   04-01-2021   Pranay Shendre                      Initial Version
2.0   16-01-2023   Sandeep Yadav                       Added New Method getAccounts()
*********************************************************
*/
global class CloseLostOpportunitiesBatch implements Database.Batchable<sObject> {
    
   global Database.QueryLocator start(Database.BatchableContext BC) {
    String closedWon = 'Closed Won';
    String closedLost = 'Closed Lost';
    String activeStatus = 'Yes';
    
    String query  = 'SELECT Id, Account.Id, CloseDate, Account.Active__c ';
           query += 'FROM Opportunity ';
           query += 'WHERE StageName != :closedWon AND StageName != :closedLost ';
           query += 'AND Account.Active__c = :activeStatus';
       
       return Database.getQueryLocator(query);
   }

    global void execute(Database.BatchableContext BC, List<Opportunity> opportunityList) {
        try {
            OpportunityController oppBatch = new OpportunityController();
            oppBatch.closeOpportunity(opportunityList);
        } catch (Exception e) {
            
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        
    }
}