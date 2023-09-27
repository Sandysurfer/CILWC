import { LightningElement, track } from "lwc";
import getAccounts from "@salesforce/apex/CallApexUsingImperative.getAccounts";

export default class LwcCombobox extends LightningElement {
  //Combobox to get accounts of salesforce using imperative method...
  @track value = "";
  @track accOptions = [];

  get options() {
    return this.accOptions;
  }
  connectedCallback() {
    getAccounts()
      .then(result => {
        let arr = [];
        for (let i = 0; i < result.length; i++) {
          arr.push({ label: result[i].Name, value: result[i].Id });
        }
        this.accOptions = arr;
      });
  }
  handleChange(event) {
    this.value = event.detail.value;
  }

  //Combobox to display input value and picklist field value when selected on UI...

  selectedSalutation = "--Select--";
  firstName = "";
  middleName = "";
  lastName = "";

  get salutationOptions() {
    return [
      { label: "--Select--", value: "" },
      { label: "Mr.", value: "Mr." },
      { label: "Mrs", value: "Mrs." }
    ];
  }

  handleFirstNamechange(event) {
    this.firstName = event.target.value;
  }
  handleMiddleNamechange(event) {
    this.middleName = event.target.value;
  }
  handleLastNamechange(event) {
    this.lastName = event.target.value;
  }
  handleSalutationChange(event) {
    this.selectedSalutation = event.target.value;
  }
}
