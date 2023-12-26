public class InnerWrapperClassDemo {
    
   public class InnerWrapperClass{
        integer num1;
        integer num2;
    }
    
    public static InnerWrapperClass wrapperMethod(){
        Integer num = 5;
        Integer num2 = 6;
        InnerWrapperClass wrapper = new InnerWrapperClass();
        wrapper.num1 = num;
        wrapper.num2 = num2;
        System.debug('--1--'+wrapper);
        return wrapper;
    }
}
/*InnerWrapperClassDemo.InnerWrapperClass handleWrapper = new InnerWrapperClassDemo.InnerWrapperClass();
handleWrapper = InnerWrapperClassDemo.wrapperMethod();

System.debug('---1---'+handleWrapper);
System.debug('---2---'+handleWrapper.num1);
System.debug('---3---'+handleWrapper.num2);


*/