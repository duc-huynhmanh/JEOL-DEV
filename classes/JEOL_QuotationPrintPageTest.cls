@IsTest
private class JEOL_QuotationPrintPageTest {

    //メソッド呼び出し
    public static testMethod void Test01() {
        // テストデータ生成
        String targetId = testData();
        
        PageReference testPage = Page.JEOL_QuotationPrintPage;//ページ参照型クラス返す(URL情報あり)
        Map<String, String> params = testPage.getParameters();
        params.put('id', targetId);//ID指定
        params.put('print', 'true');
        Test.setCurrentPage(testPage);//コントローラ現在のPageReferenceオブジェクトを設定

        JEOL_QuotationPrintPageCtrl ctrl = new JEOL_QuotationPrintPageCtrl();
        JEOL_QuotationPrintPageCtrl.PageBlock PrintPageCtrl_PageBlock = ctrl.pdfPages.get(0);

        //JEOL_QuotationPrintPageCtrlクラスメソッド
        ctrl.getDetails(targetId);
        
        //PageBlockクラスメソッド
        PrintPageCtrl_PageBlock.getDetailSize();
        PrintPageCtrl_PageBlock.getNoteTextLineSize();
        
        //QuotationHeaderクラスメソッド
        PrintPageCtrl_PageBlock.head.getAmountTotalLineSize();
        PrintPageCtrl_PageBlock.head.getDeliveryLocation();
        PrintPageCtrl_PageBlock.head.getDeliveryPeriod();
        PrintPageCtrl_PageBlock.head.getPaymentCondition();
    }

    //accompanyingPaperDetailRecs処理
    static testMethod void Test02() {
        
        // テストデータ生成
        String targetId = testData2();
        
        //JEOLUtil util = new JEOLUtil();
        //QuotationDetailInformation__c qdi = new QuotationDetailInformation__c();
        //qdi.AccompanyingPaperOutput__c = true;
        
        PageReference testPage = Page.JEOL_QuotationPrintPage;//ページ参照型クラス返す(URL情報あり)
        Map<String, String> params = testPage.getParameters();
        params.put('id', targetId);//ID指定
        params.put('preview', 'true');
        Test.setCurrentPage(testPage);//コントローラ現在のPageReferenceオブジェクトを設定
        
        JEOL_QuotationPrintPageCtrl ctrl = new JEOL_QuotationPrintPageCtrl();
        
    }
    
