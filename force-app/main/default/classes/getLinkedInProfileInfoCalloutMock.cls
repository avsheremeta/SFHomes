@isTest
global with sharing class getLinkedInProfileInfoCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        String access_token = 'AQWTiMiRSQECSZR6QF';
        String responseTokenBody = '{"localizedLastName":"TestName","profilePicture":{"displayImage":"urn:li:digitalmediaAsset:C4E03AQGYWuEa"},' +
                                    '"firstName":{"localized":{"ru_RU":"TestFirstName"},"preferredLocale":{"country":"RU","language":"ru"}},' + 
                                    '"lastName":{"localized":{"ru_RU":"TestLastName"},"preferredLocale":{"country":"RU","language":"ru"}},' + 
                                    '"id":"qwert345","localizedFirstName":"Testname"}';

        HttpResponse response = new HttpResponse();
        response.setHeader('Authorization', 'Bearer ' + access_token);
        response.setBody(responseTokenBody);
        response.setStatusCode(200);
        return response; 
    }
}
