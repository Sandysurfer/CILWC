/*
*********************************************************
Apex Class Name    : AccountController
Created Date       : Nov 16, 2023
@description       : This class is used for getting and creating accounts....
@author            : Sandeep Yadav
Modification Log:
Ver   Date         Author                               Modification
1.0   04-01-2021   Amit Chaudhary                      Initial Version
2.0   16-01-2023   Sandeep Yadav                       Added New Method getAccounts()
*********************************************************
*/
public with sharing class AccountController {
    
    /*
    *********************************************************
    @Method Name    : getAccounts
    @author         : Sandeep Yadav
    @description    : method to fetch all account for the name
    @param          : String
    @param          : Integer
    @return         : void
    ********************************************************
    */

    public static void getAccounts(String accountName){
        List<Account> accountList = [SELECT Id,Name
                                     FROM Account
                                     WHERE Name =: accountName
                                     WITH SECURITY_ENFORCED];
    }
    
    /*
    *********************************************************
    @Method Name    : createContact
    @author         : Sandeep Yadav
    @description    : method to create Contact
    @param          : String
    @return         : void
    ********************************************************
    */
    
    public static void createContact(String lastName){
        try{
            Contact con = new Contact();
            con.lastName = lastName;
            if(Schema.sObjectType.Contact.isCreateable()){
                Database.insert(con);
            }
        }
        catch(Exception exp){
            
        }
    }
}