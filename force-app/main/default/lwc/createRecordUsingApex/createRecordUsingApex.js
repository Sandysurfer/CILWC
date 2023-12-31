import { LightningElement } from 'lwc';
import createClientRecords from '@salesforce/apex/ClientController.createClientRecords';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
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
                this.dispatchEvent(
                    new ShowToastEvent({
                      title: "Success",
                      message: "Client Record created Successfully",
                      variant: "success",
                      mode: 'dismissable'
                    })
                  );
            })
            .catch(error => {
                console.log('Error-->' + JSON.stringify(error));
                this.dispatchEvent(
                    new ShowToastEvent({
                      title: "Error creating record",
                      message: error.body.message,
                      variant: "error"
                    })
                  );
            })

    }
}

