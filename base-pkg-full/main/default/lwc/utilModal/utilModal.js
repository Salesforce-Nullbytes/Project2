import { LightningElement, api } from 'lwc';

export default class UtilModal extends LightningElement {
    
    // modal params...
    @api
    show;

    @api
    myLabel;

    @api
    myContent;

    @api
    showSignInButton;

    get cssClass() {
        return (this.show)? "modal show" : "modal hide";
    }
    closeModal(event) {
        this.dispatchEvent(new CustomEvent('closeModal'));
    }
}