public class AccountTriggerHandler {
    //***Task :- Create multiple Contacts on insert,update and delete according to of No of contacts field in Account(While Insert)....
    public static void createMultipleContact(list<Account> newAccList,Map<Id,Account> oldAccMap){
        list<contact> conList = new list<contact>();
        for(Account ac: newAccList){
            for(integer i = 1; i <= ac.No_of_Contacts__c; i++){
                Contact c = new Contact();
                c.lastName = ac.Name;
                c.AccountId= ac.id;
                conList.add(c);
            }
        }
        if(conList.size()>0)
            insert conList;      
    }
    
    //***Task :- Create multiple Contacts on update and delete Contacts according to of No of contacts field in Account(While Update)....
    public static void updateMultipleContact(List<Account> newAccList,Map<Id,Account> oldAccMap){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,List<Contact>> accConMap = new Map<Id,List<Contact>>();
        
        for(Account ac : newAccList){
            accIdSet.add(ac.Id);
        }
        for(Account act : [Select Id,No_of_Contacts__c,(Select Id,AccountId From Contacts) From Account Where Id IN : accIdSet]){
            accConMap.put(act.Id,act.Contacts);
        }
        List<Contact> diffConList = new List<Contact>();
        List<Contact> delConList = new List<Contact>();
        
        if(oldAccMap != null){
            for(Account acc : newAccList){
                if(acc.No_of_Contacts__c != oldAccMap.get(acc.Id).No_of_Contacts__c){
                    decimal diff = acc.No_of_Contacts__c - oldAccMap.get(acc.Id).No_of_Contacts__c;
                    
                    if(diff > 0){
                        //Insert Contacts...
                        for(integer i=0; i<diff; i++){
                            contact con = new contact();
                            con.lastName = acc.Name;
                            con.AccountId = acc.id;
                            diffConList.add(con);
                        }
                    }
                    else{
                        //Delete Contacts...
                        for(Contact c : accConMap.get(acc.Id)){
                            if(diff == 0){
                                break;
                            }
                            delConList.add(c);
                            diff = diff+1;
                        }
                    }
                }
            }
            if(diffConList.size()>0)
                insert diffConList;
            if(delConList.size()>0)
                delete delConList;
        }   
    }
    //Scenario:-9, When we are trying to delete Account record delete all the corresponding child records from Contact object,
    public static void deleteAccountRelatedContacts(List<Account> oldAccList){
        Set<Id> accIdSet = new Set<Id>();
        for(Account acc : oldAccList){
            accIdSet.add(acc.Id);
        }  
        List<Contact> conList = [Select Id,AccountId From Contact where AccountId IN : accIdSet];
        if(!conList.isEmpty()){
            delete conList;
        }
    }
    
    //Scenario 1:- When we are trying to insert new record into Account object. 
    //If there is any record existing with same account name it should prevent duplicate record.....
    
    public static void preventDuplicateAccountRecords(List<Account> accList){
        //1.Collect Account Names w.r.t DataType(String) in set....
        Set<String> accNames = new Set<String>();
        for(Account acc: accList){
            accNames.add(acc.Name);
        }
        //Get All the Existing Account Names from DB....
        List<Account> exAccList = [Select Id,Name From Account Where Name IN : accNames];
        Set<String> duplicateAccNames = new Set<String>();
        for(Account acc : accList){
            duplicateAccNames.add(acc.Name.toLowerCase()); //to prevent cases while inserting...
        }
        for(Account ac : accList){
            if(ac.Name != null && duplicateAccNames.contains(ac.Name.toLowerCase())){
                ac.addError('Account  with same Name already Exists');
            }
        }
    }
    //Scenario 2:- Append Prefix on Name while creating Account Records
    public static void appendPrefixonName(List<Account> accList){
        for(Account acc : accList){
            acc.Name = 'Mr '+acc.Name;
        }
    }
    //Scenario 3:-Whenever a new record is created into account object,Before this new record is inserted into Account,
    // delete all the contacts records created similar with this account name.....
    public static void deleteContactsOnAccountInsert(List<Account> newAccList){
        Set<String> accNameSet = new Set<String>();
        for(Account acc : newAccList){
            accNameSet.add(acc.Name);
        }
        //To Delete Contact Record With its Related Account Name.....
        List<Contact> conListToDelete = [Select Id From Contact Where Name IN : accNameSet];
        if(conListToDelete.size()>0){
            delete conListToDelete;
        }
    }
    
