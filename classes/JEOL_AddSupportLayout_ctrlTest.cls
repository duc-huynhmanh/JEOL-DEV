@IsTest
private class JEOL_AddSupportLayout_ctrlTest {

    private static testMethod void test01() {

        // テストデータ作成、顧客対応票取得
        Support__c testRec = testData();

        // ページを設定
        PageReference testPage = Page.JEOL_AddSupportLayoutPage;
        Test.setCurrentPage(testPage);

        // 標準コントローラを生成
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(testRec);

        // コントローラ拡張を生成
        JEOL_AddSupportLayout_ctrl ctrl = new JEOL_AddSupportLayout_ctrl(stdCtrl);

        // 独自メソッド呼び出し
        ctrl.getProductNumber();
    }

    // テストデータ作成
    private static Support__c testData(){

        // 品目
        ProductItem__c pi = new ProductItem__c();
        pi.Name = 'testITEMname';
        pi.Series__c = 'testPI';
        pi.JapaneseName__c = 'testModelNamePI';
        insert pi;

        // シリアル番号付品目
        UnitBody__c ub = new UnitBody__c();
        ub.ItemLink__c = pi.Id;
        ub.SerialNo__c = 'testSNo';
        ub.UnitBody__c = 'testUnitBody';
        ub.StatusOfUse__c = '1';
        insert ub;

        // 販売オーダ．保守契約レコードタイプID取得
        List<RecordType> soRecTypes = [select Id from RecordType where SobjectType = 'SalesOrder__c' and developerName = 'HosyuKeiyaku'];
        if (soRecTypes == null) {
            soRecTypes = new List<RecordType>();
        }

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.Name = 'testSOname';
        so.UpdateStatus__c = 'testUpdSts';
        so.UnitBodyLink__c = ub.Id;
        so.MaintenanceStartDate__c = System.now();
        so.MaintenanceEndDate__c = System.now();
        so.RecordTypeId = soRecTypes[0].Id;
        insert so;

        // 顧客対応票
        Support__c spt = new Support__c();
        spt.Name = 'testSPTname';
        spt.UnitBodyLink__c = ub.Id;
        insert spt;

        return spt;
    }

}