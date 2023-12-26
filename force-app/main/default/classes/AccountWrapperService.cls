public class AccountWrapperService{
    
    public class AccountWrapper {
        @auraenabled
        public string Name{get;set;}
        @auraenabled
        public integer NoOfContacts{get;set;}
        @AuraEnabled
        public List<Contact> Contacts { get; set; }
    }
    
    @AuraEnabled
    public static void createAccountContact(AccountWrapper accWrapper) {
        System.debug('Received wrapper--->' + accWrapper);
        
        if (accWrapper != null) {
            Account act = new Account();
            act.Name = accWrapper.Name;
            act.No_of_Contacts__c = accWrapper.NoOfContacts;
            System.debug('Creating Account: ' + act);
            insert act;
            
            if (accWrapper.Contacts != null) {
                for (Contact ct : accWrapper.Contacts) {
                    ct.AccountId = act.Id;
                }    
                System.debug('Inserting Contacts: ' + accWrapper.Contacts);
                insert accWrapper.Contacts;
            }
        }
    }
}
/*Executing Wrapper Class....
 * 
 // Create an instance of the AccountWrapper class
     AccountLightningService.AccountWrapper wrapper = new AccountLightningService.AccountWrapper();

// Populate the properties of the wrapper object
   wrapper.Name = 'ACC';
   wrapper.NoOfContacts = 5;

// Create a list of contacts and add them to the wrapper object
   List<Contact> conlist = new List<Contact>{new Contact(LastName = 'con1'),new Contact(LastName = 'con2')};
   wrapper.Contacts = conlist;

// Call the createAccountContact method with the wrapper object
AccountLightningService.createAccountContact(wrapper);
*/