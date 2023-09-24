import { LightningElement } from "lwc";

export default class ChildHook extends LightningElement {
  constructor() {
    super();
    console.log("inside Constructor from Child");
  }

  connectedCallback() {
    console.log("inside ConnectedCallBack from Child");
  }

  renderedCallback() {
    console.log("inside renderdCallBack from Child");
  }

  errorCallback(error, stack) {
    console.log("inside errorCallBack from Child");
    console.log("error", error);
    console.log("stack", stack);
  }
  disconnectedCallback() {
    console.log("inside disconnectedCallBack from Child");
  }
}
