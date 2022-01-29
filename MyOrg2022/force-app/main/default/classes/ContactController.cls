public with sharing class ContactController {
@AuraEnabled
    public static List<Contact> getContacts() {
        list<contact> con = [select id,lastname,phone from contact];
       return con;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact            
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WHERE Name LIKE :key AND Picture__c != NULL
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Contact getSingleContact() {
        return [
            SELECT Id, Name, Title, Phone, Email, Picture__c
            FROM Contact
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }
}