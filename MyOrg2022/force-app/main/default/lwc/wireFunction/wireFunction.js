import { LightningElement, api } from 'lwc';

/*import ACCOUNT_FIELD from '@salesforce/schema/Account.Name';
import NAME_FIELD from '@salesforce/schema/Account.Active__c';
import TITLE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import EMAIL_FIELD from '@salesforce/schema/Account.OwnerId';*/
import Id from '@salesforce/user/Id';
//import user_name from '@salesforce/schema/user.IsActive';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';


export default class WireFunction extends LightningElement {
    // Flexipage provides recordId and objectApiName
    @api recordId = Id;
    @api  objectApiName ='User';

    //fields = [ACCOUNT_FIELD, NAME_FIELD, TITLE_FIELD, PHONE_FIELD,EMAIL_FIELD];
    fields = [PHONE_FIELD];
    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        fields.PHONE_FIELD = 'My Custom Last Name'; // modify a field
        this.template.querySelector('lightning-record-form').submit(fields);
     }

}