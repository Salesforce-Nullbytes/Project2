({
    Initialize : function(component, event, helper) {
        console.log("initialize is good");



        let apexMethod = component.get("c.GetCartItems");

        // Finally, we set the callback function. Seem familiar?
        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                component.set("v.items", response.getReturnValue());
            } else {
                console.log("callback not set");
            }
        });

        // Before we finish, we use the A namespace to enqueue the action and send it to the server
        $A.enqueueAction(apexMethod);

    }, 

    TestPrint : function(component, event, helper) {
        console.log("hello we are here");
        let items = component.get("v.items");

        for (let item of items) {
            console.log(item);
        }
    },

    HandleRemove : function(component, event, helper) {
        console.log("herd a removal");
        let target = event.target;
        console.log(target);
        console.log(event);
    },
    
    HandleChangeQuantity : function(component, event, helper) {
        console.log(event.getParam('data'));
        
    }
})
