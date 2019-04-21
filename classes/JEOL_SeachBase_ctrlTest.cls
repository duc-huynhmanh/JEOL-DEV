@IsTest
private class JEOL_SeachBase_ctrlTest {

    //各メソッドの呼び出し
    private static testMethod void test01() {

        //
        date myDate = testData();

        JEOL_ServiceUketsuke_ctrl ctrl = new JEOL_ServiceUketsuke_ctrl();
        ctrl.customerCode_sales = 'k001';
        ctrl.customerName_sales = '花子';
        ctrl.mainPartNoMachine_sales = 'g01';
        ctrl.name_sales = 'u001';
        ctrl.productNo_sales = 'sei001';
        ctrl.center_sales = ''; //
        ctrl.uketsukeSupportPerson_sales = '荒木';

        ctrl.taiouStartDate_sales = myDate.format();
        ctrl.taiouEndDate_sales = myDate.format();

        ctrl.keyword = 'XXXX';
        
        ctrl.getPageSize();
        ctrl.setPageSize(1);
        ctrl.getPageSize();
        ctrl.jump();
        ctrl.first();
        ctrl.last();
        ctrl.next();
        ctrl.previous();
        ctrl.changeSize();
        ctrl.orderBy = 'name';
        ctrl.changeOrder();
        ctrl.changeOrder();
        //
    }

    //テストデータ作成
    private static date testData() {

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
        spItem.SerialNo__c = 'tests00001';
        //spItem.Position__c = 10;
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
        acc.Code__c = 'testtt01';
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
        //spp.WasteSituation__c = '進捗中';
        spp.SalesOrderNo__c = 'so001';
        spp.MaintenanceSerialNo__c = 'M00001';
        spp.UnitBody__c = 'g01';
        insert spp;

        return myDate;

    }

}