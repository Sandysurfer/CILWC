public class CustomUserLoginController {
    
    @AuraEnabled
    public static Boolean authenticateCustomUser(String usernameInput, String passwordInput) {
        List<Custom_User__c> userList = [SELECT Id, Username__c, Password__c FROM Custom_User__c 
                                         WHERE Username__c = :usernameInput AND Password__c = :passwordInput LIMIT 1];
        
        if (!userList.isEmpty()) {
            System.debug('login Success');
            return true; // user is authenticated.
        }
        else{
            System.debug('login Error');
            return false; // Authentication failed.
        }
    }
    
    @AuraEnabled
    public static String createCustomUser(String username, String password, String confirmPassword) {
        // Check if password and confirm password match
        if (password != null && password.equals(confirmPassword)) {
            system.debug('PassWord Equals');
            // Check if the username already exists
            List<Custom_User__c> userList = [SELECT Id,Username__c FROM Custom_User__c WHERE Username__c = :username LIMIT 1];
            if (!userList.isEmpty()) {
                System.debug('UserName Already Exists');
                return 'Username already exists';
            }
            //If this is new Username and confirmpassword and password are same then,
            // Create the new user record
            System.debug('New User Registration');
            Custom_User__c custom = new Custom_User__c();
            custom.Username__c = username;
            custom.Password__c = password;
            
            try {
                insert custom;
                System.debug('Custom User Created-->'+custom.Id);
                return 'User created successfully';
            } 
            catch (Exception ex) {
                return 'Error creating user: ' + ex.getMessage();
            }
        } 
        else
        {   System.debug('Password Not Equals');
         return 'Password and Confirm Password do not match';
        }
    }
}