    //品名0個処理
    static testMethod void Test03() {
        // テストデータ生成
        String targetId = testData3();
        
        PageReference testPage = Page.JEOL_QuotationPrintPage;//ページ参照型クラス返す(URL情報あり)
        Map<String, String> params = testPage.getParameters();
        params.put('id', targetId);//ID指定
        params.put('print', 'true');
        Test.setCurrentPage(testPage);//コントローラ現在のPageReferenceオブジェクトを設定

        JEOL_QuotationPrintPageCtrl ctrl = new JEOL_QuotationPrintPageCtrl();
    }
    //和暦表示テスト
    static testMethod void Test04() {
        // テストデータ生成
        String targetId = testData4();
        PageReference testPage = Page.JEOL_QuotationPrintPage;//ページ参照型クラス返す(URL情報あり)
        Map<String, String> params = testPage.getParameters();
        params.put('id', targetId);//ID指定
        params.put('print', 'true');
        params.put('name', 'testtesttest');
        params.put('year', '2010');
        Test.setCurrentPage(testPage);//コントローラ現在のPageReferenceオブジェクトを設定

        JEOL_QuotationPrintPageCtrl ctrl = new JEOL_QuotationPrintPageCtrl();
        JEOL_QuotationPrintPageCtrl.PageBlock PrintPageCtrl_PageBlock = ctrl.pdfPages.get(0);
        
        //QuotationHeaderクラスメソッド
        PrintPageCtrl_PageBlock.head.getQuotationVlidityPeriod();//JEOL_QuotationPrintPageCtrlクラス→PageBlockクラス→QuotationHeader型head変数のgetQuotationVlidityPeriodメソッドコール
        PrintPageCtrl_PageBlock.head.getQuotationRequestDate();
        PrintPageCtrl_PageBlock.head.getIssueDate();
        PrintPageCtrl_PageBlock.head.getColspan();
    }
    //西暦表示テスト
    static testMethod void Test05() {
        // テストデータ生成
        String targetId = testData5();
        PageReference testPage = Page.JEOL_QuotationPrintPage;//ページ参照型クラス返す(URL情報あり)
        Map<String, String> params = testPage.getParameters();
        params.put('id', targetId);//ID指定
        params.put('print', 'true');
        params.put('name', 'testtesttest');
        params.put('year', '2010');
        Test.setCurrentPage(testPage);//コントローラ現在のPageReferenceオブジェクトを設定

        JEOL_QuotationPrintPageCtrl ctrl = new JEOL_QuotationPrintPageCtrl();
        JEOL_QuotationPrintPageCtrl.PageBlock PrintPageCtrl_PageBlock = ctrl.pdfPages.get(0);
        
        //QuotationHeaderクラスメソッド
        PrintPageCtrl_PageBlock.head.getQuotationVlidityPeriod();//JEOL_QuotationPrintPageCtrlクラス→PageBlockクラス→QuotationHeader型head変数のgetQuotationVlidityPeriodメソッドコール
        PrintPageCtrl_PageBlock.head.getQuotationRequestDate();
        PrintPageCtrl_PageBlock.head.getIssueDate();
        PrintPageCtrl_PageBlock.head.getColspan();
    }
    //MODIFICATION-VAIB-MAY-28-2015
    /*static testMethod void Test06() {
        // テストデータ生成
        String targetId = testData5();
        PageReference testPage = Page.JEOL_QuotationPrintPage;//ページ参照型クラス返す(URL情報あり)
        Map<String, String> params = testPage.getParameters();
        params.put('print', 'true');
        params.put('name', 'testtesttest');
        params.put('year', '2010');
        Test.setCurrentPage(testPage);//コントローラ現在のPageReferenceオブジェクトを設定

        JEOL_QuotationPrintPageCtrl ctrl = new JEOL_QuotationPrintPageCtrl();
        JEOL_QuotationPrintPageCtrl.PageBlock PrintPageCtrl_PageBlock = ctrl.pdfPages.get(0);
        
        //QuotationHeaderクラスメソッド
        PrintPageCtrl_PageBlock.head.getQuotationVlidityPeriod();//JEOL_QuotationPrintPageCtrlクラス→PageBlockクラス→QuotationHeader型head変数のgetQuotationVlidityPeriodメソッドコール
        PrintPageCtrl_PageBlock.head.getQuotationRequestDate();
        PrintPageCtrl_PageBlock.head.getIssueDate();
        PrintPageCtrl_PageBlock.head.getColspan();
    } */

