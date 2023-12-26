public class ContactRelationshipHandler {
    
    //Scenario 18: When we change the owner of the Contact Relationship, then the owner name will be
    //automatically populated in the Contact Relationship name field.
   
    public static void updateOwner(List<Contact_Relationship__c> crList){
        Set<Id> ownerIdSet =  new Set<Id>();
        for(Contact_Relationship__c cr : crList){
            if(cr.OwnerId != null){
                ownerIdSet.add(cr.OwnerId);
            }
        }
        Map<Id,User> userMap = new Map<Id,User>();
        List<User> usrList = [Select Id,Name From User Where Id IN : ownerIdSet];
        for(User usr : usrList){
            userMap.put(usr.Id, usr);
        }
        for(Contact_Relationship__c crl : crList){
            if(crl.OwnerId != null){
                crl.Name = userMap.get(crl.ownerId).Name;
            }
        }
    }
}