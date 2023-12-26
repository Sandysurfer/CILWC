public class LinkedInIntegration {
    
    //Parent Method Calling Both Below Method..
    public static void postOnLinkedIn(String Message){
        String loginId = loginToLinkedIn();
        postMessage(loginId,Message);
    }
    
    public static string loginToLinkedIn(){
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndPoint('callout:LinkedIn/v2/me');
        
        HttpResponse response = http.send(request);
        System.debug('response'+response.getBody());
        System.debug('reponse'+response.getStatusCode());
        Map<String,Object> result = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        String loginId = (String) result.get('id');
        System.debug('loginId'+loginId);
        return loginId;
        
    }
    
    public static void postMessage(String loginId,String postMessage){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('X-Restli-Protocol-Version','2.0.0');
        request.setHeader('Content-Type', 'application/json');
        String authorId = 'urn:li:person:' +loginId;
        String linkedInPostBody=
            ' {'+
            '"author": "urn:li:person:8675309",'+
            '"lifecycleState": "PUBLISHED",'+
            '"specificContent": {'+
            '"com.linkedin.ugc.ShareContent": {'+
            ' "shareCommentary": {'+
            '"text": "'+postMessage+'" '+
            ' },'+
            '"shareMediaCategory": "NONE"'+
            '}'+
            '},'+
            '"visibility": {'+
            '"com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"'+
            ' }'+
            '}';
        
        request.setBody(linkedInPostBody);
        request.setEndPoint('callout:LinkedIn/v2/ugcPosts');
        
        HttpResponse response = http.send(request);
        System.debug('response'+response.getBody());
        System.debug('reponse'+response.getStatusCode());
    }
    
    @AuraEnabled(cacheable=true)
    public static string getProfilePhoto(){
        Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        // GET https://api.linkedin.com/v2/me?projection=(id,profilePicture(displayImage~digitalmediaAsset:playableStreams))
        request.setEndPoint('callout:LinkedIn_Named_Credenatial/v2/me?projection=(id,profilePicture(displayImage~digitalmediaAsset:playableStreams))');
        request.setMethod('GET');
        //Send the Request
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            System.debug('Response Recieved Successfully'+response.getBody());
            Map<String,Object> result = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        
            Map<String,Object> profilePicture  = (Map<String,Object>) result.get('profilePicture');
            Map<String,Object> displayImage = (Map<String,Object>) profilePicture.get('displayImage~');
            
            List<Map<String,Object>> elements = new List<Map<String,Object>>();
            for(Object instance : (List<Object>) displayImage.get('elements')){
                elements.add((Map<String,Object>)instance);
            }
            Map<String,Object> identifierMap = elements[3]; //can take elements 0,1,2 likewise
            
            List<Map<String,Object>> identifierList = new List<Map<String,Object>>();
            for(Object instance : (List<Object>)identifierMap.get('identifiers')){
                identifierList.add((Map<String,Object>)instance);
            }
            Map<String,Object> identifierImageRecordMap = identifierList[0];
            String profilePictureUrl = (String) identifierImageRecordMap.get('identifier');
            System.debug('ProfilePictureUrl'+profilePictureUrl);
            return profilePictureUrl;
        }
        else
        {
            System.debug('Response Failed'+response.getBody());
            return null;
        }
        
    }
    
}