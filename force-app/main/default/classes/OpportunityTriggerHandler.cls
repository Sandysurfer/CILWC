public class OpportunityTriggerHandler {
    //***Rollup Summary of TotalOpportunities on Account By Using AggregateQuery.......
    public static void rollUpCountOfOpportunity(List<Opportunity> oppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> accIdSet = new Set<Id>();
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                //for Update Operations.....
                if(oldOppMap != null){
                    if(opp.AccountId != oldOppMap.get(opp.Id).AccountId){
                        accIdSet.add(oldOppMap.get(opp.Id).AccountId);
                        accIdSet.add(opp.AccountId);
                    }
                    else
                    {
                        accIdSet.add(opp.AccountId);
                    }
                }
                //For Insert Operations...
                accIdSet.add(opp.AccountId);
            }
        }
        if(!accIdSet.isEmpty()){
            List<AggregateResult> aggrList = [Select AccountId aIds, Sum(Amount) totalamt, Count(Id) oppCount From Opportunity Where AccountId IN : accIdSet Group by AccountId];
            Map<Id,Account> accMapToUpdate = new Map<Id,Account>();
            if(!aggrList.isEmpty()){
                //When there is Any Opportunity Linked With Account....
                for(AggregateResult aggr : aggrList){
                    Account acc = new Account();
                    acc.Id = (Id)aggr.get('aIds');
                    acc.No_of_Opportunities__c = (decimal)aggr.get('oppCount');
                    acc.Total_Amount__c = (decimal)aggr.get('totalamt');
                    accMapToUpdate.put(acc.Id,acc);
                }
            }
            //When there is No Opportunity Related to Account.....
            else{
                for(Id accId : accIdSet){
                    Account acc = new Account();
                    acc.Id = accId;
                    acc.No_of_Opportunities__c = 0;
                    acc.Total_Amount__c = 0;
                    accMapToUpdate.put(acc.Id,acc);
                }
            }
            if(!accMapToUpdate.isEmpty()){
                update accMapToUpdate.values();
            }
        }
    }
    //**Task 10: Populate Account Custom Field(Max_Opportunity) With Highest Related Opportunity Amount.......
    public static void populateMaxOpportunity(List<Opportunity> oppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> accIdSet = new Set<Id>();
        
        if(!oppList.isEmpty()){
            for(Opportunity newOpp : oppList){
                
                //for Update Operations.....
                if(oldOppMap != null){
                    Opportunity oldOpp = oldOppMap.get(newOpp.Id);
                    if(newOpp.AccountId != oldOpp.AccountId)
                    {
                        accIdSet.add(oldOpp.AccountId);
                        accIdSet.add(newOpp.AccountId);
                    }
                    else
                    {
                        accIdSet.add(newOpp.AccountId);
                    }
                }
                else
                {
                    //For Insert Operations...
                    accIdSet.add(newOpp.AccountId);
                }
            }
        }
        if(!accIdSet.isEmpty()){
            List<Account> accListToUpdate = new List<Account>();
            List<Account> accList = [Select Id,Max_Opportunity__c,(Select Id,Name From Opportunities Where Amount != null ORDER BY Amount DESC Limit 1) From Account Where Id IN : accidSet];
            for(Account ac : accList){
                if(!ac.Opportunities.isEmpty())
                {
                    ac.Max_Opportunity__c = ac.Opportunities[0].Name;
                    accListToUpdate.add(ac);
                }
                else
                {
                    ac.Max_Opportunity__c = '';
                    accListToUpdate.add(ac);
                    
                }
                
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }
        }
    }
    //***Task 25: Write an Apex Class to update Account Rating Field based on Total Amount of Opportunities.....
    public static void updateAccountRating(List<Opportunity> newOppList,Map<Id,Opportunity> oldOppMap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Account> accountMapToUpdate = new Map<Id,Account>();
        Map<Id,Double> oppTotalAmountMap = new Map<Id,Double>();

        if(!newOppList.isEmpty())
        {
            for(Opportunity newOpp : newOppList){
                if(oldOppMap != null)
                {
                    Opportunity oldOpp = oldOppMap.get(newOpp.Id);
                    
                    if(newOpp.AccountId != oldOpp.AccountId) //For Update When ParentAccountId is Changed.....
                    {
                        accIdSet.add(oldOpp.AccountId);
                        accIdSet.add(newOpp.AccountId);
                    }
                    else if(newOpp.Amount != oldOpp.Amount) //When Opportunity Amount is Updated.....
                    {
                        accIdSet.add(newOpp.AccountId);
                    }
                }
                else
                {
                    accIdSet.add(newOpp.AccountId); // For Insert Operations...
                }
            }
        }
        if(!accIdSet.isEmpty()){
            List<Opportunity> oppList = [Select Id,Amount,AccountId From Opportunity Where AccountId IN : accIdSet];
            if(!oppList.isEmpty()){
                for(Opportunity opp : oppList){
                    if(oppTotalAmountMap.containsKey(opp.AccountId))
                    {   //2.When Existing Opportunity(Update existing values with new values)....
                        oppTotalAmountMap.put(opp.AccountId, oppTotalAmountMap.get(opp.AccountId) + opp.Amount);
                    }
                    else
                    {   //1.When New Opportunity(Insert)......
                        oppTotalAmountMap.put(opp.AccountId, opp.Amount);
                    }
                }   
            }
            for(Id ids : accIdSet){ 
                if(oppTotalAmountMap.containsKey(ids))
                {
                    Double totalAmount = oppTotalAmountMap.get(ids);
                    String rating;
                    Integer coldThreshold=50000; //Value Set for cold Account Rating...
                    Integer warmThreshold=100000; //Value Set for warm Account Rating...
                    
                    if(totalAmount <= coldThreshold){
                        rating = 'cold';
                    }
                    else if(totalAmount	<= warmThreshold){
                        rating = 'warm';
                    }
                    else{
                        rating = 'Hot';
                    }
                    accountMapToUpdate.put(ids,	new Account(Id = ids, Rating = rating));
                }
                else
                {
                    accountMapToUpdate.put(ids,	new	Account(Id = ids, Rating = null));
                }
            }
        }
        if(!accountMapToUpdate.isEmpty()){
            update accountMapToUpdate.Values();
        }
    }
    
