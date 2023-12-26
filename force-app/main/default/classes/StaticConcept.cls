public class StaticConcept {
    
    public static integer sum = 1;   //Static Variable in Instance Variable....
    
    public void staticMethod1(){
        
        Integer Num1 = 1;  //Calling through Non Static Context..
        num1 = num1 + 1;
        
        sum =  sum + 1;    //Calling through Static Context
        System.debug('Num1 is '+Num1);
        System.debug('Sum is '+sum);
        
        staticMethod2();  // Accessing Private Method in Class 	Level......
    }
    
    void staticMethod2(){
        System.debug('Sum is '+sum);
    }
}