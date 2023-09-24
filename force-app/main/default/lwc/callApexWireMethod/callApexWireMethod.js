import { LightningElement, wire } from "lwc";
import getAccountList from "@salesforce/apex/CallApexUsingWireMethod.getAccountList";
import findContactList from "@salesforce/apex/CallApexUsingWireMethod.findContactList";
import findAccountList from "@salesforce/apex/CallApexUsingWireMethod.findAccountList";
import passAccountList from "@salesforce/apex/CallApexUsingWireMethod.passAccountList";
export default class CallApexWireMethod extends LightningElement {
  //Wire as a Property without paramter...
  @wire(getAccountList) accounts;

  //Wire as a Property With Parameter...
  searchContactKey;
  contacts;

  handleContactChange(event) {
    this.searchContactKey = event.target.value;
  }

  @wire(findContactList, { searchContacts: "$searchContactKey" }) contacts;

  //Wire as a Function with Parameter...
  accList;
  SearchcAccountKey;
  error;

  handleAccountChange(event) {
    this.searchAccountKey = event.target.value;
  }

  @wire(findAccountList, { searchAccounts: "$searchAccountKey" })
  getAccounts({ data, error }) {
    if (data) {
      this.accList = data;
      console.log("accList-->" + JSON.stringify(this.accList));
    } else if (error) {
      this.error = error;
    }
  }

  //Wire as function without parameter..
  accountRecords;

  @wire(getAccountList)
  wiredAccounts({ error, data }) {
    if (data) {
      this.accountRecords = data;
      console.log("accList-->" + JSON.stringify(this.accountRecords));
    } else if (error) {
      this.error = error;
    }
  }

  //Passing Array of Account from lwc to apex Using wire as function with parameter...
  newAccList;
  accountArray = ["Madrid", "Barcelona", "Sevilla"];

  @wire(passAccountList, { newAccountList: "$accountArray" })
  wiredAccounts({ data, error }) {
    if (data) {
      this.newAccList = data;
      console.log("Account Data-->" + JSON.stringify(this.newAccList));
    } else if (error) {
      console.log("Accout Error-->" + error);
    }
  }
}
