package com.mxystudio;

import org.scribe.builder.ServiceBuilder;
import org.scribe.builder.api.YahooApi;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Response;
import org.scribe.model.SignatureType;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.oauth.OAuthService;

public class YQLPrivateQueryObject {

	// private static final String PROTECTED_RESOURCE_URL =
	// "http://query.yahooapis.com/v1/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22AUDUSD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";
	// private static final Token EMPTY_TOKEN = null;

	// http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDAUD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys

	// final big query
	// private static final String yqlquerystr =
	// "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22EURUSD%22%2C%22EURAUD%22%2C%22EURCAD%22%2C%22EURCHF%22%2C%22EURCNY%22%2C%22EURGBP%22%2C%22EURHKD%22%2C%22EURJPY%22%2C%22EURNZD%22%2C%0A%0A%0A%22GBPUSD%22%2C%22GBPAUD%22%2C%22GBPCAD%22%2C%22GBPCHF%22%2C%22GBPCNY%22%2C%22GBPEUR%22%2C%22GBPHKD%22%2C%22GBPJPY%22%2C%22GBPNZD%22%2C%0A%0A%0A%22AUDUSD%22%2C%22AUDCHF%22%2C%22AUDCNY%22%2C%22AUDEUR%22%2C%22AUDGBP%22%2C%22AUDHKD%22%2C%22AUDJPY%22%2C%22AUDNZD%22%2C%0A%0A%0A%22NZDUSD%22%2C%22NZDCNY%22%2C%0A%0A%0A%22USDCNY%22%2C%22USDTWD%22%2C%22USDHKD%22%2C%22USDSGD%22%2C%22USDCAD%22%2C%22USDCHF%22%2C%22USDJPY%22%2C%22USDMOP%22%2C%22USDMYR%22%2C%0A%0A%0A%22CADAUD%22%2C%22CADCHF%22%2C%22CADCNY%22%2C%22CADEUR%22%2C%22CADGBP%22%2C%22CADHKD%22%2C%22CADJPY%22%2C%22CADNZD%22%2C%0A%0A%0A%22CHFAUD%22%2C%22CHFCAD%22%2C%22CHFCNY%22%2C%22CHFEUR%22%2C%22CHFGBP%22%2C%22CHFHKD%22%2C%22CHFJPY%22%2C%0A%0A%0A%22CNYJPY%22%2C%0A%0A%0A%22HKDAUD%22%2C%22HKDCAD%22%2C%22HKDCHF%22%2C%22HKDCNY%22%2C%22HKDEUR%22%2C%22HKDGBP%22%2C%22HKDJPY%22%2C%0A%0A%0A%22JPYAUD%22%2C%22JPYCAD%22%2C%22JPYCHF%22%2C%22JPYEUR%22%2C%22JPYGBP%22%2C%22JPYHKD%22%2C%0A%0A%0A%22SGDCNY%22%2C%0A%0A%0A%22TWDCNY%22%2C%0A%0A%22SEKCNY%22%2C%20%22DKKCNY%22%2C%20%22NOKCNY%22%2C%20%22JPYCNY%22%2C%20%22MYRCNY%22%2C%20%22MOPCNY%22%2C%20%22PHPCNY%22%2C%20%22THBCNY%22%2C%20%22KRWCNY%22%2C%20%22RUBCNY%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

	// test ont query
	// select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22AUDUSD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
	private static final String yqlquerystr = "select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22EURUSD%22%2C%22AUDUSD%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

	// super finalstring

	private static final String PROTECTED_RESOURCE_URL = "http://query.yahooapis.com/v1/yql?q="
			+ yqlquerystr;
	OAuthService service = new ServiceBuilder()
			.provider(YahooApi.class)
			.apiKey("dj0yJmk9bWlsa3FUOFlIYUhJJmQ9WVdrOVEyRTJNRFZyTm1zbWNHbzlNVGMxTlRZNE1EazJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD04ZQ--")
			.apiSecret("74f5febfc8680dc6650370b7c4e430554cf5c80e")
			.signatureType(SignatureType.QueryString).build();

	Token token = new Token("", "");

	public String queryCurrencyRate() {
		OAuthRequest request = new OAuthRequest(Verb.GET,
				PROTECTED_RESOURCE_URL);
		service.signRequest(token, request);
		Response response = request.send();
		return response.getBody();
	}

	public String queryCurrencyRate(String url) {
		OAuthRequest request = new OAuthRequest(Verb.GET, url);
		service.signRequest(token, request);
		Response response = request.send();
		return response.getBody();
	}

}
