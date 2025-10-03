@isTest
global class OutlookEventMockWithError implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        // Prepara la respuesta simulada
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        // Determina el tipo de método para forzar el error
        if (req.getMethod() == 'POST') {
            // Forzamos un código distinto a 201 para que lance la excepción
            res.setStatusCode(400);
            res.setBody('{"error": "Bad Request"}');
        } else if (req.getMethod() == 'PATCH') {
            // Puedes personalizarlo si deseas forzar otro error en PATCH
            res.setStatusCode(400);
            res.setBody('{"error": "Bad Request"}');
        } else if (req.getMethod() == 'DELETE') {
            // O forzar error en DELETE
            res.setStatusCode(400);
            res.setBody('{"error": "Bad Request"}');
        } else {
            // Respuesta por defecto si llegara otro método
            res.setStatusCode(400);
            res.setBody('{"error": "Bad Request"}');
        }

        return res;
    }
}