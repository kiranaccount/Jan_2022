import { LightningElement,api, wire } from 'lwc';
import getrecord from '@salesforce/apex/GetLiberay.getLiberyItems';
import { NavigationMixin } from 'lightning/navigation';

const actions = [  
  { label: 'Preview', name: 'Preview' }
];
const columns = [     
          {
            label: 'Title',
            fieldName: 'accountIdForURL',
            type: 'url',
            typeAttributes: {label: { fieldName: 'Title' }, 
            target: '_blank'}
          },
                 
          {
            label: "Last modified date",
            fieldName: "LastModifiedDate",
            type: "date",
            typeAttributes:{
                year: "numeric",
                month: "long",
                day: "2-digit",
                hour: "2-digit",
                minute: "2-digit"
            }
          },
          { type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'left' } } 
             
];

export default class LibraryRecordBasedOnID extends NavigationMixin(LightningElement) {
 columns = columns; 
@api recordId;
libraryRecords=[];

@wire(getrecord, {contectid:'0580o000001AEQkAAO'})
wiredRecord({error,data}){
 if(data){ 
   let accountContractArray = [];
   //add each row data in array using for loop
   data.forEach(contentList => {    
       let contentDocsRows = {};
       contentDocsRows.Title = contentList.Title;
       contentDocsRows.ContentDocumentId = contentList.ContentDocumentId;
       contentDocsRows.FileType = contentList.FileType;
       contentDocsRows.Description = contentList.Description;
       contentDocsRows.VersionDataURL = contentList.VersionDataURL;   
       contentDocsRows.LastModifiedDate = contentList.LastModifiedDate; 
       contentDocsRows.accountIdForURL = '/' + contentList.Id;
       accountContractArray.push(contentDocsRows);
       
   });
   //assign the array to variable which will store data to be shown in the datatable
   this.libraryRecords = accountContractArray;
 }else if(error){
    console.error(error);
 }
}

handleRowAction(event) {
  const action = event.detail.action;
  const row = event.detail.row;
  switch (action.name) {      
      case 'Preview':        
        var currentid = JSON.stringify(row.ContentDocumentId);
        this[NavigationMixin.Navigate]({
          type: 'standard__namedPage',
          attributes: {
              pageName: 'filePreview'
          },
          state : {
              recordIds: currentid,
              selectedRecordId:currentid  
          }
        });
          break;
}
}}