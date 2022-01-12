({
    Initialize : function(component, event, helper) {
        helper.ApexSetTopLevelPosts(component);
    }, 
    HandleChoose: function(component, event, helper) {
        let index = event.getParam('id');
        helper.SetParentPostFromTop(component, index);
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
})