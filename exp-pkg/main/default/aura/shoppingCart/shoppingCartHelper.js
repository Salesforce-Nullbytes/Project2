({
    SetItems : function(query) {
        let itemList = [];
        for (let result of query) {
            let item = {};
            item.UnitPrice = result.unitprice;
            item.Quanity = result.quantity;

            let product = {};
            product.Name = result.product2.name;
            product.ProductCode = result.product2.productcode;
            product.HasVarieties__c = result.product2.hasvarieties__c;
            product.SubVarieties__c = result.product2.subvarieties__c;
            product.Size__c = result.product2.size__c;
            product.Difficulty__c = result.product2.difficulty__c;
            product.Light_Level__c = result.product2.light_level__c;
            product.IsPetFriendly__c = result.product2.ispetfriendly__c;
            product.HasColor__c = result.product2.hascolor__c;
            product.HasFlowers__c = result.product2.hasflowers__c;

            item.Product2 = product;

            itemList.push(item);
        }

        component.set("v.items", itemList);
    }
})
