@isTest
public class RestorePasswordContactControllerTest {
    @testSetup
    static void setup()
    {
        Contact con = new Contact(FirstName='Test',LastName = 'Contact', Email='email@test.com', Password__c='123');
        insert con;
    }
    
    @isTest static void sendSuccessTest(){
        RestorePasswordContactController rpc = new RestorePasswordContactController();
        
        Test.startTest(); 
       	rpc.contactEmail = 'email@test.com';
       	rpc.send(); 
        Test.stopTest();
        
		System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.INFO));
    }
    
    @isTest static void sendErrorTest(){
        RestorePasswordContactController rpc = new RestorePasswordContactController();
        
        Test.startTest(); 
        rpc.contactEmail = 'emailtest.com';
       	rpc.send(); 
        Test.stopTest();
        
		System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
    }
    
     @isTest static void cancelTest(){
        RestorePasswordContactController rpc = new RestorePasswordContactController();
         
        Test.startTest();       	       
        rpc.cancel();        
        Test.stopTest();         
    }       
}