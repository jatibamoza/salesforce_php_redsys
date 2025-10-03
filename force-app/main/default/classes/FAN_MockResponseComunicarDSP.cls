@isTest 
public class FAN_MockResponseComunicarDSP implements HttpCalloutMock{
	protected Integer code;
    protected String Descriptivoerror;
    protected String bodyAsString;
    protected Map<String, String> responseHeaders;

    public FAN_MockResponseComunicarDSP(Integer code, String Descriptivoerror, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.Descriptivoerror = Descriptivoerror;
        this.bodyAsString = body;
        this.responseHeaders = responseHeaders;
    }
	public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setStatus(Descriptivoerror);
        resp.setBody(bodyAsString);

        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                    resp.setHeader(key, responseHeaders.get(key));
            }
        }
        return resp;
    }
}