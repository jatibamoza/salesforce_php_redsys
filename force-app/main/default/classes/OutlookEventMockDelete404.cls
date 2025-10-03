@isTest
global class OutlookEventMockDelete404 implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        // Por defecto, supongamos que viene DELETE y devolvemos 404
        if (req.getMethod() == 'DELETE') {
            res.setStatusCode(404);
            res.setBody('{"error": "Not Found"}');
        } else {
            // Cualquier otra operación no usada aquí
            res.setStatusCode(200);
            res.setBody('{"status": "ok"}');
        }
        return res;
    }
}