import { LightningElement, api } from 'lwc';
import starUnliked from '@salesforce/resourceUrl/starUnliked';
import starLiked from '@salesforce/resourceUrl/starLiked';

export default class ForumItem extends LightningElement {
    starUnliked = starUnliked;
    starLiked = starLiked;

    @api
    headerOnly = false;

    @api
    myTitle = 'no title';

    @api
    myDetails = 'no details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno details no detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno detailsno details';

    @api
    numComments = 0;

    @api
    numLikes = 0;

    @api
    userLiked = false;
    
    @api
    isSelected = false;

    @api
    accessId = -1;

    
    expanded = false;

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
    }

    addComment() {
        this.numComments +=1;
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