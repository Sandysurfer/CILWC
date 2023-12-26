public class CaseHandler {
    
    //**Task 6:- Populate Account Custom Field (Latest_Case_Record__c) With Latest Created Case Field (CaseNumber) .......
    //By Using Map....
    public static void updateCaseNumberOnAccount(List<Case> caseList){
        Map<Id,Case> caseMap = new Map<Id,Case>();
        for(Case cs : caseList){
            if(cs.AccountId != null){
                caseMap.put(cs.AccountId,cs);
            }
        }
        List<Account> accListToUpdate = new List<Account>();
        for(Account ac : [Select Id,Latest_Case_Record__c From Account Where Id IN : caseMap.keySet()]){
            if(caseMap.containsKey(ac.Id)){
                ac.Latest_Case_Record__c = caseMap.get(ac.Id).caseNumber;
                accListToUpdate.add(ac);
            }
        }
        if(!accListToUpdate.isEmpty()){
            update accListToUpdate;
        }
    }
    // 2nd Method :- By Using Set && Using Best practices......
    public static void updateLatestCaseNumber(List<Case> newCaseList){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        Map<Id,Account> accMapToUpdate = new Map<Id,Account>();
        
        for(Case c : newCaseList){
            if(c.AccountId != null){
                accIdSet.add(c.AccountId);
            }
        }
        for(Account ac : [Select Id,Latest_Case_Record__c From Account Where ID IN : accIdSet]){
            accMap.put(ac.Id,ac);
        }
        for(Case cs : newCaseList){
            if(accMap.containsKey(cs.AccountId)){
                Account acc = accMap.get(cs.AccountId);
                if(acc.Latest_Case_Record__c != cs.CaseNumber){
                    acc.Latest_Case_Record__c = cs.CaseNumber;
                    accMapToUpdate.put(acc.Id, acc);
                }
            }
        }
        if(!accMapToUpdate.isEmpty()){
            update accMapToUpdate.values();
        }
    }
    //**Task 23:Update Case Related Parent Account CustomField(No of Cases), Whenever Case Status is changed from new to working or escalated.....
    public static void updateAccount(List<case> newCaseList, Map<Id,Case> oldCaseMap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Integer>newCaseCountMap = new Map<Id,Integer>();
        Map<Id,Integer>workingCaseCountMap = new Map<Id,Integer>();
        Map<Id,Integer>escalatedCaseCountMap = new Map<Id,Integer>();
        Map<Id,Account> accountsToUpdate = new Map<Id,Account>();
        
        if(!newCaseList.isEmpty()){
            for(Case newCase : newCaseList){
                if(oldCaseMap != null)
                {  //When Parent AccountId is Updated....
                    Case oldCase = oldCaseMap.get(newCase.Id);
                    if(newCase.AccountId != oldCase.AccountId)
                    {
                        accIdSet.add(oldCase.AccountId);
                        accIdSet.add(newCase.AccountId);
                    }//When Case Status is Updated(update Operation)...
                    else if(newCase.status != oldCase.status)
                    {
                        accIdSet.add(newCase.AccountId);
                    }
                }
                else
                {//When new Case is Inserted...
                    accIdSet.add(newCase.AccountId);
                }
            }
        }
        if(!accIdSet.isEmpty()){
            for(Account acc : [Select Id, No_of_New_Case__c, No_of_Working_Case__c, No_of_Escalated_Case__c,
                               (Select Id,Status From Cases)From Account Where Id IN : accIdSet])
            {
                newCaseCountMap.put(acc.Id, 0); //initial values to represent Case,as no Cases has been processed(to prevent null values)
                workingCaseCountMap.put(acc.Id, 0);
                escalatedCaseCountMap.put(acc.Id, 0);
                
                for(Case c : acc.Cases)
                {
                    if(c.Status == 'New'){
                        newCaseCountMap.put(acc.Id,	newCaseCountMap.get(acc.Id) + 1);//increment count according to status(update count by 1)
                    }
                    else if(c.Status == 'Working'){
                        workingCaseCountMap.put(acc.Id,	workingCaseCountMap.get(acc.Id) + 1);
                    }
                    else if(c.Status == 'Escalated'){
                        escalatedCaseCountMap.put(acc.Id, escalatedCaseCountMap.get(acc.Id) + 1);
                    }
                }
                //To Check Whether There is Change in Count of No of Cases with Current Value of Case on Related Account.......
                if(newCaseCountMap.get(acc.Id) != acc.No_of_New_Case__c || 
                   workingCaseCountMap.get(acc.Id) != acc.No_of_Working_Case__c ||
                   escalatedCaseCountMap.get(acc.Id) != acc.No_of_Escalated_Case__c)
                {
                    acc.No_of_New_Case__c = newCaseCountMap.get(acc.Id);
                    acc.No_of_Working_Case__c = workingCaseCountMap.get(acc.Id);
                    acc.No_of_Escalated_Case__c = escalatedCaseCountMap.get(acc.Id);
                    
                    accountsToUpdate.put(acc.Id,acc);
                }
            }
            if(!accountsToUpdate.isEmpty()){
                update accountsToUpdate.values();
            }
        }  
    }
    //***Task 30:-Update Case Related Parent Account Rating, Based on Number of Closed cases on Account......
    public static void updateAccountRating(List<Case> newCaseList,Map<Id,Case> oldCaseMap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Integer> accCaseCountMap = new Map<Id,Integer>();
        List<Account> accListToUpdate = new List<Account>();
        
        if(!newCaseList.isEmpty()){
            for(Case newCase : newCaseList){
                if(oldCaseMap != null){
                    Case oldCase = oldCaseMap.get(newCase.Id);
                    //for Update When Parent AccountId is Updated
                    if(newCase.AccountId != oldCase.AccountId){
                        accIdSet.add(oldCase.AccountId);
                        accIdSet.add(newCase.AccountId);
                    }
                    else if(oldCase.IsClosed != newCase.IsClosed){
                        accIdSet.add(newCase.AccountId);
                    }  
                }
                //for insert,delete and undelete..
                else if(newCase.IsClosed == true){
                    accIdSet.add(newCase.AccountId);
                }
            }
            if(!accIdSet.isEmpty()){
                //Use Any One Approach....
                //1.)By Using Inner Query...
                for(Account acc : [Select Id,(Select Id From Cases Where IsClosed = true) From Account Where Id IN : accIdSet]){
                    Integer closeCase = acc.Cases.Size();
                }
                //2.)By Using Map..
                for(Case closedCase :[Select Id, AccountId From Case Where AccountId IN : accIdSet AND IsClosed = true]){
                    if(accCaseCountMap.containsKey(closedCase.AccountId)){
                        accCaseCountMap.put(closedCase.AccountId, accCaseCountMap.get(closedCase.AccountId) + 1);
                    }
                    else{
                        accCaseCountMap.put(closedCase.AccountId, 1);
                    }
                }
                //3.)By Using AggregateQuery....
                for(AggregateResult aggrResult : [Select AccountId accIds, Count(Id) caseCount From Case Where AccountId IN : accIdSet AND IsClosed = true Group by AccountId]){
                    Id accountId = (Id)aggrResult.get('accIds');
                    Integer caseCount = (Integer)aggrResult.get('caseCount');
                    
                    accCaseCountMap.put(accountId, caseCount);
                }
                List<Account> accList = [Select Id,Rating From Account Where Id IN : accIdSet];
                if(!accList.isEmpty()){
                    for(Account acc : accList){
                        //Using ternary Operator Same as if else-->Conditional Statement ? true:false;
                        Integer closedCaseCount = accCaseCountMap.containsKey(acc.Id) ? accCaseCountMap.get(acc.Id) : 0;
                        String accountRating;
                        if(closedCaseCount > 5){
                            accountRating = 'Hot';
                        }
                        else if(closedCaseCount > 2){
                            accountRating = 'Warm';
                        }
                        else{
                            accountRating = 'Cold';
                        }
                        acc.Rating = accountRating;
                        accListToUpdate.add(acc);
                    }
                    if(!accListToUpdate.isEmpty()){
                        update accListToUpdate;
                    }
                }
            }
        }
    }
    //***Task 32:- Automatically Update Case Related Task Status and Parent Account Description, Whenever Case Status is Updated......
    public static void updateRelatedTaskAndAccount(List<Case> newCaseList, Map<Id,Case> oldCaseMap){
        Map<Id,String> caseStatusMap = new Map<Id,String>();
        Set<Id> accIdSet = new Set<Id>();
        List<Task> taskListToUpdate = new List<Task>();
        List<Account> accListToUpdate = new List<Account>();
        
        if(!newCaseList.isEmpty()){
            for(Case newCase : newCaseList){
                if(!oldCaseMap.isEmpty()){
                    Case oldCase = oldCaseMap.get(newCase.Id);
                    if(newCase.Status != oldCase.Status && newCase.AccountId != null){
                        caseStatusMap.put(newCase.Id,newCase.Status); //For Updating Case Related Task...
                        accIdSet.add(newCase.AccountId);  //For Updating Related Parent Account.....
                    }
                }
            }
        }
        //1st Task:- Update Related Task Status With Updated Case Status Values....
        if(!caseStatusMap.isEmpty()){
            List<Task> taskList = [Select Id, whatId, Status From Task Where WhatId IN : caseStatusMap.keySet()];
            if(!taskList.isEmpty()){
                for(Task tsk : taskList){
                    String caseStatus; //Store Case Status(String),to Update Related Task Status.....
                    if(caseStatusMap.containsKey(tsk.whatId)){
                        caseStatus = caseStatusMap.get(tsk.WhatId);
                    }
                    tsk.Status = caseStatus;
                    taskListToUpdate.add(tsk);
                }
            }
            if(!taskListToUpdate.isEmpty()){
                update taskListToUpdate;
            }
        }
        //2nd Task:- Update Related Account Description With CaseNumber and Status, Whenever Case Status is updated...
        if(!accIdSet.isEmpty()){
            Map<Id,Case> latestCaseMap = new Map<Id,Case>();
            for(Case cs : [Select AccountId, CaseNumber, Status From Case Where AccountId IN : accIdSet AND Status != null]){
                if(!latestCaseMap.containsKey(cs.AccountId)){
                    latestCaseMap.put(cs.AccountId, cs);
                }
            }
            for(Account acc : [Select Id,Description From Account Where Id IN : accIdSet]){
                if(latestCaseMap.containsKey(acc.Id)){
                    Case latestCase = latestCaseMap.get(acc.Id);
                    acc.Description = 'Latest Case Status For Case # '+latestCase.CaseNumber+ ' is '+latestCase.Status;
                    accListToUpdate.add(acc);
                }
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }
        }
    }
    //***Task 33:- While Insertion of New Case Record, Update Account Related Contact which is Primary_Contact_c to Case Object ContactId then
    // Create new Event Accordingly and if no primary_contact__c is related with account then Apply Validations.....
    public static void updateAccountPrimaryContactAndEvent(List<Case> newCaseList){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        List<Event> eventList = new List<Event>();
        
        if(!newCaseList.isEmpty()){
            for(Case newCase : newCaseList){
                if(newCase.AccountId != null && String.isNotBlank(newCase.Subject)){
                    accIdSet.add(newCase.AccountId);
                }
            }
        }
        if(!accIdSet.isEmpty()){
            for(Contact con : [Select Id, AccountId, Primary_Contact__c From Contact Where Primary_Contact__c = true
                               AND AccountId IN : accIdSet Order by LastModifiedDate DESC Limit 1])
            {
                conMap.put(con.AccountId, con);
            }
            if(!newCaseList.isEmpty()){ 
                for(Case csObj : newCaseList){
                    //Apply Checks while creating new case record and related Account is selected and Contact is not selected....
                    if(csObj.AccountId != null && csObj.ContactId == null && !conMap.isEmpty()){
                        Contact conRcd = conMap.get(csObj.AccountId);
                        csObj.ContactId = conRcd.Id;
                        
                        //Create Event After Updating Case ContactId With PrimaryContact of related Account...
                        Datetime currentDateTime = DateTime.now();
                        Datetime startDateTime = currentDateTime.addDays(2);
                        Datetime endDateTime = startDateTime.addHours(2);
                        
                        Event ev = new Event();
                        ev.Subject = csObj.Subject;
                        ev.WhoId = csObj.Id;             //"Who Id refers to person Name (Contact or Lead)and whatId refers to related Object(Account)....
                        ev.StartDateTime = startDateTime;
                        ev.EndDateTime = endDateTime;
                        eventList.add(ev);
                        
                        if(!eventList.isEmpty()){
                            insert eventList;
                        }
                    }
                    //Apply Validations, If There is No Primary Contact present on Related Account Show Error...
                    else if(csObj.AccountId != null && conMap.isEmpty()){
                        csObj.addError('There is No Primary Contact Present on Selected Account');
                    }
                }
            }    
        }
    }
    //***Task 39: Whenever Escalation Required Checkbox gets checked for a case on an Account,then a followup task should be
    //created for the primary contact on Account.
    public static void createFollowUpTaskForPrimaryContact(List<Case> newCaseList,Map<Id,Case> oldCaseMap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        List<Task> tasksToInsert = new List<Task>();
        
        if(!newCaseList.isEmpty()){
            for(Case newCase : newCaseList){
                Case oldCase = oldCaseMap.get(newCase.Id);
                if(newCase.AccountId != null && newCase.EscalationRequired__c == true && oldCase.EscalationRequired__c  == false){
                    accIdSet.add(newCase.AccountId);
                }
            }
        }
        if(!accIdSet.isEmpty()){
            List<Contact> conList = [Select Id,AccountId,Primary_Contact__c From Contact Where AccountId IN:accIdSet AND Primary_Contact__c = true
                                     order by LastModifiedDate];
            for(Contact con : conList){
                conMap.put(con.AccountId,con);
            }
            
            for(Case csRec : newCaseList){
                if(!conMap.isEmpty() && conMap.containsKey(csRec.Id)){
                    Contact primaryCon = conMap.get(csRec.AccountId);
                    
                    Task tsk = new Task();
                    tsk.Subject = 'Follow Up Task';
                    tsk.WhoId = primaryCon.Id;
                    tsk.Status = 'Not Started';
                    tsk.Priority = 'High';
                    tsk.Description = 'This Task is Created For Case';
                    tasksToInsert.add(tsk);
                    
                }
            }
            try{
                insert tasksToInsert; 
            }
            catch(exception ex){
                System.debug('Error While inserting Case Record '+ex.getMessage());
            }
            
        }
    }
}