@RestResource(urlMapping='/createRecord')
global class AccountManager {
    
    @HttpPost
    global static String createAccount(){
        //Rest Context objects for request and response
        RestRequest req = RestContext.request;
        String returnReq = req.requestBody.toString();
        System.debug('Request Content' + returnReq);
        
        //wrapper for accepting parameters passed in and deserialize parameters into wrapper
        AccountParameters accParams = (AccountParameters)JSON.deserialize(returnReq, AccountParameters.Class);
        System.debug('Deserialized AccountParams' + accParams);
        
        //create Account list and Contact List to store newly created Accounts and Contacts
        List<Account> acctList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        
        //populate values on acctToInsert from deserialized parameters
        Account acc = new Account();
        acc.Name = accParams.Name;
        acc.Description = accParams.Description;
        acc.AccountSource = accParams.AccountSource;
        acc.Description = accParams.Description;
        acc.Industry = accParams.Industry;
        acc.Website = accParams.Website;
        acc.Type = accParams.Type;
        acctList.add(acc);
        
        insert acctList;
        
        //iterate through Contact children to insert Contacts
        if(!accParams.contacts.isEmpty()){
            for(ContactParameters CP : accParams.contacts){
                Contact con = new Contact();
                con.LastName = CP.lastname;
                con.FirstName = CP.firstname;
                con.MobilePhone = CP.MobilePhone;
                con.Email = CP.Email;
                con.GenderIdentity = CP.GenderIdentity;
                con.AccountId = acc.Id;
                conList.add(con);
            }
            insert conList;
        }
        return 'Account and Contacts Record Created Successfully';
    }
    
    global class AccountParameters{
        global String Name;
        global String Description;
        global String AccountSource;
        global String Industry;
        global String Phone;
        global String Website;
        global String Type;
        global List<contactParameters> contacts;
    }
    
    global class ContactParameters{
        global String lastname;
        global String firstname;
        global String Email;
        global String MobilePhone;
        global String GenderIdentity;
    }
}

/*{
    "Name": "SAP Account",
    "AccountSource": "Web",
    "Industry": "Technology",
    "Phone": "123456789",
    "Website": "SAP.com",
    "Type": "Technology Partner",
  
  "Contacts": [
    {
      "FirstName": "John",
      "LastName": "Wick",
      "Email": "johnwick@mail.com",
      "MobilePhone": "9998887776",
      "GenderIdentity": "Male"
    },
    {
      "FirstName": "Mike",
      "LastName": "Taylor",
      "Email": "miketaylor@yahoo.com",
      "MobilePhone": "8887779990",
      "GenderIdentity": "Male"
    }
  ]
}
*/