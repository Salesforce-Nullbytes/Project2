import { LightningElement, track, api } from 'lwc';

export default class ProductCard extends LightningElement {
    @api
    isCartItem = false;
    @api
    image = {
        link: '',
        alt: 'Generic Product Image'
    };
    
    // Object of 'Product2' type: retrieve attributes from 'productField(prop)' method
    @api
    productData;
    productField(property) {
        if (!this.productData || !this.productData.hasOwnProperty(property)) { return null; }
        return this.productData[property];
    }
}