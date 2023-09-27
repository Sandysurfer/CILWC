public class ClientHandler {
    
    public static List<Client__c> getClientsWithAddress(List<Address__c> adList){
        
        Set<Id> clientIds = new Set<Id>();
        for(Address__c a : adList){
            clientIds.add(a.Client__c);
        } 
        List<Client__c>  clList = [Select Id,Name From Client__c where Id IN : clientIds];
        return clList;
        
        /*---Execute Anonymous----
List<Address__c> adList = [Select Id,Name,Client__c From Address__c Limit 5];
List<Client__c> clientList = ClientHandler.getClientsWithAddress(adList);
System.debug(clientList);
*/
    }
    //Scenario 6:- Whenever Client record is updated, before updating the record create new record
    // in Contact object with old values of client record....
    public static void copyDataToContact(List<Client__c> oldClientList){
        List<Contact> conList = new List<Contact>();
        
        for(Client__c cl : oldClientList){
            Contact con = new Contact();
            if(cl.First_Name__c != null){
                con.FirstName = cl.First_Name__c;
            }
            con.LastName = cl.Last_Name__c;
            conList.add(con);
        }
        insert conList;
    }
    //Task 3: Check if client exist with same name, if there dont create contact and if not then create contact with client Name....
    public static void createContactIfClientNotExists(List<Client__c> newClientList) {
        List<Contact> conList = new List<Contact>();
        Map<Id,Client__c> existingClient = new Map<Id,Client__c>();
        
        for(Client__c exClient : [SELECT Id, Name FROM Client__c]) {
            existingClient.put(exClient.Id,exClient);
        }
        
        for(Client__c newCl : newClientList){
            if(existingClient != null && existingClient.containskey(newCl.Id)){
                if(newCl.Name != existingClient.get(newCl.Id).Name){
                    Contact con = new Contact();
                    con.LastName = newCl.Name;
                    con.Email = newCl.Email_Id__c;
                    conList.add(con);
                }
                else{
                    newCl.addError('Client Already Exists');
                }
            }
        }
        if(!conList.isEmpty()) {
            insert conList;
        }
    }
    
}