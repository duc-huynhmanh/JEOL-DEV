/*
 * Created : 2016/06/16 by Kobayashi (Voxer)
 */
public with sharing class JEOLAsia_QuotationTermsConditionsCtrl{

    public static final String PARAM_ID = 'id';
    public static final String PARAM_QUOTATION_ID = 'pcid';

    public Boolean isValid{get; set;} // 有効フラグ
    public String paramQuotId{get; set;} // パラメータ
    public AsiaQuotationTermsConditions__c rec{get; set;} //AsiaQuotationTermsConditionsオブジェクト
    public AsiaQuotationTermsConditions__c baseRec{get; set;} //比較用オブジェクト
    public AsiaProfitCalculation__c quot{get; set;}

    // コンストラクタ
    public JEOLAsia_QuotationTermsConditionsCtrl(ApexPages.StandardController controller) {

  	    try {
            this.isValid = false;

            // パラメータ取得
            Map<String, String> params = Apexpages.currentPage().getParameters();
System.debug('コンストラクタ:params = ' + params);

            if (params.containsKey(PARAM_QUOTATION_ID)) {
                // レコード取得

                this.paramQuotId = params.get(PARAM_QUOTATION_ID);
                this.quot = getQuotation(this.paramQuotId);

                if (this.quot == NULL) {
                	// AsiaProfitCalculation__c がない場合
                    // ⇒不正
                    this.isValid = false;
System.debug('コンストラクタ:AsiaProfitCalculation__c.Idがパラメータ、AsiaProfitCalculation__cレコードなし、エラー');

                } else {
                	// AsiaProfitCalculation__c がある場合
                    // ⇒正常
                    this.rec = getTargetRecord(this.paramQuotId, true);

                    if (this.rec == NULL) {
                   	    // AsiaQuotationTermsConditionsがない場合
                        // ⇒レコード新規作成
                        this.rec = createNewRecord(this.paramQuotId);
                        this.isValid = true;
System.debug('コンストラクタ:AsiaProfitCalculation__c.Idがパラメータ、AsiaQuotationTermsConditions__cレコードなし、新規作成');

                    } else {
                   	    // AsiaQuotationTermsConditionsがある場合
                        // ⇒取得したレコードのクローンを作成
                        this.baseRec =  this.rec.clone(true);
                        this.isValid = true;
System.debug('コンストラクタ:AsiaProfitCalculation__c.Idがパラメータ、AsiaQuotationTermsConditions__cレコードあり、レコード取得');
                    }
                }

            } else if (params.containsKey(PARAM_ID)) {
                // パラメータID(AsiaQuotationTermsConditions.Id)が存在する場合
                // レコード取得
                this.rec = getTargetRecord(params.get(PARAM_ID), false);

                if (this.rec == NULL) {
                	// AsiaQuotationTermsConditionsがない場合
                    // ⇒不正
                    this.isValid = false;
System.debug('コンストラクタ:AsiaQuotationTermsConditions__c.Idがパラメータ、レコードなし、エラー');

                } else {
                	// AsiaQuotationTermsConditionsがある場合
                	// ⇒AsiaProfitCalculation__c取得
                    //this.paramQuotId = this.rec.ProfitCalculation__r.Id;
                    this.paramQuotId = this.rec.ProfitCalculation__r.Id;
                    this.quot = getQuotation(this.paramQuotId);

                    // 取得したレコードのクローンを作成
                    this.baseRec =  this.rec.clone(true);
                    this.isValid = true;
System.debug('コンストラクタ:AsiaQuotationTermsConditions__c.Idがパラメータ、レコードあり、レコード取得');
                }
            } else {
                // パラメータが存在しない場合
                // ⇒不正
                this.isValid = false;

System.debug('コンストラクタ:パラメータなし');
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

    public String getValidityPeriod() {

        String sReturn = '';

        if (quot.QuoteExpirationDate__c != NULL) {

            sReturn += 'This quotation stands valid until ' + Datetime.newInstance(quot.QuoteExpirationDate__c.year(), quot.QuoteExpirationDate__c.month(), quot.QuoteExpirationDate__c.day()).format('MM/dd/yyyy') + '.';

        } else if (quot.QuoteValidityPeriodDays__c != NULL && quot.QuoteValidityPeriodDays__c > 0) {

            sReturn += 'This quotation stands valid for ' + quot.QuoteValidityPeriodDays__c + ' day' + (quot.QuoteValidityPeriodDays__c > 1 ? 's' : '') + '.';

        } else if (quot.QuoteValidityPeriod__c != NULL) {

            sReturn += 'This quotation stands valid for ' + quot.QuoteValidityPeriod__c + ' month' + (quot.QuoteValidityPeriod__c > 1 ? 's' : '') + '.';

        }

        return sReturn;

    }


    // AsiaQuotationTermsConditions__cより、レコード取得
    private AsiaQuotationTermsConditions__c getTargetRecord(String targetId, boolean isQuotationId) {

        AsiaQuotationTermsConditions__c targetaRecord = null;
        List<AsiaQuotationTermsConditions__c> recs = new List<AsiaQuotationTermsConditions__c>();
system.debug('getTargetRecord:targetId = ' + targetId);
system.debug('getTargetRecord:isQuotationId = ' + isQuotationId);

        if (isQuotationId) {
        	// AsiaProfitCalculation__c.Idがキー

            recs = [
                SELECT
                    id, name, LastModifiedDate, ProfitCalculation__c, ProfitCalculation__r.Name, ProfitCalculation__r.DeliveryDate_Arbitrarily__c,
                    ProfitCalculation__r.DeliveryDeadline__c, Warranty__c, Installation__c,
                    Packing__c, Training__c, Export__c, Validity__c, Price__c, Remarks__c, Manufacturer__c, BankDetail__c
                FROM
                    AsiaQuotationTermsConditions__c
                WHERE
                    ProfitCalculation__c =: targetId
            ];
system.debug('getTargetRecord:recs1 = ' + recs);

       	} else {
        	// AsiaQuotationTermsConditions__c.Idがキー

            recs = [
                SELECT
                    id, name, LastModifiedDate, ProfitCalculation__c, ProfitCalculation__r.Name, ProfitCalculation__r.DeliveryDate_Arbitrarily__c,
                    ProfitCalculation__r.DeliveryDeadline__c, Warranty__c, Installation__c,
                    Packing__c, Training__c, Export__c, Validity__c,  Price__c, Remarks__c, Manufacturer__c, BankDetail__c
                FROM
                    AsiaQuotationTermsConditions__c
                WHERE
                    Id =: targetId
            ];
system.debug('getTargetRecord:recs2 = ' + recs);
       	}

        if (recs != null && recs.size() > 0) {
            // データあり
            targetaRecord = recs.get(0);
        } else {
            // データなし
            targetaRecord = null;
        }

system.debug('getTargetRecord:end');
        return targetaRecord;
    }

    // AsiaProfitCalculation__c より、レコード取得
    private AsiaProfitCalculation__c getQuotation(String targetId) {

        AsiaProfitCalculation__c targetaRecord = null;

        List<AsiaProfitCalculation__c> recs = [
            SELECT
                Id, Name, RecordType.DeveloperName, LastModifiedDate, DeliveryDate_Arbitrarily__c, DeliveryDeadline__c, PaymentConditionSection__c, QuoteExpirationDate__c, QuoteValidityPeriod__c, QuoteValidityPeriodDays__c
            FROM
                AsiaProfitCalculation__c
            WHERE
                Id =: targetId
        ];

        if (recs != null && recs.size() > 0) {
            // データあり
            targetaRecord = recs.get(0);
        } else {
            // データなし
            targetaRecord = null;
        }
        return targetaRecord;
    }

    // 新規レコード作成
    private AsiaQuotationTermsConditions__c createNewRecord(String targetId) {

        AsiaQuotationTermsConditions__c newRecord = new AsiaQuotationTermsConditions__c();
        newRecord.ProfitCalculation__c = targetId;

system.debug('createNewRecord:newRecord = ' + newRecord);
        return newRecord;
    }

    // save Button
    public Pagereference saveAction() {
system.debug('saveAction:start');

        Pagereference ref = null;
        Savepoint sp = Database.setSavepoint();

        try {

system.debug('saveAction:rec = ' + rec);

            if (rec.Id != null) {
                // AsiaQuotationTermsConditions__cにデータあり

                AsiaQuotationTermsConditions__c refreshedRec =
                    [SELECT
                        Id, Name, LastModifiedDate, LastModifiedBy.Name
                    FROM
                        AsiaQuotationTermsConditions__c
                    WHERE
                        Id =: rec.Id];
system.debug('saveAction:refreshedRec = ' + refreshedRec);

                if(rec.LastModifiedDate != refreshedRec.LastModifiedDate)
                    // 最終更新日に相違有

                    throw new JEOLException('This record has been modified by ' + refreshedRec.LastModifiedBy.Name + ' at ' + refreshedRec.LastModifiedDate.format() + '. Please reload the data before making again your modifications.');
            }

            // AsiaQuotationTermsConditions__c更新
            upsert rec;
system.debug('saveAction(save後):rec = ' + rec);

            ref = Page.JEOLAsia_QuotationTermsConditionsPage;
            ref.getParameters().put(PARAM_QUOTATION_ID, this.paramQuotId);
            ref.setRedirect(true);

        } catch(Exception e) {
            String message = e.getMessage();

            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, message));
system.debug('saveAction:LastModifiedDate = ' + rec.LastModifiedDate);
            Database.rollback(sp);
system.debug('saveAction:LastModifiedDate2 = ' + rec.LastModifiedDate);
            return null;
        }

system.debug('saveAction:end');
        return ref;
    }
}