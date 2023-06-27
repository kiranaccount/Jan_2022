/*write a trigger when contact last name updated are changed need to update the related account descpration.*/


trigger contactCascade on contact(after update, after insert){
	
	map<id,contact> contatMap = new map<id,contact>();
	map<id,account> accountMap = new map<id,Account>();
	
	if(trigger.isAfter && trigger.Isupdate){
		for(contact c: trigger.new){
		 if(c.lastname != trigger.oldmap.get(c.id).lastname){
			 contatMap.put(c.accountId,c);
		 }
	   }
	
	
	    if(contatMap.values().size()>0){
		for(account ac: [select id,name,description from account where id=:contatMap.keyset()]){
			contact c = contatMap.get(ac.id);
			if(c != null){
				ac.description = c.lastName;
			}
			accountMap.put(ac.id,ac);
		}
	}
	
	if(accountMap.values().size()>0){update accountMap.values();}
	
	}
	
}