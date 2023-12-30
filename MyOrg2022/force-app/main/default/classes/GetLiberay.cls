public class GetLiberay {
//0580o000001AEQkAAO
     @AuraEnabled(cacheable=true)
    public static list<ContentVersion>getLiberyItems(string contectid){
       list<ContentVersion> kv = new list<ContentVersion>();     
        for(ContentVersion ls: [SELECT id,Title,ContentDocumentId,FileType,Description,VersionDataURL,LastModifiedDate  FROM ContentVersion WHERE ContentDocument.ParentId =:contectid]){
            kv.add(ls);
            system.debug('ls-->'+ls.Title);
        }
        return kv;
    }
    
}