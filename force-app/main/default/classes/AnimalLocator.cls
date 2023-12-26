public class AnimalLocator {
    public static String getAnimalNameById(Integer id) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndPoint('https://th-apex-http-callout.herokuapp.com/animals/'+id);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        String strResp='';
        if(response.getStatusCode() == 200){
            Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('Results-->'+results);
            Map<String,Object> animals = (Map<String,Object>) results.get('animal');
            System.debug('Animals-->'+animals);
            strResp = String.valueOf(animals.get('name'));
            System.debug('String Response-->'+strResp);
        }
        return strResp;
        
    }
}