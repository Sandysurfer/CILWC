public class DemoMultiClass {
    
    public static void createRecord(String objectName){
        if(objectName == 'Account'){
            Account acc = new Account();
            acc.Name = 'Test Class Account';
            insert acc;
        }
        if(objectName == 'Contact'){
            Contact con = new Contact();
            con.LastName = 'Test Class Contact';
            insert con;
        }  
    }
    
    //Wire Class to import in Lwc..
    public static List<Account> getAccountDetails(String accountId){
        List<Account> accList = [Select Id,Name From Account Where Id =: accountId];
        return accList;
        
    }
}