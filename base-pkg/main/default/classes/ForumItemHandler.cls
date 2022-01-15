public without sharing class ForumItemHandler {

    // BEFORE INSERT -> increment all the way up parent chain
    public static void IncreaseParentCommentCounts(List<Forum_Item__c> insertions) {
        Forum_Item__c[] newTops = new Forum_Item__c[]{}; // Tops cannot have comments yet
        Forum_Item__c[] newComments = new Forum_Item__c[]{};

        Set<ID> topIDs = new Set<ID>();
        for (Forum_Item__c insertion : insertions) {
            ID thisTop = insertion.Top__c;
            if (thisTop == null) { newTops.add(insertion); }
            else {
                topIDs.add(thisTop);
                newComments.add(insertion);
            }
        } // Segregated children (who have parent comment increments) from top-level

        if (newComments.size() == 0) return; // No comment increments to make

        Map<Integer, Map<ID, Integer>> depthToIdToCount = mapDepthToPostToCascadedCounts(newComments);
        Integer maxDepth = getGreatestMapKey(depthToIdToCount);

        cascadeCounts(depthToIdToCount, maxDepth);

        Map<ID, Integer> allChanges = new Map<ID, Integer>();
        for (Integer depth : depthToIdToCount.keySet()) {
            allChanges.putAll(depthToIdToCount.get(depth));
        }

        List<Forum_Item__c> updates = [SELECT Child_Comments__c FROM Forum_Item__c WHERE id IN :allChanges.keySet()];
        for (Forum_Item__c updating : updates) {
            updating.Child_Comments__c += allChanges.get(updating.id);
        }
        Update updates;
    }

    // Build map of cascaded inserted/deleted comment counts from existing list
    private static Map<Integer, Map<ID, Integer>> mapDepthToPostToCascadedCounts(
        List<Forum_Item__c> existingList
    ) {
        Map<Integer, Map<ID, Integer>> depthToIdToCount = new Map<Integer, Map<ID, Integer>>();
        Integer maxDepth = 0;
        for (Forum_Item__c comment : existingList) {
            ID parent = comment.Parent__c;
            Integer pDepth = (Integer)comment.Depth__c - 1;

            if (!depthToIdToCount.containsKey(pDepth)) {
                depthToIdToCount.put(pDepth, new Map<ID, Integer>());
                if (pDepth > maxDepth) maxDepth = pDepth;
            }

            Integer childCount = 1; // The increment to take place for the new comment being iterated
            if (depthToIdToCount.get(pDepth).containsKey(parent)) {
                childCount += depthToIdToCount.get(pDepth).get(parent);
            }
            depthToIdToCount.get(pDepth).put(parent, childCount);
        }
        // Fill holes in keyset from 0 to maxDepth
        for (Integer depth = 0; depth < maxDepth; depth++) {
            if (!depthToIdToCount.containsKey(depth)) {
                depthToIdToCount.put(depth, new Map<ID, Integer>());
            }
        }
        return depthToIdToCount;
    }
    private static Integer getGreatestMapKey(Map<Integer, Map<ID, Integer>> fromSet) {
        if (!fromSet.containsKey(1)) return 0;
        Integer key = 1;
        while (fromSet.containsKey(key+1)) {
            key++;
        }
        return key;
    }
    private static void cascadeCounts(
        Map<Integer, Map<ID, Integer>> depthToIdToCount,
        Integer maxDepth
    ) {
        for (Integer depth = maxDepth; depth > 0; depth--) {
            incrementCounts(depthToIdToCount, [
                SELECT Parent__c, Depth__c FROM Forum_Item__c 
                WHERE Depth__c = :depth AND id IN :depthToIdToCount.get(depth).keySet()
            ]);
        }
        
    }
    private static void incrementCounts(
        Map<Integer, Map<ID, Integer>> depthToIdToCount,
        List<Forum_Item__c> children // Only those with counts!
    ) {
        for (Forum_Item__c child : children) {
            ID parent = child.Parent__c;
            Integer pDepth = (Integer)child.Depth__c - 1;
            Integer childCount = 1; // Default in cast the comment is new
            if (depthToIdToCount.containsKey(pDepth+1)) {
                if (depthToIdToCount.get(pDepth+1).containsKey(child.Id)) {
                    childCount = depthToIdToCount.get(pDepth+1).get(child.Id);
                }
            }
            incrementCount(depthToIdToCount, pDepth, parent, childCount);
        }
    }
    private static void incrementCount(
        Map<Integer, Map<ID, Integer>> depthToIdToCount,
        Integer pDepth,
        ID parent,
        Integer childCount
    ) {
        Integer newCount = childCount;
        if (depthToIdToCount.get(pDepth).containsKey(parent)) {
            newCount += depthToIdToCount.get(pDepth).get(parent);
        }
        depthToIdToCount.get(pDepth).put(parent, newCount);
    }
}
