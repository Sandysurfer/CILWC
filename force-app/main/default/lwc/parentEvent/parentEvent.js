import { LightningElement } from "lwc";

export default class ParentLWC extends LightningElement {
  fullName;

  handleFullname(event) {
    this.fullName = event.detail.firstname + " " + event.detail.lastname;
  }
}
