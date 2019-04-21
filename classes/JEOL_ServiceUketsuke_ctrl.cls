public with sharing class JEOL_ServiceUketsuke_ctrl extends JEOL_SearchBase_ctrl {

    // 検索項目(営業向け検索)
    public String customerCode_sales { get; set; }
    public String customerName_sales { get; set; }
    public String customerCategory_sales { get; set; }
    public String kikaku_sales { get; set; }
    public String modelName_sales { get; set; }
    public String mainPartNoMachine_sales { get; set; }
    public String name_sales { get; set; }
    public String productNo_sales { get; set; }
    public String center_sales { get; set; }
    public String uketsukeSupportPerson_sales { get; set; }
    public String serviceDateStatus_sales { get; set; }
    public String taiouStartDate_sales { get; set; }
    public String taiouEndDate_sales { get; set; }
    
    // 検索項目(サポート向け検索)
    public String customerCode_support { get; set; }
    public String customerName_support { get; set; }
    public String center_support { get; set; }
    public String series_support { get; set; }
    public String kikaku_support { get; set; }
    public String mainPartNoMachine_support { get; set; }
    public String uketsukeSupportPerson_support { get; set; }
    public String serviceType_support { get; set; }
    public String name_support { get; set; }
    public String productNo_support { get; set; }
    public String keyword_support { get; set; }
    public String status_support { get; set; }
    public String uketsukeStartDate_support { get; set; }
    public String uketsukeEndDate_support { get; set; }
    public String serviceDateStatus_support { get; set; }
    public String taiouStartDate_support { get; set; }
    public String taiouEndDate_support { get; set; }
    
    // サポート向け検索項目
    public String keyword { get; set; }

    // COOKIE LABEL(営業向け検索)
    private static final String COOKIE_LABEL_SALES_CUSTOMER_CODE = 'customerCode_sales';
    private static final String COOKIE_LABEL_SALES_CUSTOMER_NAME = 'customerName_sales';
    private static final String COOKIE_LABEL_SALES_CUSTOMER_CATEGORY = 'customerCategory_sales';
    private static final String COOKIE_LABEL_SALES_KIKAKU = 'kiaku_sales';
    private static final String COOKIE_LABEL_SALES_MODEL_NAME = 'modelName_sales';
    private static final String COOKIE_LABEL_SALES_MAIN_PART_NO_MACHINE = 'mainPartNoMachine_sales';
    private static final String COOKIE_LABEL_SALES_NAME = 'name_sales';
    private static final String COOKIE_LABEL_SALES_PRODUCT_NO = 'productNo_sales';
    private static final String COOKIE_LABEL_SALES_CENTER = 'center_sales';
    private static final String COOKIE_LABEL_SALES_UKETSUKE_SUPPORT_PERSON = 'uketsukeSupportPerson_sales';
    private static final String COOKIE_LABEL_SALES_SERVICE_DATE_STATUS = 'serviceDateStatus_sales';
    private static final String COOKIE_LABEL_SALES_TAIOU_START_DATE = 'taiouStartDate_sales';
    private static final String COOKIE_LABEL_SALES_TAIOU_END_DATE = 'taiouEndDate_sales';

    // COOKIE LABEL(サポート向け検索)
    private static final String COOKIE_LABEL_SUPPORT_CUSTOMER_CODE = 'customerCode_support';
    private static final String COOKIE_LABEL_SUPPORT_CUSTOMER_NAME = 'customerName_support';
    private static final String COOKIE_LABEL_SUPPORT_CENTER = 'center_support';
    private static final String COOKIE_LABEL_SUPPORT_SERIES = 'series_support';
    private static final String COOKIE_LABEL_SUPPORT_KIKAKU = 'kikaku_support';
    private static final String COOKIE_LABEL_SUPPORT_MAIN_PART_NO_MACHINE = 'mainPartNoMachine_support';
    private static final String COOKIE_LABEL_SUPPORT_UKETSUKE_SUPPORT_PERSON = 'uketsukeSupportPerson_support';
    private static final String COOKIE_LABEL_SUPPORT_SERVICE_TYPE = 'serviceType_support';
    private static final String COOKIE_LABEL_SUPPORT_NAME = 'name_support';
    private static final String COOKIE_LABEL_SUPPORT_PRODUCT_NO = 'productNo_support';
    private static final String COOKIE_LABEL_SUPPORT_KEYWORD = 'keyword_support';
    private static final String COOKIE_LABEL_SUPPORT_STATUS = 'status_support';
    private static final String COOKIE_LABEL_SUPPORT_UKETSUKE_START_DATE = 'uketsukeStartDate_support';
    private static final String COOKIE_LABEL_SUPPORT_UKETSUKE_END_DATE = 'uketsukeEndDate_support';
    private static final String COOKIE_LABEL_SUPPORT_SERVICE_DATE_STATUS = 'serviceDateStatus_support';
    private static final String COOKIE_LABEL_SUPPORT_TAIOU_START_DATE = 'taiouStartDate_support';
    private static final String COOKIE_LABEL_SUPPORT_TAIOU_END_DATE = 'taiouEndDate_support';

    public String COOKIE_PATH = '/apex/JEOL_ServiceUketsukePage';
    
    private static final String COOKIE_LABEL_SEARCH_TYPE = 'searchType';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    private static final String SEARCH_TYPE_SALES = 'sales';
    private static final String SEARCH_TYPE_SUPPORT = 'support';

    // 検索タイプ        1:営業向け検索、2:サポート向け検索
    public String searchType { get; set; }

    public Boolean isDisabled_sales{get; set;}
    public Boolean isDisabled_support{get; set;}

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';

    public JEOL_ServiceUketsuke_ctrl() {
        this.searchType = SEARCH_TYPE_SALES;
        orderBy= 'CustomerCode__c';
        currentOrder = 'CustomerCode__c';
        orderDesc = false;
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }
        inputDisabled();
    }

    // 取引先カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }

    // 系列選択リスト値
    public List<SelectOption> getSeriesPIOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }

    // サービスエリア選択リスト値
    public List<SelectOption> getAreaOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERVICE_AREA);
    }

    // サービス種別選択リスト値
    public List<SelectOption> getServiceTypeList() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERVICE_TYPE);
    }
    
    // サービスステータス選択リスト値
    public List<SelectOption> getStatusList() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERVICE_STATUS);
    }
    
    //対応日
    public List<SelectOption> getServiceDateStatusList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        options.add(new SelectOption('対応開始日', '対応開始日'));
        options.add(new SelectOption('対応終了日', '対応終了日'));
        options.add(new SelectOption('完了日', '完了日'));
        return options;
    }

    public void doFormClear() {

        // 営業向け検索条件クリア
        this.customerCode_sales = null;
        this.customerName_sales = null;
        this.customerCategory_sales = null;
        this.kikaku_sales = null;
        this.modelName_sales = null;
        this.mainPartNoMachine_sales = null;
        this.name_sales = null;
        this.productNo_sales = null;
        this.center_sales = null;
        this.uketsukeSupportPerson_sales = null;
        this.serviceDateStatus_sales = null;
        this.taiouStartDate_sales = null;
        this.taiouEndDate_sales = null;

        // サポート向け検索条件クリア
        this.customerCode_support = null;
        this.customerName_support = null;
        this.center_support = null;
        this.series_support = null;
        this.kikaku_support = null;
        this.mainPartNoMachine_support = null;
        this.uketsukeSupportPerson_support = null;
        this.serviceType_support = null;
        this.name_support = null;
        this.productNo_support = null;
        this.keyword_support = null;
        this.status_support = null;
        this.uketsukeStartDate_support = null;
        this.uketsukeEndDate_support = null;
        this.serviceDateStatus_support = null;
        this.taiouStartDate_support = null;
        this.taiouEndDate_support = null;
        
        this.ssc = null;

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        inputDisabled();
        saveInputValues();

    }

    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;

        if(cookies.containsKey(COOKIE_LABEL_SALES_CUSTOMER_CODE)){
            this.customerCode_sales = cookies.get(COOKIE_LABEL_SALES_CUSTOMER_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_CUSTOMER_NAME)){
          this.customerName_sales = cookies.get(COOKIE_LABEL_SALES_CUSTOMER_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_CUSTOMER_CATEGORY)){
          this.customerCategory_sales = cookies.get(COOKIE_LABEL_SALES_CUSTOMER_CATEGORY).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_KIKAKU)){
          this.kikaku_sales = cookies.get(COOKIE_LABEL_SALES_KIKAKU).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_MODEL_NAME)){
          this.modelName_sales = cookies.get(COOKIE_LABEL_SALES_MODEL_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_MAIN_PART_NO_MACHINE)){
          this.mainPartNoMachine_sales = cookies.get(COOKIE_LABEL_SALES_MAIN_PART_NO_MACHINE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_NAME)){
          this.name_sales = cookies.get(COOKIE_LABEL_SALES_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_PRODUCT_NO)){
          this.productNo_sales = cookies.get(COOKIE_LABEL_SALES_PRODUCT_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_CENTER)){
          this.center_sales = cookies.get(COOKIE_LABEL_SALES_CENTER).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_UKETSUKE_SUPPORT_PERSON)){
          this.uketsukeSupportPerson_sales = cookies.get(COOKIE_LABEL_SALES_UKETSUKE_SUPPORT_PERSON).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_SERVICE_DATE_STATUS)){
          this.serviceDateStatus_sales = cookies.get(COOKIE_LABEL_SALES_SERVICE_DATE_STATUS).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_TAIOU_START_DATE)){
          this.taiouStartDate_sales = cookies.get(COOKIE_LABEL_SALES_TAIOU_START_DATE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SALES_TAIOU_END_DATE)){
          this.taiouEndDate_sales = cookies.get(COOKIE_LABEL_SALES_TAIOU_END_DATE).getValue();
        }
        
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_CUSTOMER_CODE)){
          this.customerCode_support = cookies.get(COOKIE_LABEL_SUPPORT_CUSTOMER_CODE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_CUSTOMER_NAME)){
          this.customerName_support = cookies.get(COOKIE_LABEL_SUPPORT_CUSTOMER_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_CENTER)){
          this.center_support = cookies.get(COOKIE_LABEL_SUPPORT_CENTER).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_SERIES)){
          this.series_support = cookies.get(COOKIE_LABEL_SUPPORT_SERIES).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_KIKAKU)){
          this.kikaku_support = cookies.get(COOKIE_LABEL_SUPPORT_KIKAKU).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_MAIN_PART_NO_MACHINE)){
          this.mainPartNoMachine_support = cookies.get(COOKIE_LABEL_SUPPORT_MAIN_PART_NO_MACHINE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_UKETSUKE_SUPPORT_PERSON)){
          this.uketsukeSupportPerson_support = cookies.get(COOKIE_LABEL_SUPPORT_UKETSUKE_SUPPORT_PERSON).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_SERVICE_TYPE)){
          this.serviceType_support = cookies.get(COOKIE_LABEL_SUPPORT_SERVICE_TYPE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_NAME)){
          this.name_support = cookies.get(COOKIE_LABEL_SUPPORT_NAME).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_PRODUCT_NO)){
          this.productNo_support = cookies.get(COOKIE_LABEL_SUPPORT_PRODUCT_NO).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_KEYWORD)){
          this.keyword_support = cookies.get(COOKIE_LABEL_SUPPORT_KEYWORD).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_STATUS)){
          this.status_support = cookies.get(COOKIE_LABEL_SUPPORT_STATUS).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_UKETSUKE_START_DATE)){
          this.uketsukeStartDate_support = cookies.get(COOKIE_LABEL_SUPPORT_UKETSUKE_START_DATE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_UKETSUKE_END_DATE)){
          this.uketsukeEndDate_support = cookies.get(COOKIE_LABEL_SUPPORT_UKETSUKE_END_DATE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_SERVICE_DATE_STATUS)){
          this.serviceDateStatus_support = cookies.get(COOKIE_LABEL_SUPPORT_SERVICE_DATE_STATUS).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_TAIOU_START_DATE)){
          this.taiouStartDate_support = cookies.get(COOKIE_LABEL_SUPPORT_TAIOU_START_DATE).getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_SUPPORT_TAIOU_END_DATE)){
          this.taiouEndDate_support = cookies.get(COOKIE_LABEL_SUPPORT_TAIOU_END_DATE).getValue();
        }

        if(cookies.containsKey(COOKIE_LABEL_SEARCH_TYPE)){
            this.searchType = cookies.get(COOKIE_LABEL_SEARCH_TYPE).getValue();
        }

        // ページ番号（値が設定されていない場合は起動時検索対象外とする）
        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER) && cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue().length() != 0){
            PageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        // ページサイズ（値の取得のみとし、hasSearchValuesで判定させない）
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

    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();

        cookies.add(new Cookie(COOKIE_LABEL_SALES_CUSTOMER_CODE, this.customerCode_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CUSTOMER_NAME, this.customerName_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CUSTOMER_CATEGORY, this.customerCategory_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_KIKAKU, this.kikaku_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_MODEL_NAME, this.modelName_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_MAIN_PART_NO_MACHINE, this.mainPartNoMachine_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_NAME, this.name_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_PRODUCT_NO, this.productNo_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_CENTER, this.center_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_UKETSUKE_SUPPORT_PERSON, this.uketsukeSupportPerson_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_SERVICE_DATE_STATUS, this.serviceDateStatus_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_TAIOU_START_DATE, this.taiouStartDate_sales, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SALES_TAIOU_END_DATE, this.taiouEndDate_sales, COOKIE_PATH, -1, true));

        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_CUSTOMER_CODE, this.customerCode_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_CUSTOMER_NAME, this.customerName_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_CENTER, this.center_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_SERIES, this.series_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_KIKAKU, this.kikaku_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_MAIN_PART_NO_MACHINE, this.mainPartNoMachine_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_UKETSUKE_SUPPORT_PERSON, this.uketsukeSupportPerson_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_SERVICE_TYPE, this.serviceType_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_NAME, this.name_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_PRODUCT_NO, this.productNo_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_KEYWORD, this.keyword_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_STATUS, this.status_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_UKETSUKE_START_DATE, this.uketsukeStartDate_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_UKETSUKE_END_DATE, this.uketsukeEndDate_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_SERVICE_DATE_STATUS, this.serviceDateStatus_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_TAIOU_START_DATE, this.taiouStartDate_support, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_SUPPORT_TAIOU_END_DATE, this.taiouEndDate_support, COOKIE_PATH, -1, true));

        cookies.add(new Cookie(COOKIE_LABEL_SEARCH_TYPE, this.searchType, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);

    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {

        // SOQLを作成する
        String soql = 'SELECT ' +
                        ' Id, Name, CustomerCode__c, CustomerName__c, Kikaku__c, ModelNamePI__c, UnitBody__c, ShipDate__c, ' +
                        ' AcceptanceDate__c, ProductNo__c, ReceptionDatetime__c, ReceptionDate__c, ServiceAreaName__c, ' +
                        ' ServicePerson__c, ServiceStartDate__c, ServiceEndDate__c, ServiceCompletedDateFormula__c, ServiceUketuskeNaiyou__c, TypeOfService__c, ' +
                        ' ServiceDate__c, FirstSupportPerson__c, SecondSupportPerson__c, SupportPerson__c, SeriesPI__c, CustomerFacultyOffice__c ' +
                    ' FROM ' +
                        ' Support__c';

        // SOQLに検索用項目を追加する
        
        List<String> whereConditions = new List<String>();
        // 営業向け検索criteria作成
        if( this.searchType == SEARCH_TYPE_SALES) {

            //取引先コード
            if (String.isNotBlank(this.customerCode_sales)) {
                whereConditions.add(JEOLUtil.appendAfterLikeText('CustomerCode__c', this.customerCode_sales));
            }
            //取引先名
            if (String.isNotBlank(this.customerName_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('CustomerName__c', this.customerName_sales));
            }
            //取引先カテゴリ 
            if (String.isNotBlank(this.customerCategory_sales)) {
                List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory_sales);
                whereConditions.add(JEOLUtil.appendInText('SalesCustomer__c', accIdList));
                whereConditions.add('SalesCustomer__c != null');
            }
            //機種 
            if (String.isNotBlank(this.kikaku_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('Kikaku__c', this.kikaku_sales));
            }
            //機種名称
            if (String.isNotBlank(this.modelName_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('ModelNamePI__c', this.modelName_sales));
            }
            //本体号機
            if (String.isNotBlank(this.mainPartNoMachine_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('UnitBody__c', this.mainPartNoMachine_sales));
            }
            //受付番号
            if (String.isNotBlank(this.name_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('Name', this.name_sales));
            }
            //製番
            if (String.isNotBlank(this.productNo_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('ProductNo__c', this.productNo_sales));
            }
            //サービスエリア
            if (String.isNotBlank(this.center_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('ServiceAreaName__c', this.center_sales));
            }
            if (String.isNotBlank(this.uketsukeSupportPerson_sales)) {
                whereConditions.add(JEOLUtil.appendLikeText('SupportPerson__c', this.uketsukeSupportPerson_sales));
            }
            
            // 対応日
            String targetField = getSupportedDateField();
            try {
                if (String.isNotBlank(targetField)) {
                    if (String.isNotBlank(this.taiouStartDate_sales)) {
                        Date fromDate = Date.parse(this.taiouStartDate_sales);
                        whereConditions.add(JEOLUtil.appendGreaterThanEqualText(targetField, fromDate.format().replaceAll('/', '-'), false));
                    }
                    if (String.isNotBlank(this.taiouEndDate_sales)) {
                        Date toDate = Date.parse(this.taiouEndDate_sales);
                        whereConditions.add(JEOLUtil.appendLessThanEqualText(targetField, toDate.format().replaceAll('/', '-'), false));
                    }
                    if (String.isNotBlank(this.taiouStartDate_sales) || String.isNotBlank(this.taiouEndDate_sales)) {
                        whereConditions.add(' ' + targetField + ' != null ');
                    }
                    if (String.isBlank(this.taiouStartDate_sales) && String.isBlank(this.taiouEndDate_sales)) {
                        whereConditions.add(' ' + targetField + ' = null ');
                    }
                }
            } catch(Exception e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'対応日は半角の「年/月/日」で入力してください。');
                Apexpages.addMessage(msg);
                return;
            }
        }

        // サポート向け検索criteria作成
        if (this.searchType == SEARCH_TYPE_SUPPORT) {

            //取引先コード
            if (String.isNotBlank(this.customerCode_support)) {
                whereConditions.add(JEOLUtil.appendAfterLikeText('CustomerCode__c', this.customerCode_support));
            }
            //取引先名
            if (String.isNotBlank(this.customerName_support)) {
                whereConditions.add(JEOLUtil.appendLikeText('CustomerName__c', this.customerName_support));
            }
            //サービスエリア
            if (String.isNotBlank(this.center_support)) {
                whereConditions.add(JEOLUtil.appendEqualText('ServiceAreaName__c', this.center_support));
            }
            //系列
            if (String.isNotBlank(this.series_support)) {
                whereConditions.add(JEOLUtil.appendEqualText('SeriesPI__c', this.series_support));
            }
            //機種
            if (String.isNotBlank(this.kikaku_support)) {
                whereConditions.add(JEOLUtil.appendLikeText('Kikaku__c', this.kikaku_support));
            }
            //本体号機
            if (String.isNotBlank(this.mainPartNoMachine_support)) {
                whereConditions.add(JEOLUtil.appendLikeText('UnitBody__c', this.mainPartNoMachine_support));
            }
            //対応者
            if (String.isNotBlank(this.uketsukeSupportPerson_support)) {
                whereConditions.add(JEOLUtil.appendLikeText('SupportPerson__c', this.uketsukeSupportPerson_support));
            }
            //サービス種別
            if (String.isNotBlank(this.serviceType_support)) {
                whereConditions.add(JEOLUtil.appendEqualText('TypeOfService__c', this.serviceType_support));
            }
            //受付番号
            if (String.isNotBlank(this.name_support)) {
                whereConditions.add(JEOLUtil.appendLikeText('Name', this.name_support));
            }
            //製番
            if (String.isNotBlank(this.productNo_support)) {
                whereConditions.add(JEOLUtil.appendLikeText('ProductNo__c', this.productNo_support));
            }
            //キーワード
            if (String.isNotBlank(this.keyword_support)) {
                whereConditions.add(JEOLUtil.appendLikeText('ServiceUketuskeNaiyou__c', this.keyword_support));
            }
            //ステータス
            if (String.isNotBlank(this.status_support)) {
                whereConditions.add(JEOLUtil.appendEqualText('Status__c', this.status_support));
            }
            // 受付日
            try {
                if (String.isNotBlank(this.uketsukeStartDate_support)) {
                    Date fromDate = Date.parse(this.uketsukeStartDate_support);
                    whereConditions.add(JEOLUtil.appendGreaterThanEqualText('ReceptionDate__c', fromDate.format().replaceAll('/', '-'), false));
                }
                if (String.isNotBlank(this.uketsukeEndDate_support)) {
                    Date toDate = Date.parse(this.uketsukeEndDate_support);
                    whereConditions.add(JEOLUtil.appendLessThanEqualText('ReceptionDate__c', toDate.format().replaceAll('/', '-'), false));
                }
                if (String.isNotBlank(this.uketsukeStartDate_support) || String.isNotBlank(this.uketsukeEndDate_support)) {
                    whereConditions.add(' ReceptionDate__c != null ');
                }
            } catch(Exception e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'受付日は半角の「年/月/日」で入力してください。');
                Apexpages.addMessage(msg);
                return;
            }

            // 対応日
            String targetField = getSupportedDateField();
            try {
                if (String.isNotBlank(targetField)) {
                    if (String.isNotBlank(this.taiouStartDate_support)) {
                        Date fromDate = Date.parse(this.taiouStartDate_support);
                        whereConditions.add(JEOLUtil.appendGreaterThanEqualText(targetField, fromDate.format().replaceAll('/', '-'), false));
                    }
                    if (String.isNotBlank(this.taiouEndDate_support)) {
                        Date toDate = Date.parse(this.taiouEndDate_support);
                        whereConditions.add(JEOLUtil.appendLessThanEqualText(targetField, toDate.format().replaceAll('/', '-'), false));
                    }
                    if (String.isNotBlank(this.taiouStartDate_support) || String.isNotBlank(this.taiouEndDate_support)) {
                        whereConditions.add(' ' + targetField + ' != null ');
                    }
                    if (String.isBlank(this.taiouStartDate_support) && String.isBlank(this.taiouEndDate_support)) {
                        whereConditions.add(' ' + targetField + ' = null ');
                    }
                } 
            } catch(Exception e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'対応日は半角の「年/月/日」で入力してください。');
                Apexpages.addMessage(msg);
                return;
            }
        }

        soql += JEOLUtil.joinWhereConditions(whereConditions);
        soql += ' ORDER BY ' + orderBy;

        System.debug(soql);
        if (orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000 ';

        System.debug(soql);
        Database.Querylocator qLocate = Database.getQueryLocator(soql);
        ssc = new ApexPages.StandardSetController (qLocate);
        
        if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }
    
    private String getSupportedDateField() {
        String value;
        if(this.searchType == SEARCH_TYPE_SALES) {
            value = serviceDateStatus_sales;
        } else if (this.searchType == SEARCH_TYPE_SUPPORT) {
            value = this.serviceDateStatus_support;
        }
        String targetField;
        if (value == '対応開始日') {
            targetField = 'ServiceStartDate__c';
        } else if (value== '対応終了日') {
            targetField = 'ServiceEndDate__c';
        } else if (value== '完了日') {
            targetField = 'ServiceCompletedDateFormula__c';
        }
        return targetField;
    }

    /**
     *  営業向け検索
     */
    public PageReference search1() {
        this.searchType = SEARCH_TYPE_SALES;
        
        orderBy= 'CustomerCode__c';
        currentOrder = 'CustomerCode__c';
        orderDesc = false;
        
        search();

        return null;
    }

    /**
     *  サポート向け検索
     */
    public PageReference search2() {
        this.searchType = SEARCH_TYPE_SUPPORT;
        
        orderBy= 'CustomerCode__c';
        currentOrder = 'CustomerCode__c';
        orderDesc = false;
        
        search();
        return null;
    }

    /**
     *  検索（StandardSetController初期化）
     */
    private void search() {
        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        setStandardSetController();
        if (ssc != null) {
            ssc.setPageNumber(1);
        }
        saveInputValues();
    }


    /*検索内容の取得*/  
    public List<rowWrapper> getSupport() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;
        
        if(ssc != null) {
            for (Support__c row : (List<Support__c>)ssc.getRecords()) {
                rowWrapper wrap  = new rowWrapper(row, currentCount);
                rows.add(wrap);
                currentCount++;
            }
        }
        return rows;
    }
    
    /*検索結果の設定*/
    public class rowWrapper{
        public Support__c rec {get; set;}
        public String ReceptionDatetimeJST {get; set;}  // 受付日時の日本時間変換用
        public Integer rowNumber {get; set;}
        
        public rowWrapper(Support__c rec, Integer rowNumber) {
            this.rec  = rec;
            if(rec.ReceptionDatetime__c != null){
                this.ReceptionDatetimeJST = rec.ReceptionDatetime__c.format('yyyy/MM/dd HH:mm:ss','JST');
            }
            this.rowNumber = rowNumber;
        }
        
        public Pagereference getUrl() {
            Pagereference ref = Page.JEOL_ServiceShoriPage;
            String unitBody = rec.unitBody__c;
            if (unitBody == null) {
                unitBody = '';
            }
            ref.getParameters().put('mainPartNo', unitBody);
            return ref;
        }
    }

    public void inputDisabled() {
        if (String.isNotBlank(serviceDateStatus_sales)) {
            isDisabled_sales = false;
        } else {
            isDisabled_sales = true;
        }
        if (isDisabled_sales) {
            taiouStartDate_sales = null;
            taiouEndDate_sales = null;
        }

        if (String.isNotBlank(serviceDateStatus_support)) {
            isDisabled_support = false;
        } else {
            isDisabled_support = true;
        }
        if (isDisabled_support) {
            taiouStartDate_support = null;
            taiouEndDate_support = null;
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