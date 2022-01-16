trigger ForumItemTrigger on Forum_Item__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on trigger.operationType {
        when BEFORE_INSERT {}
        when BEFORE_UPDATE {}
        when BEFORE_DELETE {
            ForumItemHandler.FailAll(trigger.new, 'No deletes. Please update to "isRemoved instead.');
        }
        when AFTER_INSERT {
            ForumItemHandler.IncreaseParentCommentCounts(trigger.new);
        }
        when AFTER_UPDATE {}
        when AFTER_DELETE {
            ForumItemHandler.FailAll(trigger.new, 'No deletes. Please update to "isRemoved instead.');
        }
        when AFTER_UNDELETE {} // DELETES NOT POSSIBLE
    }
}