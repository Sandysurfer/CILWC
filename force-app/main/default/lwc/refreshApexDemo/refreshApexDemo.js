import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getAccounts from '@salesforce/apex/AccountDeleteRefreshApexHandler.getAccounts';
import deleteAccount from '@salesforce/apex/AccountDeleteRefreshApexHandler.deleteAccount';

export default class RefreshApexDemo extends LightningElement {

    accounts;
    error;
    wiredAccountResult;

    @wire(getAccounts)
    wiredAccounts(result) {
        this.wiredAccountResult = result;
        if (result.data) {
            this.accounts = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.accounts = undefined;
            this.error = result.error;
        }
    }

    handleDelete(event) {
        const accountId = event.target.dataset.accountId;
        deleteAccount({ accountId })
            .then(() => {
                // Perform any success actions if needed..
                refreshApex(this.wiredAccountResult);

            })
            .catch(() => {
                // Handle the error if deletion fails..
            });
    }


}
