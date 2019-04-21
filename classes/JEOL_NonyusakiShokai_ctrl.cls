public with sharing class JEOL_NonyusakiShokai_ctrl extends JEOL_SearchBase_ctrl{

    // 検索条件
    public UnitBody__c targetRec {get; set;}
    public List<SalesOrder__c> ConservativeInfos{get; set;}
    
    /**
    * コンストラクタ
    */
    public JEOL_NonyusakiShokai_ctrl(Apexpages.Standardcontroller ctrl){
        try {
            
            String targetId = Apexpages.currentPage().getParameters().get('id');
            UnitBody__c targetRec = getTargetRecord(targetId);
            this.targetRec = targetRec;
            conservativeInfos = getConservativeInfos();
        } catch(Exception e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, '不正な操作がありました。');
            ApexPages.addMessage(msg);
        }
    }
    
    public List<SalesOrder__c> getConservativeInfos() {
        String unitBody = this.targetRec.UnitBody__c;
        
        List<SalesOrder__c> children;
        if (String.isNotBlank(unitBody)) {
            String recordTypeId;
            for (RecordType rec: [select Id from RecordType where SobjectType = 'SalesOrder__c' and developerName = 'HosyuKeiyaku']) {
                recordTypeId = rec.id;
            }
            children = [SELECT id, FlagshipProduct__c, Name, ProductNumber__c, MaintenanceType__c
                        FROM SalesOrder__c
                        WHERE UnitBody__c = : unitBody
                        AND RecordTypeId =: recordTypeId
                        AND MaintenanceStartDateFormula__c <= TODAY
                        AND MaintenanceEndDateFormula__c >= TODAY
                        ORDER BY MaintenanceType__c ASC , MaintenanceStartDateFormula__c DESC
                        LIMIT 3];
        }
        if (children == null) {
            children = new List<SalesOrder__c>();
        }
        while (children.size() < 3) {
            children.add(new SalesOrder__c());
        }
        return children;
    }

    /**
    * メイン情報取得
    */
    private UnitBody__c getTargetRecord(String targetId) {
        UnitBody__c targetRec;
        List<UnitBody__c> recs = [
                SELECT
                    Id,
                    Name,
                    SerialNo__c,
                    UnitBody__c,
                    ItemLink__c,
                    ItemLink__r.JapaneseName__c,
                    ItemLink__r.EnglishName__c,
                    ModelAbbreviation__c,
                    Series__c,
                    ShippingDateFormula__c,
                    AcceptanceDateFormula__c,
                    StatusOfUse__c,
                    DeliveryAccount__r.Code__c,
                    DeliveryAccount__r.Name,
                    SalesAccount__r.Code__c,
                    SalesAccount__r.Name,
                    DeliveryAccount__r.ServiceArea__c,
                    DeliveryAccount__r.Country__c,
                    DeliveryAccount__r.DispatchTime__c,
                    DeliveryAccount__r.DistanceSection__c,
                    DeliveryAccount__r.PostalCode__c,
                    DeliveryAccount__r.Address__c,
                    SpecialContractNote__c,
                    SvcForm__c,
                    EfProductNo__c,
                    EFEndDateFormula__c,
                    Contact1__r.TantoshaCode__c,
                    Contact1__r.Name,
                    Contact1__r.HeadquartersSection__c,
                    Contact1__r.Affiliation__c,
                    Contact1__r.Phone,
                    Contact1__r.Extension__c,
                    Contact1__r.MobilePhone,
                    Contact1__r.Fax,
                    Contact1__r.Email,
                    Contact1__r.DM__c,
                    Contact2__r.TantoshaCode__c,
                    Contact2__r.Name,
                    Contact2__r.HeadquartersSection__c,
                    Contact2__r.Affiliation__c,
                    Contact2__r.Phone,
                    Contact2__r.Extension__c,
                    Contact2__r.MobilePhone,
                    Contact2__r.Fax,
                    Contact2__r.Email,
                    Contact2__r.DM__c,
                    DeliveryAccount__r.State__c,
                    (select id, name from SalesOrder__r)
                FROM
                    UnitBody__c
                WHERE
                    Id =: targetId
        ];
        for (UnitBody__c rec: recs) {
            targetRec = rec;
        }
        
        return targetRec;
    }

    public List<PartsItem> getPartsItems() {
        List<Component__c> partsItems;
        String parentId = this.targetRec.id;
        partsItems = [
            SELECT
                id,
                ItemLink__r.Name,
                ItemLink__r.JapaneseName__c,
                ItemLink__r.Model__c,
                ModelAbbreviation__c,
                SerialNo__c ,
                ShippingDateFormula__c,
                AcceptanceDateFormula__c
            FROM
                Component__c 
            WHERE
                UnitBody__c =: parentId
            ORDER BY
                SerialNo__c
        ];
        if (partsItems == null) {
            partsItems = new List<Component__c>(); 
        }
        List<PartsItem> items = new List<PartsItem>();
        for (Component__c rec: partsItems) {
            items.add(new PartsItem(rec));
        }
        return items;
    }
    
    public class PartsItem {
        public Component__c rec{get; set;}
        
        public PartsItem(Component__c rec) {
            this.rec = rec;
        }
        
        public String getModelText() {
            String ret;
            if (this.rec != null && this.rec.ItemLink__r != null) {
                String modelName = this.rec.ItemLink__r.Name;
                if (String.isNotBlank(ModelName) && (modelName == 'K999999' || modelName.startsWith('ZZ'))) {
                    ret = this.rec.ModelAbbreviation__c;
                } else {
                    ret = this.rec.ItemLink__r.Model__c;
                }
            }
            return ret;
        }
    }
}