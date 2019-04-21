@IsTest
private class JEOL_HosyuKeiyaku_ctrlTest {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_HosyuKeiyakuPage';  // PATH
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // コンストラクタ、各メソッド呼び出し、検索結果取得（クッキー系処理含む）
    private static testMethod void test01() {

        // テストデータ生成
        testData();

        PageReference testPage = Page.JEOL_HosyuKeiyakuPage;
        Test.setCurrentPage(testPage);

        // クッキー設定
        createCookies();

        JEOL_HosyuKeiyaku_ctrl ctrl = new JEOL_HosyuKeiyaku_ctrl();

        // 検索結果取得とページ制御系メソッド呼び出し
        ctrl.getSalesOrderList();
        ctrl.getContractUpdateStatus();
        ctrl.getContractPeriodTargetList();
        ctrl.getRegionOptions();
        ctrl.contractPeriodTarget = '';
        ctrl.contractPeriodListChangeAction();
        ctrl.nextAndSaveCurrentPageNumber();
        ctrl.previousAndSaveCurrentPageNumber();
        ctrl.firstAndSaveCurrentPageNumber();
        ctrl.lastAndSaveCurrentPageNumber();
        ctrl.setJumpSaveCurrentPageSize();
        ctrl.setSizeSaveCurrentPageSize();

        // クリアメソッド呼び出し
        ctrl.doFormClear();

	    // 全パラメータ指定
        ctrl.unitBody = 'testUB';
        ctrl.itemName = 'testITMname';
        ctrl.productNumber = 'testPN';
        ctrl.accountCode = 'testACCcd';
        ctrl.accountName = 'testACCnm';
        ctrl.updateStatus = 'testUpdSts';
        ctrl.shipmentAccountCode = 'test999999';
        ctrl.shipmentAccountName = 'testAcctName';
        ctrl.area = 'testArea';
        ctrl.contractPeriodTarget = 'Start';
        ctrl.contractPeriodFrom = '2999/12/31';
        ctrl.contractPeriodTo = '2999/12/31';
        ctrl.contractPeriodTarget = 'Start';
        ctrl.Search1();

		// 検索結果取得テスト
		ctrl.orderDesc = true;
        ctrl.unitBody = '';
        ctrl.itemName = '';
        ctrl.productNumber = '';
        ctrl.accountCode = '';
        ctrl.accountName = '';
        ctrl.updateStatus = '';
        ctrl.shipmentAccountCode = '';
        ctrl.shipmentAccountName = '';
        ctrl.area = '';
        ctrl.contractPeriodTarget = 'Start';
        ctrl.contractPeriodFrom = '';
        ctrl.contractPeriodTo = '';
        ctrl.contractPeriodTarget = '';
        ctrl.Search1();
        ctrl.getSalesOrderList();

    }

    // クッキー生成処理（画面起動時検索フラグON、一部条件指定）
    private static void createCookies(){
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie('unitBody', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('modelPI', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('itemName', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('productNumber', '', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('accountCode', 'testACCcd', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('accountName', 'testACCnm', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('updateStatus', 'testUpdSts', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shipmentAccountCode', 'test9999999', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shipmentAccountName', 'testShipName', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('area', 'testArea', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('contractPeriodTarget', 'Start', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('contractPeriodFrom', '2999/12/31', COOKIE_PATH, -1, true));
        cookies.add(new Cookie('contractPeriodTo', '2999/12/31', COOKIE_PATH, -1, true));

        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, '1', COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, '10', COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, 'true', COOKIE_PATH, -1, true));
        Apexpages.currentPage().setCookies(cookies);
    }

    // テストデータ作成
    private static void testData(){

        // 販売オーダ．保守契約レコードタイプID取得
        List<RecordType> soRecTypes = [select Id from RecordType where SobjectType = 'SalesOrder__c' and developerName = 'HosyuKeiyaku'];
        if (soRecTypes == null) {
            soRecTypes = new List<RecordType>();
        }
        // 販売オーダ．販売先取引先
        Account accSL = new Account();
        accSL.Name = 'testACCnm';
        accSL.Code__c = 'testACCcd';
        insert accSL;

        // 販売オーダ
        SalesOrder__c so = new SalesOrder__c();
        so.Name = 'testSOname';
        so.UpdateStatus__c = 'testUpdSts';
        so.SalesAccount__c = accSL.Id;
        so.RecordTypeId = soRecTypes[0].Id;
        insert so;
    }

}