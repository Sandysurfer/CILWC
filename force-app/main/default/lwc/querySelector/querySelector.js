import { LightningElement } from "lwc";

export default class ResultComponent extends LightningElement {
  empfname;
  emplname;

  handleSubmit() {
    //When we want input data on clicking of button (Replacement of multiple-->event.target.value)

    //For single lightning-input....
    this.empfname = this.template.querySelector("lightning-input").value;

    //For multiple lightning-input value (collection)....
    let input = this.template.querySelectorAll("lightning-input");

    input.forEach((element) => {
      if (element.name === "fname") {
        this.empfname = element.value;
      } else if (element.name === "lname") {
        this.emplname = element.value;
      }
    }, this);
  }
}
