({
    ApexSetAccount : function(component) {
        let apexMethod = component.get("c.GetMyAccount");

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                component.set("v.thisAccount", response.getReturnValue());
            } else {
                console.log("Error retrieving top level posts!");
            }
        });

        $A.enqueueAction(apexMethod);
    }, 
    ApexSetTopLevelPosts : function(component) {
        let apexMethod = component.get("c.GetTopLevelPosts");

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let posts = response.getReturnValue();
                component.set("v.topLevelPosts", posts);
                component.set("v.topList", this.BuildTopList(posts));
            } else {
                console.log("Error retrieving top level posts!");
            }
        });

        $A.enqueueAction(apexMethod);
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
        //console.log("Set # children: " + component.get("v.childPosts").length);
        
        component.set("v.showTop", false);
        this.ResetSelection(component);
        this.BuildDisplayTree(component);
    },
    ResetSelection: function(component) {
        component.set("v.selectedPost", null);
        component.set("v.selectedId", null);
        component.set("v.hasSelection", false);
    },
    BuildDisplayTree: function(component) {   
        let parent = component.get("v.parentPost");
        let allPosts = component.get("v.childPosts");

        let parentDepth = parent.Depth__c;
        let postsByDepth = [];

        postsByDepth[0] = [];
        postsByDepth[0].push(this.MakeNode(parent));

        for (let post of allPosts) {
            let depth = post.Depth__c - parentDepth;
            if (depth < 0) {continue;} // Review this condition later
            
            if (postsByDepth[depth] === undefined) postsByDepth[depth] = [];
            postsByDepth[depth].push(this.MakeNode(post));
        }


        // Traverse from bottom to top of tree.
        // Start one before the last depth.
        // Iterate posts at depth beneath it.
        //   Iterate posts at that depth
        //   If child parent is the current post, push to children
        for (let i = postsByDepth.length-2; i >= 0; i--) {
            for (let comment of postsByDepth[i+1]) {
                for (let post of postsByDepth[i]) {
                    this.PushIfChild(post, comment);
                }   
            }
        }

        //this.PrintTree(postsByDepth[0][0], 0);
        component.set("v.displayTree", postsByDepth[0][0]);
    },
    PrintTree: function(node, depth) {
        let indent = ""; 
        for (let i=0;i<depth;i++) indent += "  ";

        if (!node) {
            console.log(indent+"node does not exist...");
            return;
        }
        for (let key in node.self) {
            console.log(indent+"self." + key + ": " +node.self[key]);
        }
        console.log(indent+"children:");
        for (let child of node.children) {
            this.PrintTree(child, depth+1);
        }
    },
    MakeNode: function(post) {
        return {
            self: post,
            children: [],
        };
    },
    PushIfChild: function(node, child) {
        if (!node || !node.hasOwnProperty("self") || !node.hasOwnProperty("children")) {
            console.log("Invalid node! Requires a self and children.");
            return;
        }

        if (!child) { return; }
        if (!child.hasOwnProperty("self") || !child.hasOwnProperty("children")) {
            console.log("Invalid child! Requires a self and children.");
            return;
        }

        if (child.self.Parent__c == node.self.Id) {
            node.children.push(child);
        }
    },
    BuildTopList: function(posts) {
        let list = [];
        for (let post of posts) {
            list.push(this.MakeNode(post));
        }
        return list;
    },
})

