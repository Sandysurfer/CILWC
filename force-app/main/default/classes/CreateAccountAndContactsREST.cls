@RestResource(urlMapping='/createAccountAndContacts')
global with sharing class CreateAccountAndContactsREST {
    
    @HttpPost
    global static String createAccountAndContacts(String requestBody) {
        //Rest Context objects for request and response
        RestRequest req = RestContext.request;
        String returnReq = req.requestBody.toString();
        System.debug('Request Content' + returnReq);
        
        try {
            // Parse the JSON request body
            Map<String, Object> requestMap = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
            System.debug('Request Body'+requestMap);
            
            // Extract Account data from the JSON
            Map<String, Object> accountData = (Map<String, Object>) requestMap.get('Account');
            System.debug('Account--->'+accountData);
                        
            // Create the Account
            Account newAccount = new Account(
                Name = (String) accountData.get('Name'),
                AccountSource = (String) accountData.get('AccountSource'),
                Industry = (String) accountData.get('Industry'),
                Phone = (String) accountData.get('Phone'),
                Website = (String) accountData.get('Website'),
                Type = (String) accountData.get('Type')
            );
            insert newAccount;
            
            // Extract Related Contacts
            List<Object> contactList = (List<Object>) requestMap.get('Contacts');
            System.debug('Contacts---->'+contactList);
            List<Contact> contactsToInsert = new List<Contact>();
            
            for (Object contactObj : contactList) {
                if (contactObj instanceof Map<String, Object>) {
                    Map<String, Object> contactData = (Map<String, Object>) contactObj;
                    String contactFirstName = (String) contactData.get('FirstName');
                    String contactLastName = (String) contactData.get('LastName');
                    String email = (String) contactData.get('Email');
                    String mobilePhone = (String) contactData.get('MobilePhone');
                    String genderIdentity = (String) contactData.get('GenderIdentity');
                    
                    Contact newContact = new Contact(
                        FirstName = contactFirstName,
                        LastName = contactLastName,
                        Email = email,
                        MobilePhone = mobilePhone,
                        GenderIdentity = genderIdentity,
                        AccountId = newAccount.Id
                    );
                    contactsToInsert.add(newContact);
                }
            }
            
            // Insert the Contacts
            insert contactsToInsert;
            
            // Return the AccountId in the response
            return newAccount.Id;
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}