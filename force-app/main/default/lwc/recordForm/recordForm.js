import { LightningElement, api } from "lwc";
import ACCOUNT_FIELD from "@salesforce/schema/Contact.AccountId";
import NAME_FIELD from "@salesforce/schema/Contact.Name";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";

export default class LdsrecordForm extends LightningElement {
  // Flexipage provides recordId and objectApiName Static Contact....
  // @api recordId;
  // @api objectApiName;

  //fields = [ACCOUNT_FIELD, NAME_FIELD, PHONE_FIELD, EMAIL_FIELD];

  // Flexipage provides recordId and objectApiName Dynamic Contact(No need to import fields)....
  @api recordId;
  @api objectApiName;
  fields = ["AccountId", "Name", "Phone", "Email"];
}
