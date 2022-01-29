import { LightningElement,api } from 'lwc';

export default class CollapsibleSections extends LightningElement {

    @api name;
    @api show = false;
}