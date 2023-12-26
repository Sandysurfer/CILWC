public class ProcessAccountBatchSchedulable implements schedulable{
    
    public void execute(schedulableContext sc){
        database.executeBatch(new ProcessAccountNameBatch(),2);
    }
    
    /* ---Schedule With Cron Exp And Execute......
     
          String exp = '0 0 * ? * * *';
          ProcessAccountBatch pr = new ProcessAccountBatch();
          System.schedule('Run Process Account Batch', exp, pr);
    */
   
}