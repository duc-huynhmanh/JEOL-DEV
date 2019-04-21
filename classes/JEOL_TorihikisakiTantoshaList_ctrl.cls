public with sharing class JEOL_TorihikisakiTantoshaList_ctrl extends JEOL_SearchBase_ctrl {

    private static final String COOKIE_PATH = '/apex/JEOL_TorihikisakiTantoshaListPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ
    // 検索条件の項目
    public String customerCode { get; set; }
    public String customerName { get; set; }
    public String customerNameHan { get; set; }
    public String customerCategory { get; set; }
    public String tantoshaCode { get; set; }
    public String tantoshaName { get; set; }

    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }

    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';

    public JEOL_TorihikisakiTantoshaList_ctrl() {
        orderBy= 'TantoshaCode__c';
        currentOrder = 'TantoshaCode__c';
        orderDesc = false;

        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }

    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {

        // SOQLを作成する
        String soql = 'select Id, ';
               soql += 'AccountId, ';
               soql += 'Account.name, ';
               soql += 'Account.Code__c, ';
               soql += 'Account.Undergraduate__c, ';
               soql += 'TantoshaCode__c, ';
               soql += 'Name, ';
               soql += 'Affiliation__c, ';
               soql += 'Department, ';
               soql += 'Phone, Fax, ';
               soql += 'Email, ';
               soql += 'Gakureki__c, ';
               soql += 'DM__c, ';
               soql += 'biko1__c, ';
               soql += 'biko2__c, ';
               soql += 'biko3__c, ';
               soql += 'IsDeleted, ';
               soql += '(select id from CaseInformations__r)';
               soql += 'from Contact ';
		
		List<String> whereConditions = new List<String>();
        //顧客コード
        if (String.isNotBlank(this.customerCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('Account.code__c', this.customerCode));
        }
        //顧客名半角
        if (String.isNotBlank(this.customerNameHan)) {
            whereConditions.add(JEOLUtil.appendLikeText('Account.NameUpToKana__c', this.customerNameHan));
        }
        //顧客名
        if (String.isNotBlank(this.customerName)) {
            whereConditions.add(JEOLUtil.appendLikeText('Account.Name', this.customerName));
        }
        //顧客カテゴリ 
        if (String.isNotBlank(this.customerCategory)) {
            List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory);
            whereConditions.add(JEOLUtil.appendInText('AccountId', accIdList));
            whereConditions.add(' AccountId != null ');
        }

        //担当者コード
        if (String.isNotBlank(this.tantoshaCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('TantoshaCode__c', this.tantoshaCode));
        }
        //担当者名
        if (String.isNotBlank(this.tantoshaName)) {
            whereConditions.add(JEOLUtil.appendLikeText('Name', this.tantoshaName));
        }

        soql += JEOLUtil.joinWhereConditions(whereConditions);
        if (orderBy != 'caseSort') {
	        soql += ' ORDER BY ' + orderBy;
	        if (orderDesc) {
	            soql += ' DESC NULLS LAST';
	        }
        }
        
        soql += ' LIMIT 10000 ';

        //削除したレコードも表示するために、「ALL ROWS」をつけているが、「削除」は「isdeleted」のことではないかもしれない
        soql += ' ALL ROWS';
        ssc = new ApexPages.StandardSetController(Database.getQueryLocator(soql));

		if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }

    //画面の検索ボタンから呼ばれるメソッド
    public PageReference search1() {
        orderBy= 'TantoshaCode__c';
        currentOrder = 'TantoshaCode__c';
        orderDesc = false;
        search();
        return null;
    }

    //画面のクリアボタンから呼ばれるメソッド
    public void doFormClear() {
        // 検索条件のクリア
        this.customerCode = null;
        this.customerName = null;
        this.customerNameHan = null;
        this.customerCategory = null;
        this.tantoshaCode = null;
        this.tantoshaName = null;

        //ページ初期化
        pageNo = 1;
		pageSize = 50;
        
        // 検索結果のクリア
        ssc = null;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        // 検索条件のCookie保存
        saveInputValues();
    }

    /**
     *  検索（StandardSetController初期化）
     */
    private void search() {
        this.initSearchFlg = 'true';  // 画面起動時検索フラグON

        //ページ初期化
        pageNo = 1;
		pageSize = 50;

        setStandardSetController();
        if (ssc != null) {
            ssc.setPageNumber(1);
        }
        saveInputValues();
    }
    
    //検索条件保持
    private void saveInputValues() {
        List<Cookie> cookies = new List<Cookie>();
        cookies.add(new Cookie('customerCode', this.customerCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerNameHan', this.customerNameHan, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerName', this.customerName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerCategory', this.customerCategory, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('tantoshaCode', this.tantoshaCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('tantoshaName', this.tantoshaName, COOKIE_PATH, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);

    }

    //保持項目有無判定
    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();

        Boolean hasSearchValues = false;
        if(cookies.containsKey('customerCode')){
            this.customerCode = cookies.get('customerCode').getValue();
        }
        if(cookies.containsKey('customerNameHan')){
            this.customerNameHan = cookies.get('customerNameHan').getValue();
        }
        if(cookies.containsKey('customerName')){
            this.customerName= cookies.get('customerName').getValue();
        }
        if(cookies.containsKey('customerCategory')){
            this.customerCategory = cookies.get('customerCategory').getValue();
        }
        if(cookies.containsKey('tantoshaCode')){
            this.tantoshaCode= cookies.get('tantoshaCode').getValue();
        }
        if(cookies.containsKey('tantoshaName')){
            this.tantoshaName= cookies.get('tantoshaName').getValue();
        }
        // ページ
        if(cookies.containsKey(COOKIE_LABEL_PAGE_NUMBER)){
            pageNo = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_NUMBER).getValue());
        }
        // ページサイズ
        if(cookies.containsKey(COOKIE_LABEL_PAGE_SIZE)){
            pageSize = Integer.valueOf(cookies.get(COOKIE_LABEL_PAGE_SIZE).getValue());
        }
        // 画面起動時検索フラグ
        if(cookies.containsKey(COOKIE_LABEL_INIT_SEARCH_FLG) && String.isNotBlank(cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue())) {
            this.initSearchFlg = cookies.get(COOKIE_LABEL_INIT_SEARCH_FLG).getValue();
            hasSearchValues = (this.initSearchFlg == 'true') ||  hasSearchValues ? true : false;
        }

        return hasSearchValues;
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


    /*検索内容の取得*/
    public List<rowWrapper> getContactList() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;
        
        if(ssc != null) {
        	if (orderBy != 'caseSort') {
	            for (Contact row : (List<Contact>)ssc.getRecords()) {
	                rowWrapper wrap = new rowWrapper(row, currentCount);
	                rows.add(wrap);
	                currentCount++;
	            }
	         } else {
	         	Integer currentPageSize = ssc.getPageSize();
	         	Integer currentPageNo = ssc.getPageNumber();
	         	Integer resultSize = ssc.getResultSize();
	         	if (resultSize > 0) {
					
					List<rowWrapper> wraps = new List<rowWrapper>();
					Integer lineNum = 1;
					Integer pageNum = 1;
		         	ssc.setPageSize(2000);
		         	ssc.setPageNumber(pageNum);
					while (pageNum*ssc.getPageSize() < resultSize) {
						ssc.setPageNumber(pageNum);
						for (Contact targetRec: (List<Contact>)ssc.getRecords()) {
							wraps.add(new rowWrapper(targetRec, lineNum));
							lineNum++;
						}
						pageNum++;
					}
					ssc.setPageNumber(pageNum);
					for (Contact targetRec: (List<Contact>)ssc.getRecords()) {
						wraps.add(new rowWrapper(targetRec, lineNum));
						lineNum++;
					}
		         	ssc.setPageSize(currentPageSize);
		         	ssc.setPageNumber(currentPageNo);
		        	wraps.sort();
	
					List<rowWrapper> retWraps = new List<rowWrapper>();
		        	for (Integer i = currentPageSize*(currentPageNo-1); (i < currentPageSize*currentPageNo) && (i < wraps.size()); i++) {
		        		rowWrapper targetWrap = wraps.get(i);
		        		targetWrap.rowNumber = i + 1;
		        		retWraps.add(targetWrap);
		        	}
		        	if (orderDesc) {
		        		List<rowWrapper> descList = new List<rowWrapper>();
		        		Integer size = retWraps.size();
		        		for (Integer i = size; i > 0; i--) {
			        		rowWrapper targetWrap = wraps.get(i - 1);
			        		targetWrap.rowNumber = size - i;
			        		descList.add(targetWrap);
		        		}
		        		retWraps = descList;
		        	}
		        	rows = retWraps;
	         	}
	         }
        }
        
        return rows;
    }
    
    /*検索結果の設定*/
    public class rowWrapper implements Comparable {
        public Contact rec {get; set;}
        public Integer rowNumber {get; set;}
        public Integer caseCount{get; set;}
        public rowWrapper(Contact rec, Integer rowNumber) {
            this.rec = rec;
            this.rowNumber = rowNumber;
            if (rec.CaseInformations__r != null) {
	            this.caseCount = rec.CaseInformations__r.size();
            } else {
	            this.caseCount = 0;
            }
        }
        
        public Integer compareTo(Object compareTo) {
	        rowWrapper wrap = (rowWrapper)compareTo;
    	    if (caseCount == wrap.caseCount) {
				return 0;
    	    }
        	if (caseCount > wrap.caseCount) {
        		return -1;
        	}
	        return 1;
    	}
    }
    
}