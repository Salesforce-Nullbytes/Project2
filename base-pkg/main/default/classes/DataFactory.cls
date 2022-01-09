public class DataFactory {
    enum PlantSize { SMALL, MEDIUM, LARGE }
    enum Difficulty { EASY, REGULAR, HARD }
    enum LightLevel { LOW, INDIRECT, BRIGHT, ANY_LIGHT }

    private static Integer counter = 101; // For assigning uinque product codes

    public static void ProductSetup() {
        // Pricebook setup
        Pricebook2 pb = [SELECT id, name FROM Pricebook2 WHERE name = 'Standard Price Book' LIMIT 1];
        pb.isActive = true;
        Update pb;

        // Used to generate products and later attach prices in PricebookEntry
        Map<String, ProductInfo> infoMap = GetProductMap();

        // Insert Product2 records
        List<Product2> productInserts = new List<Product2>();
        for (ProductInfo pInfo : infoMap.values()) {
            productInserts.add(pInfo.ToProduct());
        }
        Insert productInserts;

        // Insert pricebook entries
        List<PricebookEntry> pbEntries = new List<PricebookEntry>();
        for (Product2 prod : productInserts) {
            PricebookEntry entry = new PricebookEntry();
            entry.isActive = true;
            entry.Pricebook2Id = pb.id;
            entry.Product2Id = prod.id;
            entry.UnitPrice = infoMap.get(prod.ProductCode).price;
            //entry.UseStandardPrice = true;

            pbEntries.add(entry);
        }
        Insert pbEntries;
    }

    // Generate Map of ProductCode (SKU) to Product Info Helper (with price)
    public static Map<String, ProductInfo> GetProductMap() {
        Map<String, ProductInfo> infoMap = new Map<String, ProductInfo>();
        ProductInfo[] details = new ProductInfo[] {
            new ProductInfo('Pothos', 15.00, PlantSize.SMALL, Difficulty.EASY, 
                true, // hasVarieties
                'golden', // subVariety
                false, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.LOW),
            new ProductInfo('Pothos', 15.00, PlantSize.SMALL, Difficulty.EASY, 
                true, // hasVarieties
                'silver', // subVariety
                false, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.LOW),
            new ProductInfo('Pothos', 15.00, PlantSize.SMALL, Difficulty.EASY, 
                true, // hasVarieties
                'marble green', // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.LOW),
            new ProductInfo('Philodendron', 15.00, PlantSize.SMALL, Difficulty.EASY, 
                true, // hasVarieties
                'heartleaf', // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.LOW),
            new ProductInfo('Philodendron', 15.00, PlantSize.SMALL, Difficulty.EASY, 
                true, // hasVarieties
                'brasil', // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.LOW),
            new ProductInfo('Monstera', 100.00, PlantSize.LARGE, Difficulty.EASY, 
                false, // hasVarieties
                null, // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.LOW),
            new ProductInfo('Cactus', 10.00, PlantSize.SMALL, Difficulty.EASY, 
                true, // hasVarieties
                'prickly pear - small', // subVariety
                true, // petFriendly
                true, // flowers
                false, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Cactus', 10.00, PlantSize.SMALL, Difficulty.EASY, 
                true, // hasVarieties
                'fairy tale - small', // subVariety
                true, // petFriendly
                true, // flowers
                false, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Cactus', 50.00, PlantSize.MEDIUM, Difficulty.EASY, 
                true, // hasVarieties
                'prickly pear - medium', // subVariety
                true, // petFriendly
                true, // flowers
                false, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Cactus', 50.00, PlantSize.MEDIUM, Difficulty.EASY, 
                true, // hasVarieties
                'fairy tale - medium', // subVariety
                true, // petFriendly
                true, // flowers
                false, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Cactus', 100.00, PlantSize.LARGE, Difficulty.EASY, 
                true, // hasVarieties
                'prickly pear - large', // subVariety
                true, // petFriendly
                true, // flowers
                false, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Cactus', 100.00, PlantSize.LARGE, Difficulty.EASY, 
                true, // hasVarieties
                'fairy tale - large', // subVariety
                true, // petFriendly
                true, // flowers
                false, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Fig Fiddle', 150.00, PlantSize.LARGE, Difficulty.HARD, 
                false, // hasVarieties
                null, // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.INDIRECT),
            new ProductInfo('Bird of Paradise', 150.00, PlantSize.LARGE, Difficulty.REGULAR, 
                false, // hasVarieties
                null, // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.BRIGHT),
            new ProductInfo('Ficus', 65.00, PlantSize.MEDIUM, Difficulty.REGULAR, 
                true, // hasVarieties
                'Burgundy and dark Green', // subVariety
                false, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.BRIGHT),
            new ProductInfo('Ficus', 65.00, PlantSize.MEDIUM, Difficulty.REGULAR, 
                true, // hasVarieties
                'ruby-pink', // subVariety
                false, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.BRIGHT),
            new ProductInfo('Dracaena', 100.00, PlantSize.LARGE, Difficulty.REGULAR, 
                false, // hasVarieties
                null, // subVariety
                false, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.LOW),
            new ProductInfo('Maranta Prayer Plant', 15.00, PlantSize.SMALL, Difficulty.REGULAR, 
                false, // hasVarieties
                null, // subVariety
                true, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.LOW),
            new ProductInfo('Sansevieria Snake Plant', 75.00, PlantSize.LARGE, Difficulty.EASY, 
                true, // hasVarieties
                'zeylanica', // subVariety
                false, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Sansevieria Snake Plant', 75.00, PlantSize.LARGE, Difficulty.EASY, 
                true, // hasVarieties
                'lavenia', // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.ANY_LIGHT),
            new ProductInfo('Orchid', 30.00, PlantSize.MEDIUM, Difficulty.HARD, 
                true, // hasVarieties
                'blue', // subVariety
                true, // petFriendly
                true, // flowers
                true, // Colors
                LightLevel.BRIGHT),
            new ProductInfo('Orchid', 30.00, PlantSize.MEDIUM, Difficulty.HARD, 
                true, // hasVarieties
                'orange', // subVariety
                true, // petFriendly
                true, // flowers
                true, // Colors
                LightLevel.BRIGHT),
            new ProductInfo('Money Tree', 60.00, PlantSize.MEDIUM, Difficulty.EASY, 
                false, // hasVarieties
                null, // subVariety
                true, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.LOW),
            new ProductInfo('Pilea', 15.00, PlantSize.SMALL, Difficulty.EASY, 
                false, // hasVarieties
                null, // subVariety
                true, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.INDIRECT),
            new ProductInfo('Calathea', 20.00, PlantSize.SMALL, Difficulty.REGULAR, 
                true, // hasVarieties
                'triostar', // subVariety
                true, // petFriendly
                false, // flowers
                true, // Colors
                LightLevel.LOW),
            new ProductInfo('Calathea', 20.00, PlantSize.SMALL, Difficulty.REGULAR, 
                true, // hasVarieties
                'pinstripe', // subVariety
                true, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.LOW),
            new ProductInfo('Palm', 80.00, PlantSize.LARGE, Difficulty.EASY, 
                false, // hasVarieties
                null, // subVariety
                true, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.BRIGHT),
            new ProductInfo('Zanzibar', 30.00, PlantSize.MEDIUM, Difficulty.EASY, 
                false, // hasVarieties
                null, // subVariety
                false, // petFriendly
                false, // flowers
                false, // Colors
                LightLevel.LOW)
        };
        for (ProductInfo info : details) {
            infoMap.put(info.code, info);
        }
        return infoMap;
    }
    // Helper class (with price) to contain product details
    private class ProductInfo {
        //private static Integer counter = 101;

        public String name;
        public Decimal price;
        public PlantSize size;
        public Difficulty difficulty;
        public Boolean hasVarieties;
        public String subVariety;
        public Boolean petFriendly;
        public Boolean flowers;
        public Boolean colors;
        public LightLevel light;
        public String code;

        public ProductInfo(String name, Decimal price, PlantSize size, Difficulty difficulty, Boolean hasVarieties, 
            String subVariety, Boolean petFriendly, Boolean flowers, Boolean colors, LightLevel light
        ) {
            this.name = name;
            this.price = price;
            this.hasVarieties = hasVarieties;
            this.subVariety = subVariety;
            this.size = size;
            this.difficulty = difficulty;
            this.light = light;
            this.petFriendly = petFriendly;
            this.flowers = flowers;
            this.colors = colors;

            this.code = this.newProductCode();
        }

        public Product2 ToProduct() {
            Product2 p = new Product2();
            p.name = this.name;
            p.ProductCode = this.code;
            p.StockKeepingUnit = this.code;
            p.IsActive = true;

            // Custom Product Details
            p.HasVarieties__c = this.hasVarieties;
            if (this.hasVarieties) {
                p.SubVariety__c = this.subVariety;
            }
            switch on this.size {
                when SMALL { p.Size__c = 'Small'; }
                when MEDIUM { p.Size__c = 'Medium'; }
                when LARGE { p.Size__c = 'Large'; }
                when else { p.addError('Unrecognized size!'); }
            }
            switch on this.difficulty {
                when EASY { p.Difficulty__c = 'Easy'; }
                when REGULAR { p.Difficulty__c = 'Regular'; }
                when HARD { p.Difficulty__c = 'Hard'; }
                when else { p.addError('Unrecognized difficulty!'); }
            }
            switch on this.light {
                when LOW { p.Light_Level__c = 'Low'; }
                when INDIRECT { p.Light_Level__c = 'Indirect'; }
                when BRIGHT { p.Light_Level__c = 'Bright'; }
                when ANY_LIGHT { p.Light_Level__c = 'Any'; }
                when else { p.addError('Unrecognized light level!'); }
            }
            p.IsPetFriendly__c = this.petFriendly;
            p.HasColor__c = this.colors;
            p.HasFlowers__c = this.flowers;

            return p;
        }
        public String newProductCode() {
            String sizeCode;
            String diffCode;
            String lightCode;
            switch on this.size {
                when SMALL { sizeCode = 'S'; }
                when MEDIUM { sizeCode = 'M'; }
                when LARGE { sizeCode = 'L'; }
                when else { sizeCode = '0'; }
            }
            switch on this.difficulty {
                when EASY { diffCode = 'E'; }
                when REGULAR { diffCode = 'R'; }
                when HARD { diffCode = 'H'; }
                when else { diffCode = '0'; }
            }
            switch on this.light {
                when LOW { lightCode = 'L'; }
                when INDIRECT { lightCode = 'I'; }
                when BRIGHT { lightCode = 'B'; }
                when ANY_LIGHT { lightCode = 'A'; }
                when else { lightCode = '0'; }
            }
            return 'P' + counter++ + sizeCode + diffCode + lightCode;
        }
    }
}