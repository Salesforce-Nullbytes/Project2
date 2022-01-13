({
    Initialize : function(component, event, helper) {
        helper.ApexSetAccount(component);
        helper.ApexSetTopLevelPosts(component);
    }, 
    HandleChoose: function(component, event, helper) {
        let id = event.getParam('id');
        helper.SetSelected(component, id);
    },
    HandleLike: function(component, event, helper) {
        let id = event.getParam('id');
        let direction = event.getParam('direction');
        helper.ToggleLike(component, id, direction);
    },
    OpenSelected: function(component, event, helper) {
        let selectedId = component.get("v.selectedId");
        if (!selectedId) {
            console.log("No ID to select!");
            return;
        }
        helper.ApexSetPostTree(component, helper, selectedId);
        //helper.SetTree2(component, helper, selectedId);
    },
    HandleTop: function(component, event, helper) {
        helper.ApexSetTopLevelPosts(component);
        helper.ResetSelection(component);
    },
})