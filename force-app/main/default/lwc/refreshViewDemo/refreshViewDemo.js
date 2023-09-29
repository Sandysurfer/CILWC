/* eslint-disable no-unused-expressions */
import { LightningElement, api } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateAccountName from '@salesforce/apex/AccountNameRefreshHandler.updateAccountName';

export default class RefreshAccountData extends LightningElement {
    @api recordId;

    //1.)Use Case While Updating Account Name using refresh view api....
    //Using async await in place of promises...

    async refreshViewHandler() {
        let acc = this.refs.accNameRef.value;    //Replacement of (this.template.queryselector.value).....
        console.log('Account Input Name == ', acc);
        await updateAccountName({ Id: this.recordId, Name: acc });

        //RefreshView in Lwc
        this.showToast("Success!", "Account Name has been updated successfully.", "Success");
        this.dispatchEvent(new RefreshEvent());
        console.log('Event is dispatch');
    }


    //2.) Use Case While Uploading file use of refreshview api..
    get acceptedFormats() {
        return ['.pdf', '.png'];
    }

    handleUploadFinished() {
        this.showToast("Success!", "Attachment has been uploaded successfully.", "Success");
        this.dispatchEvent(new RefreshEvent());
    }

    //Reusing Toast Message Component....
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }
}