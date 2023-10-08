import { LightningElement } from 'lwc';
import saveClientRecords from '@salesforce/apex/ClientController.saveClientRecords';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class CreateUpdateDeleteUsingApex extends NavigationMixin(LightningElement) {

    clientName;
    clientEmail;
    clientPhone;
    clientProgress;
    isLoading = false;
    recordId;

    clientStatus = [
        { label: 'New', value: 'new' },
        { label: 'In Progress', value: 'inProgress' },
        { label: 'Completed', value: 'completed' },
    ];

    get options() {
        return this.clientStatus;

    }

    handleChange(event) {
        let eventName = event.target.name;
        if (eventName === "clientname") {
            this.clientName = event.target.value;
        }
        else if (eventName === "phone") {
            this.clientPhone = event.target.value;
        }
        else if (eventName === "email") {
            this.clientEmail = event.target.value;
        }
        else if (eventName === "progress") {
            this.clientProgress = event.detail.value;
        }

    }
    handleSave() {
        this.isLoading = true;
        saveClientRecords({ clName: this.clientName, clPhone: this.clientPhone, clEmail: this.clientEmail, clStatus: this.clientProgress, recordId: this.recordId })
            .then(result => {
                this.isLoading = false;
                this.recordId = result;
                if (this.recordId) {
                    this.showSuccessHandle();
                    //Call NavigationMixin Component on Requirement..
                    this.navigateonrecordsview();
                }
                console.log('Records Data-->', result);
            })
            .catch(error => {
                console.log('Error Data-->', error);

            });
    }

    //Navigation to the view record...
    navigateonrecordsView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Client__c',
                actionName: 'view'
            }
        })
    }
    //Navigation to the edit record..
    navigateonrecordsEdit() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Client__c',
                actionName: 'edit'
            }
        })
    }
    //Navigation to the new record...
    navigateonrecordsNew() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Client__c',
                actionName: 'new'
            }
        })
    }
    //Navigation to the list view..
    navigateonrecordsList() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Client__c',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            }
        })
    }
    //Navigate to Record Home Page..
    navigateonrecordsHome() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Client__c',
                actionName: 'home'
            }
        })

    }
    //Navigate to Clients(Record_Manage Tab Page)...
    navigateonrecordsTabCustomer() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {

                apiName: 'Record_Manage'
            }
        })
    }
    //navigate url
    navigateonrecordsURL() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                "url": "https://www.linkedin.com/in/sandeep-yadav-2b889a21a/"
            }
        })
    }
    //Success toast message
    showSuccessHandle() {
        const evt = new ShowToastEvent({
            title: 'Success',
            message: 'Record created successfully!',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

}