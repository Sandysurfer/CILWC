import { LightningElement } from "lwc";
import getAccounts from "@salesforce/apex/callApexUsingImperative.getAccounts";

export default class LifecycleHooks extends LightningElement {
  //JS For Lifecycle hooks...

  constructor() {
    super(); //must to avoid compile time errors..
    console.log("Inside Constructor");
    //Accessing child component is not allowed as its not available....

    //Defining a variable is allowed,But Use Getters and Setter intstead..
    let name = "salesforce";
    if (name) {
      this.property = "salesforce triumph";
    }

    //Accessing elements using (this.template) is not allowed..

    //Calling Apex Method is Allowed in constructor method, But try doing in connected Callback method..

    //Do not create Custom Events and dispatchEvent...

    //Navigation Mixin for stage Change in allowed...
  }

  connectedCallback() {
    console.log("Inside connectedCallback");
    //To Avoid firing of connected callback multiple times use boolean variable..

    //Accessing child component is not allowed as its not available..

    //Accessing elements using (this.template) is allowed but not on child element..

    //Calling Apex impertive Method  is Allowed...
    getAccounts()
      .then((result) => {
        this.accounts = result;
      })
      .catch((error) => {
        this.error = error;
      });
    //Creating custom event and dispatching is allowed also publish and subscribe is allowed..

    //Calling uiRecordApi is allowed..
  }

  renderedCallback() {
    console.log("Inside renderedCallback");
    //Access child component as its flow from child to parent component...

    //Accessing elements using queryselector is  allowed..
    // eslint-disable-next-line no-unused-expressions
    this.template.querySelector("lightning-button").value;

    //Calling Apex impertive Method  is Allowed...
    getAccounts()
      .then((result) => {
        this.accounts = result;
      })
      .catch((error) => {
        this.error = error;
      });

    //Creating custom event and dispatching is allowed..

    //Calling uiRecordApi is allowed..
  }

  disconnectedCallback() {
    console.log("Inside disconnectedCallback");
  }
  errorCallback(error, stack) {
    console.log("Error callBack called ");
    this.error = error;
    this.stack = stack;
  }
}
