({
    ApexCartItems : function(component, helper) {
        let apexMethod = component.get("c.GetCartItems");

        // Finally, we set the callback function. 
        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let itemList = helper.SetItems(response.getReturnValue());  
                console.log('Item list is');
                console.log(itemList);
                component.set("v.cartItems", itemList);
            } else {
                console.log("callback not set");
            }
        });

        // Before we finish, we use the A namespace to enqueue the action and send it to the server
        $A.enqueueAction(apexMethod);
    },

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
})
