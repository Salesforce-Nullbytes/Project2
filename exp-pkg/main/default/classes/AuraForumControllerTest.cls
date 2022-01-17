@isTest
public class AuraForumControllerTest {
    @isTest
    public static void TP_NoExtraTopLevelPosts() {
        Set<ID> actualIDs = new Set<ID>();
        for (Forum_Item__c post : [SELECT id FROM Forum_Item__c WHERE Depth__c = 0 AND isRemoved__c = false]) {
            actualIDs.add(post.id);
        }

        Boolean success = true;
        for (Forum_Item__c post : AuraForumController.GetTopLevelPosts()) {
            if (!actualIDs.contains(post.id)) {
                success = false;
            }
        }
        System.assert(success);
    }
    @isTest
    public static void TP_GetsAllTopLevelPosts() {
        Set<ID> returnedIDs = new Set<ID>();
        for (Forum_Item__c post : AuraForumController.GetTopLevelPosts()) {
            returnedIDs.add(post.Id);
        }

        Boolean success = true;
        for (Forum_Item__c post : [SELECT id FROM Forum_Item__c WHERE Depth__c = 0 AND isRemoved__c = false]) {
            if (!returnedIDs.contains(post.id)) {
                success = false;
            }
        }
        System.assert(success);
    }
    // @isTest
    // public static void TP_PostLikeCreated() {
    //     Account a = SELECT
    // }
}
