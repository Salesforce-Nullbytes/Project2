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
        this.SetParentPostFromTop(component, index);
        this.PrintTest();
    },
    ApexSetValueChildPosts: function(component, helper, fromId) {
        let apexMethod = component.get("c.GetPostsUnder");
        apexMethod.setParams({ postId: fromId });

        apexMethod.setCallback(component, function (response) {
            if (response.getState() == 'SUCCESS') {
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
        this.BuildDisplayTree(component);
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
    },
    BuildDisplayTree: function(component) {   
        let parent = component.get("v.parentPost");
        let parentDepth = parent.Depth__c;

        let allPosts = component.get("v.childPosts");
        let topLevel = [];
        let secondLevel = [];

        for (let post of allPosts) {
            switch (post.Depth__c - parentDepth) {
                case 1:
                    if (post.Parent__c == parent.Id)
                        topLevel.push(post);
                    break;
                case 2:
                    secondLevel.push(post);
                    break;
            }
        }

        let tree = {};
        let tree2 = [];
        for (let i = 0; i < topLevel.length; i++) {
            let comment = topLevel[i];
            tree[comment.Id] = {};
            tree[comment.Id].comment = comment;

            let entry = {};
            entry.comment = comment;
            entry.subcomments = [];

            let subLevel = [];
            for (let subcomment of secondLevel) {
                if (subcomment.Parent__c == comment.Id) {
                    subLevel.push(subcomment);
                    entry.subcomments.push(subcomment);
                }
            }
            tree[comment.Id].subcomments = subLevel;
            tree2.push(entry);

            // let subArray = [];
            // subArray.push(topLevel[i]);
            // for (let comment of secondLevel) {
            //     if (comment.Parent__c.Id == topLevel[i].Id) {
            //         subArray.push(comment);
            //     }
            // }
            // output.push(subArray);
        }

        //this.PrintTree(tree);
        component.set("v.displayTree", tree);
        component.set("v.displayTree2", tree2);
    },
    PrintTree: function(tree) {
        console.log("PRINTING TREE FUNCTION!");
        for (let id in tree) {
            console.log("Comment: " + tree[id].comment.Id);
            for (let subcomment of tree[id].subcomments) {
                console.log("   Sub: " + subcomment.Id);
            }
        }
    },
    // IterateBranch: function(tree, level, subId) {
    //     if (level == 2 && subId == null) {
    //         console.log("Require subId on level 2 query!");
    //         return [];
    //     }
    //     if (level == 2) {
    //         return tree[subId].subcomments;
    //     }
    //     if (level == 1) {
    //         let result = [];
    //         for (let key in tree) {
    //             result.push(tree[key].comment);
    //         }
    //         return result;
    //     }

    //     console.log("Can only iterate levels 1-2");
    //     return;
    // },
})
