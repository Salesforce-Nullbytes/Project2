({
    refreshCart : function(component, changed) {
       //request parent to refresh data
        let changeEvent = component.getEvent("refresh");

        this.updatePendingStatus(component, false);

        changeEvent.setParams({ cartChanged: changed });
        changeEvent.fire();
    },

    updatePendingStatus : function(component, isPending) {
        //request parent to refresh data
         let changeEvent = component.getEvent("changePending");
 
         changeEvent.setParams({ changePending : isPending });
         changeEvent.fire();
     },
    
    SendCartToServer : function(component, removals, changes, quantities, helper) {
    
        // First, we must retrieve the method that we want to call
        let apexMethod = component.get("c.updateCart");
    
        // Next, we populate any parameters using this object notation
        apexMethod.setParams({ListOfRemovedIds : removals,  ListOfChangedQuantityIds : changes,  ListOfChangedQuantityInts : quantities});
    
        // Finally, we set the callback function. Seem familiar?
        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                helper.refreshCart(component, true);
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
                this.refreshCart(component, true);
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
