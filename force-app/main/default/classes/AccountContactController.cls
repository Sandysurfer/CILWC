public class AccountContactController{
    //Inner Wrapper Class...
    public class AccountContactWrapper{
        @AuraEnabled
        public Account accRecord{get;set;}
        @AuraEnabled
        public string accName{get;set;}
        @AuraEnabled
        public List<Contact> contactList{get;set;}
        @AuraEnabled
        public Integer contactCount{get;set;}
    }
    
    @AuraEnabled(cacheable=true)
    public static List<AccountContactWrapper> getAllAccountWithContacts(){
        List<AccountContactWrapper> accWrapperList = new List<AccountContactWrapper>();
        List<Account> accList = [SELECT Id, Name,(SELECT Id, Name From Contacts) FROM Account LIMIT 5];
        
        if(!accList.isEmpty()){
            for(Account acc : accList){
                AccountContactWrapper accWrapper = new AccountContactWrapper();
                accWrapper.accRecord = acc;
                accWrapper.accName = acc.Name;
                accWrapper.contactList = acc.Contacts;
                accWrapper.contactCount = acc.Contacts.size();
                accWrapperList.add(accWrapper);
            }
            System.debug('Wrapper Data--->'+accWrapperList);
        }
        return accWrapperList;
    }
}