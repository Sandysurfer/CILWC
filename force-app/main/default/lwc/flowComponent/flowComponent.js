/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, api } from 'lwc';


export default class FlowComponent extends LightningElement {


    @api accName;
    @api accCount;
    @api accountRecords;

    connectedCallback() {
        console.log('Data From Flow to LWC-->' + this.accName);
        console.log('Count of Account-->' + JSON.stringify(this.accCount));
        console.log("AccountList-->" + JSON.stringify(this.accountRecords));

    }
    handleChange(event) {
        this.accName = event.target.value;
    }
}