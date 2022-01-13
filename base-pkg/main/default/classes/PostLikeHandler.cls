public without sharing class PostLikeHandler {
    // BEFORE INSERT -> Prevent if account already liked post.
    public static void PreventDoubleInsert(List<Post_Like__c> insertions) {
        Set<ID> accounts = new Set<ID>();
        Set<ID> posts = new Set<ID>();
        for (Post_Like__c insertion : insertions) {
            accounts.add(insertion.Account__c);
            posts.add(insertion.Forum_Item__c);
        }

        List<Account> accountLikes = [
            SELECT id, (
                SELECT id, Forum_Item__c 
                FROM Post_Likes__r 
                WHERE id IN :posts 
            ) 
            FROM Account 
            WHERE id IN :accounts
        ];
        Map<ID, Account> mapAccountLikes = new Map<ID, Account>();
        for (Account a : accountLikes) {
            mapAccountLikes.put(a.id, a);
        }

        for (Post_Like__c insertion : insertions) {
            List<Post_Like__c> likes = mapAccountLikes.get(insertion.Account__c).Post_Likes__r;
            for (Post_Like__c liked : likes) {
                if (insertion.Forum_Item__c == liked.Forum_Item__c) {
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
            post.Likes__c += postLikes.get(post.Id);
        }
        Update updates;
    }
    // AFTER DELETE -> Decrement post likes
    public static void DecrementParentPostLikes(List<Post_Like__c> deletions) {
        Map<ID, Integer> postUnlikes = getLikeCountsByPost(deletions);

        Forum_Item__c[] updates = [SELECT id, Likes__c FROM Forum_Item__c WHERE id IN :postUnlikes.keySet()];
        for (Forum_Item__c post : updates) {
            post.Likes__c -= postUnlikes.get(post.Id);
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
            ID postId = liked.Forum_Item__c;
            if (!counts.containsKey(postId)) {
                counts.put(postId, 0);
            }
            Integer prior = counts.get(postId);
            counts.put(postId, prior + 1);
        }
        return counts;
    }
}
