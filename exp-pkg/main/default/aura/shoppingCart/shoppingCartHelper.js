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
    },

    ServerActivateOrder : function(component, event) {
        let params = event.getParam('data');
        let apexMethod = component.get("c.changeOrderStatus");
    
        // Next, we populate any parameters using this object notation
        apexMethod.setParams(params);
    
        // Finally, we set the callback function. Seem familiar?
        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                this.refreshCart(component, this);
                console.log("Success");
                component.set("v.placeOrderUnclicked", false);
            } else {
                console.log("Update Failed");
            }
        });

        // Before we finish, we use the A namespace to enqueue the action and send it to the server
        $A.enqueueAction(apexMethod);
    }, 
})
