import { LightningElement, api } from 'lwc';
import starUnliked from '@salesforce/resourceUrl/starUnliked';
import starLiked from '@salesforce/resourceUrl/starLiked';
import commentIcon from '@salesforce/resourceUrl/commentIcon';

export default class ForumItem extends LightningElement {
    commentIcon = commentIcon;

    expanded() { return this.flipExpand ? this.noExpand : !this.noExpand } 
    get showFade() { return this.expanded(); }

    showComments = true;

    @api
    noExpand = false;
    flipExpand = false;

    @api
    headerOnly = false;

    @api
    selectedId;

    @api
    postTree = {
        self: {
            Id: "id1",
            Title__c: "Test top comment",
            Content__c: "no details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detail",
            Likes__c: 50,
            Child_Comments__c: 2,
            Poster__r: {
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
                    Poster__r: {
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
                    Poster__r: {
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
                            Poster__r: {
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
            if (!this.postTree.self.hasOwnProperty("Poster__r")) { return null; }
            if (!this.postTree.self.Poster__r.hasOwnProperty("Name")) { return null; }
            return this.postTree.self.Poster__r.Name;
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

    likeOffset = 0;
    get numLikes() {
        return this.dataParser("Likes__c") + this.likeOffset;
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
        if (!this.userLiked()) {
            return (starUnliked);
        } else {
            return (starLiked);
        }
    }

    get itemClass(){
        let output = "forum-item";
        if (!this.expanded()) { output += " cropped";} 
        if (this.dataParser("Id") == this.selectedId) { output += " selected";} 
        return output;
    }

    get isSelected() {
        return this.dataParser("Id") == this.selectedId;
    }

    get expandLabel() {
        return this.expanded() ? 'Collapse -' : 'Expand +';
    }

    clickExpand() {
        this.flipExpand = !this.flipExpand;
    }

    toggleLike() {
        let dir;
        if (this.userLiked()) {
            dir = 'down';
            this.likeOffset--;
        } else {
            dir = 'up';
            this.likeOffset++;
        }
        this.flipLike = !this.flipLike;

        const event = new CustomEvent('like', {
            detail: { id: this.dataParser("Id"), direction: dir },
        });

        this.dispatchEvent(event);
    }

    passLike(event) {
        this.dispatchEvent(new CustomEvent('like', {
            detail : { id: event.detail.id, direction: event.detail.direction },
        }));
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
                detail: { id: this.dataParser("Id") },
            });
    
            this.dispatchEvent(event);
        }
    }

    passChoose(event) {
        this.dispatchEvent(new CustomEvent('choose', {
            detail: { id: event.detail.id },
        }));
    }

    flipLike = false;
    userLiked() {
        let original = (this.dataParser("Post_Likes__r") != null);
        return this.flipLike ? !original : original;
    }


}