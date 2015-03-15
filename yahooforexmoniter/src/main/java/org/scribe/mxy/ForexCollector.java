package org.scribe.mxy;

import org.scribe.builder.ServiceBuilder;
import org.scribe.builder.api.YahooApi;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Response;
import org.scribe.model.SignatureType;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.oauth.OAuthService;

public class ForexCollector {
	
	 private static final String PROTECTED_RESOURCE_URL = "http://query.yahooapis.com/v1/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22AUDUSD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
	 private static final Token EMPTY_TOKEN = null;
	 
	 
	 public static void test(){
			OAuthService service = new ServiceBuilder()
	        .provider(YahooApi.class)
	        .apiKey("dj0yJmk9bWlsa3FUOFlIYUhJJmQ9WVdrOVEyRTJNRFZyTm1zbWNHbzlNVGMxTlRZNE1EazJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD04ZQ--")
	        .apiSecret("74f5febfc8680dc6650370b7c4e430554cf5c80e")
	        .signatureType(SignatureType.QueryString)
	        .build();
			
			
			Token token = new Token("", "");
		    OAuthRequest request = new OAuthRequest(Verb.GET, PROTECTED_RESOURCE_URL);
		    service.signRequest(token, request);
		    Response response = request.send();
		    System.out.println(response.getBody());
		    System.out.println("start=============");
		}
	 
	 public void check(){
			OAuthService service = new ServiceBuilder()
	        .provider(YahooApi.class)
	        .apiKey("dj0yJmk9bWlsa3FUOFlIYUhJJmQ9WVdrOVEyRTJNRFZyTm1zbWNHbzlNVGMxTlRZNE1EazJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD04ZQ--")
	        .apiSecret("74f5febfc8680dc6650370b7c4e430554cf5c80e")
	        .signatureType(SignatureType.QueryString)
	        .build();
			
			
			Token token = new Token("", "");
		    OAuthRequest request = new OAuthRequest(Verb.GET, PROTECTED_RESOURCE_URL);
		    service.signRequest(token, request);
		    Response response = request.send();
		    System.out.println(response.getBody());
		    System.out.println("start=============");
		}
	
	

}
