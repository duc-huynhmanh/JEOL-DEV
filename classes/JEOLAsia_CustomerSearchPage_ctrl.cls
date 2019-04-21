/*
 * Created : 2016/06/22 by Kobayashi (Voxer)
 */
public with sharing class JEOLAsia_CustomerSearchPage_ctrl extends JEOL_SearchBase_ctrl {

    private static final String COOKIE_PATH = '/apex/JEOLAsia_CustomerSearchPage';
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';         // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';             // ページサイズ
    private static final String COOKIE_LABEL_INIT_SEARCH_FLG = 'initSearchFlg';  // 画面起動時検索フラグ

    // 検索項目
    public String name { get; set; }
    public String code { get; set; }
    public String undergraduate { get; set; }
    public String customerCategory { get; set; }
    public String countryCode{get; set;} 
    private List<String> targetAreas;
    
    public String currentCountry {get; set;}
    private Map<String, String> displayCountryMap = new Map<String, String>();

    public List<OptionDetail> AreaOptions{get; set;}

    //国コード
    public List<SelectOption> getCountryOptions(){
        List<SelectOption> options = JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_COUNTRY);
        List<SelectOption> dispOptions = new List<SelectOption>();
        for (SelectOption option: options) {
            String value = option.getValue();
            String label = option.getLabel();
            if (String.isNotBlank(label)) {
                displayCountryMap.put(value, label);
            }
            SelectOption newOption = new SelectOption(value, value);
            newOption.setDisabled(option.getDisabled());
            dispOptions.add(newOption);
        }
        this.changeCountry();
        return dispOptions;
    }

    public void changeCountry() {
        String countryName;
        if (this.displayCountryMap.containsKey(this.countryCode)) {
            countryName = this.displayCountryMap.get(this.countryCode);
        } else {
            countryName = '  ---  ';
        }
        this.currentCountry = countryName;
    }

    // 顧客カテゴリ選択リスト値取得
    public List<SelectOption> getCCategoryOptions() {
        return JEOLUtil.getCategoryNameOptions();
    }
    
    // 画面起動時検索フラグ（'true'の場合に検索する）
    public String initSearchFlg = '';

    /* 検索内容の取得 */
    public List<rowWrapper> getAccount() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;
        
        if (ssc != null) {
            for(Account row: (List<Account>)ssc.getRecords()) {
                rowWrapper wrap = new rowWrapper(row, currentCount);
                rows.add(wrap);
                currentCount++;
            }
        }
  system.debug('rows = ' + rows);        
  
        return rows;
    }
    
    public void areaSelectCancel() {
        List<OptionDetail> areaOptions = this.AreaOptions;
        for (OptionDetail detail: areaOptions) {
            detail.cancel();
        }
    }

    public void areaSelectApply() {
        Set<String> areas = new Set<String>();
        List<OptionDetail> areaOptions = this.AreaOptions;
        for (OptionDetail detail: areaOptions) {
            detail.apply();
            if (detail.isSelected) {
                areas.add(detail.option.getValue());
            }
        }
        targetAreas = new List<String>(areas);
    }

    public void areaSelectAllSelect() {
        List<OptionDetail> areaOptions = this.AreaOptions;
        for (OptionDetail detail: areaOptions) {
            detail.isSelected = true;
        }
    }

    public void areaSelectAllDeselect() {
        List<OptionDetail> areaOptions = this.AreaOptions;
        for (OptionDetail detail: areaOptions) {
            detail.isSelected = false;
        }
    }
    
    public String getSelectedAreas() {
        String value = System.Label.JEOLAsia_ProjectMasterList_Label_None;
        Integer selectedCount = 0;
        Set<String> areas = new Set<String>();
        for (OptionDetail detail: this.AreaOptions) {
            if (detail.isSelected) {
                areas.add(detail.option.getLabel());
                selectedCount++;
            }
        }
        if (selectedCount == this.AreaOptions.size()) {
            value = System.Label.JEOLAsia_ProjectMasterList_Label_All;
        } else if (areas.size() > 0) {
            value = String.join(new List<String>(areas), ', ');
        }
        return value;
    }
    
    /**
    *  検索結果の設定
    */
    public class rowWrapper{
        public Account rec {get; set;}
        public Integer rowNumber {get; set;}
        
        public rowWrapper(Account rec, Integer rowNumber){
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
    }
    
    public class OptionDetail {
        public Boolean isSelected{get; set;}
        public Boolean beforeSelected{get; set;}
        public SelectOption option{get; set;}
        public String val{get; set;}
        public OptionDetail(SelectOption option, Boolean isSelected) {
            this.option = option;
            this.isSelected = isSelected;
            this.beforeSelected = this.isSelected;
        }
        
        public void cancel() {
            this.isSelected = this.beforeSelected;
        }

        public void apply() {
            this.beforeSelected = this.isSelected;
        }
        
        public void setSelected(Boolean isSelected) {
            this.isSelected = isSelected;
            this.beforeSelected = this.isSelected;
        }
    }

    // クリアボタン
    public void doFormClear() {

        // 検索内容のクリア
        this.name = null;
        this.code = null;
        this.customerCategory = null;
        this.undergraduate = null;
        this.countryCode = null;
        this.targetAreas = null;
        for (OptionDetail detail: this.AreaOptions) {
            detail.setSelected(false);
        }
        
        // 検索結果のクリア
        ssc = null;

        //ページ初期化
        pageNo = 1;
        pageSize = 50;

        // 画面起動時検索フラグOFF
        this.initSearchFlg = '';

        // 検索条件のCookie保存
        saveInputValues();
    }

    public JEOLAsia_CustomerSearchPage_ctrl() {
        orderBy= 'Name';
        currentOrder = 'Name';
        orderDesc = false;
        Boolean hasSearchValue = initFieldFromCookie();
        if (hasSearchValue) {
            setStandardSetController();
        }
        List<optionDetail> areaOptions = new List<optionDetail>();
        Set<String> areas;
        if (this.targetAreas != null) {
            areas = new Set<String>(this.targetAreas);
        }
        for (SelectOption option: JEOLUtil.getSelectList(false, JEOLUtil.REFERENCE_NAME_AREA)) {
            Boolean isSelected = false;
            if (areas != null) {
                isSelected = areas.contains(option.getValue());
            }
            areaOptions.add(new OptionDetail(option, isSelected)); 
        }
        this.areaOptions = areaOptions;
    }

    private Boolean initFieldFromCookie() {
        Map<String, Cookie> cookies = Apexpages.currentPage().getCookies();
        Boolean hasSearchValues = false;
        if(cookies.containsKey('name')){
          this.name = cookies.get('name').getValue();
        }
        if(cookies.containsKey('code')){
          this.code = cookies.get('code').getValue();
        }
        if(cookies.containsKey('undergraduate')){
            this.undergraduate = cookies.get('undergraduate').getValue();
        }
        if(cookies.containsKey('customerCategory')){
            this.customerCategory = cookies.get('customerCategory').getValue();
        }
        if(cookies.containsKey('countryCode')){
            this.countryCode = cookies.get('countryCode').getValue();
        }
        if (cookies.containsKey('targetAreas')) {
            String targetAreasText = cookies.get('targetAreas').getValue();
            if (String.isNotBlank(targetAreasText)) {
                this.targetAreas = targetAreasText.split('&&');
            }
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

        cookies.add(new Cookie('name', this.name, null, -1, true));
        cookies.add(new Cookie('code', this.code, null, -1, true));
        cookies.add(new Cookie('undergraduate', this.undergraduate, null, -1, true));
        cookies.add(new Cookie('countryCode', this.countryCode, COOKIE_PATH, -1, true));
        cookies.add(new Cookie('customerCategory', this.customerCategory, COOKIE_PATH, -1, true));
        String targetAreasText = '';
        
        if (this.targetAreas != null && this.targetAreas.size() > 0) {
            targetAreasText = String.join(this.targetAreas, '&&');
        }
        cookies.add(new Cookie('targetAreas', targetAreasText, null, -1, true));
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_NUMBER, String.valueOf(pageNo), COOKIE_PATH, -1, true));  // ページ番号
        cookies.add(new Cookie(COOKIE_LABEL_PAGE_SIZE, String.valueOf(pageSize), COOKIE_PATH, -1, true));  // ページサイズ
        cookies.add(new Cookie(COOKIE_LABEL_INIT_SEARCH_FLG, this.initSearchFlg, COOKIE_PATH, -1, true));  // 画面起動時検索フラグ

        Apexpages.currentPage().setCookies(cookies);
    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {
        String soql = 'select Id, Name, Code__c, Area__c, UndergraduateFormula__c, Address__c, toLabel(CustomerSituation__c), CountryCode__c from Account';

        List<String> whereConditions = new List<String>();
        if (String.isNotBlank(this.name)) {
            whereConditions.add(JEOLUtil.appendLikeText('Name', this.name));
        }
        if (String.isNotBlank(this.code)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('Code__c', this.code));
        }
        if (String.isNotBlank(this.undergraduate)) {
            whereConditions.add(JEOLUtil.appendLikeText('UndergraduateFormula__c', this.undergraduate));
        }
        if (this.targetAreas != null && this.targetAreas.size() > 0) {
             whereConditions.add(JEOLUtil.appendInText('Area__c', this.targetAreas));
        }
        if (String.isNotBlank(this.countryCode)) {
            whereConditions.add(JEOLUtil.appendEqualText('CountryCode__c', this.countryCode));
        }
        if (String.isNotBlank(this.customerCategory)) {
            List<String> accIdList = JEOLUtil.getCategoryJunctionAccountIds(this.customerCategory);
            whereConditions.add(JEOLUtil.appendInText('Id', accIdList));
        }
        
        soql += JEOLUtil.joinWhereConditions(whereConditions);
        soql += ' ORDER BY ' + orderBy;

        if (orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000 ';

        ssc = new ApexPages.StandardSetController (Database.getQueryLocator(soql));
system.debug('soql = ' + soql);        
system.debug('ssc = ' + ssc);        
        
        if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(pageSize);
            ssc.setPageNumber(pageNo);
        }
    }

    public PageReference search1() {
        orderBy= 'Name';
        currentOrder = 'Name';
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