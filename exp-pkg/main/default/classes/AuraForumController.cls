public without sharing class AuraForumController {
    @AuraEnabled
    public static List<Forum_Item__c> GetTopLevelPosts() {
        List<Forum_Item__c> top = [
            SELECT Id, Title__c, Content__c, Poster__r.Name, Topics__c, Depth__c, 
                Top__c, Parent__c, Likes__c, Child_Comments__c, 
                (SELECT id FROM Post_Likes__r WHERE Account__c = :getAccountId())
            FROM Forum_Item__c WHERE Depth__c = 0 AND IsRemoved__c = false
        ];
        return top;
    }

    @AuraEnabled
    public static Boolean CreateOrDeleteLike( ID postId, Boolean isUp) {
        ID myId = getAccountId();
        if (myId == null) return false;

        if (isUp) {
            Post_Like__c action = new Post_Like__c();
            action.Account__c = myId;
            action.Forum_Item__c = postId;
            Insert action;
        } else {
            Delete [SELECT id FROM Post_Like__c WHERE Account__c = :myId AND Forum_Item__c = :postId];
        }
        return true;
    }

    @AuraEnabled
    public static Forum_Item__c UploadPost( ID parentId, String title, String content, List<String> topics) {
        ID acctId = getAccountId();
        ID top = null;
        Integer depth = 0;

        if (parentId != null) {
            Forum_Item__c parent = [SELECT id, Depth__c, Top__c FROM Forum_Item__c WHERE id = :parentId LIMIT 1];
            if (parent == null) return null;

            depth = (Integer)parent.Depth__c + 1;
            top = (parent.Top__c == null) ? parent.Id : parent.Top__c;
        }

        Forum_Item__c post = new Forum_Item__c();
        post.Poster__c = acctId;
        post.Title__c = title;
        post.Content__c = content;
        post.Parent__c = parentId;
        post.Top__c = top;
        post.Depth__c = depth;

        String topicPattern = '';
        for (String topic : topics) {
            topicPattern += ';' + topic;
        }
        post.Topics__c = topicPattern;

        Insert post;
        return post;
    }

    @AuraEnabled
    public static List<Forum_Item__c> GetPostsUnder(ID postId) {
        List<Forum_Item__c> posts = [
            SELECT Id, Title__c, Content__c, Poster__r.Name, Topics__c, Depth__c, 
                Top__c, Parent__c, Likes__c, Child_Comments__c, 
                (SELECT id FROM Post_Likes__r WHERE Account__c = :getAccountId())
            FROM Forum_Item__c WHERE Top__c = :postId OR Id = :postId
        ];
        return posts;
    }

    @AuraEnabled
    public static Account GetMyAccount(){
        return [SELECT Id, Name FROM Account WHERE Id = :getAccountId() LIMIT 1];
    }

    public static ID getAccountId() {
        String acctName = 'Account 3';
        return [SELECT id FROM Account WHERE name= :acctName]?.id;
    }
}