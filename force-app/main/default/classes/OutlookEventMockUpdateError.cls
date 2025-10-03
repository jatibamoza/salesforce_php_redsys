@isTest
public class OutlookEventMockUpdateError implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();

        if (req.getMethod() == 'PATCH') {
            // Forzar un 500 en la actualización
            res.setStatusCode(500);
            res.setBody('{"error": "Internal Server Error"}');
        } else {
            // Default
            res.setStatusCode(200);
            res.setBody('{"status":"ok"}');
        }
        return res;
    }
}