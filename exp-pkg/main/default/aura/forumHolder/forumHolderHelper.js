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
    ToggleLike: function(component, likeId, direction) {        
        let flag;
        if (direction === 'up') flag = true;
        else if (direction === 'down') flag = false;
        else {
            console.log("LIKE DIRECTION CANNOT BE " + direction);
            return;
        }

        let apexMethod = component.get("c.CreateOrDeleteLike");
        apexMethod.setParams({ postId: likeId, isUp: flag });

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                if (!response.getReturnValue()) console.log("Like request failed.");
            } else {
                console.log("Error toggling the like!");
            }
        });

        $A.enqueueAction(apexMethod);
    },
    SetSelected: function(component, toId) {        
        component.set("v.selectedId", toId);
        component.set("v.hasSelection", true);
    },
    ApexSetTopLevelPosts : function(component) {
        let apexMethod = component.get("c.GetTopLevelPosts");

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let posts = response.getReturnValue();
                component.set("v.topLevelPosts", posts);
                component.set("v.topList", this.BuildTopList(posts));
                component.set("v.showTop", true);
            } else {
                console.log("Error retrieving top level posts!");
            }
        });

        $A.enqueueAction(apexMethod);
    },
    ApexInsertForumItem : function(component) {
        // Ensure user is logged in
        let thisUser = component.get("v.thisAccount");
        if (thisUser == null) {
            let message = {show: true};
            message.label="Please Sign In";
            message.content="Only authenticated users may interact with the forum.";
            message.signin = true;
            component.set("v.modal1", message);
            return;
        }

        let apexMethod = component.get("c.UploadPost");
        let post = this.SetPostAttributes(component);
        let message = {show: true};

        if (!this.ValidatePost(post)) {
            message.label="Post not submitted!";
            message.content="Post must have title and content!";
            message.signin = false;
            component.set("v.modal1", message);
            return;
        }
        apexMethod.setParams(this.SetPostAttributes(component));

        apexMethod.setCallback(this, function (response) {
            if (response.getState() == 'SUCCESS') {
                let created = response.getReturnValue();
                if (created.Top__c != null) {
                    this.ApexSetPostTree(component, this, created.Top__c);
                } else {
                    this.ApexSetTopLevelPosts(component);
                }
                this.SetSelected(component, created.Id);
                this.ClearPostInputs(component);
            } else {
                console.log("Error submitting post to server!");
            }
        });

        $A.enqueueAction(apexMethod);
    },
    SetPostAttributes: function(component) {
        let setParent = null;
        if (!component.get("v.showTop")) {
            setParent = component.get("v.selectedId") || component.get("v.displayTree").self.Id;
        }
        let post = {
            parentId: setParent,
            title: component.find("postTitle").getElement().value,
            content: component.find("postContent").getElement().value,
            topics: '',
        };
        return post;
    },
    ValidatePost: function(post) {
        if (post.title == '' || post.content == '') return false;
        return true;
    },
    ClearPostInputs: function(component) {
        component.find("postTitle").getElement().value = '';
        component.find("postContent").getElement().value = '';
    },
    ApexSetPostTree: function(component, helper, fromId) {
        let apexMethod = component.get("c.GetPostsUnder");
        apexMethod.setParams({ postId: fromId });

        apexMethod.setCallback(component, function (response) {
            if (response.getState() == 'SUCCESS') {
                helper.SetTree(component, response.getReturnValue());
            } else {
                console.log("Error retrieving top posts!");;
            }
        });

        $A.enqueueAction(apexMethod);
    },
    SetTree: function(component, posts) {
        if (!posts) {
            console.log("No results!");
            return;
        }
        component.set("v.treePosts", posts);
        component.set("v.showTop", false);

        this.ResetSelection(component);
        this.BuildDisplayTree(component);
    },
    ResetSelection: function(component) {
        component.set("v.hasSelection", false);
    },
    BuildDisplayTree: function(component) {   
        let allPosts = component.get("v.treePosts");
        let postsByDepth = [];

        for (let post of allPosts) {
            let depth = post.Depth__c;

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

