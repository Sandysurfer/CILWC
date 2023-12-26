//Requirement: Pass Input firstName,LastName AND return output Wrapper along With Contact and Account,
//if contact firstname and lastname is present in output wrapper then return contact firstname and lastname along with related account.

public class ContactWrapperClass{
    
    public Static ContactWrapper getContactsRelatedWithAccount(String fName, String lName) {
        
        Contact conObj = [SELECT Id, FirstName, LastName, AccountId, Account.Name FROM Contact WHERE FirstName =: fName AND LastName =: lName LIMIT 1];
        
        Account accObj = [SELECT Id, Name FROM Account WHERE Id =: conObj.AccountId LIMIT 1];
        
        ContactWrapper conWrap = new ContactWrapper(conObj, accObj);
        
        return conWrap;
    }
} 

/*--Execute---

ContactWrapper handleWrapper = ContactWrapperClass.getContactsRelatedWithAccount('Arthur', 'Song');
if(handleWrapper.conObj != null) {
    //Contact With AccountId exists.....
    System.debug('Contact FirstName--->' + handleWrapper.conObj.FirstName);
    System.debug('Contact LastName--->' + handleWrapper.conObj.LastName);
    System.debug('Account Name--->' + handleWrapper.conObj.Account.Name);
   }

*/