//***Task 12:- When All Opportunity Linked to Account whose Stage Name are Closed Won, Update the Account custom Field (Status) to 'Closed',
// However if any Opportunity Stage Name Which are not Closed. then update Account (Status) to 'Open'.......
    public static void updateAccountStatus(List<Opportunity> newoppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Account> accOpportunitiesMap = new Map<Id,Account>();
        List<Account> accListToUpdate = new List<Account>();
        
        if(!newOppList.isEmpty()){
            for(Opportunity opp : newoppList){
                //System.debug('--1--'+oldOppMap);
                
                //For After Update Operations...
                if(oldOppMap != null)
                {   //When Opportunity Parent AccountId is Updated....
                    if(opp.AccountId != oldOppMap.get(opp.Id).AccountId)
                    {
                        accIdSet.add(oldOppMap.get(opp.Id).AccountId);
                        accIdSet.add(opp.AccountId);
                    } //When Opportunity Stage Name is Updated...
                    else if(opp.StageName != oldOppMap.get(opp.Id).StageName)
                    {
                        accIdSet.add(opp.AccountId);
                    }
                }
                //For After Insert Operations(When new Opportunity is Inserted)....
                else
                {
                    accIdSet.add(opp.AccountId);
                }
            }
        }
        
        if(!accIdSet.isEmpty()){
            //1*By Using Map to store (AccountId, List<Opportunity>)......
            Map<Id,List<Opportunity>> accOppMap = new Map<Id,List<Opportunity>>();
            for(Opportunity opp : [Select Id,AccountId,StageName From Opportunity Where AccountId IN : accIdSet])
            {
                if(!accOppMap.containsKey(opp.AccountId))
                {
                    accOppMap.put(opp.AccountId, new List<Opportunity>());
                }
                accOppMap.get(opp.AccountId).add(opp);
            }
            
            for(Id ids : accOppMap.keySet()){
                List<Opportunity> accOppList = accOppMap.get(ids);
                //System.debug('--1--'+accOppList);
                Boolean allClosedOpps = true;
                if(!accOppList.isEmpty()){
                    for(Opportunity op : accOppList){
                        if(!op.StageName.equals('Closed Won')){
                            allClosedOpps = false;
                            break;
                        }
                    }
                    if(allClosedOpps == true){
                        accListToUpdate.add(new Account(Id = ids,Status__c = 'Closed'));
                    }
                    else{
                        accListToUpdate.add(new Account(Id = ids,Status__c = 'Open'));
                    }
                }
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }
            
            //2* By Using Parent to Child (Inner Query). Get All Opportunity Related With Associated Account.....
            for(Account ac : [Select Id,Status__c,(Select Id, StageName From Opportunities) From Account Where Id IN : accIdSet]){
                accOpportunitiesMap.put(ac.Id,ac);
                //System.debug('--2--'+accMap.values());
            }
            for(Account acc : accOpportunitiesMap.values()){
                Boolean hasOpenOpportunity = false;
                for(Opportunity op : acc.Opportunities){
                    if(op.StageName != 'closed won'){
                        hasOpenOpportunity = true;
                    }
                }
                //By Using Ternary Operator.....
                acc.Status__c = hasOpenOpportunity ? 'open':'closed';
                accListToUpdate.add(acc);
            }
        }
        if(!accListToUpdate.isEmpty()){
            update accListToUpdate;
        }
    }
    //Task 24: Update Opportunity Related Case Status, Whenever Opportunity StageName is changed.....
    public static void updateCaseStatus(List<Opportunity> newoppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id,Case> caseMap = new Map<Id,Case>();
        List<Case> caseListToUpdate = new List<Case>();
        
        if(!newOppList.isEmpty()){
            for(Opportunity opp : newoppList){
                //System.debug('--1--'+oldOppMap);
                
                //For After Update Operations(Compare New Opportunity With old Opportunity)...
                if(oldOppMap != null)
                {   //When Opportunity Related Case is Changed....
                    if(opp.Case__c != oldOppMap.get(opp.Id).Case__c)
                    {
                        caseIdSet.add(oldOppMap.get(opp.Id).Case__c);
                        caseIdSet.add(opp.Case__c);
                    } //When Opportunity StageName is Updated...
                    else if(opp.StageName != oldOppMap.get(opp.Id).StageName)
                    {
                        caseIdSet.add(opp.Case__c);
                    }
                }
                //For After Insert Operations(When new Opportunity is Inserted)....
                else
                {
                    caseIdSet.add(opp.Case__c);
                }
            }
            if(!caseIdSet.isEmpty()){
                //1.By Using Map...
                Map<Id,List<Opportunity>> caseOppMap = new Map<Id,List<Opportunity>>();
                for(Opportunity opp : [Select Id,AccountId,StageName From Opportunity Where Case__c IN : caseIdSet]){
                    if(!caseOppMap.containsKey(opp.Case__c)){
                        caseOppMap.put(opp.Case__c, new List<Opportunity>());
                    }
                    caseOppMap.get(opp.Case__c).add(opp);
                }
                for(Id ids : caseOppMap.keyset()){
                    List<Opportunity> caseOppList = caseOppMap.get(ids);
                    boolean isOpenOpportunity = false;
                    if(!caseOppList.isEmpty()){
                        for(Opportunity op : caseOppList){
                            if(!op.StageName.equals('Closed Won')){
                                isOpenOpportunity = false;
                                break;
                            }
                        }
                        if(isOpenOpportunity == true){
                            caseListToUpdate.add(new Case(Id = ids,Status = 'Working'));
                        }
                        else{
                            caseListToUpdate.add(new Case(Id = ids,Status = 'Escalated'));
                        }
                    }
                }
                if(!caseListToUpdate.isEmpty()){
                    update caseListToUpdate;
                }       
            }
            //2.By Using Parent to Child Query.....
            for(Case cs :[Select Id,Status,(Select Id,StageName From Opportunities__r) From Case Where Id IN : caseIdSet]){
                caseMap.put(cs.Id,cs);
            }
            for(Case ca : caseMap.values()){
                boolean isOpenOpportunity = false;
                for(Opportunity op : ca.Opportunities__r){
                    if(op.StageName != 'Closed Won'){
                        isOpenOpportunity = true; 
                    }
                }
                if(isOpenOpportunity == true){
                    ca.Status = 'Working';
                }
                else{
                    ca.status = 'Escalated';
                }
                caseListToUpdate.add(ca);
            }
            if(!caseListToUpdate.isEmpty()){
                update caseListToUpdate;
            }
        }
    }
    
    
    //Task 26:- Whenever Opportunity Owner is Updated, then Update the Owner Name and Email in Opportunity Description Field With Updated Owner....
    public static void updateDescription(List<Opportunity> newOppList,Map<Id,Opportunity> oldOppMap){
        Map<Id,Opportunity> oppOwnerMap = new Map<Id,Opportunity>();
        if(!newOppList.isEmpty()){
            for(Opportunity opp : newOppList){
                if(opp.ownerId != oldOppMap.get(opp.Id).ownerId){
                    oppOwnerMap.put(opp.ownerId, opp);
                }
            }
        }
        if(!oppOwnerMap.isEmpty()){
            for(User usr : [Select Id,Name,Email From User Where Id IN : oppOwnerMap.keySet()]){
                if(oppOwnerMap.ContainsKey(usr.Id)){
                    oppOwnerMap.get(usr.Id).Description = usr.Name+'-'+usr.Email;
                }
            }
        }
    }
    //Task 15:-When any Opportunity is created with amount populated and When Amount is updated, then populate total Amount on Account Level for all
    //related opportunities in Annual Revenue Field. If opportunity is deleted or undeleted then update Amount on Account as well..
    public static void populateOpportunityAmount(List<Opportunity> oppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        Map<Id,Account> accMapToUpdate = new Map<Id,Account>();
        
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                if(oldOppMap != null)
                {
                    if(opp.AccountId != null && opp.Amount != null && opp.Amount != oldOppMap.get(opp.Id).Amount){
                        accIdSet.add(opp.AccountId);
                    }
                    
                }else{
                    if(opp.AccountId != null && opp.Amount != null){
                        accIdSet.add(opp.AccountId);
                    }
                }
            } 
        }
        if(!accIdSet.isEmpty()){
            for(Account ac :  [Select Id,AnnualRevenue From Account Where Id IN : accIdSet]){
                accMap.put(ac.Id,ac);
            }
        }
        for(Opportunity op : oppList){
            if(accMap.containsKey(op.AccountId)){
                Account acc = accMap.get(op.AccountId);
                acc.AnnualRevenue = acc.AnnualRevenue + op.Amount;
                accMapToUpdate.put(op.AccountId,acc);
            }
        }
        if(!accMapToUpdate.isEmpty()){
            update accMapToUpdate.values();
        }
    }
    
    //Task 21:-When a Opportunity StageName is changed,then create or update Task record based on Opportunity stageName......
    public static void createOrUpdateTaskBasedOnStageName(List<Opportunity> oppList, Map<Id,Opportunity> oldOppMap){
        Set<Id> oppIdSet = new Set<Id>();
        List<Task> taskListToUpdate = new list<Task>();
        List<Task> taskListToInsert = new list<Task>();
        
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                if(opp.StageName != oldOppMap.get(opp.Id).StageName){
                    oppIdSet.add(opp.Id);
                }
            }
        }
        if(!oppIdSet.isEmpty()){
            Map<Id,Task> taskMap = new Map<Id,Task>();
            for(Task tsk : [Select Id, whatId, Description From Task Where WhatId IN : oppIdSet]){
                taskMap.put(tsk.whatId, tsk);
            }
            for(Opportunity op : oppList){
                if(op.StageName != oldOppMap.get(op.Id).StageName)
                {
                    //Making Variable to either update or insert task based on Certain Conditions...
                    Task newTask;
                    //For Update Operation(If there is any Task Present With Related Opportunity)...
                    if(taskMap.containsKey(op.id))
                    {
                        newTask = taskMap.get(op.Id);
                        newTask.Description = 'Opportunity '+op.Name+ 'has been updated to Stage "'+op.StageName+' ",FollowUp Accordingly.';
                        taskListToUpdate.add(newTask);
                    }
                    //For Insert Operation(If there is no Task Present With Related Opportunity) create new Task...
                    else
                    {
                        newTask = new Task();
                        newTask.Subject = 'Follow up on Opportunity '+op.Name;
                        newTask.Description =  'Opportunity '+op.Name+ 'has been updated to Stage "'+op.StageName+' ",FollowUp Accordingly.';
                        newTask.OwnerId = userInfo.getUserId();
                        newTask.WhatId = op.Id;
                        newTask.ActivityDate = Date.today();
                        newTask.Status = 'Not Started';
                        taskListToInsert.add(newTask);
                    }
                }
            }
            //Using try,catch block to handle exception....
            try
            {
                if(!taskListToUpdate.isEmpty()){
                    update taskListToUpdate;
                }
                if(!taskListToInsert.isEmpty()){
                    insert taskListToInsert;
                }
            }
            catch(exception ex)
            {
                System.debug('Error While Inserting or Updating a record '+ex.getMessage());
            }
        }
    } 
    //Task 38: When Opportunity Type gets Updated, then insert a new OpportunityContactRole according to Opportunity Type. 
    //Delete the existing OpportunityContactRole and also if there is no contact present of the same type as the opportunity,then show error.
    public static void updationOfOpportunityContactRole(List<Opportunity> newOppList,Map<Id,Opportunity> oldOppMap){
        Map<Id,String> oppTypeMap = new Map<Id,String>();
        Set<Id> accIdSet = new Set<Id>();
        Map<String,Contact> oppConMap = new Map<String,Contact>();
        List<OpportunityContactRole> oppContactRoleToInsert = new List<OpportunityContactRole>();                                                                                                                                  
        
        if(!newOppList.isEmpty()){
            for(Opportunity newOpp : newOppList){
                Opportunity oldOpp = oldOppMap.get(newOpp.Id);
                if(newOpp.AccountId != null && newOpp.Type != oldOpp.Type){
                    accIdSet.add(newOpp.AccountId);
                    oppTypeMap.put(newOpp.Id,newOpp.Type);
                }
            }
        }
        if(!accIdSet.isEmpty() && !oppTypeMap.isEmpty()){
            List<Contact> relatedContacts = [Select Id,Contact_Type__c From Contact Where AccountId IN : accIdSet 
                                             AND Contact_Type__c IN : oppTypeMap.values() ORDER BY LastModifiedDate Limit 1];
            for(Contact con : relatedContacts){
                oppConMap.put(con.Contact_Type__c,con);
            }
            
            for(Opportunity opp : newOppList){
                if(oppTypeMap.containsKey(opp.Id)){
                    Contact conForType = oppConMap.get(opp.Type);
                    
                    if(conForType != null){
                        OpportunityContactRole oppConRole = new OpportunityContactRole();
                        oppConRole.OpportunityId = opp.Id;
                        oppConRole.ContactId = conForType.Id;
                        oppContactRoleToInsert.add(oppConRole);                        
                    }
                    else{
                        opp.addError('No Contact Found With Type '+opp.Type+'.');
                    }
                }
            }
            if(!oppContactRoleToInsert.isEmpty()){
                List<OpportunityContactRole> existingRoles = [Select Id From OpportunityContactRole Where OpportunityId IN : oppTypeMap.keySet()];
                delete existingRoles;
                
                insert oppContactRoleToInsert;
            }
        }
    }
}