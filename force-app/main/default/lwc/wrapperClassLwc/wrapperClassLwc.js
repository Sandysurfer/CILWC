import { LightningElement, wire, track } from 'lwc';
import getAllAccountWithContacts from '@salesforce/apex/AccountContactController.getAllAccountWithContacts'
import createAccountContact from '@salesforce/apex/AccountLightningService.createAccountContact';

export default class WrapperClassDemo extends LightningElement {

    //Sending Wrapper From Apex to Lwc Object....

    @track accountsWithContacts;
    @track error;
    @wire(getAllAccountWithContacts) wiredAccountWithContacts({ error, data }) {
        if (data) {
            this.accountsWithContacts = data;
            console.log('Data--->' + JSON.stringify(data));
        } else if (error) {
            this.error = error;
            console.error('Error--->', error);
        }
    }

    //Sending Object from Lwc to Apex Wrapper (Using Imperative method)......
    contacts = [];
    error;

    handleClick() {
        var conData =
        {
            LastName: 'haldiram',
            Email: 'haldiram@gmail.com',
            Phone: '546854685151'
        };
        this.contacts.push(conData);

        var accData =
        {
            Name: 'NagpurFoods',
            NoOfContacts: 2,
            Contacts: this.conData
        };

        createAccountContact({ accWrapper : accData })
            .then(result => {
                this.createdAccount = result;
                console.log('Data:' + JSON.stringify(this.createdAccount));
            }).catch(error => {
                console.log(error);
                this.error = error;
            });
    }
}