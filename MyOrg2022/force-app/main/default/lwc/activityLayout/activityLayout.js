import { LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACTIVITY_OBJECT from '@salesforce/schema/Task';
import fieldss from '@salesforce/schema/task.FSL__Count_of_Events__c';

export default class ActivityLayout extends LightningElement {
    activityFields = [fieldss];

    @wire(getObjectInfo, { objectApiName: ACTIVITY_OBJECT })
    activityObjectInfo({ data, error }) {
        if (data) {
            const fields = data.fields;
            this.activityFields = [
                { label: fields.Subject.label, value: fields.Subject.apiName },
                { label: fields.Priority.label, value: fields.Priority.apiName },
                // Add more fields here as needed
            ];
        } else if (error) {
            console.error(error);
        }
    }
}
