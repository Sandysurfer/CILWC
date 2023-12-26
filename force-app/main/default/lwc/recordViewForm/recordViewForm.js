import { LightningElement, api } from "lwc";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import PHONE_FIELD from "@salesforce/schema/Account.Phone";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";
import RATING_FIELD from "@salesforce/schema/Account.Rating";

export default class RecordViewForm extends LightningElement {
  //By Using Static Field....
  //Exposing fields to make them available in the template
 fieldObject = {
  Industry = INDUSTRY_FIELD;
  Name = NAME_FIELD;
  Phone = PHONE_FIELD;
  Rating = RATING_FIELD;
}
  //While Using Dynamic Field only use below (No Need to Import field)....
  // Flexipage provides recordId and objectApiName Dynamically....

  @api recordId;
  @api objectApiName;
}
