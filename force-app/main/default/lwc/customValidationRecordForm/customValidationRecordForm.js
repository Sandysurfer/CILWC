import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CustomValidationRecordForm extends LightningElement {

    isInputValid() {

        let isValid = true;
        let inputFields = this.template.querySelectorAll('lightning-inputfield');

        inputFields.forEach(inputField => {
            if (!inputField.reportValidity()) {
                isValid = false;
            }
        });
        return isValid;
    }

    handleSubmit() {
        // Custom logic before submission
        let isValid = this.isInputValid();
        if (isValid) {
            // Submit the form
            this.template.querySelector('lightning-record-edit-form').submit();
        }
    }

    handleSuccess() {
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Contact created successfully.',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(toastEvent);
    }


}