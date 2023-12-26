import { LightningElement, track } from 'lwc';
import getSingleAccount from '@salesforce/apex/ContactController.getSingleAccount';
export default class LaunchFlowFromLwc extends LightningElement {

    @track singleAccount;

    connectedCallback() {

        getSingleAccount()
            .then((result) => {
                console.log('Result', result);
                this.singleAccount = result;
            })
            .catch((error) => {
                console.log('Error', error);
            })
    }

    get inputVariables() {
        return [
            {
                name: 'account',
                type: 'sObject',
                value: this.singleAccount
            }

        ];
    }

    handleStatusChange(event) {
        console.log('handleStatusChange', event.detail);

    }
}