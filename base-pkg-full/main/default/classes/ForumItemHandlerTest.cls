@isTest
public class ForumItemHandlerTest {
    @testSetup
    public static void SetupTests() {
        //Pricebook2 std = new Pricebook2(name = 'Standard Price Book');
        //Insert std;
        //DataFactory.ProductSetup();
        DataFactory.AccountSetup();
        DataFactory.ForumSetup();
    }
    @isTest
    public static void TN_NoDeletes() {
        Test.startTest();
        Forum_Item__c ref = [SELECT id FROM Forum_Item__c LIMIT 1];
        System.assertNotEquals(null, ref);

        Boolean failed = false;
        try{
            Delete ref;
        } catch (Exception e){
            failed = true;
        }
        System.assertEquals(true, failed);
        Test.stopTest();
    }
    @isTest
    static void TS_IncrementSingleTopOneChild(){
        Test.startTest();
        Forum_Item__c[] topLevelPosts = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE Depth__c = 0 LIMIT 1];
        System.assert(topLevelPosts.size() > 0);

        Decimal previousCount = topLevelPosts[0].Child_Comments__c;

        Forum_Item__c comment = new Forum_Item__c();
        comment.Title__c = 'Test title';
        comment.Content__c = 'Test content';
        comment.Parent__c = topLevelPosts[0].id;
        comment.Top__c = topLevelPosts[0].id;

