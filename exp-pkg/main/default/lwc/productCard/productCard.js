import { LightningElement, api } from 'lwc';
import productImage from '@salesforce/resourceUrl/productimage';

export default class ProductCard extends LightningElement {
    needUpdate = false;
    qtyHolder = 0;

    @api
    accessId = -1;
    @api
    isCartItem = false;
    @api
    image = {
        link: productImage,
        alt: 'Generic Product Image'
    };
    
    // Helper to retrieve input data
    productField(property) {
        // if (!this.productData || !this.productData.hasOwnProperty(property)) { return null; }
        // return this.productData[property];
        return this.dataParser("product", property);
    }
    orderField(property) {
        // if (!this.orderData || !this.orderData.hasOwnProperty(property)) { return null; }
        // return this.orderData[property];
        return this.dataParser("order", property);
    }

    @api
    itemData;
    dataParser(type, property) {
        if (!this.itemData) { return null; }
        switch (type) {
            case "product":
                if (!this.itemData.hasOwnProperty("product2")) { return null; }
                if (!this.itemData.product2.hasOwnProperty(property)) { return null; }
                return this.itemData.product2[property];
            case "order":
                if (!this.itemData.hasOwnProperty(property)) { return null; }
                return this.itemData[property];
            default:
                console.log("Unkown data type: " + type);
        }
    }

    // // Object of 'Product2' type: retrieve attributes from 'productField(prop)' method
    // @api
    // productData;
    // // Object of 'OrderItem' type: retrieve attributes from 'productField(prop)' method
    // @api
    // orderData;

    // // MOCK DATA
    // productData = {
    //     name: 'Ficus',
    //     ProductCode: 'P000MRB',
    //     HasVarieties__c: true,
    //     SubVariety__c: 'Burgundy and dark Green',
    //     Size__c: 'Medium',
    //     Difficulty__c: 'Regular',
    //     Light_Level__c: 'Bright',
    //     IsPetFriendly__c: false,
    //     HasColor__c: true,
    //     HasFlowers__c: false,
    // };
    // orderData = {
    //     Product2Id: 'mockProduct2Id',
    //     PricebookEntryId: 'mockPrickbookEntryId',
    //     Quantity: 3,
    //     UnitPrice: 23.00,
    // };

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

    // Interactivity
    qtyChange(event) {
        this.needUpdate = true;
        this.qtyHolder = event.target.value;
    }

    // Events
    clickUpdate(event) {
        this.dispatchEvent(new CustomEvent('changequantity', {
            detail: { id: this.accessId,
                quantity: this.qtyHolder,
            },
        }));
    }
    clickRemove(event) {
        this.dispatchEvent(new CustomEvent('remove', {
            detail: { id: this.accessId, },
        }));
    }
    clickToggle(event) {
        this.dispatchEvent(new CustomEvent('toggleitem', {
            detail: { id: this.accessId, },
        }));
    }

    // Class calculation
    get cssClass() {
        return this.cartItem ? 'product cart' : 'product';
    }
    get changeClass() {
        return this.needUpdate ? 'must-update' : 'in-sync';
    }
}