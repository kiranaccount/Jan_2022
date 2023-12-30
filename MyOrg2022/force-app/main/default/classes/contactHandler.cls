public class contactHandler {
    
    public static void globalmethod(list<contact> newlist,list<contact> oldlist,
                                   map<id,contact> olamap,map<id,contact> newmap)
    {
        if(newlist.size()>0){for(contact c: newlist){system.debug('newlist--->'+c.id);}}
        if(oldlist.size()>0){for(contact c: oldlist){system.debug('oldlist--->'+c.id);}}
        if(olamap.values().size()>0){for(contact c: olamap.values()){system.debug('olamap--->'+c.id);}}
        if(newmap.values().size()>0){for(contact c: newmap.values()){system.debug('newmap--->'+c.id);}} 
        
        /*for(contact c: newlist){system.debug('newlist--->'+c.id);}
        for(contact c: oldlist){system.debug('oldlist--->'+c.id);}
        for(contact c: olamap.values()){system.debug('olamap--->'+c.id);}
        for(contact c: newmap.values()){system.debug('newmap--->'+c.id);}*/
    }
    public static void beforeinsert(list<contact> newlist,
                                   map<id,contact> newmap)
    {
        if(newlist.size()>0){for(contact c: newlist){system.debug('newlist--->'+c);}}
        //if(oldlist.size()>0){for(contact c: oldlist){system.debug('oldlist--->'+c.id);}}
        //if(olamap.values().size()>0){for(contact c: olamap.values()){system.debug('olamap--->'+c.id);}}
        //if(newmap.values().size()>0){for(contact c: newmap.values()){system.debug('newmap--->'+c);}} 
    }
     public static void beforeupdate(list<contact> newlist,list<contact> oldlist,
                                   map<id,contact> olamap,map<id,contact> newmap)
    {
        if(newlist.size()>0){for(contact c: newlist){c.LastName='t3'; system.debug('newlist--->'+c);}}
        
        
        //if(oldlist.size()>0){for(contact c: oldlist){system.debug('oldlist--->'+c.id);}}
        //if(olamap.values().size()>0){for(contact c: olamap.values()){system.debug('olamap--->'+c.id);}}
        //if(newmap.values().size()>0){for(contact c: newmap.values()){system.debug('newmap--->'+c);}} 
    }
    
    public static void rolluponAccount(map<id,contact> contatMap){
         map<id,account> accountMap = new map<id,Account>();
        if(contatMap.values().size()>0){
        for(aggregateResult  r: [select accountId accs, count(id) countactcount from contact where accountid=:contatMap.keyset() group by accountId]){
            account a = new account();
            a.id =(id)r.get('accs');
            a.description = string.valueOf( (integer)r.get('countactcount'));
            accountMap.put(a.id,a);
        }
        
        if(accountMap.values().size()>0){update accountMap.values();}
    } 
    }
    
}