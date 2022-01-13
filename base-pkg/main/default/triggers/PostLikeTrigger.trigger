trigger PostLikeTrigger on Post_Like__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on trigger.operationType {
        when BEFORE_INSERT {
            PostLikeHandler.PreventDoubleInsert(trigger.new);
        }
        when BEFORE_UPDATE {}
        when BEFORE_DELETE {}
        when AFTER_INSERT {
            PostLikeHandler.IncrementParentPostLikes(trigger.new);
        }
        when AFTER_UPDATE {}
        when AFTER_DELETE {}
        when AFTER_UNDELETE {}
    }
}