/*
 * Created : 2016/06/13 by Kobayashi (Voxer)
 * ==================================================
 * Change : 2016/07/19 by Weijian Zhu (Voxer)
 * Detail : change AsiaQuotationDetail__c(sObj)
 *          to AsiaProfitCalculationDetail__c(sObj)
 * ==================================================
 */
public with sharing class JEOLAsia_QuotationSpecificationCtrl {

    public static final String PARAM_ID = 'id';
    public static final String PARAM_QUOTATION_ID = 'pcid';
    public static final String NEW_URL = 'retURL';
    public static final String NEW_SAVE_NEW = 'save_new';
    private static final String ERROR_MSG1 = 'This record has been modified by ';
    private static final String ERROR_MSG2 = '. Please reload the data before making again your modifications.';
    public Boolean isValid{get; set;} // 有効フラグ
    public Boolean isRecord{get; set;} // レコード有無フラグ
    public String paramId{get; set;} // パラメータ
    public String asiaQuotationName{get; set;} // AsiaQuotation__r.Name
    public String salesCurrency{get; set;} // SalesCurrency__c
    public List<AsiaQuotationDescription__c> categoryA{get; set;} //AsiaQuotationDescription(category='A')オブジェクト
    public List<AsiaQuotationDescription__c> categoryB{get; set;} //AsiaQuotationDescription(category='B')オブジェクト
    public List<AsiaQuotationDescription__c> categoryG{get; set;} //AsiaQuotationDescription(category='G')オブジェクト
    public List<AsiaQuotationDescription__c> baseCategoryA{get; set;} //AsiaQuotationDescription(category='A')比較用オブジェクト
    public List<AsiaQuotationDescription__c> baseCategoryB{get; set;} //AsiaQuotationDescription(category='B')比較用オブジェクト
    public List<AsiaQuotationDescription__c> baseCategoryG{get; set;} //AsiaQuotationDescription(category='G')比較用オブジェクト

    public List<AsiaProfitCalculationDetail__c> detail_categoryA{get; set;} //AsiaProfitCalculationDetail__c(category='A')オブジェクト
    public List<AsiaProfitCalculationDetail__c> detail_categoryB{get; set;} //AsiaProfitCalculationDetail__c(category='B')オブジェクト
    public List<AsiaProfitCalculationDetail__c> detail_categoryG{get; set;} //AsiaProfitCalculationDetail__c(category='G')オブジェクト

    // コンストラクタ
    public JEOLAsia_QuotationSpecificationCtrl(ApexPages.StandardController controller) {

        try {
            this.isValid = false;
            this.isRecord = false;
            // When new
            List<AsiaQuotationDescription__c> emptyQuotDescription = new List<AsiaQuotationDescription__c>();
            List<AsiaProfitCalculationDetail__c> emptyPC = new List<AsiaProfitCalculationDetail__c>();

            // パラメータ取得
            Map<String, String> params = Apexpages.currentPage().getParameters();
            if (params.containsKey(PARAM_ID)) {
                // パラメータID(AsiaQuotationDescription__c.Id)が存在する場合
                // ⇒AsiaQuotation__c.Idを取得し、quotidに設定
                this.paramId = getQuotationId(params.get(PARAM_ID));

                Apexpages.currentPage().getParameters().put(PARAM_QUOTATION_ID, this.paramId);
                params = Apexpages.currentPage().getParameters();
            }

            if (params.containsKey(PARAM_QUOTATION_ID)) {
                // パラメータID(⇒AsiaQuotation__c.Id)が存在する場合
                this.paramId = params.get(PARAM_QUOTATION_ID);

                // レコード取得
                getTargetRecords(this.paramId);

                if ((this.categoryA.size() + this.categoryB.size() + this.categoryG.size()) > 0) {
                    // いずれかのカテゴリにレコードが1件以上存在する場合
                    // クローンを生成

                    this.baseCategoryA =  this.categoryA.clone();
                    this.baseCategoryB =  this.categoryB.clone();
                    this.baseCategoryG =  this.categoryG.clone();

                    this.isValid = true;
                    this.isRecord = true;

                } else {
                    // レコードが存在しない場合
                    // ⇒不正ではないが、入力不可
                    this.isValid = true;
                    this.isRecord = false;
                }
            } else {
                // パラメータが存在しない場合

                // When new
                if(params.containsKey(NEW_URL) && params.containsKey(NEW_SAVE_NEW)){
                    categoryA = baseCategoryA = emptyQuotDescription;
                    categoryB = baseCategoryB = emptyQuotDescription;
                    categoryG = baseCategoryG = emptyQuotDescription;
                    detail_categoryA = emptyPC;
                    detail_categoryB = emptyPC;
                    detail_categoryG = emptyPC;
                    this.isValid = true;
                    this.isRecord = true;
                }else{
                    // ⇒不正
                    this.isValid = false;
                    this.isRecord = false;
                }
            }

        } catch (JEOLException e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
System.debug('@@@:' + e.getStackTraceString());
            return;
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, 'An unexpected error occured.'));
            return;
        }
    }

    public Integer getCategoryASize () {
        return this.categoryA.size();
    }
    public Integer getCategoryBSize () {
        return this.categoryB.size();
    }
    public Integer getCategoryGSize () {
        return this.categoryG.size();
    }

    /**
     * [getTargetRecords: AsiaQuotationDescription__cより、レコード取得]
     * @param parentId [AsiaProfitCalculation__c(OBJ).Id]
     */
    private void getTargetRecords(String parentId) {
System.debug('getTargetRecords');
        List<sobject> quotDetailRecs = getQuotDetail(parentId);
        List<AsiaQuotationDescription__c> desRecs = new List<AsiaQuotationDescription__c>();
        AsiaQuotationDescription__c desRec = new AsiaQuotationDescription__c();
        AsiaProfitCalculationDetail__c rec = new AsiaProfitCalculationDetail__c();

        this.categoryA = new List<AsiaQuotationDescription__c>();
        this.categoryB = new List<AsiaQuotationDescription__c>();
        this.categoryG = new List<AsiaQuotationDescription__c>();

        this.detail_categoryA = new List<AsiaProfitCalculationDetail__c>();
        this.detail_categoryB = new List<AsiaProfitCalculationDetail__c>();
        this.detail_categoryG = new List<AsiaProfitCalculationDetail__c>();

        // AsiaProductItemSpecification__cのMapを取得
        Map<String, String> specificationMap = JEOLAsia_QuotationSpecificationCtrl.getItemSpecification();

        for (sobject osbj: quotDetailRecs) {

            rec = (AsiaProfitCalculationDetail__c) osbj;

            // AsiaProfitCalculationDetail__c から AsiaQuotationDescription__cを取得
            desRecs = rec.getSObjects('QuotationSpecifications__r');
            if (rec.Category__c == 'A') {
                // カテゴリA
                if (desRecs == NULL) {
                    // 新規作成
                    // ⇒Default Value Set
                    desRec = new AsiaQuotationDescription__c();
                    desRec.ProfitCalculationDetail__c = rec.Id;
                    desRec.ProductSpecification__c = specificationMap.get(rec.ModelType__c);
                    this.categoryA.add(desRec);
                } else {
                    this.categoryA.add(desRecs[0]);
                }
                this.detail_categoryA.add(rec);

            } else if (rec.Category__c == 'B') {
                // カテゴリB
                if (desRecs == NULL) {
                    // 新規作成
                    // ⇒Default Value Set
                    desRec = new AsiaQuotationDescription__c();
                    desRec.ProfitCalculationDetail__c = rec.Id;
                    desRec.ProductSpecification__c = specificationMap.get(rec.ModelType__c);
                    this.categoryB.add(desRec);
                } else {
                    this.categoryB.add(desRecs[0]);
                }
                this.detail_categoryB.add(rec);

            } else if (rec.Category__c == 'G') {
                // カテゴリG
                if (desRecs == NULL) {
                    // 新規作成
                    // ⇒Default Value Set
                    desRec = new AsiaQuotationDescription__c();
                    desRec.ProfitCalculationDetail__c = rec.Id;
                    desRec.ProductSpecification__c = specificationMap.get(rec.ModelType__c);
                    this.categoryG.add(desRec);
                } else {
                    this.categoryG.add(desRecs[0]);
                }
                this.detail_categoryG.add(rec);
            }
        }

    }

    /**
     * [getQuotDetail: List<AsiaQuotationDetail__c>より、カテゴリ'A'、'B'、'G'かつType'1'のレコード取得]
     * @param  targetId [AsiaProfitCalculation__c(OBJ).Id]
     * @return recs　    [AsiaProfitCalculationDetail__c(OBJ) のレコードリスト]
     */
    private List<sobject> getQuotDetail(String targetId) {
        
        List<String> categories = new List<String>();
        categories.add('A');
        categories.add('B');
        categories.add('G');

        List<AsiaProfitCalculationDetail__c> recs = JEOLAsia_QuotationSpecificationCtrl.getProfitCalculationDetails(targetId, categories);
        if (recs != null && recs.size() > 0) {
            // データあり
            this.asiaQuotationName = recs.get(0).Parent__r.Name;
            this.salesCurrency = recs.get(0).Parent__r.SalesCurrency__c;
        }

        return recs;
    }

    /**
     * [getProfitCalculationDetails: List<AsiaProfitCalculationDetail__c>より、指定カテゴリを含む、かつ、Type'1'のレコード取得]
     * - JEOLAsia_QuotationPrintPageCtrlからも呼び出すのでpublic static
     * @param  targetId   [AsiaProfitCalculation__c(OBJ).Id]
     * @param  categories [List<String>の検索対象カテゴリーリスト]
     * @return recs　     [AsiaProfitCalculationDetail__c(OBJ) のレコードリスト]
     */
    public static List<AsiaProfitCalculationDetail__c> getProfitCalculationDetails(String targetId, List<String> categories) {

        List<AsiaProfitCalculationDetail__c> recs =
        [
            SELECT
                Name,
                LastModifiedDate,
                Parent__c,
                Depth__c,
                Type__c,
                Quantity__c,
                QuantityUnit__c,
                Description__c,
                Body__c,
                SalesPrice__c,
                SalesPriceFormula__c,
                SalesUnitPrice__c,
                ParentDetail__c,
                Category__c,
                SortNo__c,
                ProfitCalcNo_BranchNo_SEQ_Sync__c,
                ModelType__c,
                Parent__r.Name,
                Parent__r.SalesCurrency__c,
                (
                    SELECT
                        Id,
                        Name,
                        LastModifiedDate,
                        PCDAmount__c,
                        PCDItemName__c,
                        PCDQuantity__c,
                        ProfitCalculationDetail__c,
                        ProductSpecification__c,
                        ProfitCalculationDetail__r.Category__c,
                        ProfitCalculationDetail__r.Parent__r.SalesCurrency__c
                    FROM QuotationSpecifications__r
                )
            FROM AsiaProfitCalculationDetail__c
            WHERE Parent__c =: targetId
            AND (Category__c IN :categories)
            AND Type__c = '1'
            ORDER BY SortNo__c ASC
        ];

        return recs;
    }

    /**
     * [getQuotationId: AsiaQuotationDescription__cより、レコード取得]
     * @param  targetId [AsiaQuotationDescription__c(OBJ).Id]
     * @return parentId [AsiaProfitCalculation__c(OBJ).Id]
     */
    private String getQuotationId(String targetId) {

        String parentId = null;

        AsiaQuotationDescription__c targetaRecord = null;

        List<AsiaQuotationDescription__c> recs =
        [
            SELECT
                Id,
                Name,
                LastModifiedDate,
                ProfitCalculationDetail__r.Parent__r.Id
            FROM AsiaQuotationDescription__c
            WHERE Id =: targetId
        ];

        if (recs != null && recs.size() > 0) {
            // データあり
            // ⇒AsiaQuotation__c.Idを取得
            targetaRecord = recs.get(0);
            parentId = targetaRecord.ProfitCalculationDetail__r.Parent__r.Id;
        }
        return parentId;
    }

    /**
     * [getItemSpecification: AsiaProductItemSpecification__cより、全レコード取得し、Mapに格納する]
     * - JEOLAsia_QuotationPrintPageCtrlからも呼び出すのでpublic static
     * @return [specificationMap]
     */
    public static Map<String, String> getItemSpecification() {

        Map<String, String> specificationMap = new Map<String, String>();

        List<AsiaProductItemSpecification__c> recs =
        [
            SELECT
                Id,
                Name,
                LastModifiedDate,
                ModelType__c,
                Specification__c
            FROM AsiaProductItemSpecification__c
        ];

        if (recs != null && recs.size() > 0) {
            // データあり
            for(AsiaProductItemSpecification__c rec : recs){
                specificationMap.put(rec.ModelType__c, rec.Specification__c);
            }
        }

        return specificationMap;
    }

    // save Button
    public Pagereference saveActionxxe() {

System.debug(LoggingLevel.Info, 'Start of saveAction');

        Pagereference ref = null;
        Savepoint sp = Database.setSavepoint();

        try {
            // 最終更新日チェック
            checkLastModified(this.categoryA, this.categoryB, this.categoryG);

            upsert this.categoryA;
            upsert this.categoryB;
            upsert this.categoryG;
            ref = Page.JEOLAsia_QuotationSpecificationPage;
            ref.getParameters().put(PARAM_QUOTATION_ID, this.paramId);
            ref.setRedirect(true);

        } catch(Exception e) {
            String message = e.getMessage();
System.debug('Error in saveAction: ' + message);

            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
            Database.rollback(sp);
            return null;
        }

        return ref;
    }

    // 最終更新日チェック
    private void checkLastModified(List<AsiaQuotationDescription__c> categorysA, List<AsiaQuotationDescription__c> categorysB, List<AsiaQuotationDescription__c> categorysG) {
System.debug('Start of checkLastModified');

        Map<id, Datetime> mpID = new Map<id, Datetime>();

        for (AsiaQuotationDescription__c category: categorysA) {
            if (category.Id != null) {
                mpID.put(category.Id, category.LastModifiedDate);
            }
        }
        for (AsiaQuotationDescription__c category: categorysB) {
            if (category.Id != null) {
                mpID.put(category.Id, category.LastModifiedDate);
            }
        }
        for (AsiaQuotationDescription__c category: categorysG) {
            if (category.Id != null) {
                mpID.put(category.Id, category.LastModifiedDate);
            }
        }

        List<AsiaQuotationDescription__c> refreshedRec = [SELECT Id, Name, LastModifiedDate, LastModifiedBy.Name
                                                          FROM AsiaQuotationDescription__c
                                                          WHERE Id in :mpID.keySet()
                                                         ];

        for (AsiaQuotationDescription__c ref : refreshedRec) {
            if (ref.LastModifiedDate != mpID.get(ref.Id))
            // 最終更新日に相違有
            throw new JEOLException(ERROR_MSG1 + ref.LastModifiedBy.Name + ' at ' + ref.LastModifiedDate.format() + ERROR_MSG2);
        }
System.debug('End of checkLastModified');
    }
}