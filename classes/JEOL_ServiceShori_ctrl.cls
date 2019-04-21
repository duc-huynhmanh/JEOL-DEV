public with sharing class JEOL_ServiceShori_ctrl extends JEOL_SearchBase_ctrl {

    // Cookei用定数
    private static final String COOKIE_PATH = '/apex/JEOL_ServiceShoriPage';  // ページのパス
    private static final String COOKIE_LABEL_MAIN_NO = 'mainPartNoMachine';  // 本体号機（検索条件）
    private static final String COOKIE_LABEL_PAGE_NUMBER = 'PageNumber';  // ページ番号
    private static final String COOKIE_LABEL_PAGE_SIZE = 'PageSize';  // ページサイズ

    // 検索条件
    public String mainPartNoMachine { get; set; }

    /**
     * コンストラクタ 
     */
    public JEOL_ServiceShori_ctrl() {
        this.mainPartNoMachine = System.currentPageReference().getParameters().get('mainPartNo');
        if (this.mainPartNoMachine == null || this.mainPartNoMachine.length() == 0) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'本体号機が指定されていません。');
            ApexPages.addMessage(msg);
            return;
        }
        orderBy= 'CustomerCode__c';
        currentOrder = 'CustomerCode__c';
        orderDesc = false;
        setStandardSetController();
    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {
        String mainPartNoMachine = String.escapeSingleQuotes(this.mainPartNoMachine);
        String soql = 'select Id, CustomerCode__c, CustomerName__c, ModelPI__c, ModelNamePI__c, UnitBody__c, ProductNo__c, Name, '+
                        'ReceptionDatetime__c, ServiceStartDate__c, ServiceEndDate__c,'+
                        'ServiceUketuskeNaiyou__c, FaultLocation1__c, FailureCause1__c, ClassificationDeal1__c, FaultLocation2__c,'+
                        'FailureCause2__c, ClassificationDeal2__c, FaultLocation3__c, FailureCause3__c, ClassificationDeal3__c, UketsukeSupportPerson__c, Responce__c'+
                        ' from Support__c where UnitBody__c = :mainPartNoMachine';
        soql += ' order by ' + orderBy;
        if (this.orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000 ';
        ssc = new ApexPages.StandardSetController (Database.getQueryLocator(soql));

        //不正なパラメータ（存在しない本体号機Noを入力した場合）
        if (ssc.getResultSize() == 0 ) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '本体号機が指定されていません。'));
        }
        
        //検索結果が１万件を超えた場合
        if (ssc.getResultSize() >= 10000 ) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。'));
        } else {
            ssc.setPageSize(this.pageSize);
            ssc.setPageNumber(this.pageNo);
        }
    }

    public PageReference prev() {
        return Page.JEOL_ServiceUketsukePage;
    }
    
    /*検索内容の取得*/
    public List<rowWrapper> getCustomerSupportServiceSyoriList() {
        List<rowWrapper> rows = new List<rowWrapper>();
        Integer currentCount = 0;
        
        if(ssc != null) {
            for(Support__c row : (List<Support__c>)ssc.getRecords()) {
                rowWrapper wrap = new rowWrapper(row, currentCount);
                rows.add(wrap);
                currentCount++;
            }
        }
        return rows;
    }
    
    /*検索結果の取得*/
    public class rowWrapper{
        public Support__c rec {get; set;}
        public String ReceptionDatetimeJST {get; set;}  // 受付日時の日本時間変換用
        public Integer rowNumber {get; set;}
        
        public rowWrapper(Support__c rec, Integer rowNumber) {
            this.rec = rec;
            if(rec.ReceptionDatetime__c != null){
                this.ReceptionDatetimeJST = rec.ReceptionDatetime__c.format('yyyy/MM/dd HH:mm:ss','JST');
            }
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