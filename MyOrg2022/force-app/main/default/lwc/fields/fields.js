import { LightningElement,api,track} from 'lwc';

export default class Fields extends LightningElement {
    @api itemName = 'New Item';
    firstName = '';
    lastName = '';
    @track x;
    //fullName = { firstName : '', lastName : ''};
    handleChange(event){
        const field = event.target.name;
        if(field==='firstName'){
         this.firstName = event.target.value;
        // this.fullName = { firstName : 'John', lastName : 'Doe'};
        }else if (field==='lastName'){
         this.lastName = event.target.value;
        }
    }
    get uppercasedFullName() {
        return `${this.firstName} ${this.lastName}`.trim().toUpperCase();
    }
    initDate(){
        this.x= new Date();
    }
    updateDate() {
        this.x.setHours(7);
    }
}