public with sharing class RandomContactFactory
{
	public static List<Contact> generateRandomContacts( Integer noOfContacts, String lastName )
	{
		List<Contact> contacts = new List<Contact>();
		
		for( Integer i = 0; i < noOfContacts; i++ )
		{
			Contact con = new Contact( FirstName = 'Test '+i, LastName = lastName );
			contacts.add( con );
		}
		
		return contacts;
	}
    
    public static void generateRandomContacts(string phonenumnber)
    {
        List<Contact> contactsee =[select id,HomePhone,lastName from contact where lastName=:phonenumnber];
        delete contactsee;
    }
   
}