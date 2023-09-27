import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ModalPopup extends LightningModal {
    @api content;
    @api description;
    handleOkay() {
        this.close('okay');
    }
    handleNotOkay(){
        this.close('Not okay');
    }
}