import { LightningElement } from 'lwc';
import modalPopup from 'c/modalPopup';

export default class PreviewModalPopup extends LightningElement {
    showModal = true;
    result;
    async handleShowModal() {
        this.result = await modalPopup.open({
            size: 'large',
            description: 'Accessible Decription of Modal/popup Purpose',
            content: 'passed into content api',
        });
        console.log(result);
    }
}