/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-20-2023
 * @last modified by  : kiran Naik Gugulothu 
**/
    trigger AccountAddressTrigger on Account (before insert, after update) {

    map<id,account> ids = new map<id,account>();

    for(Account a : Trigger.new){
        ids.put(a.id,a);
        If (a.Match_Billing_Address__c == true) {
            a.ShippingPostalCode = a.BillingPostalCode;
        }  
    } 
    list<account> ac = new list<account>();
    if(trigger.isUpdate) 
    for(account a1: [select id,name,Rollupcustom__c,(select id,lastname from Contacts) from account where id =: ids.keySet()] ){        
        a1.Rollupcustom__c = a1.Contacts.size();
        system.debug('values==>'+a1.Contacts.size());  
        ac.add(a1);    
    }
    update ac;  

    }