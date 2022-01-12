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
    
    @api
    itemData = {
        Product2: {
            Name: 'Ficus',
            ProductCode: 'P000MRB',
            HasVarieties__c: true,
            SubVariety__c: 'Burgundy and dark Green',
            Size__c: 'Medium',
            Difficulty__c: 'Regular',
            Light_Level__c: 'Bright',
            IsPetFriendly__c: false,
            HasColor__c: true,
            HasFlowers__c: false,
        },
        UnitPrice: 25.03,
        Quantity: 7,
    };
    dataParser(property) {
        if (!this.itemData) { return null; }

        if (property === "UnitPrice" || property === "Quantity" ) {
            if (!this.itemData.hasOwnProperty(property)) { return null; }
            return this.itemData.property;
        }

        if (!this.itemData.hasOwnProperty("Product2")) { return null; }
        if (!this.itemData.Product2.hasOwnProperty(property)) { return null; }
        return this.itemData.Product2.property;
    }

    // Data Bindings
    get fullName() {
        let name = this.dataParser('Name') || 'Basic Product';
        if (this.dataParser('HasVarieties__c')) {
            name += ': ' + this.dataParser('SubVariety__c');
        }
        return name;
    }
    get itemName() {
        return this.dataParser('Name') || 'Basic Product';
    }
    get variantName() {
        return this.dataParser('SubVariety__c') || '';
    }
    get unitPrice() {
        let price = 'Not Available';
        if (this.dataParser('UnitPrice')) {
            price = '$' + this.dataParser('UnitPrice');
            if (this.isCartItem) {
                price += ' each';
            }
        }
        return price;
    }
    get cartQuantity() {
        return this.dataParser('Quantity') || 0;
    }
    get cartTotal() {
        let q = this.dataParser('Quantity');
        let p = this.dataParser('UnitPrice');
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