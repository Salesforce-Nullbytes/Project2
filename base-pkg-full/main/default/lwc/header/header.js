import {LightningElement, api} from 'lwc';
import shoppingCartIcon from '@salesforce/resourceUrl/shoppingCartIcon';

export default class header extends LightningElement {
    shoppingCartIcon = shoppingCartIcon;

    @api
    value = "Home";

    handleClick(event) {
        this.value = event.target.innerText;

        let valueChangeEvent = new CustomEvent("valuechange", {
            detail: { value : this.value }
        });

        this.dispatchEvent(valueChangeEvent);
    }

    handleClickImage(event) {
        this.value = "Cart";

        let valueChangeEvent = new CustomEvent("valuechange", {
            detail: { value : this.value }
        });

        this.dispatchEvent(valueChangeEvent);
    }
}
