public class MathBasics {
    
    public MathBasics(){
        System.debug('First Constructor is Calling');
    }
    
    // Calling Multiple Method in Class.....
    public void addFunction(){
        integer num1 = 100;
        integer num2 = 200;
        integer sum = num1 + num2;
        System.debug('Addition of Both Numbers is '+sum);
    }
    
    public void subFunction(){
        integer num1 = 500;
        integer num2 = 200;
        integer sum = num1 - num2;
        System.debug('Substraction of Both Numbers is '+sum);
    }
    
    public void mulFunction(){
        integer num1 = 100;
        integer num2 = 100;
        integer sum = num1 * num2;
        System.debug('Multiplication of Both Numbers is '+sum);
    }
    
    //Conditional Statements For Performing Mathematical Operation...........
    
    //With Return Value....
    public integer mathematicalOpr(Integer num1,Integer num2, String str){
        integer result = 0;
        if(str == 'sum'){
            result = num1 + num2;
        }        
        if(str == 'sub'){
            result = num1 - num2;
        }
        if(str == 'mul'){
            result = num1 * num2;
        }
        return result;
        
    }
    //Without Return Value.....
    public void mathematicalOperation(Integer num1,Integer num2, String str){
        
        integer result = 0;
        if(str == 'Sum'){
            result = num1 + num2;
        }
        if(str == 'sub'){
            result = num1 - num2;
        }
        if(str == 'mul'){
            result = num1 * num2;
        }
        System.debug('Result of Mathematical Operation '+result);
    }
    
    public void checkConditions(Integer num){
        
        if(num == 1){
            System.debug('---True---');
        }else if(num == 2){
            System.debug('---False---');            
        }else{
            System.debug('----');
        }
    }
    
}