@isTest
public class OutlookEventMockDeleteError implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();

        if (req.getMethod() == 'DELETE') {
            // Forzar un 500 en la eliminación
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