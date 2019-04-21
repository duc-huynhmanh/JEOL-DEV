@isTest
private class JEOL_ServiceShori_ctrlTest {

    // 正常終了、各メソッド呼び出し
    static testMethod void Test01() {
        //テストデータ作成
        testData();

        // ページを設定
        PageReference testPage = Page.JEOL_ServiceShoriPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        ApexPages.currentPage().getParameters().put('mainPartNo', 'g01');

        JEOL_ServiceShori_ctrl ctrl = new JEOL_ServiceShori_ctrl();

        // 各メソッド呼び出し
        ctrl.prev();
        ctrl.getCustomerSupportServiceSyoriList();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();
    }

    // 異常終了（本体号機設定なし）
    static testMethod void Test02() {
        // ページを設定
        PageReference testPage = Page.JEOL_ServiceShoriPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        ApexPages.currentPage().getParameters().put('mainPartNo', '');

        JEOL_ServiceShori_ctrl ctrl = new JEOL_ServiceShori_ctrl();
    }

    // 異常終了（取得件数0件）
    static testMethod void Test03() {
        // テストデータ作成
        testData();

        // ページを設定
        PageReference testPage = Page.JEOL_ServiceShoriPage;
        Test.setCurrentPage(testPage);

        // パラメータ設定
        ApexPages.currentPage().getParameters().put('mainPartNo', '1234567890123456');

        JEOL_ServiceShori_ctrl ctrl = new JEOL_ServiceShori_ctrl();
    }

    // テストデータ作成
    private static void testData(){
        //品目
        ProductItem__c pItem = new ProductItem__c();
        pItem.Name = 'Test';
        pItem.Model__c = 'T001';
        pItem.Series__c = 'TS';
        pItem.JapaneseName__c = 'テスト';
        pItem.EnglishName__c = 'test';
        insert pItem;

        //シリアル番号付品目
        date myDate = date.today();
        datetime myDateTime = datetime.now();
        SerialNoProductItem__c spItem = new SerialNoProductItem__c();
        spItem.Name = 'Test';
        spItem.EfProductNo__c = 'No001';
        spItem.EfProductNoEndDate__c = myDateTime;
        spItem.SvcForm__c = 's01';
        spItem.SerialNo__c = 'tsts00001';
        spItem.ModelsAbbreviation__c = 'c3';
        spItem.AcceptanceDate__c = myDateTime;
        spItem.StatusOfUse__c = 'use';
        spItem.ShipDate__c = myDateTime;
        spItem.ParentNumber__c = 'p01';
        spItem.ParentItem__c = 'pItem';
        spItem.SpecialNote__c = 'memo';
        spItem.SalesTargetCustomer__c = 'sc01';
        spItem.ItemLink__c = pItem.Id;
        spItem.UnitBody__c = 'h01';
        insert spItem;

        //取引先
        Account acc = new Account();
        acc.Name = '取テスト１';
        acc.Code__c = 'tsttt01';
        insert acc;

        //顧客対応票
        Support__c spp = new Support__c();
        spp.Name = 'u001';
        spp.TypeOfService__c = '1：パーコール';
        spp.ServiceTypeCode__c = 'Z1';
        spp.ContactMatter__c = '至急でお願いします';
        spp.SerialNoItemsLink__c = spItem.Id;
        spp.Status__c = 'コール応答中';
        spp.RequestContent1__c = '依頼１';
        spp.RequestContent2__c = '依頼２';
        spp.RequestContent3__c = '依頼３';
        spp.FirstSupportPerson__c = '荒木';
        spp.CustomerFacultyOffice__c = '○支店';
        spp.RelevanceCcReceiptNo__c = 'ku001';
        spp.Search_StartDate__c = myDate;
        spp.Search_EndDate__c = myDate;
        spp.FailureCause1__c = '原因１';
        spp.FailureCause2__c = '原因２';
        spp.FailureCause3__c = '原因３';
        spp.CustomerCode__c = 'k001';
        spp.ServiceStartDate__c = myDate;
        spp.ServiceEndDate__c = myDate;
        spp.CustomerName__c = '花子';
        spp.CustomerAffiliation__c = '○株式会社';
        spp.CustomerContactPerson__c = '太郎';
        spp.SalesCustomer__c = acc.Id;
        spp.UketsukeSupportPerson__c = '荒木';
        spp.ServiceDate2__c = '受付開始日';
        spp.ReceptionDatetime__c = myDate;
        spp.ClassificationDeal1__c = '処置１';
        spp.ClassificationDeal2__c = '処置２';
        spp.ClassificationDeal3__c = '処置３';
        spp.FaultLocation1__c = '障害１';
        spp.FaultLocation2__c = '障害２';
        spp.FaultLocation3__c = '障害３';
        spp.ProductNo__c = 'sei001';
        spp.Responce__c = '対応';
        spp.ServiceDate__c = '対応開始日';
        spp.ServicePerson__c = '荒木';
        spp.CustomerPhone__c = '0120100123';
        spp.CustomerExtension__c = 'memo';
        spp.SecondSupportPerson__c = '新井';
        spp.SalesOrderNo__c = 'so001';
        spp.MaintenanceSerialNo__c = 'M00001';
        spp.UnitBody__c = 'g01';
        insert spp;
    }

}