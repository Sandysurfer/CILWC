import { LightningElement } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
import ACCOUNT_NAME_FIELD from "@salesforce/schema/Account.Name";

export default class GetRecordWire extends LightningElement {
  @api recordId;
  @track accountRecords;
  @track accountError;

  //Wire a Method by field Name AND recordId dynamically using uiRecordApi......
  @wire(getRecord, { recordId: "$recordId", fields: [ACCOUNT_NAME_FIELD] })
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
