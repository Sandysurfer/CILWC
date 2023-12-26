public class ContactCls {
    
    public ContactCls(){
        String val = '10';
    }
    public static Contact createContactMethod(string fName, string lName){
        List<Contact> conList = [Select Id From Contact Where firstName =: fName AND lastName =: lName];
            if(conList.size()>0){
                return conList[0];
            }
        try 
        {
         Contact con = new Contact();
            con.FirstName = fName;
            con.LastName = lName;
            insert con;
            return con;
        }
        catch(exception ex){
            return null;
        }
    }
}