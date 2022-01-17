public without sharing class PostLikeHandler {

    @testVisible
    private static Map<ID, List<ID>> getPostsLikedByAccount(Set<ID> accountIds, Set<ID> postIds) {
        List<Account> accountLikes = [
            SELECT id, (
                SELECT id, Forum_Item__c 
                FROM Post_Likes__r 
                WHERE Forum_Item__c IN :postIDs 
            ) 
            FROM Account 
            WHERE id IN :accountIDs
        ];

        Map<ID, List<ID>> mapAccountLikes = new Map<ID, List<ID>>();
        for (Account a : accountLikes) {
            List<ID> postsLiked = new List<ID>();
            for (Post_Like__c liked : a.Post_Likes__r) {
                postsLiked.add(liked.Forum_Item__c);
            }
            mapAccountLikes.put(a.id, postsLiked);
        }
        return mapAccountLikes;
    }

    // BEFORE INSERT -> Prevent if account already liked post.
    public static void PreventExistingInsert(List<Post_Like__c> insertions) {
        Set<ID> accounts = new Set<ID>();
        Set<ID> posts = new Set<ID>();
        for (Post_Like__c insertion : insertions) {
            accounts.add(insertion.Account__c);
            posts.add(insertion.Forum_Item__c);
        }

        Map<ID, List<ID>> mapAccountLikes = getPostsLikedByAccount(accounts, posts);

        for (Post_Like__c insertion : insertions) {
            ID acctId = insertion.Account__c;
            for (ID postId : mapAccountLikes.get(acctId)) {
                ID existing = insertion.Forum_Item__c;
                if (insertion.Forum_Item__c == existing) {
                    insertion.addError('No insert: Account already liked post.');
                }
            }
        }
    }
    // BEFORE INSERT -> Prevent if account liking post appears twice.
    public static void PreventDoubleInsert(List<Post_Like__c> insertions) {
        Map<ID, Set<ID>> observedLikes = new Map<ID, Set<ID>>();
        for (Post_Like__c liked : insertions) {
            ID acctId = liked.Account__c;
            if (!observedLikes.containsKey(acctId)) {
                observedLikes.put(acctId, new Set<ID>());
            }
            if (observedLikes.get(acctId).contains(liked.Forum_Item__c)) {
                liked.addError('No insert: like appeared twice in list!');
            } else {
                observedLikes.get(acctId).add(liked.Forum_Item__c);
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