/**************************************************************************************
Version     : 1.0 
Created Date: 12/07/2019
Function    : AccountsController.  
AccountsController class retuning the filedset values

Modification Log :
-----------------------------------------------------------------------------
* Developer                   Date                   Description
* ----------------------------------------------------------------------------                 
* Kiran g                   06/26/2019		         Original Version

*******************************************************************************************/
public class AccountsController { 
    /*
* Method name  : getAccounts
* Description  : AccountsController class retuning the filedset values
* Return Type  : list of Account 
* Parameter    : null 
*/
    @AuraEnabled
    public static List <Account> getAccounts() {
        List<Schema.FieldSetMember>  ftd = SObjectType.Account.FieldSets.properNames.getFields();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : ftd) {
            query += f.getFieldPath() + ', ';
        }
        system.debug(query +'Name FROM Account');
        query += 'Name FROM Account';
        list<account> accs =  Database.query(query);
        return accs;
    }  

 }