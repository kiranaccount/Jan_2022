public class BooleanUsingtest {
    public BooleanUsingtest(){
        testmethod2();
      
    }
    @future
    public static void testmethod2(){        
     list<account> up=new list<account>();
     list<account> ac=[select id,phone,name from account limit 1];
        for(account a: ac){
            if(a.phone=='95502510354'){
                a.name='futuretest';
                up.add(a);
            }
                     
        }
        update up;
        Database.SaveResult[] srList = Database.update(up,false);
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
    }

 }
}