import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners, unregisterListener } from 'c/pubsub';

export default class SubscribeCmp extends LightningElement {

    //1st Example..
    @wire(CurrentPageReference) pageRef;

    receiveData() { 
        registerListener('sandeep', this.handlePublisher, this);
    }

    handlePublisher(event) {
        console.log('data-->' + JSON.stringify(event));
    }

    unSubscribeData() {
        unregisterListener('sandeep', this.handlePublisher, this);
    }

    unSubscribeAll() {
        unregisterAllListeners(this);
    }

   
}
