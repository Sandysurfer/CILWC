public class FlowClassCI {
    //Calling Apex Class in Flow by Passing Wrapper....
    public class dataWrapper{
        @invocableVariable public List<Account> accList;
        @invocableVariable public Integer count;
    }
    
    @invocableMethod
    public static List<dataWrapper> getFlowData(List<String> name){
        List<dataWrapper>wrapperList = new List<dataWrapper>();   
        dataWrapper wrapper = new dataWrapper();
        
        List<Account> accData = [Select Id,Name,Active__c From Account Where Name = :name[0]];
        System.debug('Account Data'+accData);
        wrapper.accList = accData;
        wrapper.count = accData.size();
        wrapperList.add(wrapper);
        System.debug('Wrapper Content-->'+wrapperList);
        return wrapperList;
    }
    
}