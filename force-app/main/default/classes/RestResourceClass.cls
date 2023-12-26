@RestResource(urlMapping='/AccountMgmt/*')  //Inbound Intergration for RestService Resource Api
global class RestResourceClass {
    
    //@httpget
    global static List<Account> getTopAccounts(){
        List<Account> accList = [Select Id,Name,Industry,Rating,AnnualRevenue From Account Where AnnualRevenue != null];
        return accList;
    }
    
    @httpget
    global static AccountWrapper returnAccount(){
        //Passing Parameters to Accept the values from urlMapping...
        Map<String,String> params = RestContext.request.params;
        Set<Id> accIdSet = new Set<Id>();
        String accIndustry = params.get('industry');
        List<Account> accList = [Select Id,Name,Industry,Rating,AnnualRevenue From Account Where AnnualRevenue != null And Industry =: accIndustry
                                 order by AnnualRevenue desc Limit 10];
        for(Account acc : accList){
            accIdSet.add(acc.Id);
        }
        
        List<Contact> conList = [Select Id, FirstName, LastName, Email From Contact Where AccountId IN : accIdSet];
        List<Case> caseList = [Select Id, Priority, Subject From Case Where AccountId IN : accIdSet];
        
        AccountWrapper accWrapper = new AccountWrapper();
        accWrapper.accList = accList;
        accWrapper.conList = conList;
        accWrapper.caseList = caseList;
        return accWrapper;
    }
    
    //Wrapper Class to get Account Related Contact and Cases..
    global class AccountWrapper{
        global List<Account> accList;
        global List<Contact> conList;
        global List<Case> caseList;
    }
    
    // @httpPost
    global static String createAccount(String accName, String accRating, String accIndustry){
        Account acc = new Account();
        acc.Name = accName;
        acc.Industry = accIndustry;
        acc.Rating = accIndustry;
        try{
            insert acc;
            return 'Account Created Successfully';
        }
        catch(exception ex){
            return ex.getMessage();
        }
    }
    
    //Create Account and related Contact by Passing ComplexDatatype(WrapperClasses) by Passing Paramaters...
    @httpPost
    global static String createAccountAndContact(AccountInformation information){
        Account accRecord = information.accountRecord;
        Contact conRecord = information.contactRecord;
        try{
            insert accRecord;
            conRecord.accountId = accRecord.Id;
            insert conRecord;
            return 'Account and Contact Created Successfully';
        }
        catch(exception ex){
            return ex.getMessage();
        }
    }
    //Wrapper Class to Create Account and Related Contacts..
    global class AccountInformation{
        global Account accountRecord{get;set;}
        global Contact contactRecord{get;set;}
    }
    
    
    @httpDelete
    global static string deleteAccount(){
        //Passing Parameters to Accept the values from urlMapping...
        Map<String,String> params = RestContext.request.params;
        String accountId = params.get('accid');
        List<Account> accList = [Select Id From Account Where Id = :accountId];
        if(!accList.isEmpty()){
            try{
                delete accList;
                return 'Account Record Deleted Successfully';
            }catch(exception ex){
                return ex.getMessage();
            }
        }
        else{
            return 'Account Record Not Found';
        }
        
    }
    
}