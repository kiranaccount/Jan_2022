import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import D3 from '@salesforce/resourceUrl/d3';
//import DATA from './data';
export default class HelloWorld extends LightningElement {
    @track greeting = 'World';
    changeHandler(event) {
        this.greeting = event.target.value;
    }
}