    // テストデータ作成
    private static String testData(){
        QuotationInformation__c rec = new QuotationInformation__c();
        QuotationDetailInformation__c qdi = new QuotationDetailInformation__c();
        
        rec.QuoteNo__c = '11111';
        rec.Name = 'mitumori01';
        rec.CustomerQuotationRequestedNo__c = '22222';
        //rec.SalesPerson__c = 'Admin User';
        rec.ContractCode__c = '44444';
        rec.ContractName__c = 'abc';
        rec.ShipmentCode__c = '55555';
        rec.ShipmentName__c = 'def';
        rec.Series__c = 'EM';
        rec.SalesArea__c = '東京支店';
        rec.QuotationType__c = '保守契';
        rec.TaxExemptionTextOutput__c = true;
        rec.DeliveryPeriod__c = 5807;
        rec.DeliveryDeadline__c = Date.parse('1999/01/01');
        rec.DeliveryDate_Arbitrarily__c = 'DeliveryDate_Arbitrarily';
        rec.QuoteExpirationDate__c = Date.parse('2000/01/01');
        rec.DeliveryLocationText__c = 'DeliveryLocationText';
        rec.PaymentConditionText__c = 'PaymentConditionText';
        rec.QuoteValidityPeriod__c = 100;
        rec.QuotationRequestedDate__c = Date.parse('2001/01/01');
        rec.IssueDate__c = Date.parse('2002/01/01');
        rec.OutputSubtitle__c = true;               //小計表示
        rec.CustomReductionAmount1__c = 500;        //カスタム値引金額１
        rec.CustomReductionAmount2__c = 300;        //カスタム値引金額2
        rec.CustomReductionAmount3__c = 200;        //カスタム値引金額3
        rec.OutputTotalAmount__c = true;            //合計金額表示
        rec.OutputConsumptionTaxAmount__c = true;   //消費税額表示
        rec.OutputTotalTaxAmount__c = true;         //総合計金額表示
        insert rec;

        qdi.Body__c = 'T\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\n';
        qdi.ProductCode__c = '99999';
        qdi.Quantity__c = 9999.0;
        qdi.QuantityUnit__c = '式';
        qdi.UnitPrice__c = 1234567890;
        qdi.Parent__c = rec.id;
        qdi.SortNo__c = 1;
        qdi.Depth__c = 1;
        insert qdi;
        
        return rec.id;
    }

    private static String testData2(){
        QuotationInformation__c rec = new QuotationInformation__c();
        QuotationDetailInformation__c qdi = new QuotationDetailInformation__c();
        
        rec.QuoteNo__c = '11111';
        rec.Name = 'mitumori01';
        rec.CustomerQuotationRequestedNo__c = '22222';
        rec.ContractCode__c = '44444';
        rec.ContractName__c = 'abc';
        rec.ShipmentCode__c = '55555';
        rec.ShipmentName__c = 'def';
        rec.Series__c = 'EM';
        rec.SalesArea__c = '東京支店';
        rec.QuotationType__c = '保守契';
        rec.TaxExemptionTextOutput__c = true;
        rec.DeliveryPeriod__c = 5807;
        rec.DeliveryDeadline__c = Date.parse('1999/01/01');
        rec.DeliveryDate_Arbitrarily__c = 'DeliveryDate_Arbitrarily';
        rec.QuoteExpirationDate__c = Date.parse('2000/01/01');
        rec.DeliveryLocationText__c = 'DeliveryLocationText';
        rec.PaymentConditionText__c = 'PaymentConditionText';
        rec.QuoteValidityPeriod__c = 100;
        rec.QuotationRequestedDate__c = Date.parse('2001/01/01');
        rec.IssueDate__c = Date.parse('2002/01/01');
        rec.OutputSubtitle__c = true;               //小計表示
        rec.CustomReductionAmount1__c = 500;        //カスタム値引金額１
        rec.CustomReductionAmount2__c = 300;        //カスタム値引金額2
        rec.CustomReductionAmount3__c = 200;        //カスタム値引金額3
        rec.OutputTotalAmount__c = true;            //合計金額表示
        rec.OutputConsumptionTaxAmount__c = true;   //消費税額表示
        rec.OutputTotalTaxAmount__c = true;         //総合計金額表示
        insert rec;

        qdi.Body__c = 'T\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\n';
        qdi.ProductCode__c = '99999';
        qdi.Quantity__c = 9999.0;
        qdi.QuantityUnit__c = '式';
        qdi.UnitPrice__c = 1234567890;
        qdi.Parent__c = rec.id;
        qdi.SortNo__c = 1;
        qdi.Depth__c = 1;
        qdi.AccompanyingPaperOutput__c = true;
        insert qdi;
        
        return rec.id;
    }
    
