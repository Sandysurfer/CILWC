public class SchedulableApex implements Schedulable {
    
    public void execute(SchedulableContext sc){
        Client__c cl = new Client__c();
        cl.First_Name__c = 'Schedule';
        cl.Last_Name__c = 'Client';
        insert cl;
    }
}
        /* ---Schedule With Cron Exp And Execute......
     
          SchedulableApex pr = new SchedulableApex();
          String exp = '0 15 8 7 8 ?';
          System.schedule('InsertClient', exp , pr);
      */