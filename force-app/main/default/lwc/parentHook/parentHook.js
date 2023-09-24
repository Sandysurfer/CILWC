import { LightningElement } from "lwc";

export default class ParentHook extends LightningElement {
  displayChild = false;

  constructor() {
    super();
    console.log("inside Constructor from Parent");
  }

  connectedCallback() {
    console.log("inside ConnectedCallBack from Parent");
  }

  renderedCallback() {
    console.log("inside renderdCallBack from Parent");
  }
  errorCallback(error, stack) {
    console.log("inside errorCallBack from Parent");
    console.log("error", error);
    console.log("stack", stack);
  }
  disconnectedCallback() {
    console.log("inside disconnectedCallBack from Parent");
  }

  handleChange(event) {
    this.displayChild = event.target.checked;
  }
}
