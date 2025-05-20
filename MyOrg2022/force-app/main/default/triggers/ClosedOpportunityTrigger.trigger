trigger ClosedOpportunityTrigger on Opportunity (after insert,after Update, after undelete, after delete) {
   /* 
    List<Task> t1 = new List<Task>();
    for (Opportunity opp : trigger.new){
        Task T = new Task() ;
        T.Subject = 'Follow Up Test Task' ;
        T.WhatId = opp.Id ;
        if(opp.StageName=='Closed Won'){
            t1.add(T);
        }
    }
    insert t1;*/
    
   //write a triiger to show the count in the account des filed
    set<id> accountids = new set<id>();
    if(trigger.isInsert || trigger.IsUndelete){
        for(opportunity op: trigger.new){
            accountids.add(op.AccountId );
        }
    }
    if(trigger.Isupdate){
        for(opportunity op: trigger.old){
            if(op.StageName !=trigger.oldmap.get(op.id).StageName ){
                system.debug('i am in update');
            }
        }
    }
    if(trigger.isdelete){
         for(opportunity op: trigger.old){
            accountids.add(op.AccountId );
        }
    }
    list<account> FinalListaccount = new list<account>();
    list<account> accountlist = [select id,name,(select id,name from Opportunities)from account where id=:accountids];
    for(account acc: accountlist){
        account a = new account();
        a.id = acc.id;
        list<opportunity> optylist = acc.Opportunities;
        a.Description = string.valueOf(optylist.size());
        FinalListaccount.add(a);
    }
    if(FinalListaccount.size()>0){
        update FinalListaccount;
    }
    
}