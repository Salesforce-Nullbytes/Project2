import {LightningElement} from 'lwc';
import confirmationBackgroundImage from '@salesforce/resourceUrl/confirmationBackgroundImage';

export default class cartEmpty extends LightningElement {

    backgroundRendered = false;

    renderedCallback() {
        if (this.backgroundRendered) {
            return;
        } 

        let container = this.template.querySelectorAll(".background-image-container");
        console.log(container.length);
        container[0].style.backgroundImage = `url(${confirmationBackgroundImage})`;
        container[1].style.backgroundImage = `url(${confirmationBackgroundImage})`;

        this.backgroundRendered = true;
    }

}
