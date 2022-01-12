({
    Initialize : function(component, event, helper) {
        helper.ApexSetTopLevelPosts(component);
    }, 
    HandleChoose: function(component, event, helper) {
        let index = event.getParam('id');
        console.log('index: ' + index);

        helper.ItemChosen(component, index);
    },
    OpenSelected: function(component, event, helper) {
        // Set parent post
        component.set("v.parentPost", component.get("v.selectedPost"));
        // Set children
        let parentId = component.get("v.selectedId");
        console.log("parent id is " + parentId);

        helper.ApexSetValueChildPosts(component, helper, parentId);
    },
    HandleTop: function(component, event, helper) {
        component.set("v.showTop", true);
    },
    PrintChildren: function(component, event, helper) {
        let array = component.get("v.childPosts");
        console.log("Printing children...");
        for (let child of array) {
            console.log("    child found: " + array);
        }
    },
})