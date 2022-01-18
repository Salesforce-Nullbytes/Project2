trigger ForumItemTrigger on Forum_Item__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on trigger.operationType {
        when BEFORE_INSERT {} // SIMPLE LOGIC HANDLES IN FLOW & VALIDATION RULES
        when BEFORE_UPDATE {}
        when BEFORE_DELETE {
            ForumItemHandler.FailAll(trigger.old, 'No deletes. Please update to "isRemoved instead.');
        }
        when AFTER_INSERT {
            ForumItemHandler.IncreaseParentCommentCounts(trigger.new);
        }
        when AFTER_UPDATE {}
        when AFTER_DELETE {} // DELETES NOT POSSIBLE
        when AFTER_UNDELETE {} // DELETES NOT POSSIBLE
    }
}