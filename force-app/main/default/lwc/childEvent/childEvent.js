import { LightningElement, track } from "lwc";

export default class ChildLWC extends LightningElement {
  @track contact = {
    firstname: "",
    lastname: ""
  };

  handleFirstNameChange(event) {
    this.contact.firstname = event.target.value;
  }

  handleLastNameChange(event) {
    this.contact.lastname = event.target.value;
  }

  handleFullNameChange() {
    const myevent = new CustomEvent("fulldata", {
      detail: {
        firstname: this.contact.firstname,
        lastname: this.contact.lastname
      }
    });
    this.dispatchEvent(myevent);
  }
}
