@RestResource(urlMapping='/ci8RestResource/*')
global class CI8RestApi {
    @httpget
    global static List<Account> getAccountList(){
        return[Select Id,Name,Active__c From Account];
    }
}