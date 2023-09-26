import { LightningElement, api, wire, track } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import ACCOUNT_NAME_FIELD from "@salesforce/schema/Account.Name";
import ACCOUNT_PHONE_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_INDUSTRY_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_OWNER_FIELD from '@salesforce/schema/Account.Owner.Name';

export default class GetRecordWire extends LightningElement {
  @api recordId;
  @track accountRecords;
  @track accountError;

  //Wire a Method by function and passing parameters, field Name AND recordId dynamically using uiRecordApi......
  @wire(getRecord, { recordId: "$recordId", fields: [ACCOUNT_NAME_FIELD, ACCOUNT_PHONE_FIELD, ACCOUNT_INDUSTRY_FIELD, ACCOUNT_OWNER_FIELD] })
  wiredAccounts({ data, error }) {
    if (data) {
      this.accountRecords = data;
      console.log("Getting data from wire with function");
    } else {
      this.accountError = error;
      console.log("Error coming " + error.body.message);
    }
  }
}
