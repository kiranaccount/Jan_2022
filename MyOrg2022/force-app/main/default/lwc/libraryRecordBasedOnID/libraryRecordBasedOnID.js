import { LightningElement,api, wire } from 'lwc';
import getrecord from '@salesforce/apex/GetLiberay.getLiberyItems';
import { NavigationMixin } from 'lightning/navigation';

const columns = [    
  {
            label: 'Title',
            fieldName: 'accountIdForURL',
            type: 'url',
            typeAttributes: {label: { fieldName: 'Title' }, 
            target: '_blank'}
                   },
                    {
            label: 'VersionDataURL',
            fieldName: 'Title',
            type: 'url',
            typeAttributes: {label: { fieldName: 'VersionDataURL' }, 
            target: '_self'}
                   },
    

    { label: 'FileType', fieldName: 'FileType', type: 'string'},
   // { label: 'Title', fieldName: 'Title',type: 'string' },
    { label: 'Description', fieldName: 'Description', type: 'textarea', wrapText: true},  
   
  
];

export default class LibraryRecordBasedOnID extends LightningElement {
 columns = columns; 
@api recordId='0580o000001AEQkAAO';
searchKey ='0580o000001AEQkAAO'
libraryRecords=[];

@wire(getrecord, {contectid:'0580o000001AEQkAAO'})
wiredRecord({error,data}){
 if(data){ 
  
   //this.libraryRecords =data;

   let accountContractArray = [];
   //add each row data in array using for loop
   data.forEach(accountContract => {    
       let accountContractRow = {};
       accountContractRow.Title = accountContract.Title;
       accountContractRow.ContentDocumentId = accountContract.ContentDocumentId;
       accountContractRow.FileType = accountContract.FileType;
       accountContractRow.Description = accountContract.Description;
       accountContractRow.VersionDataURL = accountContract.VersionDataURL;

       //accountContractRow.accountIdForURL =  accountContract.Id; 

       accountContractRow.accountIdForURL = '/' + accountContract.Id;  //This field will be used for navigation to the account
       //You can add rest of the fields in similar way.
       //push row into array
      // alert(JSON.stringify('11111---->'+accountContractArray));
       accountContractArray.push(accountContractRow);
       
   });
   //alert(JSON.stringify('22222---->'+accountContractArray));
   //assign the array to variable which will store data to be shown in the datatable
   this.libraryRecords = accountContractArray;

   alert(JSON.stringify(this.libraryRecords));

 }else if(error){
    console.error(error);
 }
}

/*

viewPdf(event) {
  this[NavigationMixin.Navigate]({
    type: 'standard__namedPage',
    attributes: {
        pageName: 'filePreview'
    },
    state : {
        recordIds: '069xx0000000001AAA'  
    }
  });
}
*/

navigateToFiles(event) {
  this.record = event.detail.row;
  alert(JSON.stringify('22222---->'+this.record.id));
  this[NavigationMixin.Navigate]({
    type: 'standard__namedPage',
    attributes: {
        pageName: 'filePreview'
    },
    state : {
        recordIds: this.record.id,
        //selectedRecordId:'069xx0000000001AAA'
    }
  })
}
}