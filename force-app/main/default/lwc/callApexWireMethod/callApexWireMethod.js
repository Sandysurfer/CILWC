import { LightningElement, wire } from 'lwc';
import getAccountList from '@salesforce/apex/CallApexUsingWireMethod.getAccountList';
import findContactList from '@salesforce/apex/CallApexUsingWireMethod.findContactList';
import findAccountList from '@salesforce/apex/CallApexUsingWireMethod.findAccountList';
import passAccountList from '@salesforce/apex/CallApexUsingWireMethod.passAccountList';
export default class CallApexWireMethod extends LightningElement {

  //Wire as a Property without paramter...    
  @wire(getAccountList) accounts;

  searchContactKey;
  contacts;

  handleContactChange(event) {
    this.searchContactKey = event.target.value;
  }

  //Wire as a Property With Parameter...  
  @wire(findContactList, { searchContacts: '$searchContactKey' }) contacts;


  accList;
  SearchcAccountKey;
  error;

  handleAccountChange(event) {
    this.searchAccountKey = event.target.value;
  }

  //Wire as a Function with Parameter...
  @wire(findAccountList, { searchAccounts: '$searchAccountKey' }) getAccounts({ data, error }) {
    if (data) {
      this.accList = data;
      console.log('accList-->' + JSON.stringify(this.accList));
    }
    else if(error) {
      this.error = error;
    }
  }

  //Passing New Account array from lwc to apex...
   newAccList;
   accountArray = ["Madrid","Barcelona","Sevilla"];

  @wire(passAccountList, {newAccountList : '$accountArray'}) newAccount ({data, error}) {
      if (data) {
        this.newAccList = data
        console.log('Account Data-->'+JSON.stringify(this.newAccList));
      } else if (error) {
        console.log('Accout Error-->'+error);
      }
  }
}