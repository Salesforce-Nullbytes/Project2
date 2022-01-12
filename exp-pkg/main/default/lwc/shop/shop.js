import { LightningElement, wire } from 'lwc';
import AllProducts from "@salesforce/apex/LWCShopController.AllProducts";

export default class Shop extends LightningElement {
    @wire(AllProducts)
    catalog;
    get hasProucts() {
        if (!this.catalog.data) { return false; }
        return true;
    }

}