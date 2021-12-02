@isTest
global with sharing class getAccessTocenCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        String responseTokenBody = '{"access_token":"AQWTiMiRSQECSZR6QF","expires_in":5183999}';

        HttpResponse response = new HttpResponse();
        response.setBody(responseTokenBody);
        response.setStatusCode(200);
        return response; 
    }
}
