public with sharing class JEOL_UriageList_ctrl {

    private static final String COOKIE_PATH = '/apex/JEOL_UriageListPage';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 検索条件の項目
    public String kigyoTani { get; set; }
    public String hanbaisakiCode { get; set; }
    public String hanbaisakiName { get; set; }
    public String shukkasakiCode { get; set; }
    public String shukkasakiName { get; set; }
    public String seikyusakiCode { get; set; }
    public String seikyusakiName { get; set; }
    public String customerCategory { get; set; }
    public String bumon { get; set; }
    public String keiretsu { get; set; }
    public String nendoFrom { get; set; }
    public String nendoTo { get; set; }

    // 選択リスト取得用
    public SalesResult__c selectList { get; set; }

    //画面表示用リスト
    private transient List<SalesResultDetail> salesResultDetails;
    public List<SalesResultDetail> getSalesResult() {
    	if (this.salesResultDetails == null) {
    		this.salesResultDetails = new List<SalesResultDetail>();
    	}
    	return this.salesResultDetails.clone();
    }

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';

    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }

    public List<SelectOption> getSeriesOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }

    public List<SelectOption> getDepartmentOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_DEPARTMENT);
    }

    public List<SelectOption> getOrgUnitOptions() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_ORG_UNIT);
    }

    public class SalesResultDetail {
		
		//基本情報
        public Id id {get; set;}
        public String tani{ get; set;}    //企業単位
        public String nendo{get; set;}   //年度
        public String bumon{get; set;}   //部門
        public String keiretsu{get; set;}     //系列

        //表示用金額
        public Decimal jisha{get; set;}   //自社
        public Decimal tasha{ get; set;}   //他社
        public Decimal svc{get; set;}     //SVC
        public Decimal ef{get; set;}      //EF
        public Decimal kosen{get; set;}   //口銭
        
        //売上照会URL作成用パラメータ
        private Map<String, String> urlParameters = new Map<String, String>();
        
        public Boolean isTotal{get; set;}
        public Boolean isSubtotal{get; set;}
        
        //コンストラクタ
        public SalesResultDetail() {
        	init();
        }
        public SalesResultDetail(String hanbaisakiCode, String hanbaisakiName, String shukkasakiCode, String shukkasakiName, String seikyusakiCode, String seikyusakiName, String customerCategory) {
        	init();
        	setParametrs('hanbaisakiCode', hanbaisakiCode);
        	setParametrs('hanbaisakiName', hanbaisakiName);
        	setParametrs('shukkasakiCode', shukkasakiCode);
        	setParametrs('shukkasakiName', shukkasakiName);
        	setParametrs('seikyusakiCode', seikyusakiCode);
        	setParametrs('seikyusakiName', seikyusakiName);
        	setParametrs('customerCategory', customerCategory);
        }
        
        private void init() {
        	this.jisha = 0;
        	this.tasha = 0;
        	this.svc = 0;
        	this.ef = 0;
        	this.kosen = 0;
        	
        	this.isTotal = false;
        	this.isSubtotal = false;
        }
        
        public Map<String, String> getParametrs() {
        	return this.urlParameters;
        }

        public void setParametrs(String key, String value) {
        	String keyValue = '';
        	if (String.isNotBlank(key)) {
        		keyValue = key;
        	}
        	this.urlParameters.put(key, value);
        }
        
        public PageReference getEncTaniResultUrl() {
        	PageReference ref = getStanderdUrl();
        	ref.getParameters().put('kigyoTani', this.tani);
            return ref;
        }
        public PageReference getEncNendoResultUrl() {
        	PageReference ref = getStanderdUrl();
        	ref.getParameters().put('nendo', this.nendo);
            return ref;
        }
        public PageReference getEncBumonResultUrl() {
        	PageReference ref = getStanderdUrl();
        	ref.getParameters().put('bumon', this.bumon);
            return ref;
        }
        public PageReference getEncKeiretsuResultUrl() {
        	PageReference ref = getStanderdUrl();
        	ref.getParameters().put('keiretsu', this.keiretsu);
            return ref;
        }
        
        private PageReference getStanderdUrl() {
			PageReference ref = Page.JEOL_UriageShokaiListPage;
			ref.getParameters().putAll(this.urlParameters);
			ref.setRedirect(true);
			return ref;
		}

    }

    //コンストラクタ
    public JEOL_UriageList_ctrl() {
        selectList = new SalesResult__c();

        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            runSoql();
        }
    }

   /**
     *  soql実行
     */
    private void runSoql() {

        String soql = 'SELECT ' +
        				' id, ' +
               			' kigyoTani__c, ' +
               			' uriageNendo__c, ' +
               			' bumon__c, ' +
               			' keiretsu__c, ' +
               			' SalesForeign__c, ' +
               			'JishaTasha__c ' +
               		' FROM ' +
               			' SalesResult__c ';

		List<String> whereConditions = new List<String>();
		//企業単位
        if (String.isNotBlank(this.kigyoTani)) {
            whereConditions.add(JEOLUtil.appendEqualText('kigyoTani__c', this.kigyoTani));
        }
		//販売先取引先
        if (String.isNotBlank(this.hanbaisakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('hanbaisaki__r.Code__c', this.hanbaisakiCode));
        }
		//販売先取引先名
        if (String.isNotBlank(this.hanbaisakiName)) {
            whereConditions.add(JEOLUtil.appendLikeText('hanbaisaki__r.Name', this.hanbaisakiName));
        }
		//出荷先取引先
        if (String.isNotBlank(this.shukkasakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('shukkasaki__r.Code__c', this.shukkasakiCode));
        }
		//出荷先取引先名
        if (String.isNotBlank(this.shukkasakiName)) {
            whereConditions.add(JEOLUtil.appendLikeText('shukkasaki__r.Name', this.shukkasakiName));
        }
		//請求先取引先
        if (String.isNotBlank(this.seikyusakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('seikyusaki__r.Code__c', this.seikyusakiCode));
        }
		//請求先取引先名
        if (String.isNotBlank(this.seikyusakiName)) {
            whereConditions.add(JEOLUtil.appendLikeText('seikyusaki__r.Name', this.seikyusakiName));
        }
        //顧客カテゴリ
        if (String.isNotBlank(this.customerCategory)) {
            List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory);
            String hanbai = JEOLUtil.appendInText('hanbaisaki__c', accIdList);
            String shukka = JEOLUtil.appendInText('shukkasaki__c', accIdList);
            String seikyu = JEOLUtil.appendInText('seikyusaki__c', accIdList);
            whereConditions.add(' (' + hanbai + ' OR ' + shukka + ' OR ' + seikyu + ') ');
            whereConditions.add(' hanbaisaki__c != null ');
            whereConditions.add(' shukkasaki__c != null ');
            whereConditions.add(' seikyusaki__c != null ');
        }
        //部門
        if (String.isNotBlank(this.bumon)) {
            whereConditions.add(JEOLUtil.appendEqualText('bumon__c', this.bumon));
        }
        //系列
        if (String.isNotBlank(this.keiretsu)) {
            whereConditions.add(JEOLUtil.appendEqualText('keiretsu__c', this.keiretsu));
        }
        //売上年度FROM
    	if (String.isNotBlank(this.nendoFrom) && this.nendoFrom.isNumeric()) {
            whereConditions.add(JEOLUtil.appendGreaterThanEqualText('uriageNendo__c', this.nendoFrom));
    	} else if (String.isNotBlank(this.nendoFrom) && !this.nendoFrom.isNumeric()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '年度は数字で入力してください。'));
			return;
    	}
        //売上年度TO
    	if (String.isNotBlank(this.nendoTo) && this.nendoTo.isNumeric()) {
            whereConditions.add(JEOLUtil.appendLessThanEqualText('uriageNendo__c', this.nendoTo));
		} else if (String.isNotBlank(this.nendoTo) && !this.nendoTo.isNumeric()) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '年度は数字で入力してください。'));
			return;
		}
		if (String.isNotBlank(this.nendoFrom) || String.isNotBlank(this.nendoTo)) {
            whereConditions.add(' uriageNendo__c != null ');
		}

        soql += JEOLUtil.joinWhereConditions(whereConditions);
        soql += ' ORDER BY kigyoTani__c, uriageNendo__c, bumon__c, keiretsu__c';
        soql += ' LIMIT 100000';

        List<SalesResult__c> recs = Database.query(soql);
	
		if (recs.size() >= 100000) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '検索結果が１０万件を超えました。検索条件を追加して再度検索してください。'));
			return;
		} 
		if(recs.size() <= 0) {
            return;
        }
		createSalesResultDetail(recs);
    }
    
	public void createSalesResultDetail(List<SalesResult__c> salesResults) {
		List<SalesResultDetail> details = new List<SalesResultDetail>();
		if (salesResults != null && salesResults.size() > 0) {
			
			SalesResult__c firstSalesResult = salesResults.get(0);
			
			SalesResultDetail total = new SalesResultDetail();
			total.isTotal = true;
			SalesResultDetail subtotal = new SalesResultDetail();
			subtotal.isSubtotal = true;
			SalesResultDetail salesDetail = new SalesResultDetail();
			String currentOrgUnit = firstSalesResult.kigyoTani__c;
			String currentYear = firstSalesResult.uriageNendo__c;
			String currentDepertment = firstSalesResult.bumon__c;
			String currentSeries = firstSalesResult.keiretsu__c;
			salesDetail.tani = currentOrgUnit;
			salesDetail.nendo = currentYear;
			salesDetail.bumon = currentDepertment;
			salesDetail.keiretsu = currentSeries;
			salesDetail.isTotal = false;
			salesDetail.isSubtotal = false;
			for (SalesResult__c rec: salesResults) {
				
				String targetOrgUnit = rec.kigyoTani__c;
				String targetYear = rec.uriageNendo__c;
				String targetDepertment = rec.bumon__c;
				String targetSeries = rec.keiretsu__c;
				if (currentDepertment != targetDepertment || currentSeries != targetSeries || currentYear != targetYear || currentOrgUnit != targetOrgUnit) {
					details.add(salesDetail);
					salesDetail = new SalesResultDetail(hanbaisakiCode, hanbaisakiName, shukkasakiCode, shukkasakiName, seikyusakiCode, seikyusakiName, customerCategory);
					salesDetail.bumon = targetDepertment;
					salesDetail.keiretsu = targetSeries;
					salesDetail.tani = targetOrgUnit;
					salesDetail.nendo = targetYear;
					salesDetail.isTotal = false;
					salesDetail.isSubtotal = false;
					currentDepertment = targetDepertment;
					currentSeries = targetSeries;
					if (currentYear != targetYear || currentOrgUnit != targetOrgUnit) {
						details.add(subtotal);
						subtotal = new SalesResultDetail();
						subtotal.isTotal = false;
						subtotal.isSubtotal = true;
						currentYear = targetYear;
						if (currentOrgUnit != targetOrgUnit) {
							details.add(total);
							total = new SalesResultDetail();
							total.isTotal = true;
							total.isSubtotal = false;
							currentOrgUnit = targetOrgUnit;
						}
					}
				}
				String salesType = rec.JishaTasha__c;
				Decimal amount = rec.SalesForeign__c == null ? 0 : rec.SalesForeign__c;
				if (salesType == '自社品') {
					total.jisha += amount;
					subtotal.jisha += amount;
					salesDetail.jisha += amount;
				}
				if (salesType == '他社品') {
					total.tasha += amount;
					subtotal.tasha += amount;
					salesDetail.tasha += amount;
				}
				if (salesType == 'SVC') {
					total.svc += amount;
					subtotal.svc += amount;
					salesDetail.svc += amount;
				}
				if (salesType == 'EF') {
					total.ef += amount;
					subtotal.ef += amount;
					salesDetail.ef += amount;
				}
				if (salesType == '口銭') {
					total.kosen += amount;
					subtotal.kosen += amount;
					salesDetail.kosen += amount;
				}
			}
			details.add(salesDetail);
			details.add(subtotal);
			details.add(total);
			
		}
		
		this.salesResultDetails = details;
	}

    
    //画面のクリアボタンから呼ばれるメソッド
    public void doFormClear() {
		// 検索条件のクリア
		this.kigyoTani = null;
		this.hanbaisakiCode = null;
		this.hanbaisakiName = null;
		this.shukkasakiCode = null;
		this.shukkasakiName = null;
		this.seikyusakiCode = null;
		this.seikyusakiName = null;
		this.customerCategory = null;
		this.bumon = null;
		this.keiretsu = null;
		this.nendoFrom = null;
		this.nendoTo = null;
		// 画面起動時検索フラグOFF
		this.initSearchFlg = '';
		// 検索結果のクリア
		salesResultDetails = null;
		// 検索条件のCookie保存
		saveInputValues();
    }
    
    /**
     *  検索（StandardSetController初期化）
     */
    public void search() {
		salesResultDetails = null;
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON
        runSoql();
        saveInputValues();
    }

    /**
     *	検索結果をクッキーに保存する
     */
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        
        cookies.add(new Cookie('kigyoTani', this.kigyoTani, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiCode', this.hanbaisakiCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('hanbaisakiName', this.hanbaisakiName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiCode', this.shukkasakiCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('shukkasakiName', this.shukkasakiName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('seikyusakiCode', this.seikyusakiCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('seikyusakiName', this.seikyusakiName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerCategory', this.customerCategory, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('bumon', this.bumon, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('keiretsu', this.keiretsu, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('nendoFrom', this.nendoFrom, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('nendoTo', this.nendoTo, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);
    }

    /**
     *	クッキーの値を取得し、検索用項目に格納する
     */
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();

        Boolean hasSearchValues = false;
        if(cookies.containsKey('kigyoTani')){
            this.kigyoTani= cookies.get('kigyoTani').getValue();
        }
        if(cookies.containsKey('hanbaisakiCode')){
            this.hanbaisakiCode= cookies.get('hanbaisakiCode').getValue();
        }
        if(cookies.containsKey('hanbaisakiName')){
            this.hanbaisakiName= cookies.get('hanbaisakiName').getValue();
        }
        if(cookies.containsKey('shukkasakiCode')){
            this.shukkasakiCode= cookies.get('shukkasakiCode').getValue();
        }
        if(cookies.containsKey('shukkasakiName')){
            this.shukkasakiName= cookies.get('shukkasakiName').getValue();
        }
        if(cookies.containsKey('seikyusakiCode')){
            this.seikyusakiCode= cookies.get('seikyusakiCode').getValue();
        }
        if(cookies.containsKey('seikyusakiName')){
            this.seikyusakiName= cookies.get('seikyusakiName').getValue();
        }
        if(cookies.containsKey('customerCategory')){
            this.customerCategory = cookies.get('customerCategory').getValue();
        }
        if(cookies.containsKey('bumon')){
            this.bumon= cookies.get('bumon').getValue();
        }
        if(cookies.containsKey('keiretsu')){
            this.keiretsu = cookies.get('keiretsu').getValue();
        }
        if(cookies.containsKey('nendoFrom')){
            this.nendoFrom= cookies.get('nendoFrom').getValue();
        }
        if(cookies.containsKey('nendoTo')){
            this.nendoTo= cookies.get('nendoTo').getValue();
        }
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue().length() != 0){
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }

        return hasSearchValues;
    }
}