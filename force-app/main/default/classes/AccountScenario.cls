public class AccountScenario {
    
    public static Map<String,Id> getAccountsInMap(){
        
        Map<String,Id> accountMap = new Map<String,Id>();
        List<Account> accList = [Select Id,Name From Account];
        
        for(Account acc : accList){
            accountMap.put(acc.Name,acc.Id);
        }
        return accountMap;  //returning accountMap in format of (string,Id)......
        
        /*----Execute-----
Map<String,Id> accMap = AccountHandler.getAccounts();
System.debug(accMap);
*/
    }
    
    public static List<Account> getAccountRelatedContacts(List<Contact> conList){
        
        Set<Id> accountIds = new Set<Id>();        //Use to Store Unique Account Ids....
        
        for(Contact con : conList){
            accountIds.add(con.AccountId);      //Adding AccountIds with related Contact lookup Field....
        }
        List<Account> accList = [Select Id,Name From Account Where Id IN : accountIds];
        
        return accList;
    }
    /*-----Execute------
List<Contact> conList = [Select Id,Name,AccountId From Contact Limit 5];
List<Account> accList = AccountHandler.getAccountRelatedContacts(conList);
System.debug('List OF Account '+accList);
*/
    
    public static List<Account> getAccountsRelatedOpportunity(List<Opportunity> oppList){
        
        Set<Id> accountIds = new Set<Id>();  //Use to Store Unique Ids...
        
        for(Opportunity opp : oppList){
            accountIds.add(opp.AccountId);    //Adding AccountIds With related opportunity lookup field
        }
        
        List<Account> accList = [Select Id,Name From Account Where Id IN : accountIds];
        
        return accList;
    }
    /*----Execute----
List<Opportunity> oppList = [Select Id,Name,AccountId From Opportunity Limit 5];
List<Account> acList = AccountHandler.getAccountsWithOpportunity(oppList);
System.debug(acList);
*/
   
    
}