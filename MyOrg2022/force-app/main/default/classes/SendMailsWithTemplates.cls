public without sharing class SendMailsWithTemplates{
    
    /* Method name : SendMails
* Description  : Sending the Case Email Template, when new case inserted or new comment insert both invoked in trigger
* Return Type  : 
* Parameter    : TemplateName,list<userid>,list<case>,EmailRecipient,subject
*/ 
    
    public SendMailsWithTemplates(){
        
        list<string> getTemplate1 = new list<string>();
        getTemplate1.add('SupportEscalatedCaseReassignment');
        list<EmailTemplate> getTemplate = getTemplate(getTemplate1);   
        // this is contact id 
        //contact c = [select id,name,FirstName from contact where id='0030o00003VUcGRAA1'];
        string userid = UserInfo.getUserId();
        //this is case id
        case caserecord = [select id from case where id='5000o00003HJALtAAP'];
         list<string> toaddress = new list<string>{'kiran.naik@wisseninfotech.com','farooq.hareeda@wisseninfotech.com'};
        SendMails(getTemplate[0],userid,caserecord,'kiran_test',toaddress);
         
    

    }
    public static void SendMails(EmailTemplate oEmailTemplate,id usid,case caselist,string emailsub,list<string> toaddress){
        // public static void SendMails(EmailTemplate oEmailTemplate,list<id> usid,list<case> caselist,string emailsub){
        //string EmailRecipient;
        string emailSubject; 
        string blank = '';        
       // for(case c1: caselist){             
           // emailSubject =  emailsub+ c1.Subject;
         emailSubject =  emailsub;
            //for(id  e: usid){
                List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                oEmailTemplate.Subject = oEmailTemplate.Subject;                   
                email.setSaveAsActivity(false);
                //email.setContentType('application/pdf');
                email.setSubject(oEmailTemplate.Subject);
                email.setPlainTextBody(oEmailTemplate.Body);
                email.setHtmlBody(oEmailTemplate.htmlValue);                       
                //email.setTargetObjectId(usid);
                email.setToAddresses(toaddress);
                system.debug('setTargetObjectId--->'+usid);
                email.setTemplateId(oEmailTemplate.Id);
                emailsToSend.Add(email);
                List<Messaging.SendEmailResult> listEmailResult = Messaging.sendEmail(emailsToSend);                
                
                for(Messaging.SendEmailResult res : listEmailResult){                    
                    if(res.isSuccess() == false)                        
                        System.debug('m111111'+res.geterrors().get(0).getMessage());                    
                }
            //}
       // }   
    }
    
    
    /* Method name : getTemplate
* Description  : Query and Build list for EmailTemplate filtered by the Templatename
* Return Type  : 
* Parameter    : TemplateName
*/  
    public static list<EmailTemplate> getTemplate(list<string> Templatename){
        list<EmailTemplate> oEmailTemplate =new list<EmailTemplate>();
        for(EmailTemplate u: [SELECT Id,name,developerName,Subject,Body,htmlValue FROM EmailTemplate WHERE developerName=:Templatename Limit 1]){
            oEmailTemplate.add(u);
        }
        system.debug('oEmailTemplate--->'+oEmailTemplate);
        return oEmailTemplate;
        
    }
    public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateParmName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity ) {
        //  templateId  must be ID of an Email template
        //  targetObjId must be a Contact Id -- also used in merge fields of template recipient.xxxx
        //  whatId      must be an SObject that is used in the merge fields of the template relatedTo.xxxx
        //  fromId      if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String templateApiName =  templateParmName;
        Id templateId;  
        try {templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;}
        catch (Exception e) {
            system.debug('[UTIL-07] sendTemplatedEmail error. ' + e.getMessage());
        }
        email.setToAddresses(toRecipients);
        email.setCcAddresses(ccRecipients);
        email.setTargetObjectId(targetObjId);
        email.setWhatId(whatId);
        email.setorgWideEmailAddressId(orgWideEmailId);
        email.setTemplateId(templateId);
        email.setSaveAsActivity(saveAsActivity);         
        // save email as activity on the targetObjId (i.e. Contact)
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            return;
        }
        catch (EmailException e) {system.debug('[UTIL-07] sendTemplatedEmail error. ' + e.getMessage());}
        
    }
    
    private ContentDocumentLink createContentDocumentLink(Id contentDocumentId, Id parentId){
    ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
    contentDocumentLink.ContentDocumentId = contentDocumentId;
    contentDocumentLink.LinkedEntityId = parentId;
    contentDocumentLink.ShareType = 'I'; // Inferred permission
    contentDocumentLink.Visibility = 'InternalUsers';
    return contentDocumentLink;
}
    
}