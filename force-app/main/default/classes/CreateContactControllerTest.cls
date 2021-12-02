@isTest
public class CreateContactControllerTest {    
    @isTest
    static void saveSuccessTest(){
        Contact contact = new Contact(FirstName='Test',LastName = 'Contact', Email='email@test.com', Password__c='123');
        CreateContactController cc = new CreateContactController();
         
        Test.startTest();                  
        cc.con=contact; 
        cc.save();        
        Test.stopTest();

        Contact c = [SELECT Id, FirstName, LastName, Email, Password__c FROM Contact];  
        System.assertEquals(c.LastName, 'Contact');  
        System.assertEquals(c.Email, 'email@test.com');  
    }
        
    @isTest
    static void saveErrorTest(){
        Contact contact = new Contact(FirstName='Test',LastName = '', Email='email&test.com', Password__c='123');
        CreateContactController cc = new CreateContactController();
         
        Test.startTest();                  
        cc.con=contact; 
        cc.save();        
        Test.stopTest();

        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR)); 
    }
    
    @isTest
    static void contactPropertyTest(){
        Contact contact;
        CreateContactController cc = new CreateContactController();
         
        Test.startTest();                  
        cc.con=contact; 
        cc.save();        
        Test.stopTest();   
        
        System.assert(ApexPages.hasMessages(ApexPages.SEVERITY.ERROR));
    }
    
    @isTest
    static void cancelTest(){
        CreateContactController cc = new CreateContactController();
         
        Test.startTest();                  
        cc.cancel();        
        Test.stopTest();         
    }   
}