    private static String testData3(){
        QuotationInformation__c rec = new QuotationInformation__c();
        QuotationDetailInformation__c qdi = new QuotationDetailInformation__c();
        
        rec.QuoteNo__c = '11111';
        rec.Name = 'mitumori01';
        rec.CustomerQuotationRequestedNo__c = '22222';
        rec.ContractCode__c = '44444';
        rec.ContractName__c = 'abc';
        rec.ShipmentCode__c = '55555';
        rec.ShipmentName__c = 'def';
        rec.Series__c = 'EM';
        rec.SalesArea__c = '東京支店';
        rec.QuotationType__c = '保守契';
        rec.TaxExemptionTextOutput__c = true;
        rec.DeliveryPeriod__c = 5807;
        rec.DeliveryDeadline__c = Date.parse('1999/01/01');
        rec.DeliveryDate_Arbitrarily__c = 'DeliveryDate_Arbitrarily';
        rec.QuoteExpirationDate__c = Date.parse('2000/01/01');
        rec.DeliveryLocationText__c = 'DeliveryLocationText';
        rec.PaymentConditionText__c = 'PaymentConditionText';
        rec.QuoteValidityPeriod__c = 100;
        rec.QuotationRequestedDate__c = Date.parse('2001/01/01');
        rec.IssueDate__c = Date.parse('2002/01/01');
        rec.OutputSubtitle__c = true;               //小計表示
        rec.CustomReductionAmount1__c = 500;        //カスタム値引金額１
        rec.CustomReductionAmount2__c = 300;        //カスタム値引金額2
        rec.CustomReductionAmount3__c = 200;        //カスタム値引金額3
        rec.OutputTotalAmount__c = true;            //合計金額表示
        rec.OutputConsumptionTaxAmount__c = true;   //消費税額表示
        rec.OutputTotalTaxAmount__c = true;         //総合計金額表示
        insert rec;

        qdi.Body__c = '';
        qdi.ProductCode__c = '99999';
        qdi.Quantity__c = 9999.0;
        qdi.QuantityUnit__c = '式';
        qdi.UnitPrice__c = 1234567890;
        qdi.Parent__c = rec.id;
        qdi.SortNo__c = 1;
        qdi.Depth__c = 1;
        insert qdi;
        
        return rec.id;
    }
    // 
    private static String testData4(){
        QuotationInformation__c rec = new QuotationInformation__c();
        QuotationDetailInformation__c qdi = new QuotationDetailInformation__c();
        JEOL_QuotationListPageCtrl qtiRec = new JEOL_QuotationListPageCtrl();
        JapaneseEraNameMaster__c jenm = new JapaneseEraNameMaster__c();
        
        jenm.JapaneseCalendarStartDate__c = Date.parse('2000/01/01');
        jenm.Name = '平成';//JapaneseEraNameMaster__cがカスタム設定のため値必須
        insert jenm;
        
        rec.QuoteNo__c = '11111';
        rec.Name = 'mitumori01';
        rec.CustomerQuotationRequestedNo__c = '22222';
        //rec.SalesPerson__c = 'Admin User';
        rec.ContractCode__c = '44444';
        rec.ContractName__c = 'abc';
        rec.ShipmentCode__c = '55555';
        rec.ShipmentName__c = 'def';
        rec.Series__c = 'EM';
        rec.SalesArea__c = '東京支店';
        rec.QuotationType__c = '保守契';
        rec.TaxExemptionTextOutput__c = true;
        rec.DeliveryPeriod__c = 5807;
        rec.DeliveryDeadline__c = Date.parse('1999/01/01');
        rec.DeliveryDate_Arbitrarily__c = 'DeliveryDate_Arbitrarily';
        rec.QuoteExpirationDate__c = Date.parse('2000/01/01');
        rec.DeliveryLocationText__c = 'DeliveryLocationText';
        rec.PaymentConditionText__c = 'PaymentConditionText';
        rec.QuoteValidityPeriod__c = 100;
        rec.QuotationRequestedDate__c = Date.parse('2001/01/01');
        rec.IssueDate__c = Date.parse('2002/01/01');
        rec.OutputSubtitle__c = true;               //小計表示
        rec.CustomReductionAmount1__c = 500;        //カスタム値引金額１
        rec.CustomReductionAmount2__c = 300;        //カスタム値引金額2
        rec.CustomReductionAmount3__c = 200;        //カスタム値引金額3
        rec.OutputTotalAmount__c = true;            //合計金額表示
        rec.OutputConsumptionTaxAmount__c = true;   //消費税額表示
        rec.OutputTotalTaxAmount__c = true;         //総合計金額表示
        insert rec;

        qdi.Body__c = 'T\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\n';
        qdi.ProductCode__c = '99999';
        qdi.Quantity__c = 9999.0;
        qdi.QuantityUnit__c = '式';
        qdi.UnitPrice__c = 1234567890;
        qdi.Parent__c = rec.id;
        qdi.SortNo__c = 1;
        qdi.Depth__c = 1;
        insert qdi;
        
        return rec.id;
    }

