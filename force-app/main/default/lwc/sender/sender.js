import { LightningElement, wire } from 'lwc';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';

export default class PublishCmp extends LightningElement {
  //1st Example....
  @wire(CurrentPageReference) pageRef;

  publishData() {
    var data = {
      name: "sandeep",
      age: 28
    };
    fireEvent(this.pageRef, "abc", data);
  }

  publishData2() {
    var data = {
      name: "sandeep",
      age: 28
    };
    fireEvent(this.pageRef, "xyz", data);
  }

  handleChange(event) {
    fireEvent(this.pageRef, 'sandeep', event.target.value);
  }


 
}