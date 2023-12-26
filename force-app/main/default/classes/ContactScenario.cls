public class ContactScenario {
    
    public List<Contact> getContactList(String FName){
        String FiName =  '%'+FName+'%';
        List<Contact> conList = new List<Contact>();
        conList = [Select Id ,FirstName,LastName From Contact Where FirstName =: FiName];  //Binding Soql with input from Parameters.... 
        conList = [Select Id ,FirstName,LastName From Contact Where FirstName Like : '%'+fName+'%'];  //Using Like to Match Contain Values....
        
        return conList;
        
        /*---Execute---
          	ContactHandler cl = new ContactHandler();
			List<Contact> clList = cl.getContactList('Ro');
			System.debug(clList); 
		*/
    }
    
    //getting List<sObject> as Return Type.......
    public List<Contact> createContact(String fName, String lName){
        
        List<Contact> cList = new List<Contact>();
        for(integer i=0; i<=10; i++){
            Contact con = new Contact();
            con.FirstName = fName;
            con.LastName = lName;
            cList.add(con);
        }
        insert cList;
        
        return cList;   //returning sObject DataType in Bulk....
        
        /*----Execute---
         	ContactHandler crtl = new ContactHandler();
			Contact ct = crtl.createContact('Rishi','Sunak');
			System.debug(ct);
       	*/
    }
    
    public static List<Contact> getContactsRelatedWithAccount(List<Account> accList){
        
        Set<Id> contactIds = new Set<Id>();
        
        for(Account acc : accList){
            contactIds.add(acc.Id);
        }
       List<Contact> conList = [Select Id,Name,AccountId From Contact Where AccountId IN : contactIds];
        return conList;
    }
   /*---Execute----
     List <Account> aList = [Select Id,Name From Account Limit 5];
	 List <Contact> cList = ContactHandler.getContactsWithAccount(aList);
	 System.debug(cList);
   */
    
    public static boolean checkWhetherAccountExists(List<Contact> conList){
        
        boolean isRelatedAccount = false;
        Set<Id> accIds = new Set<Id>();
        
        for(Contact con : conList){
            if(con.AccountId != Null){
                accIds.add(con.AccountId);
            }
        }
        return isRelatedAccount = true;
     
        /*---Execute----
         List<Contact> conList = [Select Id,FirstName,AccountId From Contact Where FirstName = 'Rishi']; //Returns False.
         boolean isAccExt = ContactHandler.checkWhetherAccountExists(conList);
         System.debug('Check for Account '+isAccExt);
        */
    }
    
    public static Map<Id,boolean> getRelatedAccountsWithMap(List<Contact> conList){
        
        Map<Id,boolean> contactMap = new Map<Id,boolean>();
        
        for(Contact con : conList){
            if(con.AccountId != Null){
                contactMap.put(con.Id,true);
            }
            else{
                contactMap.put(con.Id,false);
            }
        }
        return contactMap;
    }
    /*----Execute-----
      List<Contact> conList = [Select Id,Name,AccountId From Contact];
      Map<Id,boolean> conMap = ContactHandler.getRelatedAccountsWithMap(conList);

      for(Id ids : conMap.keySet()){ //Collecting Set of Keys....
      System.debug('Ids----->'+conMap.get(ids); // get value w.r.t Key....
    */
    
  //Demo 2:-By Refrence of Account Id Get List<Contact> Related with Particular Account Using Map.......
    public static void mapScenario (){
        set<id> accountIds = new set<id>();
        list<account> acList = [SELECT id FROM Account];
        for(Account ac: acList){
            accountIds.add(ac.id);
        }
        Map<id,list<contact>> conMap = new Map<id,list<contact>>();
        list<contact> conList = [SELECT id, lastName, accountId FROM Contact WHERE accountId in: accountIds];
        
        for(contact c: conList){
            if(conMap.containsKey(c.accountId)){
                conMap.get(c.accountId).add(c);
                //System.debug('MapContains--->'+conMap);
            }else{
                list<contact> cList = new list<contact>();
                cList.add(c);
                conMap.put(c.accountId,cList);
                //System.debug('MapNotContains-->'+conMap);
            }
            
        }
        system.debug('Key AND Values in conMap \n>'+conMap);
        
    }
}