    private static String testData5(){
        QuotationInformation__c rec = new QuotationInformation__c();
        QuotationDetailInformation__c qdi = new QuotationDetailInformation__c();
        JEOL_QuotationListPageCtrl qtiRec = new JEOL_QuotationListPageCtrl();
        JapaneseEraNameMaster__c jenm = new JapaneseEraNameMaster__c();
        
        jenm.JapaneseCalendarStartDate__c = Date.parse('2000/01/01');
        jenm.Name = '平成';//JapaneseEraNameMaster__cがカスタム設定のため値必須
        insert jenm;
        
        rec.QuoteNo__c = '11111';
        rec.Name = 'mitumori01';
        rec.CustomerQuotationRequestedNo__c = '22222';
        //rec.SalesPerson__c = 'Admin User';
        rec.ContractCode__c = '44444';
        rec.ContractName__c = 'abc';
        rec.ShipmentCode__c = '55555';
        rec.ShipmentName__c = 'def';
        rec.Series__c = 'EM';
        rec.SalesArea__c = '東京支店';
        rec.QuotationType__c = '保守契';
        rec.TaxExemptionTextOutput__c = true;
        rec.DeliveryPeriod__c = 5807;
        rec.DeliveryDeadline__c = Date.parse('1999/01/01');
        rec.DeliveryDate_Arbitrarily__c = 'DeliveryDate_Arbitrarily';
        rec.QuoteExpirationDate__c = Date.parse('2000/01/01');
        rec.DeliveryLocationText__c = 'DeliveryLocationText';
        rec.PaymentConditionText__c = 'PaymentConditionText';
        rec.QuoteValidityPeriod__c = 100;
        rec.QuotationRequestedDate__c = Date.parse('2001/01/01');
        rec.IssueDate__c = Date.parse('2002/01/01');
        rec.CalendarExpress__c = '西暦';
        rec.OutputSubtitle__c = true;               //小計表示
        rec.CustomReductionAmount1__c = 500;        //カスタム値引金額１
        rec.CustomReductionAmount2__c = 300;        //カスタム値引金額2
        rec.CustomReductionAmount3__c = 200;        //カスタム値引金額3
        rec.OutputTotalAmount__c = true;            //合計金額表示
        rec.OutputConsumptionTaxAmount__c = true;   //消費税額表示
        rec.OutputTotalTaxAmount__c = true;         //総合計金額表示
        rec.Note__c = 'No\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\nNo\n';
        rec.IsDisplayDecimal__c = false;
        insert rec;

        qdi.Body__c = 'T\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\nT\n';
        qdi.ProductCode__c = '99999';
        qdi.Quantity__c = 9999.0;
        qdi.QuantityUnit__c = '式';
        qdi.UnitPrice__c = 1234567890;
        qdi.Parent__c = rec.id;
        qdi.SortNo__c = 1;
        qdi.Depth__c = 1;
        insert qdi;
        
        return rec.id;
    }
}