//Task 18: Count No of OpportunityLineItems related With Opportunity Record and display the count on Account Custom Field...
//RollupSummary(Count of Child to GrandParent By Using Aggregate Query)....
public class OpportunityLineItemHandler {
    
    public static void countOfOpportunityLineItems(List<OpportunityLineItem> oliList){
        //Using Set....
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Decimal> oliMap = new Map<Id,Decimal>();
        List<Account> accListToUpdate = new List<Account>();
        
        if(!oliList.isEmpty()){
            for(OpportunityLineItem oli : oliList){
                oppIdSet.add(oli.OpportunityId);
            }
        }
        if(!oppIdSet.isEmpty()){
            for(Opportunity opp : [Select Id,AccountId From Opportunity Where Id IN : oppIdSet]){
                oliMap.put(opp.AccountId, 0); //intiallizing to Zero because no of (OpportunityLineItems) are unknown...
            }
            //Using Aggregate Query Get the Count of OpportunityLineItems related with Opportunity and display to Related Account Custom Field......
            for(AggregateResult aggr :[Select Count(Id) oliCount, Opportunity.AccountId From OpportunityLineItem Where Opportunity.AccountId IN : oliMap.keySet()
                                       Group by Opportunity.AccountId]){
                                           oliMap.put((Id)aggr.get('AccountId'), (Decimal)aggr.get('oliCount'));
                                       }
            
            for(Id Ids : oliMap.keySet()){
                Account acc = new Account();
                acc.Id = Ids;
                acc.No_of_Products__c = oliMap.get(Ids);
                accListToUpdate.add(acc);
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }
        }
    }
    
    //Task 19:- Automate Asset Creation and Link with AccountId of related opportunities, after Insertion of New OpportunityLineItems Records...
    public static void automateAsset(List<OpportunityLineItem> oliList){
        Set<Id> oppIdSet = new Set<Id>();
        List<Asset> assetList = new List<Asset>();
        
        if(!oliList.isEmpty()){
            for(OpportunityLineItem oli : oliList){
                oppIdSet.add(oli.OpportunityId);
            }
        }
        if(!oppIdSet.isEmpty()){
            //By Using Child to Parent Query Get Opportunity Related to Account.....
            for(Opportunity opp : [Select Id, Account.Name, AccountId From Opportunity Where Id IN : oppIdSet]){
                if(opp.AccountId != null){
                    Asset asObj = new Asset();
                    asObj.Name = opp.Account.Name + ' OpportunityLineItem';
                    asObj.AccountId = opp.AccountId;
                    assetList.add(asObj);
                }
            }
        }
        if(!assetList.isEmpty()){
            insert assetList;
        }
    }
    //Task 38: Update Account(GrandParent) Description by OpportunityLineItem(GrandChild) Description,Associated With Account Related Opportunity(Parent)....
    public static void updateAccountsDescription(List<OpportunityLineItem> newOliList){
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,String> accMap = new Map<Id,String>();
        List<Account> accListToUpdate = new List<Account>();
        
        if(!newOliList.isEmpty()){
            for(OpportunityLineItem oli : newOliList){
                //Store Opportunity whose description is not blank...
                if(string.isNotBlank(oli.Description)){
                    oppIdSet.add(oli.OpportunityId);
                }
            }
        }
        if(!oppIdSet.isEmpty()){
            //By Using Parent to Child Query....
            for(Opportunity opp : [Select Id,AccountId,(Select Description From OpportunityLineItems Order by LastModifiedDate DESC) From Opportunity Where Id IN : oppIdSet]){
                if(!opp.OpportunityLineItems.isEmpty()){
                    if(String.isNotBlank(opp.OpportunityLineItems[0].Description)){
                        accMap.put(opp.AccountId, opp.OpportunityLineItems[0].Description);
                    }
                }
                else{
                    accMap.put(opp.AccountId, 'There are no Related OpportunityLineItems Records Present.');
                }
            }
            //To Update Account Description,Make instance of Account, as there is (no relation between account and opportunitylineitems)...
            for(Id accIds : accMap.keySet()){
                Account acc = new Account();
                acc.Id = accIds;
                String latestDescription = accMap.get(accIds);
                if(string.isNotBlank(latestDescription)){
                    acc.Description = latestDescription;
                    accListToUpdate.add(acc);
                }
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }
        }  
    }
    
    //Task 20:-Prevent Insertion of OpportunityLineItem, if family and product family fields of product and Opportunity object does not Match....
    public static void preventInsertionOfOpportunityLineItem(List<OpportunityLineItem> oliList){
        Set<Id> oppIdSet = new Set<Id>();
        Set<Id> prodIdSet = new Set<Id>(); 
        
        if(!oliList.isEmpty()){
            for(OpportunityLineItem oli : oliList){
                oppIdSet.add(oli.OpportunityId);
                prodIdSet.add(oli.Product2Id);
            }
        }
        if(!oppIdSet.isEmpty() && !prodIdSet.isEmpty()){
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([Select Id,Product_Family__c From Opportunity Where Id IN : oppIdSet]);
            Map<Id,Product2> prodMap = new Map<Id,Product2>([Select Id, Family From Product2 Where Id IN : prodIdSet]);
            
            if(!oliList.isEmpty()){
                for(OpportunityLineItem oliObj : oliList){
                    if(oppMap.containsKey(oliObj.OpportunityId) && prodMap.containsKey(oliObj.product2Id) 
                       && oppMap.get(oliObj.OpportunityId).Product_Family__c != prodMap.get(oliObj.product2Id).Family)
                    {
                        oliObj.addError('Product Family and Opportunity Product Family are not Same');
                    }
                }
            }
        }
    }
    
}