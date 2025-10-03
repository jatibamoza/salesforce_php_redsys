@isTest
public class OutlookEventMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();

        if (request.getMethod() == 'POST') { // Simulate creating an event
            response.setStatusCode(201);
            response.setBody('{"id": "mockOutlookId12345", "onlineMeetingUrl": "https://teams.microsoft.com/mockMeetingLink"}');
        } else if (request.getMethod() == 'PATCH') { // Simulate updating an event
            response.setStatusCode(200);
            response.setBody('{"id": "mockOutlookId12345", "updated": true}');
        } else if (request.getMethod() == 'DELETE') { // Simulate deleting an event
            response.setStatusCode(204);
        } else {
            response.setStatusCode(400); // Default for unsupported methods
            response.setBody('{"error": "Bad Request"}');
        }

        return response;
    }
}