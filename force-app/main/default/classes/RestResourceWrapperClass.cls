@RestResource(urlMapping='/ci8RestResourceWrapper/*')
global class RestResourceWrapperClass {
    
    global class AccountContactWrapperClass{
        @AuraEnabled
        global Account acc;
        @AuraEnabled
        global Integer totalContacts;
        @AuraEnabled
        global String billingAddress;
        @AuraEnabled
        global String type;
        @AuraEnabled
        global String AccountName;
        @AuraEnabled
        global String AccountLink;
        
        global AccountContactWrapperClass(Account acc, Integer totalContacts){
            this.acc = acc;
            this.totalContacts = totalContacts;
            this.AccountLink = '/' + acc.Id;
            this.type = acc.type;
            this.AccountName = acc.Name;
            this.billingAddress = acc.BillingStreet + ',' + acc.BillingCity + ',' + acc.BillingCountry ;
        }
    }
    
    @httpget
    global static List<AccountContactWrapperClass> fetchAccountContactDetails(){
        List<AccountContactWrapperClass> lstAccountContWrapper = new List<AccountContactWrapperClass>();
        for(Account acc : [select id,name,type,BillingCity,BillingCountry,BillingStreet, (select id from Contacts) from 
                           Account where Name !=null LIMIT 10])
        {
            
            lstAccountContWrapper.add(new AccountContactWrapperClass(acc,acc.Contacts.size()));
        }
        return lstAccountContWrapper;
    }
    
}

/*
public class JSON2Apex {

	public class Acc {
		public Attributes attributes;
		public String Id;
		public String Name;
		public String Type;
		public String BillingCity;
		public String BillingStreet;
		public Contacts Contacts;
	}

	public String type;
	public Integer totalContacts;
	public String billingAddress;
	public String AccountName;
	public String AccountLink;
	public Acc acc;

	public class Contacts {
		public Integer totalSize;
		public Boolean done;
		public List<Records> records;
	}

	public class Attributes {
		public String type;
		public String url;
	}

	public class Acc_Y {
		public Attributes attributes;
		public String Id;
		public String Name;
		public String Type;
		public String BillingCity;
		public String BillingCountry;
		public String BillingStreet;
		public Contacts Contacts;
	}

	public class Records {
		public Attributes attributes;
		public String AccountId;
		public String Id;
	}

	public class Acc_Z {
		public Attributes attributes;
		public String Id;
		public String Name;
		public String Type;
		public String BillingStreet;
		public Contacts Contacts;
	}

	
	public static List<JSON2Apex> parse(String json) {
		return (List<JSON2Apex>) System.JSON.deserialize(json, List<JSON2Apex>.class);
	}
}
*/