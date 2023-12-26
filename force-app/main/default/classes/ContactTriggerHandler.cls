public class ContactTriggerHandler {
    
    public static void duplicateRecordsInsert(List<Contact> newConList){
        for(Contact  con : newConList){
            if(con.firstName == 'test'){
                con.AddError('contact already exists');
            }
            else if(con.firstName != null && con.firstName.toLowerCase().contains('test')) {
                con.firstName.addError('Contacts with "test" in their name are not allowed to be inserted.');
            }
        }
    }
    
    public static void validatePhoneValue(List<Contact> conList){
        for(Contact c : conList){
            if(c.MobilePhone == null && c.phone == null){
                c.addError('Enter Phone or MobilePhone');
            }
            else if(c.MobilePhone == null){
                c.MobilePhone = c.Phone;
            }
        }
    }
    //Task 36: Use Case of Custom Metadata...
    public static void updateCostCode(List<Contact> newConList){
        String region = [Select Region__c From User WHERE Id =: userInfo.getUserId()].Region__c;
        //System.debug('--2--'+region);
        //1.To Access only the Value of Custom Metadata Object...
        Cost_Code_Detail__mdt md = Cost_Code_Detail__mdt.getInstance(region);
        //System.debug('--1--'+md);
        for(Contact c : newConList){
            c.Cost_Detail_Value__c = md.Value__c;
        }
        //2.To Get All the Details of Custom Metadata Type...
        Map<String, Cost_Code_Detail__mdt> mapEd = Cost_Code_Detail__mdt.getAll();
        for(String nameCostDomain : mapEd.keySet()){
            System.debug('--2--'+mapEd.get(nameCostDomain).Value__c);
        }
    }
    //Scenario: If we have Contact Record, create a account record and relate it with contact...
    // for Before insert event and relate contact to newly created account through (Map)...
    public static void createRelatedAccount(List<Contact> conList){
        List<Account> accList = new List<Account>();
        for(Contact con : conList){
            Account ac = new Account();
            ac.Name = con.LastName;
            accList.add(ac);
        }
        insert accList;
        //Relating Contact.AccountId with newly Created Account.....
        Map<String,Id> accMap = new Map<String,Id>();
        for(Account acc : accList){
            accMap.put(acc.Name, acc.Id);
        }
        for(Contact con : conList){
            con.AccountId = accMap.get(con.LastName); //Through LastName get related Id....
        }
    }
    
    //Scenario 4:- Update Account of (Customer) Balance Field. When New Contact is created for associated account and 
    //if Contact Transaction Type is deposit then add (balance+amount),else if Transaction Type is withdraw then deduct (balance-amount)..... 
    
    public static void updateCustomerAccountBalance(List<Contact> conList){
        Map<Id,Account> accountMap  = new Map<Id,Account>();
        Map<Id,Account> accMapToUpdate = new Map<Id,Account>();
        Set<Id> accIds = new Set<Id>();
        
        for(Contact con : conList){
            if(con.AccountId != null){
                accIds.add(con.AccountId);
            }
        }
        for(Account ac : [Select Id,Balance__c From Account Where Id IN : accIds]){
            accountMap.put(ac.Id,ac);
        }
        for(Contact con : conList){
            Account acc = accountMap.get(con.AccountId);
            //Stystem.debug('---1---'+acc);
            if(con.Transaction_Type__c == 'Withdraw'){
                acc.Balance__c = acc.Balance__c - con.Amount__c;
                if(acc.Balance__c < 0){
                    con.addError('Balance insufficient');
                }
                //System.debug('Balance '+acc.Balance__c);
            } 
            else if(con.Transaction_Type__c == 'Deposit'){
                // System.debug('---3---'+con.Amount__c);
                acc.Balance__c = acc.Balance__c + con.Amount__c;
                // System.debug('Balance After Operations--->'+acc.Balance__c);
            }
            accMapToUpdate.put(con.AccountId,acc);
        }
        update accMapToUpdate.values();       
    }
    
    //Scenario 5:- Whenever a new contact is created for account, update the corresponding account phone with the new contact phone field.
    public static void updateRelatedAccountPhone(List<Contact> conList, Map<Id,Contact> oldConMap){
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        for(Contact con : conList){
            if(con.AccountId != null){
                //Null Check for both insert and update operations....
                if(con.Phone != null || con.Phone != oldConMap.get(con.Id).phone){
                    conMap.put(con.AccountId,con);
                }
            }
        }
        if(conMap.size()>0){ 
            List<Account> accListToUpdate = new List<Account>();         
            for(Account acc : [Select Id,Phone From Account Where Id IN : conMap.keySet()]){
                if(conMap.containskey(acc.Id)){
                    acc.Phone = conMap.get(acc.Id).Phone;
                    accListToUpdate.add(acc);
                }
            } 
            if(accListToUpdate.size()>0){
                update accListToUpdate;
            }
        }
    }
    //Task 2:-While creating a contact user is selecting an account to associate with it.
    //Check if account field Active__c == 'No',then User Should get an error ('Please Remove In-Active Account').
    public static void preventCreationOfContact(List<Contact> newConList){
        Set<Id> accIdSet = new Set<Id>();
        
        for(Contact con : newConList){
            if(con.AccountId != null){
                accIdSet.add(con.AccountId);
            }   
        }
        Set<Id> closedAccIdSet = new Set<Id>();
        for(Account acc : [Select Id From Account Where Id IN : accIdSet AND Active__c = 'No']){
            closedAccIdSet.add(acc.Id);           
        }
        for(Contact c : newConList){
            if(closedAccIdSet.contains(c.AccountId)){
                c.addError('Please Remove In-Active Account');
            }
        }
    }
    
    //Task 16:-While Creating Contact,Where Contact is Related With Account,and Contact Email is null,then Copy Related Account Email to Contact Email....
    //1st Method:-By Using Child to Parent Query.....
    public static void copyEmailUsingChildToParent(){
        List<Contact> conList = [Select Id,Name,Account.Email__c From Contact Where AccountId != null];
        for(Contact con : conList){
            if(con.Email == null){
                con.Email = con.Account.Email__c;
            }
        } 
    } 
    //2nd Method:- By Using Map....
    public static void copyEmailFromAccount(List<Contact> conList){
        Set<Id> accIdSet = new Set<Id>();
        for(Contact con : conList){
            if(con.AccountId != null){
                accIdSet.add(con.AccountId);
            }
        }
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account ac : [Select Id, Email__c From Account Where Id IN : accIdSet AND Email__c != null]){
            accMap.put(ac.Id,ac);
        }
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact ct : conList){
            if(accMap.containsKey(ct.AccountId)){
                ct.Email = accMap.get(ct.AccountId).Email__c;
                conListToUpdate.add(ct);
            }
        }
        update conListToUpdate;
    }
    //Task 17:- Same as Above but when Account Email is Also null, then copy related Opportunity Email to contact Email
    //(As there is No Relation between Contact and Opportunity)...
    public static void copyEmailFromOpportunities(List<Contact> conList){
        Set<Id> accIdSet = new Set<Id>();
        List<Contact> conListToUpdate = new List<Contact>();
        
        for(Contact con : conList){
            if(con.AccountId != null){
                accIdSet.add(con.AccountId);
            }
        }
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account ac : [Select Id,Email__c,(Select Id,Email__c From Opportunities Where AccountId != null AND Email__c != null) 
                          From Account Where Id IN : accIdSet AND Email__c = null])
        {
            accMap.put(ac.Id,ac);
        }
        
        for(Contact c : conList){
            if(accMap.containsKey(c.AccountId)){
                //Making Instance of Account, to Assign Account Email to related Contact Email, if Account Email is Not Null...
                Account acc = accMap.get(c.AccountId);
                if(c.Email == null && acc.Email__c != null){
                    c.Email = acc.Email__c;
                }
                else if(!acc.Opportunities.isEmpty()) {
                    c.Email = acc.Opportunities[0].Email__c;
                }
            }
            conListToUpdate.add(c);
        }
        if(!conListToUpdate.isEmpty()){
            update conListToUpdate;
        }
    }
    
    // Task 3:- While Inserting Contact, Search Contact's Phone Number Only in it's Parent Account Contacts,if there is duplicate contact,
    // throw error: 'phone number already exist in parent account'...
    public static void preventDuplicatePhoneonAccount(List<Contact> newConList){
        Set<String> conPhoneSet = new Set<String>();
        Set<String> accPhoneSet = new Set<String>();

        for(Contact con : newConList){
            if(con.Phone != null){
                conPhoneSet.add(con.Phone);
            }
        }
        if(!conPhoneSet.isEmpty()){
            for(Account ac : [Select Id,Phone From Account Where Phone IN : conPhoneSet]){
                accPhoneSet.add(ac.Phone);
            }
        }
        for(Contact con : newConList){
            if(accPhoneSet.contains(con.Phone)){
                con.AddError('Contact Phone Already Exist on Parent Account');
            }
        }
    }
    //Task 32:- While inserting Contact on related Account, Update the parent Account record types(Customer,Lead,Partner) and 
    //add Validations Error if Contact Record Type is Changed......
    public static void updateAccountRecordType(List<Contact> newConList, Map<Id,Contact> oldConMap){
        Map<Id,String> accMap = new Map<Id,String>();
        Set<Id> accIdSet  = new Set<Id>();
        
        //For Before Insert....
        if(!newConList.isEmpty() && oldConMap == null){
            for(Contact con : newConList){
                if(con.AccountId != null){
                    accIdSet.add(con.AccountId);
                }
            }
            if(!accIdSet.isEmpty()){
                for(Account acc : [Select Id,RecordType.Name From Account Where Id IN : accIdSet]){
                    accMap.put(acc.Id,acc.RecordType.Name);
                }  
                if(!newConList.isEmpty()){
                    for(Contact conObj : newConList){
                        //Store RecordType Name in String Variable to Check Record Type Name whether it Exists...
                        String accRecordType = accMap.get(conObj.AccountId);
                        if(accRecordType != null){
                            if(accRecordType == 'Lead'){
                                conObj.Contact_Type__c = 'Lead';
                            }
                            else if(accRecordType == 'Customer'){
                                conObj.Contact_Type__c = 'Cutomer';
                            }
                            else if(accRecordType == 'Partner'){
                                conObj.Contact_Type__c = 'Partner';
                            }
                        }
                    }
                }
            }
        }
        //For Before Update Operations and Appplying Validation....
        else {
            if(!newConList.isEmpty() && oldConMap != null){
                for(Contact conObj : newConList){
                    if(conObj.Contact_Type__c != oldConMap.get(conObj.Id).Contact_Type__c){
                        String accRecordType = accMap.get(conObj.AccountId);
                        if(conObj.Contact_Type__c != accRecordType){
                            conObj.addError('Contact Type Cannot be Updated to Value other than Account Record Type');
                        }
                    }
                }
            }
        }
    }
    
    
    //Task 22:- When Contact Phone is present in Related Account then do nothing,if phone didn`t match, then copy Account phone to Contact other phone...
    public static void copyAccountPhoneToOtherPhone(List<Contact> newConList){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();

        if(!newConList.isEmpty()){
            for(Contact con : newConList){
                if(con.AccountId != null){
                    accIdSet.add(con.AccountId);
                }
            }
        }
        //Query Related Account Phone Where Phone != null......
        for(Account acc : [Select Id,Name,Phone From Account Where Phone != null]){
            accMap.put(acc.Id,acc);
        }
        if(!accMap.isEmpty()){
            for(Contact con : newConList){
                if(accMap.containsKey(con.AccountId)){
                    if(con.Phone != null && con.Phone != accMap.get(con.AccountId).Phone){
                        con.OtherPhone = accMap.get(con.AccountId).Phone;
                    }
                }
            }
        }
    }
    
    //**Task 9:- Prevent Duplication of Contact Record Based on Email and Phone and,then Show Custom Error Message....
    public static void preventduplicateofEmailAndPhone(List<Contact> newConList, Map<Id, Contact> oldConMap) {
        
        Map<String,Contact> conEmailMap = new Map<String,Contact>();
        Map<String,Contact> conPhoneMap = new Map<String,Contact>();
        
        for(Contact newCon : newConList){
            //For Update Operations.....
            if(oldConMap.containsKey(newCon.Id)){
                if(newCon.Email != oldConMap.get(newCon.Id).Email){
                    conEmailMap.put(newCon.Email, newCon);
                }
                if(newCon.Phone != oldConMap.get(newCon.Id).Phone){
                    conPhoneMap.put(newCon.Phone, newCon);
                }
            }
            //For Insert Operations......
            else{
                conEmailMap.put(newCon.Email,newCon);
                conPhoneMap.put(newCon.Phone,newCon);
            }
        }
        //To Store Seperate Message For Both Email AND Phone.....
        String errorMessage = '';
        for(Contact ct : [Select Id,Email,Phone From Contact Where Email IN : conEmailMap.keySet() OR Phone IN : conPhoneMap.keySet()]){
            if(ct.Email != null){
                if(conEmailMap.get(ct.Email) != null){
                    errorMessage = 'Email';
                } 
            }
            if(ct.Phone != null){
                if(conPhoneMap.get(ct.Phone) != null){
                    errorMessage = errorMessage+(errorMessage != '' ? 'and Phone ' : 'Phone');
                }
            }
        }
        for(Contact newCon : newConList){
            if(errorMessage != ''){
                newCon.AddError('Your Contact '+ errorMessage + 'already exists in the system.');
            }
        }
    }
    //Task 5:When Account related Contact have unique Email, then before creating another Contact On Same Account with same email user should get an error.
    //while another Account related Contacts Can have that unique Email....
    public static void uniqueEmailForAccount(List<Contact> newConList) {
        Set<Id> accIdSet = new Set<Id>();
        for(Contact ct : newConList) {
            if(ct.AccountId != null) {
                accIdSet.add(ct.AccountId);
            }
        }
        //Map to Store AccountIds vs Related Contacts Email......
        Map<Id, Set<String>> accMap = new Map<Id, Set<String>>();
        for(Contact con : [Select Id,Email From Contact WHERE AccountId IN : accIdSet]){
            if(accMap.containsKey(con.AccountId)){
                accMap.get(con.AccountId).add(con.email);
            }
            else{
                Set<String> conEmailSet = new Set<String>();
                conEmailSet.add(con.Email);
                accMap.put(con.AccountId, conEmailSet);
            }
        }
        //Check for unique emails in their respective Accounts
        for(Contact c : newConList){
            if(accMap.get(c.AccountId).contains(c.Email)){
                c.addError('Email already exists for another Contact in the this Account.');
            }
        }
    }
    //**Task 5:-Update Account Phone With Related Contact Phone, When isVip Checkbox on Account is checked.Update contact phone to Account Phone....
    public static void updateAccountPhone(List<Contact> newList, Map<Id,Contact> oldConMap){
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        for(Contact con : newList){
            if(con.AccountId != null && con.phone != null){
                //Null Check for both insert and update operations....
                if(con.isVip__c == true && oldConMap.get(con.Id).isVip__c == false){ 
                    conMap.put(con.AccountId,con);
                }
            }
        }
        List<Account> accListToupdate = new List<Account>();
        for(Account acc : [Select Id,Phone From Account Where Id IN : conMap.keySet()]){
            if(conMap.containsKey(acc.Id)){
                acc.Phone = conMap.get(acc.Id).phone;
                accListToUpdate.add(acc);
            }
        } 
        if(!accListToUpdate.isEmpty()){
            update accListToUpdate;
        }
    }
    //Task 6:-
    public static void updateVipContact(list<contact> newConList, map<id,contact> newConMap){
        set<id> accIds = new set<id>();
        list<Account> accList = new list<Account>();
        for(contact c:newConList){
            if(c.isVip__c){
                accIds.add(c.AccountId);
            }
            if(c.isVip__c && c.Phone != null){
                Account ac = new Account();
                ac.id = c.AccountId;
                ac.phone = c.phone;
                accList.add(ac);
            }
        }
        List<Contact> conList = new List<Contact>();
        for(Contact con :  [SELECT Id, isVip__c FROM Contact WHERE accountId IN : accList AND isVip__c = true AND Id NOT IN : newConMap.keySet()]){
            con.isVip__c = false;
            conList.add(con);
        }
        update conList;
        try{
            update accList;
        } catch(exception ex){
            system.debug(ex.getMessage());
        }          
    }

    //**Task 24:-Populate Opportunities__c (Lookup Field) On Contact Object with First Created Opportunity of Related Account...
    public static void updateOpportunityLookUpField(List<Contact> conList) {
        Set<Id> accIdSet = new Set<Id>();
        for(Contact con : conList) {
            accIdSet.add(con.AccountId);
        }
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        for(Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN : accIdSet ORDER BY CreatedDate ASC]) {
            oppMap.put(opp.AccountId, opp);  
        }  
        for(Contact con : conList) {
            if(oppMap.containsKey(con.AccountId)) {
                con.Opportunities__c = oppMap.get(con.AccountId).Id;
            }
        }
    }
    //Scenario 17:- Create the field Called ‘Contact Relationship’ checkbox on the contact object and create
    //the object called “Contact Relationship” which is related list to the contact.(Lookup Relationship)..
    
    public static void createContactRelationship(List<Contact> newList){
        List<Contact_Relationship__c> crRelationshipList = new List<Contact_Relationship__c>();
        for(contact con : newList){
            if(con.Contact_Relationship__c == true){
                Contact_Relationship__c cr = new Contact_Relationship__c();
                cr.Contact__c = con.Id;
                crRelationshipList.add(cr);
            } 
        }
        if(crRelationshipList.size()>0){
            insert crRelationshipList;
        }
    }   
    
    //Task 3:-Show an Error if there are already two contacts present on Account and user tries to insert one more contact to it user should get error...
    public static void limitNoOfContacts(List<Contact> newConList){
        Set<Id> accIdSet = new Set<Id>();
       Map<Id,Integer> contactCountMap = new Map<Id,Integer>();
        
        for(Contact con : newConList){
            if(con.AccountId != null){
                accIdset.add(con.AccountId);
            }
        }
        //Use Aggregate Query to get the count of contact associated with account w.r.t Id=>list.size();....
        List<AggregateResult>aggrList = [Select AccountId accIds, Count(Id) conCount From Contact WHERE AccountId IN : accIdSet Group By AccountId];
        if(!aggrList.isEmpty()){
            for(AggregateResult aggr : aggrList){
                contactCountMap.put((Id)aggr.get('accIds'), (Integer)aggr.get('conCount'));
            }
            if(!newConList.isEmpty()){
                for(Contact c : newConList){
                    if(c.AccountId != null && contactCountMap.get(c.AccountId) >= 2){
                        c.addError('You cannot Insert More Than 2 Contact as there are already 2 contacts available');
                    }
                }
            }
        }    
    }
    
    //**Task 4:-Enforce Single Primary Contact on Account while creating contact on account if primary_contact__c == true then, 
    //while creating another contact should not be set as primary_contact__c,both while insert,update and also reparenting contact to other account Records...
    
    public static void enforcePrimaryContactOnAccount(List<Contact> conList, Map<Id,Contact> oldConMap){ 
        Set<Id> accIdSet = new Set<Id>();
        for(Contact con : conList){
            // Null Check for both insert or  update operations....
            if(con.AccountId != null  || con.AccountId != oldConMap.get(con.Id).AccountId){
                accIdSet.add(con.AccountId);
            }
        }
        if(!accIdSet.isEmpty()){
            //Use Map to Store AccountId AND Contact List.size()).....
            Map<Id,List<Contact>> conMap = new Map<Id,List<Contact>>(); 
            List<Contact> exconList = [Select Id,AccountId,Primary_Contact__c From Contact Where AccountId IN : accIdSet AND Primary_Contact__c = true];
            for(Contact c : exConList){
                conMap.put(c.AccountId, exConList);
            }
            for(Contact erCon : conList){
                if(erCon.Primary_Contact__c == true && conMap.containsKey(erCon.AccountId) && conMap.get(erCon.AccountId).size() > 0){
                    erCon.AddError('This Account Cannot Have More Than one Primary Contact');
                }
            }
        }
    }
    //***Task 8: Scenario as above when the previous primary_contact__c == true, then we are inserting new contact with primary_Contact__c = true
    //make that previous Contact primary_contact__c = false, also if there is no Contact with primary_Contact_c == true on related Account,
    //then make that first created or Modified contact as primary_Contact__c.....
    
    public static void validatePrimaryContact(List<Contact> newConList){
        Set<Id> accIds = new Set<Id>();
        for(Contact c : newConList){
            accIds.add(c.AccountId);
        }
        //use Map to store Account(ID) w.r.t List<Contact>...... 
        Map<Id,List<Contact>> accConMap = new Map<Id,List<Contact>>();
        List<Account> accList = [Select Id,(Select Id From Contacts ORDER BY CreatedDate ASC) From Account Where Id IN : accIds];
        for(Account ac : accList){
            accConMap.put(ac.Id, ac.contacts);
        }
        Set<Id> accSet = new Set<Id>();
        List<Contact> conListToUpdate = new List<Contact>();
        for(Contact c : newConList){
            if(c.Primary_Contact__c == true){
                for(Contact con : accConMap.get(c.AccountId)){
                    if(con.Id != c.Id){
                        con.Primary_Contact__c = false;
                        conListToUpdate.add(con);
                        accSet.add(con.AccountId);
                    }
                }
            }
        }
        // To Mark the First Createddate Contact as Primary Contact....
        for(Id ids : accConMap.keySet()){
            if(!accSet.contains(ids)){
                Contact con = accConMap.get(ids)[0];
                con.Primary_Contact__c = true;
                conListToUpdate.add(con);
            }
        }
        update conListToUpdate;  
    }
    //***Task 7:-In Account and Contact there is a picklist field region named america,asia,europe and also total amount based on region is present in account
    //so when the contact is inserted,updated with same region name and amount in related account the total amount field on Account should get updated...
    
    public static void updateAccountTotalAmount(List<Contact> newConList, Map<Id,Contact> oldConMap){
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        List<Account> accListToUpdate = new List<Account>(); 
        
        if(!newConList.isEmpty()){
            for(Contact con : newConList){
                if(oldConMap != null){
                    //For Insert and Update Operations...
                    if(con.AccountId != oldConMap.get(con.Id).AccountId){
                        conMap.put(con.AccountId,con);
                        conMap.put(oldConMap.get(con.Id).AccountId,con);
                    }
                    else if(con.Region__c != oldConMap.get(con.Id).Region__c){
                        conMap.put(con.AccountId,con);
                    }
                    else{
                        conMap.put(con.AccountId,con);
                    }
                }
            }
        }
        if(!conMap.isEmpty()){        
            for(Account ac :  [SELECT Id, Total_Amount__c, Region__c FROM Account WHERE Id IN : conMap.keySet()]){
                if(ac.Region__c != null && ac.Region__c == conMap.get(ac.id).Region__c){
                    Decimal totalAmount = 0;
                    for(Contact c : conMap.values()){
                        //System.debug('--2--'+conMap.values());
                        totalAmount = totalAmount + c.Amount__c;
                    }
                    ac.Total_Amount__c = totalAmount; 
                    accListToUpdate.add(ac);
                }
            }
            if(!accListToUpdate.isEmpty()){
                update accListToUpdate;
            }   
        }
    }
   
    //Task 13:- Prevent Deletion of Account Related Contact, if Associated With  parent Account..  
    public static void preventDeletionofContacts(List<Contact> conList){
        Set<Id> accIds = new Set<Id>();
        for(Contact con : conList){
            if(con.AccountId != null)
                accIds.add(con.AccountId);
        }
        List<Account> accList = [Select Id From Account Where Id IN : accIds];
        if(!accList.isEmpty()){
            for(Contact con : conList){
                con.AddError('Contact Associated with Account cannot be deleted');
            }
        }
    }
    
    //Scenario 20:-Create a field Called ‘Count of Contacts’ on Account object. When we add the contacts for that Account then
    //count will populate in the field on Account details page.(For Insert,Update,Delete,Undelete).....
    
    public static void rollUpCountofContacts(List<Contact> newConList, Map<Id,Contact> OldConMap){
        
        Set<Id> accidSet = new Set<Id>();
        for(Contact con : newConList){
            //For After Update(When AccountId Is Updated).....
            if(oldConMap != null){
                
                if(con.AccountId != oldConMap.get(con.Id).AccountId)
                {
                    accIdSet.add(oldConMap.get(con.Id).AccountId);
                    accIdSet.add(con.AccountId);
                }
                //Except (AccountId) if Any other Field is Updated...
                else
                {
                    accIdSet.add(con.AccountId);
                }
            }
            //For After Insert When new Contact is Created....
            else
            {
                accIdSet.add(con.AccountId); 
            }
            
        }
        List<Account> accListToUpdate = new List<Account>();
        for(Account acc : [Select Id,No_of_Contacts__c,Total_Amount__c,(Select Id,Amount__c From Contacts Where Amount__c > 1000) From Account Where Id IN : accIdSet]){
            if(acc.Contacts != null){
                acc.No_of_Contacts__c = acc.contacts.size();
                decimal totalAmount = 0;
                for(Contact c : acc.Contacts){
                    totalAmount = totalAmount + c.Amount__c;
                }
                acc.Total_Amount__c = totalAmount;
            } 
            accListToUpdate.add(acc);
        }
        if(!accListToUpdate.isEmpty()){
            update accListToUpdate;
        }
    }
    
    //2.)RollUp Summary By Using Aggregate Query......
    public static void countofContactUsingAggregate(List<Contact> newConList, Map<Id,Contact> oldConMap ){
        Set<Id> accIds = new Set<Id>();
        Map<Id,Account> accountMapToUpdate = new Map<Id,Account>();
        
        if(!newConList.isEmpty()){
            for(Contact newCon : newConList){
                if(oldConMap != null)
                {
                    if(newCon.AccountId != oldConMap.get(newCon.Id).AccountId)
                    {
                        accIds.add(newCon.AccountId);
                        accIds.add(oldConMap.get(newCon.Id).AccountId);
                    }
                    else
                    {
                        accIds.add(newCon.AccountId);
                    }
                }
                else
                {
                    accIds.add(newCon.AccountId);
                }
            }   
        }
        if(!accIds.isEmpty()){
            List<AggregateResult> aggrList = [Select Count(Id) countOfContact, AccountId accId From Contact Where AccountId IN : accIds Group by AccountId];
            for(AggregateResult aggr  : aggrList){
                Account acc = new Account();
                acc.Id = (Id)aggr.get('accId');
                acc.No_of_Contacts__c = (Decimal)aggr.get('countOfContact');
                accountMapToUpdate.put(acc.Id,acc);
            }
        }
        if(!accountMapToUpdate.isEmpty()){
            update accountMapToUpdate.values();
        }
    }
    
    
}