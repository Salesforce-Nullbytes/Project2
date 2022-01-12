public without sharing class AuraForumController {
    @AuraEnabled
    public static List<Forum_Item__c> GetTopLevelPosts() {
        List<Forum_Item__c> top = [
            SELECT Id, Title__c, Content__c, Poster__c, Topics__c, Depth__c, 
            Top__c, Parent__r.name, Likes__c, Child_Comments__c
            FROM Forum_Item__c WHERE Depth__c = 0 AND IsRemoved__c = false
        ];
        return top;
    }

    @AuraEnabled
    public static List<Forum_Item__c> GetPostsUnder(ID postId) {
        List<Forum_Item__c> posts = [
            SELECT Id, Title__c, Content__c, Poster__c, Topics__c, Depth__c, 
                Top__c, Parent__r.name, Likes__c, Child_Comments__c
            FROM Forum_Item__c WHERE Top__c = :postId AND IsRemoved__c = false
        ];
        return posts;
    }

    public static ID GetAccount(String acctName) {
        return [SELECT id FROM Account WHERE name= :acctName]?.id;
    }
}
