/**

@File Name          : googleAddressLocator.cls
@description        : This would be used to for google address auto suggestions and autocomplete
@Author             : Ruchita Divate
@Group              : 
@Last Modified By   : Ruchita Divate
ChangeMeIn@UserSettingsUnder.SFDoc
@Last Modified On   : 14/5/2021, 10:30:00 AM
@Modification Log   : 

Ver       Date            Author                 Modification

1.0    14/5/2021       Ruchita Divate

**/

public class googleAddressLocator {
    /**
@description : Auto suggestion Web Service 
@author : Ruchita Divate
@param : input: SearchAddress , types: Results Types , langug : language for getting the      results
@return : string
@methodCalledFrom : googleAddressAutofillHelper.js
**/  
    @AuraEnabled
    public static string getSuggestions(String input) {
        String suggestionsURL = Label.getPlacesSuggestionsURL;
        String url = suggestionsURL
            + 'input=' + EncodingUtil.urlEncode(input, 'UTF-8')
            + getKey();   
        
        String response = getResponse(url); 
        system.debug('Response suggestions***'+response);
        return response;
    }
    
    /**
@description : Place Details Web Service 
@author : Ruchita Divate
@param : PlaceId: Unique Place Id , langug : language for getting the results
@return : string
@methodCalledFrom : googleAddressAutofillHelper.js
**/ 
    @AuraEnabled
    public static string getPlaceDetails(String placeId) {
        String placeURL = Label.getPlaceDetailsURL;
        String url = placeURL
            + 'placeid=' + EncodingUtil.urlEncode(placeId, 'UTF-8')
            + getKey(); 
        String response = getResponse(url);
        system.debug('Response places****'+response);
        return response;
    }
    
    /**
@description : Common Utility method for making call out
@author : Ruchita Divate
@param : String
@return : string
**/
    
    public static string getResponse(string strURL){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        res = h.send(req); 
        String responseBody = res.getBody(); 
        system.debug('responseBody---'+responseBody);
        return responseBody; 
    }
    
    /**
@description : To get the google Api key from custom label
@author : Ruchita Divate
@param : 
@return : string
**/
    public static string getKey(){
        string key = Label.GoogleAPIKeyValue;
        string output = '&key=' + key;   
        return output;
    }
    
}