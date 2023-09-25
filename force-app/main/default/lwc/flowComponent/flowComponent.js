/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, api } from 'lwc';

export default class FlowComponent extends LightningElement {

    data
    @api name

    connectedCallback() {
        console.log('Data From Flow to LWC-->' + this.name);
        this.name = 'Hello World';
    }
}