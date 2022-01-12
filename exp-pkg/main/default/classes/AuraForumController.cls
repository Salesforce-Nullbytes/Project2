public without sharing class AuraForumController {
    @AuraEnabled
    public static List<Forum_Item__c> GetTopLevelPosts() {
        List<Forum_Item__c> top = [
            SELECT Id, Title__c, Content__c, Poster__r.Name, Topics__c, Depth__c, 
                Top__c, Parent__c, Likes__c, Child_Comments__c
            FROM Forum_Item__c WHERE Depth__c = 0 AND IsRemoved__c = false
        ];
        return top;
    }

    @AuraEnabled
    public static List<Forum_Item__c> GetPostsUnder(ID postId) {
        List<Forum_Item__c> posts = [
            SELECT Id, Title__c, Content__c, Poster__r.Name, Topics__c, Depth__c, 
                Top__c, Parent__c, Likes__c, Child_Comments__c
            FROM Forum_Item__c WHERE Top__c = :postId AND IsRemoved__c = false
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
