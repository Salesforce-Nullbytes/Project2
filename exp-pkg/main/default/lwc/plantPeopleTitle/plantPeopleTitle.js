import {LightningElement, api} from 'lwc';
import titleVines from '@salesforce/resourceUrl/titleVines';

export default class plantPeopleHeader extends LightningElement {
    titleVines = titleVines;

    @api
    largeHeader = false;


    backgroundRendered = false;

    renderedCallback() {
        if (this.backgroundRendered) {
            return;
        } 

        let container = this.template.querySelectorAll(".container");
        container[0].style.backgroundImage = `url(${titleVines})`;

        this.backgroundRendered = true;
    }
}
