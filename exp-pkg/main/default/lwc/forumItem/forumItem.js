import { LightningElement, api } from 'lwc';

export default class ForumItem extends LightningElement {
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
    

    
    expanded = false;

    get itemClass(){
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

}