public class FieldPermissionUpdateAutomatedProcess{
    public static String getFieldstoUpdate(String sObjectType,String lstcols){      
        String selectColumns;
        if(!String.isEmpty(lstcols)){
            selectColumns=lstcols;
        }else{
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectType).getDescribe().fields.getMap();      
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                    if(selectColumns=='')
                        selectColumns=dfield.getname();
                    else
                        selectColumns=selectColumns+','+dfield.getname();

            }
        }
        return selectColumns;
    }
    public static List<FieldPermissions> getFieldPermSet(String sObjectType,String operation,String fields,List<Id> profpermId){
        List<FieldPermissions> lstfldprm=New List<FieldPermissions>();
        List<String> fldlst=New List<String>();
        for(String fld:fields.split(',')){
            fldlst.add(sObjectType+'.'+fld);
        }
        Map<String,FieldPermissions> mapfdm=New Map<String,FieldPermissions>();
        String soql='Select Id,ParentId,field from FieldPermissions where sObjectType=:sObjectType and ParentId in :profpermId and field in :fldlst';
        /*if(operation=='Edit'){
            soql+='PermissionsEdit=true';
        }else{
            soql+='PermissionsRead=true';
        }*/
        for(FieldPermissions fdpm:database.query(soql)){
            mapfdm.put(fdpm.ParentId+fdpm.field,fdpm);
        }
        for(String s:fldlst){
            for(Id prof:profpermId){
            if(mapfdm.size()>0 && mapfdm.containsKey(prof+s)){
                FieldPermissions fldpermisn=mapfdm.get(prof+s);     
                if(operation=='Edit'){
                    fldpermisn.PermissionsEdit=true;
                    fldpermisn.PermissionsRead=true;
                }else{
                    fldpermisn.PermissionsRead=true;
                    fldpermisn.PermissionsEdit=false;
                }   
                lstfldprm.add(fldpermisn); 
                System.debug('Inside if'+ lstfldprm);     
            }else{
                FieldPermissions fldpermisn=New FieldPermissions();
                fldpermisn.field=s;
                fldpermisn.sObjectType=sObjectType;
                if(operation=='Edit'){
                    fldpermisn.PermissionsEdit=true;
                    fldpermisn.PermissionsRead=true;
                }else{
                    fldpermisn.PermissionsRead=true;
                    fldpermisn.PermissionsEdit=false;
                }
                fldpermisn.ParentId=prof;    
                lstfldprm.add(fldpermisn);  
                System.debug('Inside else'+ lstfldprm);         
            }           
            }//for
        }
        System.debug(lstfldprm);
        return lstfldprm;       
    }
    public static List<FieldPermissions> getFieldPermSetDel(String sObjectType,String operation,String fields,List<Id> profpermId){
        List<FieldPermissions> lstfldprm=New List<FieldPermissions>();
        List<String> fldlst=New List<String>();
        for(String fld:fields.split(',')){
            fldlst.add(sObjectType+'.'+fld);
        }
        String soql='Select Id from FieldPermissions where sObjectType=:sObjectType and ParentId in :profpermId and field in :fldlst and ';
        if(operation=='Edit'){
            soql+='PermissionsEdit=true';
        }else{
            soql+='PermissionsRead=true';
        }
        for(FieldPermissions fdpm:database.query(soql)){
            FieldPermissions fldpermisn=New FieldPermissions();
            fldpermisn.Id=fdpm.Id;
            if(operation=='Edit'){
                fldpermisn.PermissionsEdit=false;
            }else{
                fldpermisn.PermissionsRead=false;
                fldpermisn.PermissionsEdit=false;
            }
            lstfldprm.add(fldpermisn);
        }
        System.debug(lstfldprm);
        return lstfldprm;       
    }
    
    public static List<Id> getProfilePermission(List<String> profiles){
        List<Id> ProfPermList=New List<Id>();
        for(PermissionSet pm:[SELECT Id,Profile.Name FROM PermissionSet where Profile.Name in :profiles and IsOwnedByProfile=true]){
                    ProfPermList.add(pm.Id);
        }   
        return ProfPermList;
    }
    public static void addPermissionSetRead(String sObjectType,String lstcols,List<String> Profiles){
        if(!String.isEmpty(sObjectType)){
            String fieldtoaddPerms=getFieldstoUpdate(sObjectType,lstcols);
            if(!String.isEmpty(fieldtoaddPerms) && Profiles.size()>0){
                List<Id> ProfPermListId=getProfilePermission(Profiles);
                if(ProfPermListId!=null){
                    List<FieldPermissions> fldprmlst=getFieldPermSet(sObjectType,'Read',lstcols,ProfPermListId);
                    if(fldprmlst.size()>0){
                        try{
                            upsert fldprmlst;
                        }catch(exception e){
                             system.debug(e);        
                        } 
                    }
                }
            }          
        }else{
            System.debug('sObject should be populated');
        }
    }
    public static void addPermissionSetEdit(String sObjectType,String lstcols,List<String> Profiles){
        if(!String.isEmpty(sObjectType)){
            String fieldtoaddPerms=getFieldstoUpdate(sObjectType,lstcols);
            if(!String.isEmpty(fieldtoaddPerms) && Profiles.size()>0){
                List<Id> ProfPermListId=getProfilePermission(Profiles);
                if(ProfPermListId!=null){
                    List<FieldPermissions> fldprmlst=getFieldPermSet(sObjectType,'Edit',lstcols,ProfPermListId);
                    if(fldprmlst.size()>0){
                        try{
                            upsert fldprmlst;
                        }catch(exception e){
                             system.debug(e);        
                        } 
                    }
                }
            }
        }else{
            System.debug('sObject should be populated');
        }
    }
    public static void deletePermissionSetRead(String sObjectType,String lstcols,List<String> Profiles){
        if(!String.isEmpty(sObjectType)){
            String fieldtoaddPerms=getFieldstoUpdate(sObjectType,lstcols);
            if(!String.isEmpty(fieldtoaddPerms) && Profiles.size()>0){
                List<Id> ProfPermListId=getProfilePermission(Profiles);
                if(ProfPermListId!=null){
                    List<FieldPermissions> fldprmlst=getFieldPermSetDel(sObjectType,'Read',lstcols,ProfPermListId);
                    if(fldprmlst.size()>0){
                        try{
                            update fldprmlst;
                        }catch(exception e){
                             system.debug(e);        
                        } 
                    }
                }
            }
        }else{
            System.debug('sObject should be populated');
        }
    }
    public static void deletePermissionSetEdit(String sObjectType,String lstcols,List<String> Profiles){
        if(!String.isEmpty(sObjectType)){
            String fieldtoaddPerms=getFieldstoUpdate(sObjectType,lstcols);
            if(!String.isEmpty(fieldtoaddPerms) && Profiles.size()>0){
                List<Id> ProfPermListId=getProfilePermission(Profiles);
                if(ProfPermListId!=null){
                    List<FieldPermissions> fldprmlst=getFieldPermSetDel(sObjectType,'Edit',lstcols,ProfPermListId);
                    if(fldprmlst.size()>0){
                        try{
                            update fldprmlst;
                        }catch(exception e){
                             system.debug(e);        
                        } 
                    }
                }
            }
        }else{
            System.debug('sObject should be populated');
        }
    }
}