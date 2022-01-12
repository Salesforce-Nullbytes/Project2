import {LightningElement} from 'lwc';
import titleVines from '@salesforce/resourceUrl/titleVines';

export default class plantPeopleHeader extends LightningElement {
    titleVines = titleVines;

    largeHeader = true;


    backgroundRendered = false;

    renderedCallback() {
        if (this.backgroundRendered) {
            return;
        } 

        let container = this.template.querySelectorAll(".container");
        console.log(container.length);
        container[0].style.backgroundImage = `url(${titleVines})`;

        this.backgroundRendered = true;
    }
}
