public with sharing class AccountContactWrapperDemo {
    
    public class AccountContactWrapperClass{
        @AuraEnabled
        public Account acc;
        @AuraEnabled
        public Integer totalContacts;
        @AuraEnabled
        public String billingAddress;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String AccountName;
        @AuraEnabled
        public String AccountLink;
        
        public AccountContactWrapperClass(Account acc, Integer totalContacts){
            this.acc = acc;
            this.totalContacts = totalContacts;
            this.AccountLink = '/' + acc.Id;
            this.type = acc.type;
            this.AccountName = acc.Name;
            this.billingAddress = acc.BillingStreet + ',' + acc.BillingCity + ',' + acc.BillingCountry ;
        }
        
    }
    @AuraEnabled(cacheable=true)
    public static List<AccountContactWrapperClass> fetchAccountContactDetails(){
        List<AccountContactWrapperClass> lstAccountContWrapper = new List<AccountContactWrapperClass>();
        for(Account acc : [select id,name,type,BillingCity,BillingCountry,BillingStreet, (select id from Contacts) from 
                           Account where Name !=null LIMIT 10])
        {
            
            lstAccountContWrapper.add(new AccountContactWrapperClass(acc,acc.Contacts.size()));
        }
        return lstAccountContWrapper;
    }
      
}