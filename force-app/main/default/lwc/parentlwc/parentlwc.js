import { LightningElement } from 'lwc';

export default class Parentlwc extends LightningElement {
    vol = 0;
    desc = 'Please Click on Button';

    handleVolIncrease(event) {
        this.desc = event.detail;
        if (this.vol < 100) {
            this.vol = this.vol + 1;

        }
    }

    handleVolDecrease(event) {
        this.desc = event.detail;
        if (this.vol > 0) {
            this.vol = this.vol - 1;
        }
    }
}