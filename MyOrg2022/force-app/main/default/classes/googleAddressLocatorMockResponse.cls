@isTest
global class googleAddressLocatorMockResponse implements HttpCalloutMock {
    public static Integer STR_STATUSCODE = 200;
    
    global HTTPResponse respond(HTTPRequest req) { 
        System.debug('Endpoint : ' +req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        // Create a fake response
        HttpResponse objHttpRes = new HttpResponse();
        objHttpRes.setHeader('Content-Type', 'text/json');
        objHttpRes.setBody('{"long_name" : "Rutu Park"}');
        objHttpRes.setStatusCode(STR_STATUSCODE);
        return objHttpRes;
    }
}