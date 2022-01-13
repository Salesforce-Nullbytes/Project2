public without sharing class PostLikeHandler {
    // BEFORE INSERT -> Prevent if account already liked post.
    public static void PreventDoubleInsert(List<Post_Like__c> insertions) {
        Set<ID> accounts = new Set<ID>();
        Set<ID> posts = new Set<ID>();
        for (Post_Like__c insertion : insertions) {
            accounts.add(insertion.Account__c);
            posts.add(insertion.Forum_Item__c);
        }

        Map<ID, Account> accountLikes = [
            SELECT id, (
                SELECT id, Forum_Item__c 
                FROM Post_Likes__r 
                WHERE id IN :posts 
            ) 
            FROM Account 
            WHERE id IN :accounts
        ];

        for (Post_Like__c insertion : insertions) {
            List<Forum_Item> likes = accountLikes[insertion.Account__c]?.Forum_Item__r;
            for (Forum_Item liked : likes) {
                if (insertion.Forum_Item__c == liked) {
                    insertion.addError('No insert: Account already liked post.');
                }
            }
        }
    }
    // AFTER INSERT -> Increment post likes
    public static void IncrementParentPostLikes(List<Post_Like__c> insertions) {
        Map<ID, Integer> postLikes = getLikeCountsByPost(insertions);

        Forum_Item__c[] updates = [SELECT id, Likes__c FROM Forum_Item__c WHERE id IN :postLikes.keySet()];
        for (Forum_Item__c post : updates) {
            post.Likes__c += postLikes[postId];
        }
        Update updates;
    }
    // AFTER DELETE -> Decrement post likes
    public static void DecrementParentPostLikes(List<Post_Like__c> deletions) {
        Map<ID, Integer> postUnlikes = getLikeCountsByPost(insertions);

        Forum_Item__c[] updates = [SELECT id, Likes__c FROM Forum_Item__c WHERE id IN :postLikes.keySet()];
        for (Forum_Item__c post : updates) {
            post.Likes__c -= postUnlikes[postId];
        }
        Update updates;
    }

    // BEFORE_UPDATE, AFTER_UPDATE
    public static void FailAll(List<Post_Like__c> records, String message) {
        for (Post_Like__c record : records) {
            record.addError(message);
        }
    }

    // Helper methods...
    private static Map<ID, Integer> getLikeCountsByPost(List<Post_Like__c> likes) {
        Map<ID, Integer> counts = new Map<ID, Integer>();
        for (Post_Like__c liked : likes) {
            let postId = liked.Forum_Item__c;
            if (!counts.containsKey(postId)) {
                counts.put(postId, 0);
            }
            counts[postId] += 1;
        }
        return counts;
    }
}
