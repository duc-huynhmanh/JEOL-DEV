public with sharing class JEOL_UriageShokaiList_ctrl  extends JEOL_SearchBase_ctrl {

    //検索条件
    public String kigyoTani {get; set;}
    public String bumon {get; set;}
    public String keiretsu {get; set;}
    public String nendo {get; set;}

    public String hanbaisakiCode {get; set;}
    public String hanbaisakiName {get; set;}
    public String shukkasakiCode {get; set;}
    public String shukkasakiName {get; set;}
    public String seikyusakiCode {get; set;}
    public String seikyusakiName {get; set;}
    public String customerCategory {get; set;}

    public JEOL_UriageShokaiList_ctrl () {

        //検索条件の設定
        this.kigyoTani = System.currentPageReference().getParameters().get('kigyoTani');
        this.bumon = System.currentPageReference().getParameters().get('bumon');
        this.keiretsu = System.currentPageReference().getParameters().get('keiretsu');
        this.nendo = System.currentPageReference().getParameters().get('nendo');
        this.hanbaisakiCode = System.currentPageReference().getParameters().get('hanbaisakiCode');
        this.hanbaisakiName = System.currentPageReference().getParameters().get('hanbaisakiName');
        this.shukkasakiCode = System.currentPageReference().getParameters().get('shukkasakiCode');
        this.shukkasakiName = System.currentPageReference().getParameters().get('shukkasakiName');
        this.seikyusakiCode = System.currentPageReference().getParameters().get('seikyusakiCode');
        this.seikyusakiName = System.currentPageReference().getParameters().get('seikyusakiName');
        this.customerCategory = System.currentPageReference().getParameters().get('customerCategory');

        //表示順の設定（現在は仮で設定）
        orderBy = 'kigyoTani__c, uriagenendo__c DESC, SalesYM__c DESC, SalesDateFormula__c DESC, bumon__c, keiretsu__c';
        currentOrder = orderBy;
        pageSize = 50;
        orderDesc = false;
        setStandardSetController();
    }

    /**
     *  StandardSetController設定
     */
    protected override void setStandardSetController() {

        //soqlの作成（クエリパラメタでは１つの条件しか指定させない前提）
        String soql = 'SELECT ' +
                            'Id, ' +
                            'name, ' +
                            'kigyoTani__c, ' +
                            'kokunaigai__c, ' +
                            'uriagenendo__c, ' +
                            'bumon__c, ' +
                            'keiretsu__c, ' +
                            'Area__c, ' +
                            'SalesOrder__r.Name, ' +
                            'JishaTasha__c, ' +
                            'Element__c, ' +
                            'koban__c, ' +
                            'hanbaisaki__c, ' +
                            'hanbaisaki__r.Code__c, ' +
                            'hanbaisaki__r.Name, ' +
                            'shukkasaki__c, ' +
                            'shukkasaki__r.Code__c, ' +
                            'shukkasaki__r.Name, ' +
                            'seikyusaki__c, ' +
                            'seikyusaki__r.Code__c, ' +
                            'seikyusaki__r.Name ' +
                        'FROM ' +
                            'SalesResult__c ';

        List<String> whereConditions = new List<String>();
        //企業単位のSOQL
        if (String.isNotBlank(this.kigyoTani)) {
            whereConditions.add(JEOLUtil.appendEqualText('kigyoTani__c', this.kigyoTani));
            
         //部門のSOQL
        } else if (String.isNotBlank(this.bumon)) {
            whereConditions.add(JEOLUtil.appendEqualText('bumon__c', this.bumon));

        //系列のSOQL
        } else if (String.isNotBlank(this.keiretsu)) {
            whereConditions.add(JEOLUtil.appendEqualText('keiretsu__c', this.keiretsu));
        
        //年度のSOQL
        } else if (String.isNotBlank(this.nendo)) {
            whereConditions.add(JEOLUtil.appendEqualText('uriagenendo__c', this.nendo));
        }

        
        //販売先コード
        if (String.isNotBlank(this.hanbaisakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('hanbaisaki__r.Code__c', this.hanbaisakiCode));
        }
        //販売先名称
        if (String.isNotBlank(this.hanbaisakiName)) {
            whereConditions.add(JEOLUtil.appendLikeText('hanbaisaki__r.Name', this.hanbaisakiName));
        }
        //出荷先コード 
        if (String.isNotBlank(this.shukkasakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('shukkasaki__r.Code__c', this.shukkasakiCode));
        }
        //出荷先名称 
        if (String.isNotBlank(this.shukkasakiName)) {
            whereConditions.add(JEOLUtil.appendLikeText('shukkasaki__r.Name', this.shukkasakiName));
        }
        //請求先コード 
        if (String.isNotBlank(this.seikyusakiCode)) {
            whereConditions.add(JEOLUtil.appendAfterLikeText('seikyusaki__r.Code__c', this.seikyusakiCode));
        }
        //請求先名称 
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

        // where句以降をSOQLに付加
        soql += JEOLUtil.joinWhereConditions(whereConditions);
        //表示順の指定（現在は仮で設定）
        soql += ' ORDER BY ' + orderBy;
        if (this.orderDesc) {
            soql += ' DESC NULLS LAST';
        }
        
        soql += ' LIMIT 10000';
        
        List<SalesResult__c> recs = Database.query(soql);
        ssc = new ApexPages.StandardSetController (recs);

        if (ssc.getResultSize() >= 10000) {
            ssc = null;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, '検索結果が１万件を超えました。検索条件を増やし、再度検索してください。'));
        } else {
            ssc.setPageSize(this.pageSize);
            ssc.setPageNumber(this.pageNo);
        }
        recs = null;
    }

    /**
     *  検索結果をラップクラスに包んで取得する
     **/
    public List<rowWrapper> getSalesResult() {
        List<RowWrapper> rowWrappers = new List<RowWrapper>();
        Integer currentCount = 0;
        
        if(ssc != null) {
            for (SalesResult__c rec: (List<SalesResult__c>)ssc.getRecords()) {
                RowWrapper wrap = new RowWrapper(rec, currentCount);
                rowWrappers.add(wrap);
                currentCount++;
            }
        }
        return rowWrappers;
    }
    
    /** 
     *  行番表示用のラップクラス
     **/
    public class RowWrapper {
        public SalesResult__c rec {get; set;}
        public Integer rowNumber {get; set;}
        
        public rowWrapper(SalesResult__c rec, Integer rowNumber) {
            this.rec = rec;
            this.rowNumber = rowNumber;
        }
        
        public PageReference getUrl() {
            PageReference ref = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + this.rec.id);
            ref.setRedirect(true);
            
            return ref;
        }
    }
}