/*write a trigger when contact last name updated are changed need to update the related account descpration.*/


trigger contactCascade on contact(before insert,before update, before delete,
                                  after update, after insert, after delete, after undelete)
{
    
    map<id,contact> contatMap = new map<id,contact>();    
    Switch on Trigger.operationType{
        when BEFORE_INSERT{           
            system.debug('BEFORE_INSERT SIZE new --'+Trigger.New.Size());
            system.debug('BEFORE_INSERT SIZE old--'+Trigger.old.Size());
            contactHandler.beforeinsert(trigger.new,trigger.newMap);
        }
        when BEFORE_UPDATE{ 
            system.debug('BEFORE_UPDATE SIZE new--'+Trigger.New.Size());     
            system.debug('BEFORE_UPDATE SIZE old--'+Trigger.old.Size());
        }
        when BEFORE_DELETE{ 
            system.debug('BEFORE_DELETE SIZE new --'+Trigger.New.Size());    
            //system.debug('BEFORE_DELETE SIZE old--'+Trigger.old.Size());
        }
        when AFTER_INSERT{
            system.debug('AFTER_INSERT SIZE new --'+Trigger.New.Size());    
            system.debug('AFTER_INSERT SIZE old--'+Trigger.old.Size());
            for(contact c: trigger.new){
                if(c.accountId != null){
                    contatMap.put(c.accountId,c);
                }
            } 
            if(contatMap.values().size()>0){contactHandler.rolluponAccount(contatMap);}
        }
        when AFTER_UPDATE{
            system.debug('AFTER_UPDATE SIZE NEW--'+Trigger.New.Size());
            system.debug('AFTER_UPDATE SIZE OLD--'+Trigger.old.Size());
            for(contact c: trigger.new){
                if(c.accountId != trigger.oldmap.get(c.id).accountId){
                    contatMap.put(c.accountId,c);
                    system.debug('AFTER_UPDATE new id--'+c.id);
                    system.debug('AFTER_UPDATE old id--'+trigger.oldmap.get(c.id).accountId);
                }                
            }
            if(contatMap.values().size()>0){contactHandler.rolluponAccount(contatMap);}
            // contactHandler.globalmethod(trigger.new, trigger.old, trigger.oldMap, trigger.newMap);
        }
        when AFTER_DELETE{
            // system.debug('AFTER_DELETE SIZE NEW--'+Trigger.old.Size());
            system.debug('AFTER_DELETE SIZE OLD--'+Trigger.old.Size());
            for(contact c: trigger.old){             
                if(c.accountId != trigger.oldmap.get(c.id).accountId){
                    contatMap.put(c.accountId,c);
                }
            }
            if(contatMap.values().size()>0){contactHandler.rolluponAccount(contatMap);}             
        }
        when AFTER_UNDELETE{
            system.debug('AFTER_UNDELETE SIZE NEW--'+Trigger.New.Size());
            system.debug('AFTER_UNDELETE SIZE OLD--'+Trigger.New.Size());
            for(contact c: trigger.new){
                if(c.accountId != null){
                    contatMap.put(c.accountId,c);
                }
            } 
            if(contatMap.values().size()>0){contactHandler.rolluponAccount(contatMap);}            
        }
    }
}