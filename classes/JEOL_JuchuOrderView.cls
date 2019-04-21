public with sharing class JEOL_JuchuOrderView {
    
    public Boolean hasError{get; set;}
    public ViewWrapper target{get; set;}
    private static final String SOBJECT_KEYPREFIX_SALES = SalesOrder__c.SobjectType.getDescribe().getKeyPrefix();
    private static final String SOBJECT_KEYPREFIX_SERVICE = ServiceOrder__c.SobjectType.getDescribe().getKeyPrefix();

    public JEOL_JuchuOrderView() {
        try {
            String targetId = ApexPages.currentPage().getParameters().get('Id');
            if (targetId == null) {
                throw new JEOLException('');
            }
            
            Sobject targetRec = getRecord(targetId);
            
            if (targetRec == null) {
                throw new JEOLException('');
            }
            
            this.target = new ViewWrapper(targetRec);
            this.hasError = false;
        } catch(Exception e) {
            this.hasError = true;
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL, e.getMessage()));
        }
    }
    
    private Sobject getRecord(String targetId) {
        String soql;
        if (targetId.startsWith(SOBJECT_KEYPREFIX_SALES)) {
            soql = getSalesOrderQueryStr(targetId);
        }
        if (targetId.startsWith(SOBJECT_KEYPREFIX_SERVICE)) {
            soql = getServiceOrderQueryStr(targetId);
        }
        SObject targetRec = null;
        if (String.isNotBlank(soql)) {
            List<SObject> targetRecs = Database.query(soql);
            for (SObject rec: targetRecs) {
                targetRec = rec;
                break;
            }
        }
        return targetRec;
    }
    
    
    private String getSalesOrderQueryStr(String targetId) {

        String str = ' SELECT ' + 
                        ' Id ' +
                        ' ,Name' +
                        ' ,SalesAccount__r.Code__c' +
                        ' ,SalesAccount__r.Name' +
                        ' ,SalesAccount__r.Undergraduate__c' +
                        ' ,ShipmentAccount__r.Code__c' +
                        ' ,ShipmentAccount__r.Name' +
                        ' ,ShipmentAccount__r.Undergraduate__c' +
                        ' ,OrderDateFormula__c' +
                        ' ,CarryDeliveryTimeFormula__c' +
                        ' ,SalesStaff__c' +
                        ' ,ProductNumber__c' +
                        ' ,OrdersMemp__c' +
                        ' ,OrderAmount__c' +
                        ' ,TaxAmount__c' +
                        ' ,CurrencyIsoCode' +
                        ' ,SalesContactPosition__c' +
                        ' ,SalesAccount__r.Address__c' +
                        ' ,SalesTantoshya__c' +
                        ' ,SalesContactTel__c' +
                        ' ,ShipmentContactPosition__c' +
                        ' ,ShipmentAccount__r.Address__c' +
                        ' ,ShipmentTantosha__c' +
                        ' ,ShipmentContact_Tel__c' +
                        ' ,CustomerOrder__c' +
                        ' ,SchedulingDivision__c' +
                        ' ,Kosohin__c' +
                        ' ,BillingSystem__c' +
                        ' ,PaperDivision__c' +
                        ' ,Quotation__c' +
                        ' ,Invoice__c' +
                        ' ,Bill__c' +
                        ' ,ModelPI__c' +
                        ' ,UnitBody__c' +
                        ',( ' +
                            ' SELECT ' + 
                                ' Id ' +
                                ' ,CurrencyIsoCode' +
                                ' ,Name' +
                                ' ,ProductNumber__c' +
                                ' ,PositionText__c' +
                                ' ,ProductItem__r.Name' +
                                ' ,ProductName__c' +
                                ' ,OrderQuantity__c' +
                                ' ,OrderUnit__c' +
                                ' ,Price__c' +
                                ' ,Amount__c' +
                                ' ,Soko__c' +
                                ' ,NyukaYoteDateFormula__c' +
                                ' ,ShukaSuryo__c' +
                                ' ,ShukkaDateFormula__c' +
                                ' ,ShukkaStatus__c' +
                                ' ,ZaikoKanriKubun__c' +
                            ' FROM ' +
                                 ' SalesOrderLines__r ' +
                            ' ORDER BY ' +
                                ' Name ' +
                         ') ' +
                    ' FROM ' +
                        ' SalesOrder__c' +
                    ' WHERE ' +
                        ' Id =: targetId';

        return str;
    }

    private String getServiceOrderQueryStr(String targetId) {

        String str = 'SELECT ' +
                        ' Id ' +
                        ' ,CurrencyIsoCode' +
                        ' ,Name' +
                        ' ,SalesAccount__r.Code__c' +
                        ' ,SalesAccount__r.Name' +
                        ' ,SalesAccount__r.Undergraduate__c' +
                        ' ,ShipmentAccount__r.Code__c' +
                        ' ,ShipmentAccount__r.Name' +
                        ' ,ShipmentAccount__r.Undergraduate__c' +
                        ' ,OrderDateFormula__c' +
                        ' ,DesiredDeliveryDateFormula__c' +
                        ' ,SalesStaff__c' +
                        ' ,ProductNo__c' +
                        ' ,SalesContactAffiliation__c' +
                        ' ,SalesAccount__r.Address__c' +
                        ' ,SalesContactName__c' +
                        ' ,SalesContactTel__c' +
                        ' ,ShipToAffiliation__c' +
                        ' ,ShipmentAccount__r.Address__c' +
                        ' ,ShipToContactPerson__c' +
                        ' ,ShipToContactTEL__c' +
                        ' ,CustomerOrder__c' +
                        ' ,CallCenterReceptionNo__c' +
                        ' ,BunnoKubun__c' +
                        ' ,Kosohin__c' +
                        ' ,SekyuHoshiki__c' +
                        ' ,ShiteYoshiKubun__c' +
                        ' ,Mitsumori__c' +
                        ' ,Nohin__c' +
                        ' ,Sekyu__c' +
                        ' ,Model__c' +
                        ' ,UnitBody__c' +
                        ' ,Remarks__c' +
                        ',( ' + 
                            ' SELECT ' +
                                ' Id' +
                                ' ,CurrencyIsoCode' +
                                ' ,Name' +
                                ' ,ProductItem__r.Name' +
                                ' ,ProductItem__r.JapaneseName__c' +
                                ' ,Suryo__c' +
                                ' ,Tani__c' +
                                ' ,ProductItem__r.Soko__c' +
                                ' ,NyukaYoteDateFormula__c' +
                                ' ,ShukaSuryo__c' +
                                ' ,ShukkaDateFormula__c' +
                                ' ,ShukkaStatus__c' +
                                ' ,ProductItem__r.ZaikoKanriKubun__c' +
                            ' FROM ' +
                                ' ServiceOrderControls__r ' +
                            ' ORDER BY ' +
                                ' Name ' +
                        ' ) ' +
                    ' FROM ' +
                        ' ServiceOrder__c ' +
                    ' WHERE ' +
                        ' Id =: targetId ';

        return str;
    }
    
    public class ViewWrapper {
        
        private SObject rec;
        private Boolean isSales = false;
        private Boolean isService = false;
        
        public viewWrapper(SObject targetRec) {
            String targetId = (String)targetRec.get('id');
            if (targetId.startsWith(SalesOrder__c.SobjectType.getDescribe().getKeyPrefix())) {
                this.isSales = true;
            }
            if (targetId.startsWith(ServiceOrder__c.SobjectType.getDescribe().getKeyPrefix())) {
                this.isService = true;
            }
            if (isSales || isService) {
                this.rec = targetRec;
            } else {
                throw new JEOLException('予期しない操作が行われました。');
            }
        }

        public Boolean getIsSales() {
            return isSales;
        }
        public Boolean getIsService() {
            return isService;
        }

/** ここからgetメイン項目 **/
        public String getOrderNo() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('Name');
            }
            if (isService) {
                ret = (String)rec.get('Name');
            }
            return ret;
        }
        public Date getOrderDate() {
            Date ret;
            if (isSales) {
                ret = (Date)rec.get('OrderDateFormula__c');
            }
            if (isService) {
                ret = (Date)rec.get('OrderDateFormula__c');
            }
            return ret;
        }
        public Date getCarryDeliveryTime() {
            Date ret;
            if (isSales) {
                ret = (Date)rec.get('CarryDeliveryTimeFormula__c');
            }
            if (isService) {
                ret = (Date)rec.get('DesiredDeliveryDateFormula__c');
            }
            return ret;
        }
        public String getSalesStaff() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('SalesStaff__c');
            }
            if (isService) {
                ret = (String)rec.get('SalesStaff__c');
            }
            return ret;
        }
        public String getProductNumber() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('ProductNumber__c');
            }
            if (isService) {
                ret = (String)rec.get('ProductNo__c');
            }
            return ret;
        }
        public String getOrdersMemp() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('OrdersMemp__c');
            }
            if (isService) {
                ret = (String)rec.get('Remarks__c');
            }
            return ret;
        }
        public Decimal getOrderAmount() {
            Decimal ret;
            if (isSales) {
                ret = (Decimal)rec.get('OrderAmount__c');
            }
            if (isService) {
//                ret = (Decimal)rec.get('');
            }
            return ret;
        }
        public Decimal getTaxAmount() {
            Decimal ret;
            if (isSales) {
                ret = (Decimal)rec.get('TaxAmount__c');
            }
            if (isService) {
//                ret = (Decimal)rec.get('');
            }
            return ret;
        }
        public String getCurrencyIsoCode() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('CurrencyIsoCode');
            }
            if (isService) {
//                ret = (String)rec.get('');
            }
            return ret;
        }
        public Decimal getSumAmount() {
            Decimal ret;
            Decimal ordAmt = 0;
            Decimal taxAmt = 0;
            if (isSales) {
                if (rec.get('OrderAmount__c')!=null) {
                    ordAmt = (Decimal)rec.get('OrderAmount__c');
                }
                if (rec.get('TaxAmount__c')!=null){
                    taxAmt = (Decimal)rec.get('TaxAmount__c');
                }
                ret = ordAmt + taxAmt;
            }
            if (isService) {
//                ret = (String)rec.get('');
            }
            return ret;
        }
        public String getSalesContactPosition() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('SalesContactPosition__c');
            }
            if (isService) {
                ret = (String)rec.get('SalesContactAffiliation__c');
            }
            return ret;
        }
        public String getSalesTantoshya() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('SalesTantoshya__c');
            }
            if (isService) {
                ret = (String)rec.get('SalesContactName__c');
            }
            return ret;
        }
        public String getSalesContactTel() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('SalesContactTel__c');
            }
            if (isService) {
                ret = (String)rec.get('SalesContactTel__c');
            }
            return ret;
        }
        public String getShipmentContactPosition() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('ShipmentContactPosition__c');
            }
            if (isService) {
                ret = (String)rec.get('ShipToAffiliation__c');
            }
            return ret;
        }
        public String getShipmentTantosha() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('ShipmentTantosha__c');
            }
            if (isService) {
                ret = (String)rec.get('ShipToContactPerson__c');
            }
            return ret;
        }
        public String getShipmentContactTel() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('ShipmentContact_Tel__c');
            }
            if (isService) {
                ret = (String)rec.get('ShipToContactTEL__c');
            }
            return ret;
        }
        public String getCustomerOrderNo() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('CustomerOrder__c');
            }
            if (isService) {
                ret = (String)rec.get('CustomerOrder__c');
            }
            return ret;
        }
        public String getCallCenterReceptionNo() {
            String ret;
            if (isSales) {
//                ret = (String)rec.get('');
            }
            if (isService) {
                ret = (String)rec.get('CallCenterReceptionNo__c');
            }
            return ret;
        }
        public String getSchedulingDivision() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('SchedulingDivision__c');
            }
            if (isService) {
                ret = (String)rec.get('BunnoKubun__c');
            }
            return ret;
        }
        public String getKosohin() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('Kosohin__c');
            }
            if (isService) {
                ret = (String)rec.get('Kosohin__c');
            }
            return ret;
        }
        public String getBillingSystem() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('BillingSystem__c');
            }
            if (isService) {
                ret = (String)rec.get('SekyuHoshiki__c');
            }
            return ret;
        }
        public String getPaperDivision() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('PaperDivision__c');
            }
            if (isService) {
                ret = (String)rec.get('ShiteYoshiKubun__c');
            }
            return ret;
        }
        public String getQuotation() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('Quotation__c');
            }
            if (isService) {
                ret = (String)rec.get('Mitsumori__c');
            }
            return ret;
        }
        public String getInvoice() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('Invoice__c');
            }
            if (isService) {
                ret = (String)rec.get('Nohin__c');
            }
            return ret;
        }
        public String getBill() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('Bill__c');
            }
            if (isService) {
                ret = (String)rec.get('Sekyu__c');
            }
            return ret;
        }
        public String getModelPI() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('ModelPI__c');
            }
            if (isService) {
                ret = (String)rec.get('Model__c');
            }
            return ret;
        }
        public String getUnitBody() {
            String ret;
            if (isSales) {
                ret = (String)rec.get('UnitBody__c');
            }
            if (isService) {
                ret = (String)rec.get('UnitBody__c');
            }
            return ret;
        }
/** ここまでgetメイン項目 **/

/** ここからgetオブジェクト **/
        public Account getSalesAccount() {
            Account ret;
            if (isSales) {
                ret = (Account)rec.getSobject('SalesAccount__r');
            }
            if (isService) {
                ret = (Account)rec.getSobject('SalesAccount__r');
            }
            return ret;
        }
        public Account getShipmentAccount() {
            Account ret;
            if (isSales) {
                ret = (Account)rec.getSobject('ShipmentAccount__r');
            }
            if (isService) {
                ret = (Account)rec.getSobject('ShipmentAccount__r');
            }
            return ret;
        }
/** ここまでgetオブジェクト **/

/** ここからgetライン情報 **/
        public List<Sobject> getLines() {
            List<Sobject> ret;
            if (isSales) {
                ret = rec.getSobjects('SalesOrderLines__r');
            }
            if (isService) {
                ret = rec.getSobjects('ServiceOrderControls__r');
            }
            return ret;
        }
/** ここまでgetライン情報 **/

    }

}