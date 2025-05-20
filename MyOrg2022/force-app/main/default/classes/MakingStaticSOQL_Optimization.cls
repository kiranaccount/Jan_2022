public class MakingStaticSOQL_Optimization {
    
    public static list<account> userDetails = new list<account>();    
    
    public static void addrecord(){
        userDetails.add( [select id,name from account limit 1]);
    }
    
    public static void Check(){
        if(userDetails.isEmpty()){
            System.debug( 'this record are empty');
        }else{
            System.debug( 'this record are Not empty-----'+userDetails.size()); 
        }
    }
    
    public static List<account> myObjectList {
        get {
            if (myObjectList == null) {
                myObjectList = [
                    select Name
                    from account
                ];
            }
            
            return myObjectList;
        }
        set;
    }
    
    public static Map<String, account> myObjectMap {
        get {
            if (myObjectMap == null) {
                myObjectMap = new Map<String, account>();
                for (account obj: myObjectList) {
                    myObjectMap.put(obj.Name, obj);
                }
            }
            
            return myObjectMap;
        }
        set;
    }
    
    //MyObject__c obj = MyObjectUtils.myObjectMap.get('Foo');
    
    private static map<id,account> accountChahe = new map<id,Account>();
    /*retriveves an account by id using the chache to avoid repeated SOQL Queries */
    public static account getAccountById(id accountID){
        if(accountID==null) return null;
        //check if account is alredy in cache 
        if(!accountChahe.containsKey(accountID)){
            Account acc =[select id,name,type from account where Id =:accountID limit 1];
            accountChahe.put(accountID,acc);
        }
        return accountChahe.get(accountID);
    }
    
    /**
* optional : preload multiple accounts into cache
* */
    public static void preloadAccounts(Set<id> accountIDs){
        set<id> idsToLoad = new set<id>();
        for(id accids: accountIDs){
            if(!accountChahe.containsKey(accids)){
                idsToLoad.add(accids);
            }
        }
        if(!idsToLoad.isEmpty()){
            for(Account acc: [select id,name,type from account where Id =:idsToLoad]){
                accountChahe.put(acc.id,acc);
            } 
        }
    }
    
    public static list<account> getlistofAccount(set<id> accountIds){
        list<account> accs = new list<account>();        
        set<id> DontCOntainID = new set<id>();
        list<id> containsID = new list<Id>();
        
        if(accountIds.isempty()==false){
            for(id ids: accountIds){
                if(accountChahe.containsKey(ids)==true){
                    containsID.add(ids);
                }else{
                    DontCOntainID.add(ids); 
                }
            }
        }        
        if(DontCOntainID.isempty()==false){
            preloadAccounts(DontCOntainID);
        }        
        if(accountChahe.values().isempty()==false){
            for(id ids1 : accountIds){
                account acc=  accountChahe.get(ids1);
                accs.add(acc);
            }
        }        
        return accs;
    }
    
    
    
    
    /**
* list<id> accountids =new list<id>{'001GB00003GgA6xYAF','001GB00003GgAYlYAN'} 
//preload to reduce repeated queries 
MakingStaticSOQL_Optimization.preloadAccounts(new set<id>(accountids));

// later in the code 
for (id accId : accountids){
Account acc = MakingStaticSOQL_Optimization.getAccountById(accId);
System.debug('Account Name: '+ acc.name);
}
*/
}