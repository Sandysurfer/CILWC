public class MathematicalOperations {
    
    public static List<Integer> getNumbersinSequence(Integer num1, Integer num2){
        List<Integer> intList = new List<Integer>();
        
        Integer i ;
        if(num1 < num2) {
            for(i=num1; i<=num2; i++){
                System.debug('Integer in Forward--> '+i); 
                intList.add(i);
            }
        }
        else{
            for(i=num1; i>=num2; i--){
                System.debug('Integer List in Backwards '+i);
                intList.add(i);
            }
        }
        return intList;
    }
    /*----Execute----
     List<Integer> numList = MathematicalOperations.getNumbersinSequence(1, 5);
     System.debug('Numbers in Sequence '+numList);
   */
    
    static integer addition(List<Integer> numList){
        
        integer result=0;
        for(integer i : numList){
            result = result + i;
            System.debug('Addition is---->'+result);
        }
        return result;
    }
    
    static integer substraction(List<Integer> numList){
        
        integer result=0;
        for(integer i : numList){
            result = result - i;
            System.debug('Addition is---->'+result);
        }
        return result;
    }
    static integer multiplication(List<Integer> numList){
        
        integer result=0;
        for(integer i : numList){
            result = result * i;
            System.debug('Addition is---->'+result);
        }
        return result;
    }
    
    public static Integer operationInput(integer startNum, integer endNum, String operation){
        List<Integer> numList = new List<Integer>();
        for(integer i = startNum; i<= endNum; i++){
            numList.add(i);
        }
        Integer result = 0;
        if(operation == 'Sum'){
            result = addition(numList);
        }
        else if(operation == 'sub'){
            result = substraction(numList);
        }
        else if(operation == 'mul'){
            result = multiplication(numList);
        }
        return result;
    }
    /*---Execute----
    integer intOperation = MathematicalOperations.operationInput(5, 7, 'sum');
    System.debug(intOperation);
   */
    
    public static integer getLengthofStrings(List<String> strList){
        
        Integer count = 0;
        for(String st : strList){
            count = count + st.length();
        }        System.debug('Count of Char---->'+count);
        return count;
        
        /*----Execute---
          List<String> strList = new List<String>{'SANDY'};
          integer strCount = MathematicalOperations.getLengthofStrings(strList);
          System.debug('Count of String '+strCount);
       */
    }
    
    public static Map<String,integer> getcountofStringInMap(List<String> strList){
        
        Map<String,Integer> countMap = new Map<String,Integer>();        
        
        for(String str : strList){
            countMap.put(str, str.length());
            System.debug('Count of string in Map--- >'+countMap);
        }
        return countMap;
    }
    /*---Execute-----
     List<String> strList = new List<String>{'SANDY'};
     Map<String,Integer> myMap = MathematicalOperations.getcountofStringMap(strList);
     System.debug('Count of String '+myMap);
   */
}