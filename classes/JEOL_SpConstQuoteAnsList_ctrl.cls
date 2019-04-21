public with sharing class JEOL_SpConstQuoteAnsList_ctrl extends JEOL_SearchBase_ctrl {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_SpConstQuoteAnsListPage';  // PATH
    private static final String COOKIE_LABEL_COMPANY_DIVISION = 'companyDivision';  // 会社区分
    private static final String COOKIE_LABEL_QUOTE_REQUEST_NO = 'quoteRequestNo';  // 見積回答No
    private static final String COOKIE_LABEL_REQUEST_EMP_CODE = 'requestEmployeeCode';  // 依頼社員コード
    private static final String COOKIE_LABEL_REQUEST_EMP_NAME = 'requestEmployeeName';  // 依頼社員名称
    private static final String COOKIE_LABEL_ACCOUNT_CODE = 'accountCode';  // 顧客コード
    private static final String COOKIE_LABEL_ACCOUNT_NAME_KANA = 'accountNameKana';  // 顧客名称(半角)
    private static final String COOKIE_LABEL_ACCOUNT_NAME = 'accountName';  // 顧客名称
    private static final String COOKIE_LABEL_CUSTOMER_CATEGORY = 'customerCategory';  // 顧客カテゴリ
    private static final String COOKIE_LABEL_FORM = 'form';  // 形式
    private static final String COOKIE_LABEL_AREA_NAME = 'areaName';  // 地域名称
    private static final String COOKIE_LABEL_DELI_BODY_SERIAL_NO = 'deliveredBodySerialNo';  // 既納本体製番
    private static final String COOKIE_LABEL_SUBJECT = 'subject';  // 件名
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 検索項目
    public String companyDivision { get; set; }  // 会社区分
    public String quoteRequestNo { get; set; }  // 見積回答No
    public String requestEmployeeCode { get; set; }  // 依頼社員コード
    public String requestEmployeeName { get; set; }  // 依頼社員名称
    public String accountCode { get; set; }  // 顧客コード
    public String accountNameKana { get; set; }  // 顧客名称(半角)
    public String accountName { get; set; }  // 顧客名称
    public String customerCategory { get; set; }  // 顧客カテゴリ
    public String form { get; set; }  // 形式
    public String areaName { get; set; }  // 地域
    public String deliveredBodySerialNo { get; set; }  // 既納本体製番
    public String subject { get; set; }  // 件名

    // 地域選択リスト
    public List<SelectOption> getAreaOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_AREA);
    }
    public List<SelectOption> getConpanyDivisionOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_COMPANY_DIVISION);
    }
    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }

    // 検索内容出力用
    public String criteriaText {get; private set;}

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';
    
    /**
    *  コンストラクタ
    */
    public JEOL_SpConstQuoteAnsList_ctrl() {
        orderBy = 'QuoteAnswerNo__c';
        currentOrder = 'QuoteAnswerNo__c';
        orderDesc = false;

        // Cookie用
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }
    }

    /**
    *  ボタン処理系
    */
    // 検索ボタン
    public PageReference search() {
        doSearch();
        return null;
    }
    // 検索（StandardSetController初期化）
    private void doSearch(){

        orderBy = 'QuoteAnswerNo__c';
        currentOrder = 'QuoteAnswerNo__c';
        orderDesc = false;

        this.initSearchFlg = 'true';  // 画面起動時検索フラグON
        PageNo = 1;  // ページ番号の初期化
        PageSize = 50;

        setStandardSetController();
        if (ssc != null){
            ssc.setPageNumber(1);
        }
        saveInputValues();
    }
    // クリアボタン
    public void doFormClear() {
        //検索条件のクリア
        companyDivision = null;
        quoteRequestNo = null;
        requestEmployeeCode = null;
        requestEmployeeName = null;
        accountCode = null;
        accountNameKana = null;
        accountName = null;
        customerCategory = null;
        form = null;
        areaName = null;
        deliveredBodySerialNo = null;
        subject = null;

        // 検索内容のクリア
        criteriaText = null;

        // 検索結果のクリア
        ssc = null;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        // ページ番号、ページサイズの初期化
        PageNo = 1;
        PageSize = 50;

        // 検索条件のCookie保存
        saveInputValues();
    }

    /**
    *  検索条件のCookie読み取り
    */
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        // 会社区分
        if(cookies.containsKey(COOKIE_LABEL_COMPANY_DIVISION)){
            this.companyDivision = cookies.get(COOKIE_LABEL_COMPANY_DIVISION).getValue();
        }
        // 見積回答No
        if(cookies.containsKey(COOKIE_LABEL_QUOTE_REQUEST_NO)){
            this.quoteRequestNo = cookies.get(COOKIE_LABEL_QUOTE_REQUEST_NO).getValue();
        }
        // 依頼社員コード
        if(cookies.containsKey(COOKIE_LABEL_REQUEST_EMP_CODE)){
            this.requestEmployeeCode = cookies.get(COOKIE_LABEL_REQUEST_EMP_CODE).getValue();
        }
        // 依頼社員名称
        if(cookies.containsKey(COOKIE_LABEL_REQUEST_EMP_NAME)){
            this.requestEmployeeName = cookies.get(COOKIE_LABEL_REQUEST_EMP_NAME).getValue();
        }
        // 顧客コード
        if(cookies.containsKey(COOKIE_LABEL_ACCOUNT_CODE)){
            this.accountCode = cookies.get(COOKIE_LABEL_ACCOUNT_CODE).getValue();
        }
        // 顧客名称(半角)
        if(cookies.containsKey(COOKIE_LABEL_ACCOUNT_NAME_KANA)){
            this.accountNameKana = cookies.get(COOKIE_LABEL_ACCOUNT_NAME_KANA).getValue();
        }
        // 顧客名称
        if(cookies.containsKey(COOKIE_LABEL_ACCOUNT_NAME)){
            this.accountName = cookies.get(COOKIE_LABEL_ACCOUNT_NAME).getValue();
        }
        // 顧客カテゴリ
        if(cookies.containsKey(COOKIE_LABEL_CUSTOMER_CATEGORY)){
            this.customerCategory = cookies.get(COOKIE_LABEL_CUSTOMER_CATEGORY).getValue();
        }
        // 形式
        if(cookies.containsKey(COOKIE_LABEL_FORM)){
            this.form = cookies.get(COOKIE_LABEL_FORM).getValue();
        }
        // 地域名称
        if(cookies.containsKey(COOKIE_LABEL_AREA_NAME)){
            this.areaName = cookies.get(COOKIE_LABEL_AREA_NAME).getValue();
        }
        // 既納本体製番
        if(cookies.containsKey(COOKIE_LABEL_DELI_BODY_SERIAL_NO)){
            this.deliveredBodySerialNo = cookies.get(COOKIE_LABEL_DELI_BODY_SERIAL_NO).getValue();
        }
        // 件名
        if(cookies.containsKey(COOKIE_LABEL_SUBJECT)){
            this.subject = cookies.get(COOKIE_LABEL_SUBJECT).getValue();
        }
        // ページ番号
        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER) && cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue().length() != 0){
            PageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        // ページサイズ
        if(cookies.containsKey(COOKIE_LABEL_PAGE_SIZE) && cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue().length() != 0){
            PageSize = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue());
        }
        // 画面起動時検索フラグ
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }
        return hasSearchValues;
    }

    /**
    *  検索条件のCookie保存
    */
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        
        cookies.add(new Cookie(COOKIE_LABEL_COMPANY_DIVISION, this.companyDivision, COOKIE_PATH, -1, true));  // 会社区分
        cookies.add(new Cookie(COOKIE_LABEL_QUOTE_REQUEST_NO, this.quoteRequestNo, COOKIE_PATH, -1, true));  // 見積回答
        cookies.add(new Cookie(COOKIE_LABEL_REQUEST_EMP_CODE, this.requestEmployeeCode, COOKIE_PATH, -1, true));  // 依頼社員コード
        cookies.add(new Cookie(COOKIE_LABEL_REQUEST_EMP_NAME, this.requestEmployeeName, COOKIE_PATH, -1, true));  // 依頼社員名称
        cookies.add(new Cookie(COOKIE_LABEL_ACCOUNT_CODE, this.accountCode, COOKIE_PATH, -1, true));  // 顧客コード
        cookies.add(new Cookie(COOKIE_LABEL_ACCOUNT_NAME_KANA, this.accountNameKana, COOKIE_PATH, -1, true));  // 顧客名称(半角)
        cookies.add(new Cookie(COOKIE_LABEL_ACCOUNT_NAME, this.accountName, COOKIE_PATH, -1, true));  // 顧客名称
        cookies.add(new Cookie(COOKIE_LABEL_CUSTOMER_CATEGORY, this.customerCategory, COOKIE_PATH, -1, true));  // 顧客カテゴリ
        cookies.add(new Cookie(COOKIE_LABEL_FORM, this.form, COOKIE_PATH, -1, true));  // 形式
        cookies.add(new Cookie(COOKIE_LABEL_AREA_NAME, this.areaName, COOKIE_PATH, -1, true));  // 地域
        cookies.add(new Cookie(COOKIE_LABEL_DELI_BODY_SERIAL_NO, this.deliveredBodySerialNo, COOKIE_PATH, -1, true));  // 既納本体製番
        cookies.add(new Cookie(COOKIE_LABEL_SUBJECT, this.subject, COOKIE_PATH, -1, true));  // 件名
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ
        if (ssc != null) {
            cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(ssc.getPageSize()), COOKIE_PATH, -1, true));  //ページサイズ
        }
        
        Apexpages.currentPage().setCookies(cookies);
    }

    /**
    *  StandardSetController設定
    */
    protected override void setStandardSetController() {

        // 検索項目
        String soql = ' SELECT ' +
                            ' Id' +
                            ' ,CurrencyIsoCode ' +
                            ', QuoteRequestNo__c' +
                            ', BodyFormName__c' +
                            ', AreaName__c' +
                            ', QuoteAnswerNo__c' +
                            ', DeliveredBodySerialNo__c' +
                            ', SerialNo__c' +
                            ', Form__c' +
                            ', Account__c' +
                            ', AccountCode__c' +
                            ', AccountName__c' +
                            ', ConstructionNameJ__c' +
                            ', ConstructionNameE__c' +
                            ', SalesTakeOffPrice__c' +
                            ', ConstPeriodTotal__c' +
                            ', QuoteAnswerDateTime__c' +
                            ', QuoteAnswerExpirationDateFormula__c' +
                            ', ConstructionDivision__c' +
                            ', DrawingReleaseYN__c' +
                            ', OrderForm__c' +
                            ', Remarks__c' +
                            ', RequestEmployeeName__c' +
                        ' FROM ' +
                            ' SpecialConstructionQuoteAnswer__c';

        List<String> whereConditions = new List<String>();
        // 会社区分
        if (String.isNotBlank(this.companyDivision)) {
            whereConditions.add(JEOLUtil.appendEqualText('CompanyDivision__c', this.companyDivision));
        }
        // 見積回答No
        if (String.isNotBlank(this.quoteRequestNo)) {
            whereConditions.add(JEOLUtil.appendLikeText('QuoteAnswerNo__c', this.quoteRequestNo));
        }
        // 依頼社員コード
        if (String.isNotBlank(this.requestEmployeeCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('RequestEmployeeCode__c', this.requestEmployeeCode));
        }
        // 依頼社員名称
        if (String.isNotBlank(this.requestEmployeeName)) {
            whereConditions.add(JEOLUtil.appendLikeText('RequestEmployeeName__c', this.requestEmployeeName));
        }
        // 顧客コード
        if (String.isNotBlank(this.accountCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('AccountCode__c', this.accountCode));
        }
        // 顧客名称(半角)
        if (String.isNotBlank(this.accountNameKana)) {
            whereConditions.add(JEOLUtil.appendLikeText('AccountNameKana__c', this.accountNameKana));
        }
        // 顧客名称
        if (String.isNotBlank(this.accountName)) {
            whereConditions.add(JEOLUtil.appendLikeText('AccountName__c', this.accountName));
        }
        //顧客カテゴリ 
        if (String.isNotBlank(this.customerCategory)) {
            List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory);
            whereConditions.add(JEOLUtil.appendInText('Account__c', accIdList));
            whereConditions.add(' Account__c != null ');
        }
        // 形式
        if (String.isNotBlank(this.form)) {
            whereConditions.add(JEOLUtil.appendLikeText('Form__c', this.form));
        }
        // 地域
        if (String.isNotBlank(this.areaName)) {
            whereConditions.add(JEOLUtil.appendEqualText('AreaName__c', this.areaName));
        }
        // 既納本体製番
        if (String.isNotBlank(this.deliveredBodySerialNo)) {
            whereConditions.add(JEOLUtil.appendLikeText('DeliveredBodySerialNo__c', this.deliveredBodySerialNo));
        }
        // 件名
        if (String.isNotBlank(this.subject)) {
            whereConditions.add(JEOLUtil.appendLikeText('Subject__c', this.subject));
        }

        // where句以降をSOQLに付加
        soql += JEOLUtil.joinWhereConditions(whereConditions);
        soql += ' ORDER BY ' + orderBy;

        if (orderDesc) {
          soql += ' DESC NULLS LAST';
        }

        soql += ' LIMIT 10000 ';

        this.ssc = new ApexPages.StandardSetController (Database.getQueryLocator(soql));

        if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            this.ssc.setPageSize(pageSize);
            this.ssc.setPageNumber(pageNo);
        }
    }

    /**
    *  検索内容の取得
    */
     public List<rowWrapper> getSpConstQuoteAns(){
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;

        if (ssc != null){
            for (SpecialConstructionQuoteAnswer__c row: (List<SpecialConstructionQuoteAnswer__c>)ssc.getRecords()){
                rowWrapper wrap = new rowWrapper(row, currentCount);
                rows.add(wrap);
                currentCount++;
            }
        }
        return rows;
    }

    /**
    *  検索結果の設定
    */
    public class rowWrapper{
        public SpecialConstructionQuoteAnswer__c rec {get; set;}
        public Integer rowNumber {get; set;}
        
        public rowWrapper(SpecialConstructionQuoteAnswer__c rec, Integer rowNumber){
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
    }

    //次ページ
    public void nextAndSaveCurrentPageNumber() {
        next();
        setCookieCurrentPageNumber();
    }
    
    //前ページ
    public void previousAndSaveCurrentPageNumber() {
        previous();
        setCookieCurrentPageNumber();
    }
    
    //先頭へ
    public void firstAndSaveCurrentPageNumber() {
        first();
        setCookieCurrentPageNumber();
    }

    //最後へ
    public void lastAndSaveCurrentPageNumber() {
        last();
        setCookieCurrentPageNumber();
    }

    //ページ指定
    public void setJumpSaveCurrentPageSize() {
        jump();
        setCookieCurrentPageSize();
        setCookieCurrentPageNumber();
    }

    //サイズ指定
    public void setSizeSaveCurrentPageSize() {
        changeSize();
        setCookieCurrentPageSize();
        setCookieCurrentPageNumber();
    }

    //現在のページを保存する
    private void setCookieCurrentPageNumber() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(ssc.getPageNumber()), COOKIE_PATH, -1, true)});
        }
    }
    
    //ページあたりの表示行を保存する
    private void setCookieCurrentPageSize() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(ssc.getPageSize()), COOKIE_PATH, -1, true)});
        }
    }


}