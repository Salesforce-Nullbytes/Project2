trigger PostLikeTrigger on Post_Like__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on trigger.operationType {
        when BEFORE_INSERT {
            PostLikeHandler.PreventDoubleInsert(trigger.new);
            PostLikeHandler.PreventExistingInsert(trigger.new);
        }
        when BEFORE_UPDATE {
            PostLikeHandler.FailAll(trigger.new, 'Updates are not allowed. Only delete or insert.');
        }
        when BEFORE_DELETE {} // Impossible to double-delete.
        when AFTER_INSERT {
            PostLikeHandler.IncrementParentPostLikes(trigger.new);
        }
        when AFTER_UPDATE {
            PostLikeHandler.FailAll(trigger.new, 'Updates are not allowed. Only delete or insert.');
        }
        when AFTER_DELETE {
            PostLikeHandler.DecrementParentPostLikes(trigger.old);
        }
        when AFTER_UNDELETE {
            PostLikeHandler.FailAll(trigger.new, 'No undeletes. Please insert new records instead.');
        }
    }
}