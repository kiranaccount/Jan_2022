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
}
    
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
    }*/
    
    list<id> ids= new list<id>();
    set<id>idsset=new set<id>();
    if(trigger.isupdate){
        for(account a: trigger.old){
            ids.add(a.id);
            idsset.add(a.id);
        }
        
        list<account> accs = MakingStaticSOQL_Optimization.getlistofAccount(idsset);
        system.debug('accs------>'+accs);
        
        MakingStaticSOQL_Optimization.getAccountById(ids[0]);
        Integer queriesUsed1 = Limits.getQueries();
        integer QueryRows1=Limits.getQueryRows(); 
        system.debug('After queriesUsed-->'+queriesUsed1+'-----QueryRows1---->'+QueryRows1);
      
        
        MakingStaticSOQL_Optimization.getAccountById(ids[0]);
        Integer queriesUsed = Limits.getQueries();
        integer QueryRows=Limits.getQueryRows(); 
        system.debug('After queriesUsed-->'+queriesUsed+'-----QueryRows2---->'+QueryRows);
        
        MakingStaticSOQL_Optimization.preloadAccounts(idsset);
        Integer queriesUsed2 = Limits.getQueries();
        integer QueryRows2=Limits.getQueryRows(); 
        system.debug('After queriesUsed-->'+queriesUsed2+'-----queriesUsed3---->'+QueryRows2);
        
        ExceptionLog__c e1 = new ExceptionLog__c();
        e1.Name ='AccountTrrigger1';
        e1.LogError__c ='After queriesUsed-->'+Limits.getQueries()+'-----QueryRows1---->'+Limits.getQueryRows()+'---------accs siz-'+accs[0].name;
        insert e1;
        
    }
    
    
}