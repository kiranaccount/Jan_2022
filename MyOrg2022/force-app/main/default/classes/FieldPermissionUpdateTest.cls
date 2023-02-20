@isTest
public class FieldPermissionUpdateTest {
    static testMethod void addPermissionSetReadMethod(){
        List<String> prf=New List<String>();
        prf.add('Marketing User');
        FieldPermissionUpdateAutomatedProcess.addPermissionSetRead('Account','billingAddress',prf);        
    }
    
    static testMethod void addPermissionSetEditMethod(){
        List<String> prf=New List<String>();
        prf.add('Marketing User');
        FieldPermissionUpdateAutomatedProcess.addPermissionSetEdit('Account','billingAddress',prf);
    }
    
    static testMethod void deletePermissionSetEditMethod(){
        List<String> prf=New List<String>();
        prf.add('Marketing User');
        FieldPermissionUpdateAutomatedProcess.deletePermissionSetEdit('Account','billingAddress',prf);
    }
    
    static testMethod void deletePermissionSetReadMethod(){
        List<String> prf=New List<String>();
        prf.add('Marketing User');
        FieldPermissionUpdateAutomatedProcess.deletePermissionSetRead('Account','billingAddress',prf);
    }
}