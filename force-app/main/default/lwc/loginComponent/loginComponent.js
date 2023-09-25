import { LightningElement, track } from 'lwc';
import authenticateCustomUser from '@salesforce/apex/CustomUserLoginController.authenticateCustomUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LoginComponent extends LightningElement {

    @track userName = '';
    @track passWord = '';

    handleUsernameChange(event) {
        this.userName = event.target.value;
    }

    handlePasswordChange(event) {
        this.passWord = event.target.value;
    }

    handleLogin() {
        //using Imperative method....
        authenticateCustomUser({ usernameInput: this.userName, passwordInput: this.passWord })
            .then(result => {
                if (result) {
                    console.log('Successful User login-->' + result);
                    this.showToast('Success', 'Logged in successfully.', 'success');
                } else {
                    console.log('Error User login-->' + result)
                    this.showToast('Error', 'Please check your credentials.', 'error');
                }
            })
            .catch(error => {
                console.log('Error Message' + error);
                this.showToast('Error', 'An error occurred during authentication.', 'error');
            });

    }
    //Using Toast message show success and error toast...
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }

}
