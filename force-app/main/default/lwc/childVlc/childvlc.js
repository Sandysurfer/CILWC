import { LightningElement } from "lwc";

export default class Childlwc extends LightningElement {
  /*handleChange(event) {
        let myEvent = new CustomEvent("myvalue", {
            detail: event.target.value
        });

        this.dispatchEvent(myEvent);
    }*/

  handleDecrease(event) {
    //Step 1: Create Event......
    const decreaseEvent = new CustomEvent("decrease", {
      detail: "Volume is Decreasing"
    });
    //Step 2: Dispatch Event.....
    this.dispatchEvent(decreaseEvent);
  }

  handleIncrease(event) {
    //Step 1: Create custom Event and dispatch Event in one line........
    this.dispatchEvent(
      new CustomEvent("increase", { detail: "Volume is Increasing" })
    );
  }
}
