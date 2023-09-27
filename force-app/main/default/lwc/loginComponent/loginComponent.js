import { LightningElement, track } from 'lwc';
import authenticateCustomUser from '@salesforce/apex/CustomUserLoginController.authenticateCustomUser';
import createCustomUser from '@salesforce/apex/CustomUserLoginController.createCustomUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LoginComponent extends LightningElement {
    @track username = '';
    @track password = '';
    @track newusername = '';
    @track newpassword = '';
    @track confirmpassword = '';
    @track isSigningUp = false;

    handleUsernameChange(event) {
        this.username = event.target.value;
    }

    handlePasswordChange(event) {
        this.password = event.target.value;
    }

    handleNewUsernameChange(event) {
        this.newusername = event.target.value;
    }

    handleNewPasswordChange(event) {
        this.newpassword = event.target.value;
    }

    handleConfirmPasswordChange(event) {
        this.confirmpassword = event.target.value;
    }

    //handling main login page...
    handleLogin() {
        authenticateCustomUser({ usernameInput: this.username, passwordInput: this.password })
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
                console.log('Error Message-->' + error);
                this.showToast('Error', 'An error occurred during authentication.', 'error');
            });

    }
    //toggling both the lightning cards..
    showSignUp() {
        this.isSigningUp = true;
    }

    showLogin() {
        this.isSigningUp = false;
    }

    //handling Signup Screen and Checking Username,password and confirm password are same...
    handleSignUp() {
        // Check if passwords matches
        if (this.newpassword === this.confirmpassword) {
            createCustomUser({
                username: this.newusername,
                password: this.newpassword,
                confirmPassword: this.confirmpassword
            })
                .then(result => {
                    if (result === 'User created successfully') {
                        console.log('New User Registration Successful-->' + result);
                        this.showToast('Welcome to Salesforce', 'New User Registration successful.', 'success');

                        //Reseting the registration form fields here
                        this.newusername = '';
                        this.newpassword = '';
                        this.confirmpassword = '';

                        //Switch back to the login page
                        this.isSigningUp = false;

                    } else if (result === 'Username already exists') {
                        console.log('User Already Registered-->' + result);
                        this.showToast('User Already Registered', 'Username already exists. Please choose a different username.', 'error');
                    } else {
                        console.log('Unknown Error-->' + result);
                        this.showToast('Error', 'An unknown error occurred during signup', 'error');
                    }
                })
                .catch(error => {
                    console.log('Error Message' + error);
                    this.showToast('Error', 'An error occurred during signup', 'error');
                });
        } else {
            this.showToast('Error', 'Password and Confirm Password do not match', 'error');
        }

    }

    //Resusing Toast Message Component....
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }


}
