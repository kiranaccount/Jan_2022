trigger PlatformEventException on Exception__e (after insert) { 
    list<ExceptionLog__c>  finalist =  new list<ExceptionLog__c>();
    for(Exception__e ex: trigger.new){
        ExceptionLog__c  elog = new ExceptionLog__c();
        elog.Name = 'flow Exception '+ex.object__c;
        elog.ExceptionLogDateTime__c = ex.ExceptionLogDateTime__c;
        elog.object__c = ex.object__c;
        elog.ExceptionRecordID__c = ex.ExceptionRecordID__c;
        elog.LogError__c = ex.LogError__c;
        finalist.add(elog);
    }
    if(finalist.size()>0){
        system.debug('finalist--'+finalist);
       insert finalist;
    }
}