        insert comment;
        Forum_Item__c updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id = :topLevelPosts[0].id LIMIT 1];
        Decimal newCount = updated.Child_Comments__c;

        System.assertEquals(previousCount+1, newCount);
        Test.stopTest();
    }
    @isTest
    static void TB_IncrementSingleTopManyChild(){
        Test.startTest();
        Forum_Item__c[] topLevelPosts = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE Depth__c = 0 LIMIT 1];
        System.assert(topLevelPosts.size() > 0);

        Decimal previousCount = topLevelPosts[0].Child_Comments__c;

        Forum_Item__c[] comments = new Forum_Item__c[]{};
        
        Forum_Item__c comment1 = new Forum_Item__c();
        comment1.Title__c = 'Test title';
        comment1.Content__c = 'Test content';
        comment1.Parent__c = topLevelPosts[0].id;
        comment1.Top__c = topLevelPosts[0].id;
        Forum_Item__c comment2 = new Forum_Item__c();
        comment2.Title__c = 'Test title';
        comment2.Content__c = 'Test content';
        comment2.Parent__c = topLevelPosts[0].id;
        comment2.Top__c = topLevelPosts[0].id;

        comments.add(comment1);
        comments.add(comment2);

        insert comments;
        Forum_Item__c updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id = :topLevelPosts[0].id LIMIT 1];
        Decimal newCount = updated.Child_Comments__c;

        System.assertEquals(previousCount+comments.size(), newCount);
        Test.stopTest();
    }
    @isTest
    static void TS_IncrementSingleChildOneChild(){
        Test.startTest();
        Forum_Item__c[] nonTopLevelPosts = [SELECT id, Child_Comments__c, Top__c FROM Forum_Item__c WHERE Depth__c > 0 LIMIT 1];
        System.assert(nonTopLevelPosts.size() > 0);

        Decimal previousCount = nonTopLevelPosts[0].Child_Comments__c;

        Forum_Item__c comment = new Forum_Item__c();
        comment.Title__c = 'Test title';
        comment.Content__c = 'Test content';
        comment.Parent__c = nonTopLevelPosts[0].id;
        comment.Top__c = nonTopLevelPosts[0].Top__c;

        insert comment;
        Forum_Item__c updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id = :nonTopLevelPosts[0].id LIMIT 1];
        Decimal newCount = updated.Child_Comments__c;

        System.assertEquals(previousCount+1, newCount);
        Test.stopTest();
    }
    @isTest
    static void TB_IncrementSingleChildManyChild(){
        Test.startTest();
        Forum_Item__c[] nonTopLevelPosts = [SELECT id, Child_Comments__c, Top__c FROM Forum_Item__c WHERE Depth__c > 0 LIMIT 1];
        System.assert(nonTopLevelPosts.size() > 0);

        Decimal previousCount = nonTopLevelPosts[0].Child_Comments__c;

        Forum_Item__c[] comments = new Forum_Item__c[]{};
        
        Forum_Item__c comment1 = new Forum_Item__c();
        comment1.Title__c = 'Test title';
        comment1.Content__c = 'Test content';
        comment1.Parent__c = nonTopLevelPosts[0].id;
        comment1.Top__c = nonTopLevelPosts[0].Top__c;
        Forum_Item__c comment2 = new Forum_Item__c();
        comment2.Title__c = 'Test title';
        comment2.Content__c = 'Test content';
        comment2.Parent__c = nonTopLevelPosts[0].id;
        comment2.Top__c = nonTopLevelPosts[0].Top__c;

        comments.add(comment1);
        comments.add(comment2);

        insert comments;
        Forum_Item__c updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id = :nonTopLevelPosts[0].id LIMIT 1];
        Decimal newCount = updated.Child_Comments__c;

        System.assertEquals(previousCount+comments.size(), newCount);
        Test.stopTest();
    }
    @isTest
    static void TS_ManyTopOneChild(){
        Test.startTest();
        Forum_Item__c[] topLevelPosts = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE Depth__c = 0 LIMIT 2];
        System.assert(topLevelPosts.size() > 1);

        Map<ID, Decimal> prevParentCounts = new Map<ID, Decimal>();
        Forum_Item__c[] comments = new Forum_Item__c[]{};
        for (Integer i = 0; i < topLevelPosts.size(); i++) {
            Forum_Item__c comment = new Forum_Item__c();
            comment.Title__c = 'Test title ' + i;
            comment.Content__c = 'Test content ' + i;
            comment.Parent__c = topLevelPosts[i].id;
            comment.Top__c = topLevelPosts[i].id;
    
            comments.add(comment);
            prevParentCounts.put(topLevelPosts[i].id, topLevelPosts[i].Child_Comments__c);
        }
        insert comments;

        Forum_Item__c[] updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id IN :prevParentCounts.keySet()];
        System.assertEquals(topLevelPosts.size(), updated.size());
        for (Forum_Item__c incremented : updated) {
            System.assertEquals(prevParentCounts.get(incremented.id) + 1, incremented.Child_Comments__c);
        }
        Test.stopTest();
    }
    @isTest
    static void TB_IncrementManyTopManyChild(){
        Test.startTest();
        Forum_Item__c[] topLevelPosts = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE Depth__c = 0 LIMIT 2];
        System.assert(topLevelPosts.size() > 1);

        Integer numInserted = 2;

        Map<ID, Decimal> prevParentCounts = new Map<ID, Decimal>();
        Forum_Item__c[] comments = new Forum_Item__c[]{};
        for (Integer i = 0; i < topLevelPosts.size(); i++) {
            prevParentCounts.put(topLevelPosts[i].id, topLevelPosts[i].Child_Comments__c);
            
            for (Integer j = 0; j < numInserted; j++) {
                Forum_Item__c comment = new Forum_Item__c();
                comment.Title__c = 'Test title ' + j;
                comment.Content__c = 'Test content ' + j;
                comment.Parent__c = topLevelPosts[i].id;
                comment.Top__c = topLevelPosts[i].id;

                comments.add(comment);
            }
        }
        insert comments;

        Forum_Item__c[] updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id IN :prevParentCounts.keySet()];
        System.assertEquals(topLevelPosts.size(), updated.size());
        for (Forum_Item__c incremented : updated) {
            System.assertEquals(prevParentCounts.get(incremented.id) + numInserted, incremented.Child_Comments__c);
        }
        Test.stopTest();
    }
    @isTest
    static void TS_ManyChildOneChild(){
        Test.startTest();
        Forum_Item__c[] nonTopLevelPosts = [SELECT id, Child_Comments__c, Top__c FROM Forum_Item__c WHERE Depth__c > 0 LIMIT 2];
        System.assert(nonTopLevelPosts.size() > 1);

        Map<ID, Decimal> prevParentCounts = new Map<ID, Decimal>();
        Forum_Item__c[] comments = new Forum_Item__c[]{};
        for (Integer i = 0; i < nonTopLevelPosts.size(); i++) {
            Forum_Item__c comment = new Forum_Item__c();
            comment.Title__c = 'Test title ' + i;
            comment.Content__c = 'Test content ' + i;
            comment.Parent__c = nonTopLevelPosts[i].id;
            comment.Top__c = nonTopLevelPosts[i].Top__c;
    
            comments.add(comment);
            prevParentCounts.put(nonTopLevelPosts[i].id, nonTopLevelPosts[i].Child_Comments__c);
        }
        insert comments;

        Forum_Item__c[] updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id IN :prevParentCounts.keySet()];
        System.assertEquals(nonTopLevelPosts.size(), updated.size());
        for (Forum_Item__c incremented : updated) {
            System.assertEquals(prevParentCounts.get(incremented.id) + 1, incremented.Child_Comments__c);
        }
        Test.stopTest();
    }
    @isTest
    static void TB_IncrementChildManyChild(){
        Test.startTest();
        Forum_Item__c[] nonTopLevelPosts = [SELECT id, Child_Comments__c, Top__c FROM Forum_Item__c WHERE Depth__c > 0 LIMIT 2];
        System.assert(nonTopLevelPosts.size() > 1);

        Integer numInserted = 2;

        Map<ID, Decimal> prevParentCounts = new Map<ID, Decimal>();
        Forum_Item__c[] comments = new Forum_Item__c[]{};
        for (Integer i = 0; i < nonTopLevelPosts.size(); i++) {
            prevParentCounts.put(nonTopLevelPosts[i].id, nonTopLevelPosts[i].Child_Comments__c);
            
            for (Integer j = 0; j < numInserted; j++) {
                Forum_Item__c comment = new Forum_Item__c();
                comment.Title__c = 'Test title ' + j;
                comment.Content__c = 'Test content ' + j;
                comment.Parent__c = nonTopLevelPosts[i].id;
                comment.Top__c = nonTopLevelPosts[i].Top__c;

                comments.add(comment);
            }
        }
        insert comments;

        Forum_Item__c[] updated = [SELECT id, Child_Comments__c FROM Forum_Item__c WHERE id IN :prevParentCounts.keySet()];
        System.assertEquals(nonTopLevelPosts.size(), updated.size());
        for (Forum_Item__c incremented : updated) {
            System.assertEquals(prevParentCounts.get(incremented.id) + numInserted, incremented.Child_Comments__c);
        }
        Test.stopTest();
    }
    @isTest
    public static void TP_SingleIncrementsCascade() {
        Test.startTest();
        Forum_Item__c[] parents = [
            SELECT Top__c, Parent__c, Depth__c, Child_Comments__c 
            FROM Forum_Item__c
            WHERE Depth__c > 1];
        
        System.assert(parents.size() > 0); 

        Map<ID,Decimal> prevCounts = new Map<ID,Decimal>();
        Forum_Item__c parentRef = parents[0];
        prevCounts.put(parentRef.id, parentRef.Child_Comments__c);

        while (parentRef.Parent__c != null) {
            Forum_Item__c nextParent = [SELECT Parent__c, Child_Comments__c FROM Forum_Item__c WHERE id = :parentRef.Parent__c LIMIT 1];
            prevCounts.put(nextParent.id, nextParent.Child_Comments__c);
            parentRef = nextParent;            
        }

        Forum_Item__c child = new Forum_Item__c();
        child.Title__c = 'Test title';
        child.Content__c = 'Test content';
        child.Top__c = parents[0].Top__c;
        child.Parent__c = parents[0].id;

        Insert child;

        parentRef = parents[0];
        Forum_Item__c[] updated = [SELECT Child_Comments__c FROM Forum_Item__c WHERE id IN :prevCounts.keySet()];
        System.assertEquals(updated.size(), parentRef.Depth__c+1); // Plus one for top post, depth 0
        for (Forum_Item__c incremented : updated) {
            System.assertEquals(prevCounts.get(incremented.id) + 1, incremented.Child_Comments__c);
        }
        Test.stopTest();
    }
    @isTest
    public static void TP_SiblingNotIncremented() {
        Test.startTest();
        Forum_Item__c[] posts = [
            SELECT Parent__c, Child_Comments__c, Parent__r.id, Parent__r.Child_Comments__c
            FROM Forum_Item__c
            WHERE Depth__c > 1 AND Parent__r.Child_Comments__c > 0];
        
        System.assert(posts.size() > 0); 
        Forum_Item__c thisPost = posts[0];
        Forum_Item__c thisParent = thisPost.Parent__r;
        Forum_Item__c[] thisSiblings = [SELECT Child_Comments__c FROM Forum_Item__c WHERE Parent__c = :thisParent.id];
        System.assert(thisSiblings.size() > 0); 
        
        Map<ID, Decimal> prevCounts = new Map<ID,Decimal>();
        for (Forum_Item__c sibling : thisSiblings) {
            prevCounts.put(sibling.id, sibling.Child_Comments__c);
        }
        System.assert(prevCounts.size() > 0); 

        Forum_Item__c newSibling = new Forum_Item__c();
        newSibling.Title__c = 'Test Title';
        newSibling.Content__c = 'Test Content';
        newSibling.Parent__c = thisParent.id;

        Insert newSibling;

        Forum_Item__c[] updatedSiblings = [SELECT Child_Comments__c FROM Forum_Item__c WHERE Parent__c = :thisParent.id];
        for (Forum_Item__c updated : updatedSiblings) {
            if (updated.id != newSibling.id) {
                System.assertEquals(prevCounts.get(updated.id), updated.Child_Comments__c);
            } else {
                System.assertEquals(0, updated.Child_Comments__c); // New comment has no children
            }
        }
        System.assertEquals(thisSiblings.size()+1, updatedSiblings.size()); // One higher for inserted sibling
        Test.stopTest();
    }
    @isTest
    public static void TP_UnclesNotIncremented() {
        Test.startTest();
        Forum_Item__c[] posts = [
            SELECT Parent__c, Child_Comments__c, Parent__r.id, Parent__r.Child_Comments__c
            FROM Forum_Item__c
            WHERE Depth__c > 1 AND Parent__r.Child_Comments__c > 0];
        
        System.assert(posts.size() > 0); 
        Forum_Item__c thisPost = posts[0];
        Forum_Item__c thisParent = thisPost.Parent__r;
        Forum_Item__c[] thisSiblings = [SELECT Child_Comments__c FROM Forum_Item__c WHERE Parent__c = :thisParent.id];
        System.assert(thisSiblings.size() > 0); 
        
        Map<ID, Decimal> prevCounts = new Map<ID,Decimal>();
        for (Forum_Item__c sibling : thisSiblings) {
            prevCounts.put(sibling.id, sibling.Child_Comments__c);
        }
        System.assert(prevCounts.size() > 0); 

        Forum_Item__c newChild = new Forum_Item__c();
        newChild.Title__c = 'Test Title';
        newChild.Content__c = 'Test Content';
        newChild.Parent__c = thisPost.id;

        Insert newChild;

        Forum_Item__c[] updatedSiblings = [SELECT Child_Comments__c FROM Forum_Item__c WHERE Parent__c = :thisParent.id];
        for (Forum_Item__c updated : updatedSiblings) {
            if (updated.id != thisPost.id) {
                System.assertEquals(prevCounts.get(updated.id), updated.Child_Comments__c);
            } else {
                System.assertEquals(thisPost.Child_Comments__c+1, updated.Child_Comments__c);
            }
        }
        System.assertEquals(thisSiblings.size(), updatedSiblings.size()); // Same size
        Test.stopTest();
    }
}