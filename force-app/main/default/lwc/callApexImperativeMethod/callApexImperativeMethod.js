import { LightningElement,track } from 'lwc';
import getAccounts from '@salesforce/apex/CallApexUsingImperative.getAccounts';
import getClientsAddress from '@salesforce/apex/CallApexUsingImperative.getClientsAddress';
import findContactList from '@salesforce/apex/CallApexUsingImperative.findContactList';
import insertClientRecord from '@salesforce/apex/CallApexUsingImperative.insertClientRecord';
import passAccountList from '@salesforce/apex/CallApexUsingImperative.passAccountList';
export default class CallApexImperativeMethod extends LightningElement {

    accountRecords;
    clientRecords;

    searchKey = '';
    contacts;

    clientFirstName = '';
    clientLastName = '';

    //Calling Apex Using Imperative Method....
    //Get Account Records which is Active...
    handleClick1() {
        getAccounts().then((result) => {
            this.accountRecords = result;
            console.log('Data--->' + JSON.stringify(this.accountRecords));
        })
            .catch((error) => {
                this.error = error;
                console.log('Error--->' + this.error);
            });

        //console.log('Hi');
        //console.log('Hello');
    }

    //Get Clients Records With Realted Address....
    handleClick2() {
        let newclientData = [];
        getClientsAddress().then((result) => {
            this.clientRecords = result;
            for (let i = 0; i < this.clientRecords.length; i++) {
                if (this.clientRecords[i].Addresses__r) {
                    newclientData.push(this.clientRecords[i]);
                }
            }
            console.log('Data--->' + JSON.stringify(this.clientRecords));
            console.log('filtered Data-->' + JSON.stringify(newclientData));
        })
            .catch((error) => {
                this.error = error;
                console.log('Error--->' + this.error);
            });


    }

    //Search Contact Details --- (imperative method with Parameters)....
    handleSearchChange(event) {
        this.searchKey = event.target.value;
        console.log('SearchKey--->' + this.searchKey);
    }

    handleClick() {
        findContactList({ searchTerm: this.searchKey })
            .then(result => {
                this.contacts = result;
                console.log('Contacts--->' + JSON.stringify(this.contacts));
            })
            .catch(error => {
                this.error = error;
                console.log('Error--->' + this.error);
            });
    }

    //Create Client Records by passing data from lwc to apex(with Parameter) by using Imperative method...
    clientFirstName = '';
    clientLastName = '';
    clientEmail = '';

    handleFirstNameChange(event) {
        this.clientFirstName = event.target.value;
    }
    handleLastNameChange(event) {
        this.clientLastName = event.target.value;
    }
    handleEmailChange(event) {
        this.clientEmail = event.target.value;
    }
    handleCreateClient() {
        insertClientRecord({ clFirstName: this.clientFirstName, clLastName: this.clientLastName, clEmailId: this.clientEmail })
            .then(result => {
                this.createClient = result;
                console.log('createdClient--->' + JSON.stringify(this.createClient));
            })
            .catch(error => {
                this.error = error;
                console.log('Error--->' + JSON.stringify(this.error));
            });

    }

    //Passing Account Array from lwc to apex list<Account>...
    
    @track accountArray = ["united group", "stetig", "dreamforce"];

    handleAccountArray(){
        passAccountList({ accountList : this.accountArray })
            .then(result => {
                console.log('Account Result:-->'+JSON.stringify(result));
            })
            .catch(error => {
                console.error('Error Result:-->'+ error);
            });
    }
}