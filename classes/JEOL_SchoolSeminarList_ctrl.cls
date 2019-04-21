public with sharing class JEOL_SchoolSeminarList_ctrl extends JEOL_SearchBase_ctrl {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_SchoolSeminarListPage';  // ページのパス
    private static final String COOKIE_LABLE_SCHOOLSEMINAR_TYPE = 'SchoolSeminarType';  // 講習種別
    private static final String COOKIE_LABLE_SCHOOLSEMINAR_NAME = 'schoolSeminarName';  // 講習名
    private static final String COOKIE_LABLE_SERIES_PI = 'seriesPI';  // 系列
    private static final String COOKIE_LABLE_PLACE = 'place';  // 場所
    private static final String COOKIE_LABLE_JUKOCUSTOMER_NAME = 'jukoCustomerName';  // 受講顧客名称
    private static final String COOKIE_LABLE_GAITO_MODEL = 'gaitoModel';  // 該当機種
    private static final String COOKIE_LABLE_STATUS = 'Status';  // 状態
    private static final String COOKIE_LABLE_USE_FIELD = 'UseField';  // 利用分野
    private static final String COOKIE_LABLE_JUKOSHA_NAME = 'jukoshaName';  // 受講者名
    private static final String COOKIE_LABLE_START_DATE_FROM = 'startDateFrom';  // 開催日From
    private static final String COOKIE_LABLE_START_DATE_TO = 'startDateTo';  // 開催日To
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 検索項目
    public String schoolSeminarName { get; set; }  // 講習名
    public String seriesPI { get; set; }  // 系列
    public String place { get; set; }  // 場所
    public String jukoCustomerName { get; set; }  // 受講顧客名称
    public String gaitoModel { get; set; }  // 該当機種
    public String jukoshaName { get; set; }  // 受講者名
    public String startDateFrom { get; set; }  // 開催日From
    public String startDateTo { get; set; }  // 開催日To
    public String type{ get; set; }  // 講習種別
    public String status{ get; set; }  // 状態
    public String useField{ get; set; }  // 利用分野

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = null;

    // 系列選択リスト取得
    public List<SelectOption> getSeriesPIOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }

    // 講習種別選択リスト取得
    public List<SelectOption> getTypeOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SEMINAR_TYPE);
    }

    // 状態選択リスト取得
    public List<SelectOption> getStatusOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SEMINAR_STATUS);
    }

    // 利用分野選択リスト取得
    public List<SelectOption> getUseFieldOptions(){
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SEMINAR_FIELD);
    }

    /**
    * コンストラクタ
    */
    public JEOL_SchoolSeminarList_ctrl() {

        orderBy = 'SchoolSeminar__r.StartDate__c';
        currentOrder = 'SchoolSeminar__r.StartDate__c';
        orderDesc = true;
        
        // Cookie用
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }

    }

    /**
    *  検索条件のCookie読み取り
    */
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        // 講習種別
        if(cookies.containsKey(COOKIE_LABLE_SCHOOLSEMINAR_TYPE)){
            this.type = cookies.get(COOKIE_LABLE_SCHOOLSEMINAR_TYPE).getValue();
        }
        // 講習名
        if(cookies.containsKey(COOKIE_LABLE_SCHOOLSEMINAR_NAME)){
            this.schoolSeminarName = cookies.get(COOKIE_LABLE_SCHOOLSEMINAR_NAME).getValue();
        }
        // 系列
        if(cookies.containsKey(COOKIE_LABLE_SERIES_PI)){
            this.seriesPI = cookies.get(COOKIE_LABLE_SERIES_PI).getValue();
        }
        // 場所
        if(cookies.containsKey(COOKIE_LABLE_PLACE)){
            this.place = cookies.get(COOKIE_LABLE_PLACE).getValue();
        }
        // 受講顧客名称
        if(cookies.containsKey(COOKIE_LABLE_JUKOCUSTOMER_NAME)){
            this.jukoCustomerName = cookies.get(COOKIE_LABLE_JUKOCUSTOMER_NAME).getValue();
        }
        // 該当機種
        if(cookies.containsKey(COOKIE_LABLE_GAITO_MODEL)){
            this.gaitoModel = cookies.get(COOKIE_LABLE_GAITO_MODEL).getValue();
        }
        // 状態
        if(cookies.containsKey(COOKIE_LABLE_STATUS)){
            this.status = cookies.get(COOKIE_LABLE_STATUS).getValue();
        }
        // 利用分野
        if(cookies.containsKey(COOKIE_LABLE_USE_FIELD)){
            this.useField = cookies.get(COOKIE_LABLE_USE_FIELD).getValue();
        }
        // 受講者名
        if(cookies.containsKey(COOKIE_LABLE_JUKOSHA_NAME)){
            this.jukoshaName = cookies.get(COOKIE_LABLE_JUKOSHA_NAME).getValue();
        }
        // 開催日From
        if(cookies.containsKey(COOKIE_LABLE_START_DATE_FROM)){
            this.startDateFrom = cookies.get(COOKIE_LABLE_START_DATE_FROM).getValue();
        }
        // 開催日To
        if(cookies.containsKey(COOKIE_LABLE_START_DATE_TO)){
            this.startDateTo = cookies.get(COOKIE_LABLE_START_DATE_TO).getValue();
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
    /**
    *  検索条件のCookie保存
    */
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        
        cookies.add(new Cookie(COOKIE_LABLE_SCHOOLSEMINAR_TYPE, this.type, COOKIE_PATH, -1, true));  // 講習種別
        cookies.add(new Cookie(COOKIE_LABLE_SCHOOLSEMINAR_NAME, this.schoolSeminarName, COOKIE_PATH, -1, true));  // 講習名
        cookies.add(new Cookie(COOKIE_LABLE_SERIES_PI, this.seriesPI, COOKIE_PATH, -1, true));  // 系列
        cookies.add(new Cookie(COOKIE_LABLE_PLACE, this.place, COOKIE_PATH, -1, true));  // 場所
        cookies.add(new Cookie(COOKIE_LABLE_JUKOCUSTOMER_NAME, this.jukoCustomerName, COOKIE_PATH, -1, true));  // 受講顧客名称
        cookies.add(new Cookie(COOKIE_LABLE_GAITO_MODEL, this.gaitoModel, COOKIE_PATH, -1, true));  // 該当機種
        cookies.add(new Cookie(COOKIE_LABLE_STATUS, this.status, COOKIE_PATH, -1, true));  // 状態
        cookies.add(new Cookie(COOKIE_LABLE_USE_FIELD, this.useField, COOKIE_PATH, -1, true));  // 利用分野
        cookies.add(new Cookie(COOKIE_LABLE_JUKOSHA_NAME, this.jukoshaName, COOKIE_PATH, -1, true));  // 受講者名
        cookies.add(new Cookie(COOKIE_LABLE_START_DATE_FROM, this.startDateFrom, COOKIE_PATH, -1, true));  // 開催日From
        cookies.add(new Cookie(COOKIE_LABLE_START_DATE_TO, this.startDateTo, COOKIE_PATH, -1, true));  // 開催日To
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);
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

        //ページ初期化
        pageNo = 1;
		pageSize = 50;

        this.initSearchFlg = 'true';  // 画面起動時検索フラグON
        orderBy = 'SchoolSeminar__r.StartDateFormula__c';
        currentOrder = 'SchoolSeminar__r.StartDateFormula__c';
        orderDesc = true;
        
        setStandardSetController();
        if (ssc != null){
            ssc.setPageNumber(1);
        }
        saveInputValues();
    }
    // クリアボタン
    public void doFormClear() {
        // 検索条件のクリア
        this.type = null;  // 講習種別
        this.schoolSeminarName = null;  // 講習名
        this.seriesPI = null;  // 系列
        this.place = null;  // 場所
        this.jukoCustomerName = null;  // 受講顧客名称
        this.gaitoModel = null;  // 該当機種
        this.status = null;  // 状態
        this.useField = null;  // 利用分野
        this.jukoshaName = null;  // 受講者名
        this.startDateFrom = null;  // 開催日From
        this.startDateTo = null;  // 開催日To

        // 検索結果のクリア
        ssc = null;

        //ページ初期化
        pageNo = 1;
		pageSize = 50;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = null;

        // 検索条件のCookie保存
        saveInputValues();
    }

    /**
    *  検索内容の取得
    */
     public List<rowWrapper> getSchoolSeminarEntry(){
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;

        if (ssc != null){
            for (SchoolSeminarEntry__c row: (List<SchoolSeminarEntry__c>)ssc.getRecords()){
                rowWrapper wrap = new rowWrapper(row, currentCount);
                rows.add(wrap);
                currentCount++;
            }
        }
        return rows;
    }


    /**
    *  StandardSetController設定
    */
    protected override void setStandardSetController() {

        // 検索項目
        String soql = '';
        soql += 'Select Id';
        soql += ', SchoolSeminar__r.Id';
        soql += ', SchoolSeminar__r.SchoolSeminarType__c';  // 受講種別
        soql += ', SchoolSeminar__r.Name';  // 講習名
        soql += ', SchoolSeminar__r.Place__c';  // 場所
        soql += ', JukoshaCustomerName__c';  // 受講顧客名称
        soql += ', JukoshaDepartment__c';  // 受講部課名
        soql += ', JukoshaName__c';  // 受講者名
        soql += ', SeriesPI__c';  // 系列
        soql += ', SchoolSeminar__r.GaitoModel__c';  // 該当機種
        soql += ', SchoolSeminar__r.UseField__c';  // 利用分野
        soql += ', SalespersonName__c';  // 担当営業
        soql += ', SchoolSeminar__r.StartDateFormula__c';  // 開催日
        soql += ', SchoolSeminar__r.Days__c';  // 日数
        soql += ', SchoolSeminar__r.KakuteiNum__c';  // 確定数
        soql += ', SchoolSeminar__r.Status__c';  // 状態
        soql += ' From SchoolSeminarEntry__c';

        
		List<String> whereConditions = new List<String>();
        // 講習種別
        if (String.isNotBlank(this.type)) {
            whereConditions.add(JEOLUtil.appendEqualText('SchoolSeminar__r.schoolSeminarType__c', this.type));
        }
        // 講習名
        if (String.isNotBlank(this.schoolSeminarName)){
            whereConditions.add(JEOLUtil.appendLikeText('SchoolSeminar__r.Name', this.schoolSeminarName));
        }
        // 系列
        if (String.isNotBlank(this.seriesPI)){
            whereConditions.add(JEOLUtil.appendEqualText('SeriesPI__c', this.seriesPI));
        }
        // 場所
        if (String.isNotBlank(this.place)){
            whereConditions.add(JEOLUtil.appendLikeText('SchoolSeminar__r.Place__c', this.place));
        }
        // 受講顧客名称
        if (String.isNotBlank(this.jukoCustomerName)){
            whereConditions.add(JEOLUtil.appendLikeText('JukoshaCustomerName__c', this.jukoCustomerName));
        }
        // 該当機種
        if (String.isNotBlank(this.gaitoModel)){
            whereConditions.add(JEOLUtil.appendLikeText('SchoolSeminar__r.GaitoModel__c', this.gaitoModel));
        }
        // 状態
        if (String.isNotBlank(this.status)){
            whereConditions.add(JEOLUtil.appendEqualText('SchoolSeminar__r.Status__c', this.status));
        }
        // 利用分野
        if (String.isNotBlank(this.useField)){
            whereConditions.add(JEOLUtil.appendEqualText('SchoolSeminar__r.UseField__c', this.useField));
        }
        // 受講者名
        if (String.isNotBlank(this.jukoshaName)){
            whereConditions.add(JEOLUtil.appendLikeText('JukoshaName__c', this.jukoshaName));
        }
        // 開催日
        if (String.isNotBlank(this.startDateFrom) || String.isNotBlank(this.startDateTo)){
        	try {
        		if (String.isNotBlank(this.startDateFrom)) {
        			Date fromDate = Date.parse(this.startDateFrom);
		            whereConditions.add(JEOLUtil.appendGreaterThanEqualText('SchoolSeminar__r.StartDateFormula__c', fromDate.format().replaceAll('/', '-'), false));
        		}
        		if (String.isNotBlank(this.startDateTo)) {
        			Date toDate = Date.parse(this.startDateTo);
		            whereConditions.add(JEOLUtil.appendLessThanEqualText('SchoolSeminar__r.StartDateFormula__c', toDate.format().replaceAll('/', '-'), false));
        			
        		}
        		if (String.isNotBlank(this.startDateFrom) || String.isNotBlank(this.startDateTo)) {
		            whereConditions.add(' SchoolSeminar__r.StartDate__c != null ');
        		}
        	} catch (Exception e) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'開催日は半角の「年/月/日」で入力してください。');
                return;
        		
        	}
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
            // ページサイズ・番号の設定
            this.ssc.setPageSize(pageSize);
            this.ssc.setPageNumber(pageNo);
        }

    }

    public void nextAndSaveCurrentPageNumber() {
        next();
        setCookieCurrentPageNumber();
    }
    public void previousAndSaveCurrentPageNumber() {
        previous();
        setCookieCurrentPageNumber();
    }
    public void firstAndSaveCurrentPageNumber() {
        first();
        setCookieCurrentPageNumber();
    }
    public void lastAndSaveCurrentPageNumber() {
        last();
        setCookieCurrentPageNumber();
    }
    public void setJumpSaveCurrentPageSize() {
        jump();
        setCookieCurrentPageSize();
        setCookieCurrentPageNumber();
    }
    public void setSizeSaveCurrentPageSize() {
        changeSize();
        setCookieCurrentPageSize();
        setCookieCurrentPageNumber();
    }
    private void setCookieCurrentPageNumber() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(ssc.getPageNumber()), COOKIE_PATH, -1, true)});
        }
    }
    private void setCookieCurrentPageSize() {
        if (ssc != null) {
            Apexpages.currentPage().setCookies(new List<Cookie>{new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(ssc.getPageSize()), COOKIE_PATH, -1, true)});
        }
    }

    /**
    *  検索結果の設定
    */
    public class rowWrapper{
        public SchoolSeminarEntry__c rec {get; set;}
        public Integer rowNumber {get; set;}
        
        public rowWrapper(SchoolSeminarEntry__c rec, Integer rowNumber){
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
    }

}