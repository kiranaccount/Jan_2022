import { LightningElement } from 'lwc';

export default class Form extends LightningElement {
    myValue = 'initial value';

    handleChange(evt){
        console.log('Current value of the input: ' + evt.target.value);
        const typedValue = evt.target.value;
        const trimmedValue = typedValue.trim(); // trims the value entered by the user
        if (typedValue !== trimmedValue) {
            evt.target.value = trimmedValue;
        }
        this.myValue = trimmedValue; // updates the internal state
        console.log('Current value after trim  the myValue: ' + trimmedValue);
    }

}