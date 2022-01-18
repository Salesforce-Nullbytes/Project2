import {LightningElement, api} from 'lwc';
import confirmationBackgroundImage from '@salesforce/resourceUrl/confirmationBackgroundImage';

export default class cartEmpty extends LightningElement {

    @api
    returnLink = '';

    @api
    formActionLink = '';

    @api
    origId = '';


    // backgroundRendered = false;

    // renderedCallback() {
    //     if (this.backgroundRendered) {
    //         return;
    //     } 

    //     let container = this.template.querySelectorAll(".background-image-container");
    //     container[0].style.backgroundImage = `url(${confirmationBackgroundImage})`;
    //     container[1].style.backgroundImage = `url(${confirmationBackgroundImage})`;

    //     this.backgroundRendered = true;
    // }

}
