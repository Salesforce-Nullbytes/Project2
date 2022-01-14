public without sharing class ForumItemHandler {

    // // BEFORE UPDATE -> increment all the way up parent chain
    // public static void IncreaseParentCommentCounts(List<Forum_Item__c> insertions) {
    //     Forum_Item[] newTops = new Forum_Item[]{};
    //     Forum_Item[] newComments = new Forum_Item[]{};

    //     Set<ID> topIDs = new Set<ID>();
    //     for (Forum_Item__c insertion : insertions) {
    //         ID thisTop = insertion.Top__c;
    //         if (thisTop == null) { newTops.add(insertion); }
    //         else {
    //             topIDs.add(thisTop);
    //             newComments.add(insertion);
    //         }
    //     } // Segregated children (who have parent comment increments) from top-level && list of top-level ancestors

    //     if (newComments.size() == 0) return; // No comment increments to make

    //     Map<Integer, Map<ID, Integer>> changesByIdByDepth = new Map<Integer, Map<ID, Integer>>();
    //     Integer maxDepth = 0;
    //     for (Forum_Item__c insertion : insertions) {
    //         ID parent = insertion.Parent__c;
    //         Integer pDepth = insertion.Depth__c - 1;

    //         if (!changesByIdByDepth.containsKey(pDepth)) {
    //             changesByIdByDepth.put(pDepth, new Map<ID, Integer>());
    //             if (pDepth > maxDepth) maxDepth = pDepth;
    //         }
    //         if (!changesByIdByDepth.get(pDepth).containsKey(parent)) {
    //             changesByIdByDepth.get(pDepth).put(parent, 0);
    //         }
    //         Integer childCount = 1; // default case for bottom-level comment
    //         if (changesByIdByDepth.get(pDepth+1).containsKey(insertion.id)) {
    //             childCount = changesByIdByDepth.get(pDepth+1).get(insertion.id);
    //         }
    //         Integer parentCount = changesByIdByDepth.get(pDepth).get(parent);
    //         changesByIdByDepth.get(pDepth).put(parent, parentCount + childCount);
    //     }
    //     for (Integer i = maxDepth; i > 1; i--) { // Exclude depth = 1, with Top__c instead of Parent__c
    //         for (Forum_Item__c child : [
    //             SELECT Parent__c FROM Forum_Item__c 
    //             WHERE Depth__c = :i AND id IN :changesByIdByDepth.get(i).keySet()]
    //         ) {
                
    //         }
    //     }

    // }

    // private static void incrementCounts(
    //     Map<Integer, Map<ID, Integer>> depthToIdToCount,
    //     List<Forum_Item__c> children
    // ) {
    //     for (Forum_Item__c child : children) {
    //         ID parent = child.Parent__c;
    //         Integer pDepth = child.Depth__c - 1;
    //         Integer childCount = 0;

    //         incrementCount(depthToIdToCount, pDepth, parent, childCount);
    //     }
    // }
    // private static void incrementCount(
    //     Map<Integer, Map<ID, Integer>> depthToIdToCount,
    //     Integer pDepth,
    //     ID parent,
    //     Integer childCount
    // ) {
    //     Integer newCount = childCount;
    //     if (depthToIdToCount.get(pDepth).containsKey(parent)) {
    //         newCount += depthToIdToCount.get(pDepth).get(parent);
    //     }
    //     depthToIdToCount.get(pDepth).put(parent, newCount);
    // }
}
