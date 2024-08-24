trigger AccountTrigger1 on Account (after update,after insert) {
    
    // update contact phone number when account is updated
    /*
set<id> AccountID = new set<id>();   
list<contact> cs = new list<contact>();
map<id,account> accountmaps = new map<id,account>();

if(Trigger.IsUpdate)
for(account a: trigger.old){
accountmaps.put(a.id,a);
}
for(contact c: [select id,lastname,phone,AccountId from contact where accountID=:accountmaps.keyset()]){
if(accountmaps.get(c.accountId).id != null){
c.Phone = trigger.newMap.get(c.accountId).phone;
cs.add(c);
}
}

if(cs.size()>0){
update cs;
}*/
    
    list<contact> cs = new list<contact>();
    map<id,contact> mapss = new map<id,contact>([select id,lastname,phone,AccountId from contact where accountID=:trigger.new]);
    for(contact c: mapss.values()){
        if(trigger.oldMap.get(c.AccountId) !=null)
            if(trigger.newmap.get(c.accountId).name != trigger.oldmap.get(c.AccountId).name){
                c.phone = trigger.newMap.get(c.AccountId).phone;
                cs.add(c);
            }
    } 
    if(cs.size()>0){
        update cs;
    }
    
    
}