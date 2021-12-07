@RestResource(urlMapping='/Contact/*')
global with sharing class ContactServiceManager {
    @HttpPost
    global static String makePost(String firstName, String lastName, String contactEmail, String contactPassword) {
        Contact contact = new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Email = contactEmail;
        contact.Password__c = contactPassword;        
        insert contact; 
        return contact.Id;                       
    }
}
