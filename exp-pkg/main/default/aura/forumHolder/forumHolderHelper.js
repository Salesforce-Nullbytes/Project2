({
    ApexSetTopLevelPosts : function(component) {
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
    ItemChosen: function(component, index) {
        console.log("passed i="+index);
        this.SetParentPostFromTop(component, index);
        this.PrintTest();
    },
    ApexSetValueChildPosts: function(component, helper, fromId) {
        let apexMethod = component.get("c.GetPostsUnder");
        apexMethod.setParams({ postId: fromId });

        apexMethod.setCallback(component, function (response) {
            if (response.getState() == 'SUCCESS') {
                let a = response.getReturnValue(); 
                console.log(a.length);
                helper.SetValueChildPosts(component, response.getReturnValue());
            } else {
                console.log("Error retrieving top children posts!");;
            }
        });

        $A.enqueueAction(apexMethod);
    },
    SetValueChildPosts: function(component, children) {
        if (!children) {
            console.log("No results!");
            return;
        }

        component.set("v.childPosts", children);
        console.log("Set # children: " + component.get("v.childPosts").length);
        
        component.set("v.showTop", false);
        this.ResetSelection(component);
    },
    SetParentPostFromTop: function(component, index) {
        let post = null;
        if (component.get("v.showTop")) {
            post = component.get("v.topLevelPosts")[index];
        } else {
            post = component.get("v.childPosts")[index];
        }
        if (post == null) {
            console.log("ERROR: post chosen does not have valid index!");
            return;
        }

        component.set("v.selectedPost", post);
        component.set("v.selectedId", post.Id);
        component.set("v.hasSelection", true);
        console.log("SELECTED ID IS " + post.Id);
    },
    ResetSelection: function(component) {
        component.set("v.selectedPost", null);
        component.set("v.selectedId", null);
        component.set("v.hasSelection", false);
    },
    PrintTest: function() {
        console.log("Hello!");
    }
})
