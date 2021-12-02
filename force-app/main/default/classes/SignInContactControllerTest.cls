@isTest
public with sharing class SignInContactControllerTest {
    @testSetup
    static void setup()
    {
        Contact con = new Contact(FirstName='Test',LastName = 'Contact', Email='email@test.com', Password__c='123');
        insert con;
    }
    @isTest static void doEnterSuccessTest(){
        SignInContactController sic = new SignInContactController();
        
        Test.startTest();      
        sic.contactEmail = 'email@test.com';
        sic.contactPassword = '123';
        sic.doEnter();        
        Test.stopTest();
        
        Contact con = [SELECT Id, FirstName, LastName, Email, Password__c FROM Contact];
        System.assertEquals(con.Email, 'email@test.com');  
        System.assertEquals(con.Password__c, '123');  
    }
     @isTest static void doEnterErrorTest(){
        Contact con = [SELECT Id, FirstName, LastName, Email, Password__c FROM Contact];                      
        delete con;
        SignInContactController sic = new SignInContactController();
        
        Test.startTest();        
        sic.doEnter(); 
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
    }
   
    
    @isTest static void addContactTest(){
        SignInContactController sic = new SignInContactController();
        
        Test.startTest();
        sic.addContact();
        Test.stopTest();
    }
    
    @isTest static void restorePaswwordTest(){
        SignInContactController sic = new SignInContactController();
        
        Test.startTest();
        sic.restorePaswword();
        Test.stopTest();
    }
}