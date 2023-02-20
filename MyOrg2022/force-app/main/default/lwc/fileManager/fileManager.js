import { LightningElement, track, wire } from 'lwc';
import getFiles from '@salesforce/apex/FileManager.getFiles';
import deleteFiles from '@salesforce/apex/FileManager.deleteFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';


export default class FileManager extends LightningElement {
    @track columns = [
        { label: 'Name', fieldName: 'Title' },
        { label: 'Id', fieldName: 'Id' },
        { label: 'Size', fieldName: 'ContentSize'},
        { label: 'Owner', fieldName: 'OwnerName'}
    ];
   @track contentList;
   @track fileRecords;
   @track hasRendered = true;
   @track isDialogVisible = false;
   @track isButtonVisible = false;
   @track originalMessage;

   recordIds = [];
   error;
   @track selectedRows;

           

            @wire (getFiles) wiredFiles(result){
                if (result.data) {
                    this.fileRecords = result;
                    let tempRecords = JSON.parse( JSON.stringify( result.data ) );
                    tempRecords = tempRecords.map( row => {
                    //  var csize = formatBytes(row.ContentSize,2);
                    //  console.log('csize'+formatBytes(1000000,''));
                    if (row.ContentSize === 0) row.ContentSize = '0 Bytes';
                    const k = 1024;
                    const dm = 2 < 0 ? 0 : 2;
                    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
                    const i = Math.floor(Math.log(row.ContentSize) / Math.log(k));
                    row.ContentSize = parseFloat((row.ContentSize / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
                        return { ...row, OwnerName: row.Owner.Name };
                    })
                  //  console.log('Data'+JSON.stringify(result.data)); 
                    this.contentList = tempRecords;
                    this.error = undefined;
                } else if (result.error) {
                    console.log(error);
                }
            }
       
            handleRowSelection(event) {
                var rows =event.detail.selectedRows;
                if(rows.length>=1){
                    this.isButtonVisible=true;
                }else{
                    this.isButtonVisible=false;
                }
            }

    handleClick(event){
        if(event.target.name === 'openConfirmation'){
           this.recordIds = [];
           this.selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
            for(var i=0;i<this.selectedRows.length;i++){
                this.recordIds.push(this.selectedRows[i].Id);
            }
             //shows the component
            this.isDialogVisible = true;
        }else if(event.target.name === 'confirmModal'){

            //when user clicks outside of the dialog area, the event is dispatched with detail value  as 1
            if(event.detail !== 1){
              
                //you can do some custom logic here based on your scenario
                if(event.detail.status === 'confirm') {
                   console.log('Confirm');
                   deleteFiles({ recordIds: this.recordIds })
                   .then((result) => {
                       console.log('this.result'+result);
                      
                       const evt = new ShowToastEvent({
                           title: 'Files deleted successfully',
                           message: result.result,
                           variant: 'success',
                       });
                       this.dispatchEvent(evt);
                       this.template.querySelector('lightning-datatable').maxRowSelection=0;
                       this.template.querySelector('lightning-datatable').maxRowSelection=500;
                       this.selectedRows = [];
                       //refreshApex(this.fileRecords);
                      return refreshApex(this.fileRecords); 
                      
                   })
                   .catch((error) => {
                       this.error = error;
                     
                   });
                }else if(event.detail.status === 'cancel'){
                    console.log('cancel');
                    this.selectedRows = [];
                    this.template.querySelector('lightning-datatable').maxRowSelection=0;
                    this.template.querySelector('lightning-datatable').maxRowSelection=500;
                }
            }

            //hides the component
            this.isDialogVisible = false;
        }
    }

    
}