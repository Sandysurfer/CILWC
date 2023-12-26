@isTest
public class ContactClsTest {	
    @isTest
    public static void createContactPositiveTest(){
        ContactCls cls = new ContactCls();
        contact con = ContactCls.createContactMethod('first','Last');
        system.assertNotEquals(null, con);
    }   
     @isTest
    public static void fetchContactPositiveTest(){
       Contact con = new Contact();
        con.FirstName = 'first';
        con.LastName = 'Last';
        insert con;
        contact cont = ContactCls.createContactMethod('first','Last');
        system.assertNotEquals(null, cont);
    }
}