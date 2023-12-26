public class AccountWrapperClass {
    
    //Wrapper Class...
    public class AccountWrapper{
         Account accRecord;       // Type - sObject(Account)
         List<Contact> conList;  // Type - List(Contact)
         integer conSize;       // Type - integer(size)
    }
    
    public static List<AccountWrapper> getAccountWithContacts(){
        List<AccountWrapper> wrapperList = new List<AccountWrapper>();
        List<Account> accList = [Select Id,Name,(Select Id,FirstName,LastName From Contacts) From Account Limit 1];
        
        for(Account acc : accList){
            AccountWrapper awr = new AccountWrapper();
            awr.accRecord = acc;
            awr.conList = acc.Contacts;
            awr.conSize = acc.Contacts.size();
            wrapperList.add(awr);
        }      
        return wrapperList;
    }  
}
 /*   ----Execute----
      List<AccountWrapperClass.AccountWrapper> accWrapList = AccountWrapperClass.getAccountWithContacts();
      System.debug(accWrapList);
      
      for(AccountWrapperClass.AccountWrapper acc :  accWrapList){
         System.debug('--1--'+acc.accRecord);
         System.debug('--2--'+acc.conList);
         System.debug('--3--'+acc.conSize);
       }
 */