//Wrapper Class is an Object created in Apex Which contains multiple datatypes like collections,sObject,primitive data types...
 //The data lives in code during transaction and does not contain database storage eg of (Abstarction) dataType..
 
public class WrapperClassExample {
    
    public static wrapperClass wrapperMethod(){
        integer num1 = 5;
        integer num2 = 6;
        
        wrapperClass wrapper = new wrapperClass();
        wrapper.num1 = num1;
        wrapper.num2 = num2;
        System.debug('Debug-->'+wrapper);
        return wrapper;
    }
}