import { LightningElement, api } from 'lwc';

// FOR MOCK
import productImage from '@salesforce/resourceUrl/productimage';

export default class ProductCard extends LightningElement {
    //@api
    isCartItem = true;
    @api
    image = {
        link: productImage,
        alt: 'Generic Product Image'
    };
    
    // Helper to retrieve input data
    productField(property) {
        if (!this.productData || !this.productData.hasOwnProperty(property)) { return null; }
        return this.productData[property];
    }
    orderField(property) {
        if (!this.orderData || !this.orderData.hasOwnProperty(property)) { return null; }
        return this.orderData[property];
    }
    // // Object of 'Product2' type: retrieve attributes from 'productField(prop)' method
    // @api
    // productData;
    // // Object of 'OrderItem' type: retrieve attributes from 'productField(prop)' method
    // @api
    // orderData;

    // MOCK DATA
    productData = {
        name: 'Ficus',
        ProductCode: 'P000MRB',
        HasVarieties__c: true,
        SubVariety__c: 'Burgundy and dark Green',
        Size__c: 'Medium',
        Difficulty__c: 'Regular',
        Light_Level__c: 'Bright',
        IsPetFriendly__c: false,
        HasColor__c: true,
        HasFlowers__c: false,
    };
    orderData = {
        Product2Id: 'mockProduct2Id',
        PricebookEntryId: 'mockPrickbookEntryId',
        Quantity: 3,
        UnitPrice: 25.00,
    };

    // Data Bindings
    get fullName() {
        let name = this.productField('name') || 'Basic Product';
        if (this.productField('HasVarieties__c')) {
            name += ': ' + this.productField('SubVariety__c');
        }
        return name;
    }
    get itemName() {
        return this.productField('name') || 'Basic Product';
    }
    get variantName() {
        return this.productField('SubVariety__c') || '';
    }
    get unitPrice() {
        let price = 'Not Available';
        if (this.orderField('UnitPrice')) {
            price = '$' + this.orderField('UnitPrice');
            if (this.isCartItem) {
                price += ' each';
            }
        }
        return price;
    }
    get cartQuantity() {
        return this.orderField('Quantity') || 0;
    }
    get cartTotal() {
        let q = this.orderField('Quantity');
        let p = this.orderField('UnitPrice');
        if (p && q) {
            return 'Subtotal: $' + (p*q);
        }
        return 'No Charge';
    }

    // Class calculation
    get cssClass() {
        return this.cartItem ? 'product cart' : 'product';
    }
}