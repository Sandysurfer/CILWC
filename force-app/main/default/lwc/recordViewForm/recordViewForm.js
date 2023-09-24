import { LightningElement, api } from "lwc";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import PHONE_FIELD from "@salesforce/schema/Account.Phone";
import FAX_FIELD from "@salesforce/schema/Account.Fax";
import RATING_FIELD from "@salesforce/schema/Account.Rating";

export default class RecordViewForm extends LightningElement {
  //By Using Static Field....
  //Exposing fields to make them available in the template

  faxField = FAX_FIELD;
  nameField = NAME_FIELD;
  phoneField = PHONE_FIELD;
  ratingField = RATING_FIELD;

  //While Using Dynamic Field only use below (No Need to Import field)....
  // Flexipage provides recordId and objectApiName Dynamically....

  @api recordId;
  @api objectApiName;
}
