import { LightningElement, api } from 'lwc';

export default class Childcmp extends LightningElement {
    @api getValueFromParent;

    handleChild = new Date();

    @api refresh() {
        this.handleChild = new Date();
    }
    @api handleSave() {
        const nameval = this.refs.NameRef.value
        const ageval = this.refs.AgeRef.value
        console.log('Name--', nameval);
        console.log('Age-', ageval);
    }
}