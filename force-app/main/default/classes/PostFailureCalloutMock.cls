@isTest
global with sharing class PostFailureCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');       
        response.setStatusCode(500);
        return response; 
    }
}
