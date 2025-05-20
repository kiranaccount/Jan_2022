trigger optytrigger1 on Opportunity (after update) {    
    list<opportunity> ot = new list<opportunity>();
    list<opportunity> newoptyValues = [Select id,name,StageName from opportunity where id IN:Trigger.newMap.keyset()];
    map<id,opportunity> oldvaues = trigger.oldmap;
    for(opportunity op: newoptyValues){
        opportunity cseold = oldvaues.get(op.Id);
        if(op.StageName != cseold.StageName){
            Datetime dtWorking = cseold.LastModifiedDate;
            Integer diff =    dtWorking.date().daysBetween(Date.today()); 
            Integer dt1 = (system.today()).daysBetween(Date.valueOf(cseold.LastModifiedDate));            
            dtWorking = dtWorking.addDays(diff);
            Decimal hrs = (Datetime.now().getTime() - dtWorking.getTime())/1000/60/60 ;
            Decimal mts =(Datetime.now().getTime() - dtWorking.getTime())/1000/60;
            Decimal actmts = mts-(hrs*60);
            op.Description = 'old StageName__'+ cseold.StageName +'__days on hold__'+string.valueOf(diff) +'__Hours__'+ hrs +'__Minutes__'+actmts+'---newdayes check---'+string.valueOf(dt1);
            ot.add(op);
            System.debug(diff);
            System.debug(hrs);
            System.debug(actmts); 
        }
    }
    update ot; 
}