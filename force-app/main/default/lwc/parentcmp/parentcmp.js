import { LightningElement } from 'lwc';

export default class Parentcmp extends LightningElement {
    valueFromParent = 'Lightning Web Components in SalesForce';

    handleParent() {
        console.log('--Handle Click--');
        this.refs.childcmp.refresh();
    }

    handleDetails() {
        this.refs.childcmp.handleSave();
    }

}