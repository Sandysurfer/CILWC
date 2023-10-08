/* eslint-disable no-unused-vars */
import { LightningElement, wire } from "lwc";
import { updateRecord } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getContactList from "@salesforce/apex/CallApexUsingWireMethod.getContactList";
import FIRST_NAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LAST_NAME_FIELD from "@salesforce/schema/Contact.LastName";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import ID_FIELD from "@salesforce/schema/Contact.Id";

const COLS = [
  { label: "First Name", fieldName: "FirstName", type: "text", editable: "true" },
  { label: "Last Name", fieldName: "LastName", type: "text", editable: "true" },
  { label: "Phone", fieldName: "Phone", type: "Phone", editable: "true" },
  { label: "Email", fieldName: "Email", type: "Email", editable: "true" }
];

export default class LwcDatatable extends LightningElement {
  columns = COLS;
  draftValues = []; //When a user edits a cell, the updated value is stored in draft-values.

  @wire(getContactList) contacts;

  handleSave(event) {
    const updatedRecord = event.detail.draftValues[0];

    const fields = {};
    fields[ID_FIELD.fieldApiName] = updatedRecord.Id;
    fields[FIRST_NAME_FIELD.fieldApiName] = updatedRecord.FirstName;
    fields[LAST_NAME_FIELD.fieldApiName] = updatedRecord.LastName;
    fields[PHONE_FIELD.fieldApiName] = updatedRecord.Phone;
    fields[EMAIL_FIELD.fieldApiName] = updatedRecord.Email;

    const recordData = { fields };

    // Clear all datatable draft values
    this.draftValues = [];

    // Update Record Using lightning/uiRecord Api...
    updateRecord(recordData)
      .then((result) => {
        // Display success with a toast message, on Record Detail Page
        console.log("Before dispatching toast event");
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Contacts updated",
            variant: "success"
          })
        );

        // Display fresh data in the datatable...
        return refreshApex(this.contacts);
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error updating or reloading contacts",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}
