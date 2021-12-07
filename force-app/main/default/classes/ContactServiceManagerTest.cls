@IsTest
private with sharing class ContactServiceManagerTest {
    @isTest
    static void makePostSuccessTest() {

        Test.startTest();
        // Call the method to test
        String contactId = ContactServiceManager.makePost('Firtst Name', 'Last Name', 'contact@test.com', '1122334455');
        Test.stopTest();

        // Verify results
        System.assert(contactId != null);
        
        Contact contact = [SELECT Id,FirstName, LastName, Email, Password__c FROM Contact WHERE Id=:contactId];
        System.assert(contact != null);
        System.assertEquals(contact.Email, 'contact@test.com');
    }
}
