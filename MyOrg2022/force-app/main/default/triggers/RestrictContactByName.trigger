trigger RestrictContactByName on Contact (before update,before insert) {
    
    List<AccountRelatedEvents__e> FeedItemList = New List<AccountRelatedEvents__e>();
     
    for (Contact caseitem : trigger.new) {        
        AccountRelatedEvents__e post = new AccountRelatedEvents__e();
        post.name__c =  caseitem.LastName.stripHtmlTags();
         //post.name__c =  'testing kiran';
        FeedItemList.add(post);       
        
        String s = '20,09,2019,7,00,00';
        String[] data = s.split(',');
        string year = data[2];
        string month = data[1];
        string day = data[0];
        string hour = data[3];
        string minute = data[4];
        string second = data[5]; 
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' 
            + minute +  ':' + second;
        
        caseitem.TestDatetime__c = Datetime.valueOf(stringDate);
        System.debug('Datetime.now();'+Datetime.now());
        
    }
    // Call method to publish events
    List<Database.SaveResult> results = EventBus.publish(FeedItemList);
    
    // Inspect publishing result for each event
    for (Database.SaveResult sr : results) {
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +
                             err.getStatusCode() +
                             ' - ' +
                             err.getMessage());
            }
        }       
    }  
}