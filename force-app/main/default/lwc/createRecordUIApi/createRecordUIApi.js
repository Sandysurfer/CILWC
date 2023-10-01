import { LightningElement } from "lwc";
import { createRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class CreateRecordImperative extends LightningElement {

  accountName;
  accountPhone;
  accountFax;
  accountIndustry;

  handleName(event) {
    this.accountName = event.target.value;
  }
  handlePhone(event) {
    this.accountPhone = event.target.value;
  }
  handleFax(event) {
    this.accountFax = event.target.value;
  }
  handleIndustry(event) {
    this.accountIndustry = event.target.value;
  }

  handleClick() {
    //Step 1:Capture list of fields as per user has entered..
    const fields = {
      Name: this.accountName,
      Phone: this.accountPhone,
      Fax: this.accountFax,
      Industry: this.accountIndustry
    };

    //Step 2:Create api Record With Field values..
    const recordData = { apiName: "Account", fields };

    //Step 3:Create Record using LDS(uiRecordApi) method and display toast message on creation....
    createRecord(recordData)
      .then((result) => {
        console.log('Created Account Record', JSON.stringify(result));
        //alert("Account is Created Successfully with AccountId: " + result.id);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Account created",
            variant: "success",
            mode: 'dismissable'
          })
        );
      })
      .catch((error) => {
        // alert("Account Creation Failed: " + error.body.message);
        this.accountRecords = error;
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error creating record",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}
