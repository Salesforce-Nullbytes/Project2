({
    SetTopLevelPosts : function(component, event, helper) {
        let apexMethod = component.get("c.GetTopLevelPosts");

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                component.set("v.topLevelPosts", response.getReturnValue());
            } else {
                console.log("Error retrieving top level posts!");
            }
        });

        $A.enqueueAction(apexMethod);
    }, 
})