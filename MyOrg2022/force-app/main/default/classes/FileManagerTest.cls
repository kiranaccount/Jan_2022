@isTest
public with sharing class FileManagerTest {
   
    @isTest
    static void getFileTest(){
        Test.startTest();
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        ContentVersion contentVersion = new ContentVersion(
                    Title          = 'a picture',
                    PathOnClient   = 'Pic.jpg',
                    VersionData    = Blob.valueOf('Test Content'),
                    IsMajorVersion = true);
      insert contentVersion;
      List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
      ContentDocumentLink cdl = new ContentDocumentLink();
      cdl.LinkedEntityId = acc.Id;
      cdl.ContentDocumentId = documents[0].Id;
      cdl.ShareType = 'V';
      cdl.Visibility = 'AllUsers';
      insert cdl;
      List<ContentDocument> contentList = FileManager.getFiles();
      List<String> recordIds = new List<String>();
      for(ContentDocument c:contentList){
        recordIds.add(c.Id);
      }
      string result = FileManager.deleteFiles(recordIds);
      Test.stopTest();
    }
}