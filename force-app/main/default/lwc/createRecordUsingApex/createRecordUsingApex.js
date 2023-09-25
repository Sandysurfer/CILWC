import { LightningElement } from 'lwc';
import createClientRecords from '@salesforce/apex/ClientController.createClientRecords';
export default class CreateRecordUsingApex extends LightningElement {

    clientName;
    clientPhone;
    clientEmail;

    handleNameChange(event) {
        this.clientName = event.target.value;
    }
    handlePhoneChange(event) {
        this.clientPhone = event.target.value;
    }

    handleEmailChange(event) {
        this.clientEmail = event.target.value;
    }

    handleClientRecord() {
        //Creating Client Record By Calling Apex Mehtods...
        createClientRecords({ clName: this.clientName, clPhone: this.clientPhone, clEmail: this.clientEmail })
            .then(result => {
                console.log('client Record-->' + JSON.stringify(result));
            })
            .catch(error => {
                console.log('Error-->' + JSON.stringify(error));
            })

    }
}

