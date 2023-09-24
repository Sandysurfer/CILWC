import { LightningElement, api } from "lwc";
import ID_FIELD from "@salesforce/schema/Account.Id";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import PHONE_FIELD from "@salesforce/schema/Account.Phone";
import FAX_FIELD from "@salesforce/schema/Account.Fax";
import RATING_FIELD from "@salesforce/schema/Account.Rating";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class RecordEditForm extends LightningElement {
  //By Using Static Field....
  //Exposing fields to make them available in the template.
  nameField = NAME_FIELD;
  idField = ID_FIELD;
  phoneField = PHONE_FIELD;
  faxField = FAX_FIELD;
  ratingField = RATING_FIELD;

  //While Using Dyanamic Field only use below (No Need to Import field)....
  //Flexipage provides recordId and objectApiName Dynamically....
  @api recordId;
  @api objectApiName;

  handleReset() {
    const inputFields = this.template.querySelectorAll("lightning-input-field");
    if (inputFields) {
      inputFields.forEach((field) => {
        field.reset();
      });
    }
  }

  //Use of Toast Message to show Success message on Record page...
  handleSuccess(event) {
    const evt = new ShowToastEvent({
      title: "Account Record Created Successfully",
      message: "Record ID: " + event.detail.id,
      variant: "success"
    });
    this.dispatchEvent(evt);
  }
}
