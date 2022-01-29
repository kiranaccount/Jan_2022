public class JsonObjectclass {
    
    public static string Jsonserialize(){
        map<id,Account> a = new map<id,account>([select id,name from account]);
        list<sobject> ct = [select id,name,account.name from contact];        
        // Serialize the list of InvoiceStatement objects.
        String JSONString = JSON.serialize(ct);
        System.debug('Serialized list of invoices into JSON format: ' + JSONString);
        return JSONString;      
    }    
    
}