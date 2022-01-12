import { LightningElement, api } from 'lwc';
import starUnliked from '@salesforce/resourceUrl/starUnliked';
import starLiked from '@salesforce/resourceUrl/starLiked';
import commentIcon from '@salesforce/resourceUrl/commentIcon';

export default class ForumItem extends LightningElement {
    commentIcon = commentIcon;

    expanded = false;
    showComments = false;

    @api
    headerOnly = false;

    @api
    userLiked = false;
    
    @api
    isSelected = false;

    @api
    accessId = -1;


    @api
    postTree = {
        self: {
            Id: "id1",
            Title__c: "Test top comment",
            Content__c: "no details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detail",
            Likes__c: 50,
            Child_Comments__c: 2,
            Parent__r: {
                Name: "Test Account Name",
            },
        },
        children: [
            {
                self: {
                    Id: "id2",
                    Title__c: "Test subcomment 1",
                    Content__c: "no details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detail",
                    Likes__c: 45,
                    Child_Comments__c: 0,
                    Parent__r: {
                        Name: "Test Account Name 2",
                    },
                },
                children: [],
            },
            {
                self: {
                    Id: "id3",
                    Title__c: "Test subcomment 2",
                    Content__c: "no details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detail",
                    Likes__c: 35,
                    Child_Comments__c: 1,
                    Parent__r: {
                        Name: "Test Account Name 3",
                    },
                },
                children: [
                    {
                        self: {
                            Id: "id4",
                            Title__c: "Test sub-subcomment 1",
                            Content__c: "no details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detail",
                            Likes__c: 15,
                            Child_Comments__c: 0,
                            Parent__r: {
                                Name: "Test Account Name 2",
                            },
                        },
                        children: [],
                    }
                ]
            }
        ]
    };

    dataParser(property) {
        if (!this.postTree) { return null; }

        if (property === "children") {
            if (!this.postTree.hasOwnProperty(property)) { return null; }
            return this.postTree[property];
        }

        if (!this.postTree.hasOwnProperty("self")) { return null; }

        if (property === "Name") {
            if (!this.postTree.self.hasOwnProperty("Parent__r")) { return null; }
            if (!this.postTree.self.Parent__r.hasOwnProperty("Name")) { return null; }
            return this.postTree.self.Parent__r.Name;
        }

        if (!this.postTree.self.hasOwnProperty(property)) { return null; }

        return this.postTree.self[property];
    }

    get myTitle() {
        return this.dataParser("Title__c");
    }

    get myContent() {
        return this.dataParser("Content__c");
    }

    get numLikes() {
        return this.dataParser("Likes__c");
    }

    get numComments() {
        return this.dataParser("Child_Comments__c");
    }

    get accountName() {
        return this.dataParser("Name");
    }

    get postId() {
        return this.dataParser("Id");
    }

    get children() {
        return this.dataParser("children");
    }

    get ifDisplayComments() {
        return (this.postTree.children.length != 0);
    }

    get updateLikeIcon(){
        if (this.userLiked == false) {
            return (starUnliked);
        } else {
            return (starLiked);
        }
    }

    get itemClass(){
        let output = "forum-item";
        if (this.expanded) { output += " cropped";} 
        if (this.isSelected) { output += " selected";} 
        return this.expanded ? 'forum-item' : 'forum-item cropped';
    }

    clickExpand() {
        this.expanded = !this.expanded;
    }

    toggleLike() {
        this.numLikes += 1;
        this.userLiked = !this.userLiked;
    }

    addComment() {
        this.numComments +=1;
    }

    toggleShowHide() {
        this.showComments = !this.showComments;
    }

    handleSelect() {
        if (!this.isSelected) {
            const event = new CustomEvent('choose', {
                detail: { id: this.accessId, },
            });
    
            this.dispatchEvent(event);
        }
    }


}