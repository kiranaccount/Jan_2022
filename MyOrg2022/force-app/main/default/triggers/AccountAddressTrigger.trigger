trigger AccountAddressTrigger on Account (before delete, before insert, before update, 
                                          after delete, after insert, after update) {
                                              list<account> acclist = new list<account>();
                                              map<id,account> ids = new map<id,account>();                                              
                                              if(trigger.isafter && trigger.isUpdate){ 
                                                  if(checkRecursive.runOnce())
                                                  {
                                                      for(aggregateResult ac:  [select AccountId,COUNT(id)avrg from contact where accountId IN:trigger.new group by Accountid]){                                                          
                                                          object count = ac.get('avrg');
                                                          system.debug('abb---->'+count);
                                                          string sq =string.valueOf(count); 
                                                          account acc = new account();
                                                          acc.id=(Id)ac.get('Accountid');
                                                          acc.Rollupcustom__c = decimal.valueOf(sq);
                                                          //ids.put(ac.id,ac); 
                                                          acclist.add(acc);
                                                      }         
                                                  }           
                                                  
                                              }
                                              
                                          // AggregateResult[] groupedResults=[select Accountid,count(id)quan from contact  where Accountid in : accids group by Accountid];      
                                              
                                           
update ids.values();
update acclist;

/* for(Account a : Trigger.new){
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

//update ac;

*/
}