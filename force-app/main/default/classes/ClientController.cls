public class ClientController {
    @AuraEnabled
    public static List<Client__c> createClientRecords(String clName, String clPhone, String clEmail){
        List<Client__c> clientList = new List<Client__c>();
        if(clientList!= null){
            Client__c clRec = new Client__c();
            clRec.Last_Name__c = clName;
            clRec.Phone__c = clPhone;
            clRec.Email_Id__c = clEmail;
            clientList.add(clRec); 
        }
        if(!clientList.isEmpty()){
            System.debug('ClientList--->'+clientList);
            insert clientList;
            return clientList;
        }
        return null;
        
    }
    
    @AuraEnabled
    public static String saveClientRecords(String clName, String clPhone, String clEmail,String clStatus,String recordId){
        
        if(String.isBlank(recordId)){
            Client__c clRec = new Client__c();
            clRec.Last_Name__c = clName;
            clRec.Phone__c = clPhone;
            clRec.Email_Id__c = clEmail;
            clRec.Status__c = clStatus;
            
            if(clRec != null){
                System.debug('ClientRecord--->'+clRec);
                insert clRec;   //insert new client records..
            }
            return clRec.Id;   
        }
        else{
            Client__c clRec = new Client__c();
            clRec.Id = recordId;   //using recordId of inserted Client update client records...
            clRec.Last_Name__c = clName;
            clRec.Phone__c = clPhone;
            clRec.Email_Id__c = clEmail;
            clRec.Status__c = clStatus; 
            if(clRec != null){
                System.debug('ClientRecord--->'+clRec);
                update clRec; 
                //delete clRec;
            }
            return clRec.Id;   
            
        }
    }
}