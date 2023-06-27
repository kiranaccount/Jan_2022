trigger platformEvent on AccountRelatedEvents__e (after insert) {
    //List<FeedItem> FeedItemList = New List<FeedItem>();
    for(AccountRelatedEvents__e caseitem: trigger.new){      
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        // Set recipients to two contact IDs.
        // Replace IDs with valid record IDs in your org.
        message.toAddresses = new String[] {'kirangugulothu@gmail.com','kiran.gugulothu@mphasis.com' };
            message.optOutPolicy = 'FILTER';
        message.subject = 'Salesforce ReplayId :'+ caseitem.ReplayId;
        message.plainTextBody = 'This is the message body.'+caseitem.Name__c;
        Messaging.SingleEmailMessage[] messages = 
            new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '
                         + results[0].errors[0].message);
        }
    } 
    
}