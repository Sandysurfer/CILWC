/*
*********************************************************
Apex Class Name    : OpportunityController
Created Date       : Nov 17, 2023
@description       : This Apex class is used to mark Opportunities as Closed Lost after 30 days for Accounts with Active__c = 'Yes'
@author            : Sandeep Yadav
Modification Log:
Ver   Date         Author                               Modification
1.0   04-01-2021   Pranay Shendre                      Initial Version
2.0   16-01-2023   Sandeep Yadav                       Added New Method closeOpportunity()
*********************************************************
*/
public with sharing class OpportunityController {
    
    /*
    *********************************************************
    @Method Name    : closeOpportunity
    @author         : Pranay Shendre
    @description    : method to mark Opportunities as Closed Lost after 30 days
    @param          : List<Opportunity>
    @return         : void
    ********************************************************
    */
    public void closeOpportunity(List<Opportunity> opportunityList){
        
       List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        
        for (Opportunity opp : opportunityList) {
            if (opp.CloseDate.addDays(30) <= System.today()) {
                opp.StageName = 'Closed Lost';
                opportunitiesToUpdate.add(opp);
            }
        }
        try{
            if(schema.sObjectType.Opportunity.isUpdateable()) {
                Database.update(opportunitiesToUpdate,false);
            }
        }
        catch(Exception ex){
           System.debug('Exception: ' + ex.getMessage());
        }
    }
}