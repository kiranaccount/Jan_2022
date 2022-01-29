import { LightningElement } from 'lwc';

export default class All_parent_test_cmp extends LightningElement {
     lookupRecord(event){
        alert('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
    }
}