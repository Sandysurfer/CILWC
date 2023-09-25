import { LightningElement } from "lwc";
import { createRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class CreateRecordImperative extends LightningElement {

  name;
  phone;
  fax;
  industry;

  handleName(event) {
    this.name = event.target.value;
  }
  handlePhone(event) {
    this.phone = event.target.value;
  }
  handleFax(event) {
    this.fax = event.target.value;
  }
  handleIndustry(event) {
    this.industry = event.target.value;
  }

  handleClick() {
    //Step 1:Capture list of fields as per user has entered..
    const fields = {
      Name: this.name,
      Phone: this.phone,
      Fax: this.fax,
      Industry: this.industry
    };

    //Step 2:Create api Record With Field values..
    const recordData = { apiName: "Account", fields };

    //Step 3:Create Record using imperation method and display toast message on creation....
    createRecord(recordData)
      .then((result) => {
        console.log('Created Account Record', JSON.stringify(result));
        //alert("Account is Created Successfully with AccountId: " + result.id);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Account created",
            variant: "success"
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
