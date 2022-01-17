public without sharing class LWCShopController {

    @AuraEnabled
    public static Boolean AddToCart(String productCode) {
        PricebookEntry sku;
        for (PricebookEntry entry : [
            SELECT Product2Id, Pricebook2Id, UnitPrice 
            FROM PricebookEntry 
            WHERE ProductCode = :productCode AND IsActive = true 
            LIMIT 1
        ]) { sku = entry; }
        if (sku == null) return false;

        // Create draft order if none existing...
        Order cart;
        for (Order o : [
            SELECT id 
            FROM Order 
            WHERE AccountId = :getAccountId() AND Status = 'Draft' 
            LIMIT 1
        ]){ cart = o; }
        if (cart == null) {
            cart = new Order();
            cart.AccountId = getAccountId();
            cart.Pricebook2Id = sku.Pricebook2Id;
            cart.EffectiveDate = System.today();
            cart.Status = 'Draft';
            Insert cart;
        }
        
        OrderItem item;
        for (OrderItem inCart : [
            SELECT id 
            FROM OrderItem 
            WHERE OrderId = :cart.id AND Product2.ProductCode = :productCode 
            LIMIT 1
        ]) { item = inCart; }
        if (item != null) { return false; }
        item = new OrderItem();

        item.product2id = sku.id;
        item.pricebookEntryId = sku.Pricebook2Id;
        item.UnitPrice = sku.UnitPrice;
        item.orderid = cart.id;
        item.quantity = 1;
        
        Insert item;
        return true;
    }

    public static ID getAccountId() {
        ID currentUserId = UserInfo.getUserId();
        return [SELECT id, Contact.AccountId FROM User WHERE id = :currentUserId]?.Contact.AccountId;
    }
}
