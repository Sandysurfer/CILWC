//Calling Apex class in Lightning Flows.....
public class FlowGetAccounts {
    
    public class AccountsWrapper{
        @invocablevariable public List<Account> accList;
    }
    
    @invocablemethod(label = 'Get Accounts From Salesforce Database')
    public static List<AccountsWrapper> getAccList(){
        List<Account> accountList = [Select Id,Name From Account];
        List<AccountsWrapper> outputWrapperList = new List<AccountsWrapper>();
        AccountsWrapper output = new AccountsWrapper();
        output.accList = accountList;
        outputWrapperList.add(output);
        return outputWrapperList;
    }
    
}