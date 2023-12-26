public class ProcessAccountNameBatch implements Database.Batchable <sObject>,Database.Stateful{
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id,Name From Account');
    }
    
    public void execute(Database.BatchableContext bc,List<Account> accList){
        for(Account ac : accList){
            // ac.Name = 'VIP '+ac.Name;
            // To Replace append Name with blank values.....
            ac.Name = ac.Name.replace('VIP','');
        }
        update accList;
    }
    
    public void finish(Database.BatchableContext bc){
     //Post Actions...
    //Send Email Message.....
    List<Messaging.SingleEmailMessage> EmailList = new List<Messaging.SingleEmailMessage>();
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       List<String> toList = new List<String>{'sandeepyadavdv10@gmail.com'};
       mail.setToAddresses(toList);
       mail.setSubject('Report of Process Account Batch');
       mail.setplaintextbody('Records Successfully Updated');
       EmailList.add(mail);
       Messaging.sendEmail(EmailList);
    }

}