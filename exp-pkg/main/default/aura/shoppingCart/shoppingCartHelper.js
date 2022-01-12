({
    SetItems : function(query) {
        let itemList = [];
        for (let result of query) {
            let item = {};
            item.UnitPrice = result.UnitPrice;
            item.Quantity = result.Quantity;
            item.Id = result.Id;
            item.remove = false;

            let product = {};

            for (let key in result.Product2) {
                product[key] = result.Product2[key];
            }

            // product.Name = result.Product2.name;
            // product.ProductCode = result.Product2.productcode;
            // product.HasVarieties__c = result.Product2.hasvarieties__c;
            // product.SubVarieties__c = result.Product2.subvarieties__c;
            // product.Size__c = result.Product2.size__c;
            // product.Difficulty__c = result.Product2.difficulty__c;
            // product.Light_Level__c = result.Product2.light_level__c;
            // product.IsPetFriendly__c = result.Product2.ispetfriendly__c;
            // product.HasColor__c = result.Product2.hascolor__c;
            // product.HasFlowers__c = result.Product2.hasflowers__c;

            item.Product2 = product;

            itemList.push(item);

        }

        return itemList;
    },
    refreshCart : function(component, helper) {
        let apexMethod = component.get("c.GetCartItems");

        // Finally, we set the callback function. 
        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let itemList = helper.SetItems(response.getReturnValue());  
                console.log(itemList);     
                component.set("v.items", itemList);
            } else {
                console.log("callback not set");
            }
        });

        // Before we finish, we use the A namespace to enqueue the action and send it to the server
        $A.enqueueAction(apexMethod);

    },
    
    SendCartToServer : function(component, removals, changes, quantities, helper) {
    
        // First, we must retrieve the method that we want to call
        let apexMethod = component.get("c.updateCart");
    
        // Next, we populate any parameters using this object notation
        apexMethod.setParams({ListOfRemovedIds : removals,  ListOfChangedQuantityIds : changes,  ListOfChangedQuantityInts : quantities});
    
        // Finally, we set the callback function. Seem familiar?
        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                helper.refreshCart(component, helper);
            } else {
                console.log("Update Failed");
            }
        });

        // Before we finish, we use the A namespace to enqueue the action and send it to the server
        $A.enqueueAction(apexMethod);
    }
})
