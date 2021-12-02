@isTest
global with sharing class makePostLinkedInCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        String responseTokenBody = '{"owner":"urn:li:person:qwert","activity":"urn:li:activity:6871937449627672577",'+
                                '"edited":false,"subject":"Test Share","created":{"actor":"urn:li:person:R0o-wjkjvd",'+
                                '"time":1638397562402},"lastModified":{"actor":"urn:li:person:R0o-wjkjvd",'+
                                '"time":1638397562402},"text":{"text":"See Contact detail"},"id":"6871937449128542208",'+
                                '"distribution":{"linkedInDistributionTarget":{"visibleToGuest":true}},'+
                                '"content":{"title":"Click on the link and Learn more ","contentEntities":[{"title":"Click on the link and Learn more ",'+
                                '"entityLocation":"https://developer.force.com/viewdetailcontactvf?id=0030900000k"}],'+
                                '"shareMediaCategory":"ARTICLE"}}';

        HttpResponse response = new HttpResponse();
        //response.setHeader('X-RestLi-Protocol-Version', '2.0.0 ');
        response.setHeader('Content-Type', 'application/json;charset=UTF-8');
        response.setBody(responseTokenBody);
        response.setStatusCode(200);
        return response; 
    }
}
