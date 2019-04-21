@IsTest
private class JEOL_JuchuOrderViewTest {

    // ID指定なし
    private static testMethod void test01() {

        PageReference testPage = Page.JEOL_JuchuOrderView;
//        testPage.getParameters().put('Id', '');
        Test.setCurrentPage(testPage);

        JEOL_JuchuOrderView ctrl = new JEOL_JuchuOrderView();
    }

    // 検索該当なし
    private static testMethod void test02() {

        PageReference testPage = Page.JEOL_JuchuOrderView;
        testPage.getParameters().put('Id', 'test');
        Test.setCurrentPage(testPage);

        JEOL_JuchuOrderView ctrl = new JEOL_JuchuOrderView();
    }

    // 検索該当あり（販売）
    private static testMethod void test03() {

        String tgtId = testDataSales();

        PageReference testPage = Page.JEOL_JuchuOrderView;
        testPage.getParameters().put('Id', tgtId);
        Test.setCurrentPage(testPage);

        JEOL_JuchuOrderView ctrl = new JEOL_JuchuOrderView();
        JEOL_JuchuOrderView.ViewWrapper tgt = ctrl.target;

        // 値取得処理呼び出し
        tgt.getIsSales();
        tgt.getIsService();
        tgt.getOrderNo();
        tgt.getOrderDate();
        tgt.getCarryDeliveryTime();
        tgt.getSalesStaff();
        tgt.getProductNumber();
        tgt.getOrdersMemp();
        tgt.getOrderAmount();
        tgt.getTaxAmount();
        tgt.getCurrencyIsoCode();
        tgt.getSumAmount();
        tgt.getSalesContactPosition();
        tgt.getSalesTantoshya();
        tgt.getSalesContactTel();
        tgt.getShipmentContactPosition();
        tgt.getShipmentTantosha();
        tgt.getShipmentContactTel();
        tgt.getCustomerOrderNo();
        tgt.getCallCenterReceptionNo();
        tgt.getSchedulingDivision();
        tgt.getKosohin();
        tgt.getBillingSystem();
        tgt.getPaperDivision();
        tgt.getQuotation();
        tgt.getInvoice();
        tgt.getBill();
        tgt.getModelPI();
        tgt.getUnitBody();
        tgt.getSalesAccount();
        tgt.getShipmentAccount();
        tgt.getLines();
    }

    // 検索該当あり（サービス）
    private static testMethod void test04() {

        String tgtId = testDataService();

        PageReference testPage = Page.JEOL_JuchuOrderView;
        testPage.getParameters().put('Id', tgtId);
        Test.setCurrentPage(testPage);

        JEOL_JuchuOrderView ctrl = new JEOL_JuchuOrderView();
        JEOL_JuchuOrderView.ViewWrapper tgt = ctrl.target;

        // 値取得処理呼び出し
        tgt.getIsSales();
        tgt.getIsService();
        tgt.getOrderNo();
        tgt.getOrderDate();
        tgt.getCarryDeliveryTime();
        tgt.getSalesStaff();
        tgt.getProductNumber();
        tgt.getOrdersMemp();
        tgt.getOrderAmount();
        tgt.getTaxAmount();
        tgt.getCurrencyIsoCode();
        tgt.getSumAmount();
        tgt.getSalesContactPosition();
        tgt.getSalesTantoshya();
        tgt.getSalesContactTel();
        tgt.getShipmentContactPosition();
        tgt.getShipmentTantosha();
        tgt.getShipmentContactTel();
        tgt.getCustomerOrderNo();
        tgt.getCallCenterReceptionNo();
        tgt.getSchedulingDivision();
        tgt.getKosohin();
        tgt.getBillingSystem();
        tgt.getPaperDivision();
        tgt.getQuotation();
        tgt.getInvoice();
        tgt.getBill();
        tgt.getModelPI();
        tgt.getUnitBody();
        tgt.getSalesAccount();
        tgt.getShipmentAccount();
        tgt.getLines();
    }

    // テストデータ作成（販売）
    private static String testDataSales(){
        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'testPI';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // シリアル番号付品目
        SerialNoProductItem__c snpi = new SerialNoProductItem__c();
        snpi.Name = 'testSNPIname';
        snpi.ItemLink__c = pi.Id;
        snpi.SerialNo__c = 'testSNo';
        snpi.UnitBody__c = 'testUnitBody';
        snpi.StatusOfUse__c = '1';
        snpi.SalesTargetCustomer__c = 'testCode';
        insert snpi;

        // 販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACNSL';
        accSL.Code__c = 'testACCSL';
        insert accSL;

        // 出荷先取引先
        Account accSP = new Account();
        accSP.Name = 'testACNSP';
        accSP.Code__c = 'testACCSP';
        insert accSP;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.Name = 'testSOname';
        so.OrderAmount__c = 10000000;
        so.SalesAccount__c = accSL.Id;
        so.ShipmentAccount__c = accSP.Id;
        so.SerialNoItemLink__c = snpi.Id;
        insert so;

        // 販売オーダライン
        SalesOrderLine__c sol = new SalesOrderLine__c();
        sol.Name = 'testSOLname';
        sol.SalesOrderLink__c = so.Id;
        sol.ProductItem__c = pi.Id;
        insert sol;

        return so.Id;
    }

    // テストデータ作成（サービス）
    private static String testDataService(){
        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'testPI';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // シリアル番号付品目
        SerialNoProductItem__c snpi = new SerialNoProductItem__c();
        snpi.Name = 'testSNPIname';
        snpi.ItemLink__c = pi.Id;
        snpi.SerialNo__c = 'testSNo';
        snpi.UnitBody__c = 'testUnitBody';
        snpi.StatusOfUse__c = '1';
        snpi.SalesTargetCustomer__c = 'testCode';
        insert snpi;

        // 顧客対応票
        Support__c spt = new Support__c();
        spt.Name = 'testSPTname';
        spt.SerialNoItemsLink__c = snpi.Id;
        insert spt;

        // 販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACNSL';
        accSL.Code__c = 'testACCSL';
        insert accSL;

        // 出荷先取引先
        Account accSP = new Account();
        accSP.Name = 'testACNSP';
        accSP.Code__c = 'testACCSP';
        insert accSP;

        // サービスオーダ
        ServiceOrder__c so = new ServiceOrder__c();
        so.Name = 'testSOname';
        so.SalesAccount__c = accSL.Id;
        so.ShipmentAccount__c = accSP.Id;
        so.Customer__c = spt.Id;
        insert so;

        // サービスオーダ材料費
        ServiceOrderControl__c soc = new ServiceOrderControl__c();
        soc.Name = 'testSOLname';
        soc.ServiceOrder__c = so.Id;
        soc.ProductItem__c = pi.Id;
        insert soc;

        return so.Id;
    }

}