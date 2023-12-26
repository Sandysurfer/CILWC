global class CloseLostOpportunitiesBatchScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        CloseLostOpportunitiesBatch batchJob = new CloseLostOpportunitiesBatch();

        Database.executeBatch(batchJob);
    }
}

    /*
    String jobName = 'CloseLostOpportunitiesBatchJob';
    String cronExpression = '0 0 12 * * ?'; // This represents 12 pm every day
    CloseLostOpportunitiesBatchScheduler scheduler = new CloseLostOpportunitiesBatchScheduler();
    
    // Schedule the new job
    System.schedule(jobName, cronExpression, scheduler);
    */