    //***Scenario 13:-Update Account Related Contact Phone Whenever account Phone is updated..... 
    public static void updateRelatedContactPhone(List<Account> acclist, Map<Id,Account> OldAccMap){
        List<Contact> conlistToupdate = new List<Contact>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        
        for(Account acc : acclist){
            // Null Check and we will use Map to Store only those Account Whose Phone is Updated...
            if( acc.Phone != null && acc.Phone != OldAccMap.get(acc.id).phone && OldAccMap != null){
                accMap.put(acc.Id,acc);
            }
        }    
        if(accMap.size()>0){
            for(Contact con : [Select Id,HomePhone,AccountId From Contact where AccountId IN : accMap.keyset()]){
                if(accMap.containskey(con.AccountId)){
                    con.HomePhone = accMap.get(con.AccountId).phone;
                    conlistToupdate.add(con);
                }
            }
            if(conlistToupdate.size()>0){
                update conlistToupdate;
            }
        }
    }
    //Scenario 18:-While Updating Account Owner. Update related Contact owner with updated Account Owner Name........ 
    public static void updateRelatedContactOwner(List<Account> newAccList,Map<Id,Account> oldAccMap){
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc : newAccList){
            if(acc.OwnerId != oldAccMap.get(acc.Id).OwnerId){
                accMap.put(acc.Id,acc);
            }
        }
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact con : [Select Id,ownerId,AccountId From Contact Where AccountId IN : accMap.keySet()]){
            if(accMap.containsKey(con.AccountId)){
                con.OwnerId = accMap.get(con.AccountId).OwnerId;
                conlistToUpdate.add(con);
            }
        }
        if(!conListToUpdate.isEmpty()){
            update conListToUpdate;
        }        
    }
    //***Scenario 16:- Create ‘Sales Rep’ field with datatype (Text) on the account object. When we create account record,
    //the account owner will be automatically added to Sales Rep field. When we update the Account owner of the record,
    //then also the Sales Rep Will be automatically updated.......
    
    public static void updateSalesRepField(List<Account> newAccList){
        //Store Ids of  Account Owner in Set....
        Set<Id> ownerIdSet = new Set<Id>();
        for(Account acc : newAccList){
            if(acc.OwnerId != null){
                ownerIdSet.add(acc.ownerId);
            }
        }
        //Use Map to store <Id, User> to Fetch userName.......
        Map<Id,User> userMap = new Map<Id,User>();
        for(User usr : [Select Id,Name From User Where Id IN : ownerIdSet]){
            userMap.put(usr.Id,usr);
            //System.debug('--1--'+userMap);  
        }
        for(Account a : newAccList){
            a.Sales_Rep__c = userMap.get(a.OwnerId).Name;
        }
    }
    
    //***Task 5:-Automatically close all opportunity whose probability is greater >= 70%.and when checkbox(Close_All_Opps__c) is checked on Account.....
    public static void closeOpportunity(List<Account> newAccList, Map<Id,Account> oldAccMap){
        Set<Id> accIdSet = new Set<Id>();
        //System.debug('---1---'+oldAccMap);
        for(Account ac : newAccList){
            if(ac.Close_All_Opps__c == true && oldAccMap.containsKey(ac.Id) && oldAccMap.get(ac.Id).Close_All_Opps__c == false){
                accIdSet.add(ac.Id);
            }
        }
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        for(Opportunity opp : [Select Id,StageName From Opportunity Where AccountId IN : accIdSet AND StageName != 'Closed Won' AND Probability >= 70]){
            opp.stageName = 'Closed Won';
            opp.closeDate = date.today();
            opp.Description = 'Opportunity Record is Updated';
            oppListToUpdate.add(opp);
        }
        if(!oppListToUpdate.isEmpty()){
            update oppListToUpdate;
        }
    }
    //***Task 11: Automatically create Related Contact on Insertion of Account and Update Client Contact Lookup Field With newly created Contact Records.
    //By Using Best Practice.....
    public static void updateClientContactLookupField(List<Account> newAccList){
        List<Contact> conList = new List<Contact>();
        Set<Id> accIdSet = new Set<Id>();
        List<Account> accListToUpdate = new List<Account>();
        
        if(!newAccList.isEmpty()) {
            for(Account acc : newAccList){
                Contact con = new Contact();
                con.LastName = acc.Name + 'con';
                con.AccountId = acc.Id;
                conList.add(con);
                accIdSet.add(acc.Id);
            }
            if(!conList.isEmpty()){
                insert ConList;
            }
        }
        // Updating Account Object:Client Contact Lookup Field With newly Created Contact Id.....
        if(!accIdSet.isEmpty()) {           
            Map<Id,Account> accMap = new Map<Id,Account>();
            List<Account> exAccList = [Select Id,Client_Contact__c From Account Where Id IN : accIdSet];
            if(!exAccList.isEmpty()){
                for(Account ac : exAccList){
                    accMap.put(ac.Id,ac);
                }
            }
            if(!conList.isEmpty()){
                for(Contact con : conList){
                    //System.debug('---1---'+accMap.containsKey(con.AccountId));
                    if(accMap.containsKey(con.AccountId)){
                        //Making Instance of Account to assign custom field(client_Contact__c) with newly created contact Record....
                        Account ac = accMap.get(con.AccountId);
                        ac.Client_Contact__c = con.Id;
                        accListToUpdate.add(ac);
                    }
                }
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }     
        }        
    }
    
    //Task 27:-Prevent insertion of Account while creating the account with same email and existing account already exists and
    //have related contacts to it..
    public static void avoidInsertionOfAccount(List<Account> newAccList){
        Set<String> emailSet = new Set<String>();
        if(!newAccList.isEmpty()){
            for(Account acc : newAccList){
                if(acc.Email__c != null){
                    emailSet.add(acc.Email__c);
                }
            }
        }
        Set<String> duplicateEmailSet = new Set<String>();
        if(!emailSet.isEmpty())
            for(Account ac : [Select Id,Email__c,(Select Id From Contacts)From Account Where Id IN : emailSet]){
                if(ac.contacts != null){
                    duplicateEmailSet.add(ac.Email__c);
                }
            }
        for(Account acc : newAccList){
            if(duplicateEmailSet.contains(acc.Email__c)){
                acc.addError('Account Records With Same Email With Related Contacts Already Exists');
            }
        } 
    }
    //Task 15:-When Account field Active__c  is updated from ‘Yes’ to ‘No’ then check all opportunities,
    // associated with the account. Update all opportunities Stage to close lost if stage not equal to close won.
    public static void updateOpporunityStage(List<Account> accList,Map<Id,Account> oldAccMap){
        Set<Id> accIdSet = new Set<Id>();
        for(Account newAcc : accList){
            Account oldAcc = oldAccMap.get(newAcc.Id);
            if(newAcc.Active__c == 'No' && oldAcc.Active__c == 'Yes'){
                accIdSet.add(newAcc.Id);
            }
        }
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        for(Account ac : [Select Id,(Select Id,StageName From Opportunities) From Account Where Id IN : accIdSet]){
            if(ac.Opportunities != null){
                for(Opportunity opp : ac.Opportunities){
                    if(opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost'){
                        opp.StageName = 'Closed Lost';
                        oppListToUpdate.add(opp);    
                    }
                }
                if(!oppListToUpdate.isEmpty()){
                    update oppListToUpdate;
                }
            }
        }
    }
    //***Task 28:-When User Changes Account Field Status From Open to Closed,then Delete all Related Opportunities related with it and then
    // Check Do_Not_Contact__c checkbox on Related Contact...
    public static void changeStatus(List<Account> newAccList, Map<Id,Account> oldAccMap){
        Set<Id> accIdSet = new Set<Id>();
        List<Contact> conListToUpdate = new List<Contact>();
        
        if(!newAccList.isEmpty()){
            for(Account newAcc : newAccList){
                if(!oldAccMap.isEmpty()){
                    Account oldAcc = oldAccMap.get(newAcc.Id);
                    if(newAcc.Status__c == 'Closed' &&  oldAcc.Status__c == 'Open'){
                        accIdSet.add(newAcc.Id);
                    }
                }
            }
        }
        if(!accIdSet.isEmpty()){
            List<Contact> conList = [Select Id, Do_Not_Contact__c From Contact Where AccountId IN : accIdSet AND Do_Not_Contact__c = false];
            
            List<Opportunity> oppList = [Select Id From Opportunity Where AccountId IN : accIdSet AND StageName != 'Closed Won'];
            
            if(!conList.isEmpty()){
                for(Contact con : conList){
                    con.Do_Not_Contact__c = true;
                    conListToUpdate.add(con);
                }
            }
            try
            {
                if(!conListToUpdate.isEmpty()){
                    update conListToUpdate;
                }
                if(!oppList.isEmpty()){
                    delete oppList;
                }
            }
            catch(exception ex)
            {
                System.debug('Error While Doing Update or Deletion '+ex.getMessage());
            }
        }
    } 
    //Task 22:- Prevent Deletion of Account if Logged in User profile is other than system Administrator....
    public static void checkProfileForDeletion(List<Account> accList){
        Profile p = [Select Id,Name From Profile Where Name = 'System Administrator'];
        for(Account ac : accList){
            if(userinfo.getUserId() != p.Id){
                ac.AddError('Only System Administrator can Delete the Records');
            }
        }
    }
    //Task 14:- Prevent Deletion of Account if any related Contacts is Associated With it....
    public static void preventAccountDeletionIfContactsExist(List<Account> oldAcclist){ 
        Set<Id> accIdSet = new Set<Id>();
        for(Account acc : oldAccList){
            accIdSet.add(acc.Id);
        }
        for(Account ac : [Select Id,(Select Id From Contacts) From Account Where Id IN : accIdSet]){
            if(ac.contacts.size()>0){
                ac.addError('Account With Related Contacts cannot be Deleted');
            }
        }
    }
    
}