trigger opportunitlyLineItem on OpportunityLineItem (after insert,after update, after delete) {
    list<opportunity> optyliust = new list<opportunity>();
    set<id> opportunityIds = new set<id>();   
    if(trigger.isInsert){
        for(OpportunityLineItem opl: trigger.new){
            opportunityIds.add(opl.opportunityID );
        }
    }
    if(trigger.Isdelete){
        for(OpportunityLineItem opl: trigger.old){
            opportunityIds.add(opl.opportunityID );
        }
    }
    if(trigger.isUpdate){
        for(OpportunityLineItem opl: trigger.new){
            if(opl.UnitPrice != trigger.oldmap.get(opl.id).UnitPrice){
                opportunityIds.add(opl.opportunityID);
            }
        }
    }    
    for(aggregateResult sr: [select opportunityID opid,sum(UnitPrice) accs from OpportunityLineItem where opportunityID =:opportunityIds group by opportunityID]){
        opportunity op = new opportunity();
        op.id =(id)sr.get('opid');     
        op.description = string.valueOf( (Decimal)sr.get('accs'));
        optyliust.add(op);
    }
    update optyliust;
}