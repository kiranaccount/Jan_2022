/*
Class to manage file and content document related DMLS 

*/
public without sharing class FileManager {
    
    @AuraEnabled(cacheable=true)
    public static List<ContentDocument> getFiles(){
        try {
            List<ContentDocument> contentList = [select Id,ContentSize,Description, FileExtension, FileType,Title,Owner.Name from ContentDocument ORDER BY ContentSize DESC LIMIT 10000 ];
           
            return contentList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
         
    }

    @AuraEnabled(cacheable=false)
    public static string deleteFiles(List<String> recordIds){
        string result;
        try {
            System.debug('recordIds'+recordIds);
            List<ContentDocument> contentDocumentList = new List<ContentDocument>();
            for(Integer i=0;i<recordIds.size();i++){
                ContentDocument cd = new ContentDocument();
                cd.Id = recordIds[i];
                contentDocumentList.add(cd);
            }
            
            if(contentDocumentList.size()>0){
                Database.DeleteResult[] DR_Dels = Database.delete(contentDocumentList,false);
                for(Database.DeleteResult dr : DR_Dels) {
                    if (dr.isSuccess()) {
                        // Operation was successful,
                        result='Success';
                        Database.EmptyRecycleBinResult[] DR_Recycle = Database.emptyRecycleBin(contentDocumentList);
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : dr.getErrors()) {
                            result = err.getMessage();
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return result;
    }
   
}