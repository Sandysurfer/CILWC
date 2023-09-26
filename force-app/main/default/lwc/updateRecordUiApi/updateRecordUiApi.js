import { LightningElement } from 'lwc';
import ID_FIELD from '@salesforce/schema/Account.Id';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import { updateRecord } from 'lightning/uiRecordApi';

export default class UpdateRecordUiApi extends LightningElement {

    idValue;
    nameValue;
    phoneValue;

    handleIdChange(event) {
        this.idValue = event.target.value
    }
    handleNameChange(event) {
        this.nameValue = event.target.value;
    }
    handlePhoneChange(event) {
        this.phoneValue = event.target.value;
    }

    handleUpdateRecord() {

        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.idValue;
        fields[NAME_FIELD.fieldApiName] = this.nameValue;
        fields[PHONE_FIELD.fieldApiName] = this.phoneValue;
        console.log('UpdateFields-->' + JSON.stringify(fields));

        const recordInput = { fields }

        updateRecord(recordInput)
            .then(result => {
                console.log('Result Data-->' + JSON.stringify(result));
            })
            .catch(error => {
                console.log('Error-->' + JSON.stringify(error));
            })
    }
}