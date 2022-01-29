import { LightningElement,api } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';


export default class UserDetiledPageCloneTest extends LightningElement {
    activeSections = ['A'];
    activeSectionsMessage = '';
    @api show =false;

    @api recordId='0010o00002b8ZXPAA2';
    @api objectApiName='Account';

    fields = [NAME_FIELD, REVENUE_FIELD, INDUSTRY_FIELD];

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        fields.LastName = 'My Custom Last Name'; // modify a field
        this.template.querySelector('lightning-record-form').submit(fields);
     }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
        console.log("openSections===>"+openSections)
        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
            console.log("openSections===>"+openSections);
           // alert("openSections===>"+openSections);
            this.show = false;
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
                //alert("openSections in else ===>"+openSections);
                this.show = true;
        }
    }
}