import { LightningElement, wire } from 'lwc';
import fetchAccountContactDetails from '@salesforce/apex/AccountContactWrapperDemo.fetchAccountContactDetails';

const columns = [
    {
        label: 'Account Name',
        fieldName: 'AccountLink',
        type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'AccountName'
            },
            target: '_blank'
        }
    },
    {
        label: 'Type',
        fieldName: 'type'
    },
    {
        label: 'Total Contacts',
        fieldName: 'totalContacts'
    },
    {
        label: 'Address',
        fieldName: 'billingAddress'
    }
];

export default class WrapperDemo extends LightningElement {

    columns = columns;
    data;
    error;
    @wire(fetchAccountContactDetails)
    wiredAccounts({ data, error }) {
        if (data) {
            this.data = data;
        }
        else {
            this.error = error;
        }
    }

}