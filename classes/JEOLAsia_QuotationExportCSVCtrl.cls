public with sharing class JEOLAsia_QuotationExportCSVCtrl extends JEOL_SearchBase_ctrl{

    public String qtId{get; set;}

    public List<List<String>> lslsstrRowMCM{get;set;}

    public String sTitle{get;set;}
    private String qtName;

    public String getFileName() {
        return qtName + '_' + date.today().format() + '.csv'; //'NewList_'
    }

    public JEOLAsia_QuotationExportCSVCtrl() {

        String sRow = '';

        final String PARAM_CSV_ID = 'ID';
        if (Apexpages.currentpage().getparameters().containsKey(PARAM_CSV_ID)) {
            this.qtId = Apexpages.currentpage().getparameters().get(PARAM_CSV_ID);
        }

        AsiaProfitCalculation__c rec = [SELECT Id, JProdCostCurrency__c, SalesCurrency__c, SubtotalACostUnit__c, SubtotalASalesUnit__c, SubtotalADiscountRate__c, SubtotalADiscount__c, SubtotalADiscountType__c,
                                               ProfitCalculationNo__c, BranchNo__c, SalesPerson__r.Name, DeliveryDeadline__c, DeliveryDate_Arbitrarily__c, DeliveryDate_ArbitrarilyTitle__c,
                                               ContractCode__c, ContractName1__c, ContractAddress__c, ShipmentCode__c, ShipmentName1__c, ShipmentAddress__c,
                                               DeliveryCondition3__c, PaymentConditionTextarea__c, toLabel(PaymentConditionSection__c), OtherText__c,
                                               GrandTotal__c, OfferAmount__c, TotalProfitValue__c, TotalProfitRate__c,
                                               SubtotalB__c, SubtotalC__c, SubtotalD__c, SubtotalE__c, SubtotalF__c
                                        FROM AsiaProfitCalculation__c
                                        WHERE Id = :qtId
                                       ];

        qtName = rec.ProfitCalculationNo__c + '_' + rec.BranchNo__c;

        String soql = ' SELECT ' +
                      '     id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c, ' +
                      '     Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode, ' +
                      '     ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c, IsJProdTarget__c, IsForbiddenTarget__c, ' +
                      '     IsShowDetailAmount__c, DiscountAmount__c, CostPriceJProdUnit2SP__c, RowCount2SP__c, ' +
                      '     AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c, ' +
                      '     CostPrice__c, SalesPrice__c, SalesPriceCalculated__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c, CostPriceJProdUnit__c, ' +
                      '     Description__c, Remarks__c, Supplier__c, SalesPriceCoefficient__c, CommissionCostPct__c, CostPriceJPY2SP__c, CostPriceSalesCur2SP__c, SalesPriceSalesCur2SP__c ' +
                      ' FROM  ' +
                      '     AsiaProfitCalculationDetail__c  ' +
                      ' WHERE  ' +
                      '     Parent__c = \'' + qtId + '\'' +
                      ' AND  ' +
                      '     Category__c = \'A\'' +
                      ' ORDER BY ' +
                      '     SortNo__c, Depth__c Asc ';

        lslsstrRowMCM = new List<List<String>>();

        sTitle = '';
        sTitle = ConcatenateField(sTitle, 'Quotation Name', true);
        sTitle = ConcatenateField(sTitle, qtName, false);
        sTitle = ConcatenateField(sTitle, '', false);
        sTitle = ConcatenateField(sTitle, '', false);
        sTitle = ConcatenateField(sTitle, '', false);
        sTitle = ConcatenateField(sTitle, '', false);
        sTitle = ConcatenateField(sTitle, '', false);
        

        List<String> lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Salesperson', true);
        sRow = ConcatenateField(sRow, rec.SalesPerson__r.Name, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        if (rec.DeliveryDeadline__c != NULL) {
            sRow = ConcatenateField(sRow, 'Estimated Shipment Date', true);
            string dateStr = DateTime.newInstance(rec.DeliveryDeadline__c.year(),rec.DeliveryDeadline__c.month(),rec.DeliveryDeadline__c.day()).format('yyyy/MM/dd');
            sRow = ConcatenateField(sRow, dateStr, false);
        } else {
            sRow = ConcatenateField(sRow, rec.DeliveryDate_ArbitrarilyTitle__c, true);
            sRow = ConcatenateField(sRow, rec.DeliveryDate_Arbitrarily__c, false);
        }
        
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Buyer', true);
        sRow = ConcatenateField(sRow, rec.ContractCode__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Contract Name 1', true);
        sRow = ConcatenateField(sRow, rec.ContractName1__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Address', true);
        sRow = ConcatenateField(sRow, rec.ContractAddress__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'End User', true);
        sRow = ConcatenateField(sRow, rec.ShipmentCode__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Shipment Name 1', true);
        sRow = ConcatenateField(sRow, rec.ShipmentName1__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Address', true);
        sRow = ConcatenateField(sRow, rec.ShipmentAddress__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Incoterms', true);
        sRow = ConcatenateField(sRow, rec.DeliveryCondition3__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Payment Terms', true);

        if (String.isNotEmpty(rec.PaymentConditionTextarea__c)){
            sRow = ConcatenateField(sRow, rec.PaymentConditionTextarea__c, false);
        } else if (String.isNotEmpty(rec.PaymentConditionSection__c)){
            sRow = ConcatenateField(sRow, rec.PaymentConditionSection__c.replace(' | ', '\n'), false);
        } else {
            sRow = ConcatenateField(sRow, '', false);
        }

        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Others', true);
        sRow = ConcatenateField(sRow, rec.OtherText__c, false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Product Name', true);
        sRow = ConcatenateField(sRow, 'Model Type', false);
        sRow = ConcatenateField(sRow, 'Quantity', false);
        sRow = ConcatenateField(sRow, 'Unit', false);
        sRow = ConcatenateField(sRow, 'Unit Price', false);
        sRow = ConcatenateField(sRow, 'Currency', false);
        sRow = ConcatenateField(sRow, 'Cost Price (' + rec.JProdCostCurrency__c + ')', false);

        lsstrRowMCM.add(sRow);

        integer iSize = 50;
        for (AsiaProfitCalculationDetail__c mcm : Database.Query(soql)) {

            if (iSize == 1000) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            sRow = '';

            sRow = ConcatenateField(sRow, mcm.Body__c, true);
            sRow = ConcatenateField(sRow, mcm.ModelType__c, false);
            sRow = ConcatenateField(sRow, mcm.Quantity__c, false);
            sRow = ConcatenateField(sRow, mcm.QuantityUnit__c, false);
            sRow = ConcatenateField(sRow, mcm.UnitPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.CatalogCurrency__c, false);
            sRow = ConcatenateField(sRow, mcm.CostPriceJProdUnit__c, false);

            lsstrRowMCM.add(sRow);

            iSize += 1;
        }
        lslsstrRowMCM.add(lsstrRowMCM);





        lsstrRowMCM = new List<String>();
        iSize = 0;

        for (AsiaProfitCalculationDetail__c mcm : Database.Query(soql)) {

            if (mcm.RowCount2SP__c > 0) {

                if (iSize == 1000) {
                    lslsstrRowMCM.add(lsstrRowMCM);
                    lsstrRowMCM = new List<String>();
                    iSize = 0;
                }

                sRow = '';

                sRow = ConcatenateField(sRow, 'Spare Parts for ' + mcm.ModelType__c, true);
                sRow = ConcatenateField(sRow, '', false);
                sRow = ConcatenateField(sRow, '', false);
                sRow = ConcatenateField(sRow, '', false);
                sRow = ConcatenateField(sRow, mcm.CostPriceJPY2SP__c, false);
                sRow = ConcatenateField(sRow, 'JPY', false);
                sRow = ConcatenateField(sRow, mcm.CostPriceJProdUnit2SP__c, false);

                lsstrRowMCM.add(sRow);

                iSize += 1;

            }

        }
        lslsstrRowMCM.add(lsstrRowMCM);








        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);


        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Subtotal (' + rec.JProdCostCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.SubtotalACostUnit__c, false);

        lsstrRowMCM.add(sRow);


        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Discount Rate', false);
        sRow = ConcatenateField(sRow, rec.SubtotalADiscountRate__c, false);

        lsstrRowMCM.add(sRow);


        Decimal dDiscount = 0;


        // The discount value should be calculated from the values
        if (rec.SubtotalASalesUnit__c > 0) {
            dDiscount = rec.SubtotalADiscount__c / rec.SubtotalASalesUnit__c * rec.SubtotalACostUnit__c;
        }

        // The following does not work because the rate is based on the discountable amount, not on the total amount
        // if (rec.SubtotalADiscountType__c != 'Rate') {
        //     // The discount value should be calculated from the values
        //     dDiscount = rec.SubtotalADiscount__c / rec.SubtotalASalesUnit__c * rec.SubtotalACostUnit__c;
        // } else {
        //     // The discount value should be calculated from the rate
        //     dDiscount = rec.SubtotalACostUnit__c * rec.SubtotalADiscountRate__c / 100;
        // }
        dDiscount = (dDiscount * 100).Round() / 100.0;

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Discount Value', false);
        sRow = ConcatenateField(sRow, dDiscount.setScale(2).toPlainString(), false);

        lsstrRowMCM.add(sRow);


        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Subtotal after discount (' + rec.JProdCostCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.SubtotalACostUnit__c - dDiscount, false);

        lsstrRowMCM.add(sRow);


        lslsstrRowMCM.add(lsstrRowMCM);








        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);



        sRow = '';
        sRow = ConcatenateField(sRow, 'Model Type', true);
        sRow = ConcatenateField(sRow, 'Part Number', false);
        sRow = ConcatenateField(sRow, 'Description', false);
        sRow = ConcatenateField(sRow, 'Specification', false);
        sRow = ConcatenateField(sRow, 'Quantity', false);
        sRow = ConcatenateField(sRow, 'Unit Price', false);
        sRow = ConcatenateField(sRow, 'Currency', false);
        sRow = ConcatenateField(sRow, 'Cost Price (' + rec.JProdCostCurrency__c + ')', false);

        lsstrRowMCM.add(sRow);

        Decimal dRate = 1;
        List<AsiaProfitCalculationRate__c> lsRate = [SELECT id, Type__c, CurrencyBase__c, CurrencyToConvert__c, Rate__c, ReadOnly__c, Profit_Calculation__c
                                                     FROM AsiaProfitCalculationRate__c 
                                                     WHERE Profit_Calculation__c = :qtId
                                                     AND Type__c = '2'
                                                     AND CurrencyToConvert__c = 'JPY'
                                                     AND CurrencyBase__c = :rec.JProdCostCurrency__c];
         for (AsiaProfitCalculationRate__c rate : lsRate) {
            dRate = rate.Rate__c;
         }


        soql = ' SELECT ' +
                      '     id, Name, ProfitCalculationDetail__r.ModelType__c, PartNumber__c, Description__c, Specification__c, ' +
                      '     Quantity__c, UnitPrice__c, CostPriceJPY__c ' +
                      ' FROM ' +
                      '     AsiaProfitCalculationDetail2SP__c ' +
                      ' WHERE ' +
                      '     ProfitCalculationDetail__r.Parent__c = \'' + qtId + '\'' +
                      ' AND ' +
                      '      IsSelected__c = true ' +
                      ' ORDER BY ' +
                      '      ProfitCalculationDetail__r.SortNo__c, ProfitCalculationDetail__r.Depth__c, SortNo__c ';

        iSize = 0;
        for (AsiaProfitCalculationDetail2SP__c mcm : Database.Query(soql)) {

            if (iSize == 500) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            sRow = '';

            sRow = ConcatenateField(sRow, mcm.ProfitCalculationDetail__r.ModelType__c, true);
            sRow = ConcatenateField(sRow, mcm.PartNumber__c, false);
            sRow = ConcatenateField(sRow, mcm.Description__c, false);
            sRow = ConcatenateField(sRow, mcm.Specification__c, false);
            sRow = ConcatenateField(sRow, mcm.Quantity__c, false);
            sRow = ConcatenateField(sRow, mcm.UnitPrice__c, false);
            sRow = ConcatenateField(sRow, 'JPY', false);
            sRow = ConcatenateField(sRow, ((mcm.CostPriceJPY__c * dRate * 100).round() / 100.0).setScale(2).toPlainString(), false);

            lsstrRowMCM.add(sRow);

            iSize += 1;

        }
        lslsstrRowMCM.add(lsstrRowMCM);


        // L/S Informations

        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'L/S Information', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Product Name', true);
        sRow = ConcatenateField(sRow, 'Model Type', false);
        sRow = ConcatenateField(sRow, 'Quantity', false);
        sRow = ConcatenateField(sRow, 'Unit', false);
        sRow = ConcatenateField(sRow, 'Unit Price', false);
        sRow = ConcatenateField(sRow, 'Currency', false);
        sRow = ConcatenateField(sRow, 'Cost Price (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, 'Supplier', false);

        lsstrRowMCM.add(sRow);

        soql = ' SELECT ' +
               '     id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c, ' +
               '     Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode, ' +
               '     ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c, IsJProdTarget__c, IsForbiddenTarget__c, ' +
               '     IsShowDetailAmount__c, DiscountAmount__c, CostPriceJProdUnit2SP__c, RowCount2SP__c, ' +
               '     AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c, ' +
               '     CostPrice__c, SalesPrice__c, SalesPriceCalculated__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c, CostPriceJProdUnit__c, ' +
               '     Description__c, Remarks__c, Supplier__c, SalesPriceCoefficient__c, CommissionCostPct__c, CostPriceJPY2SP__c, CostPriceSalesCur2SP__c, SalesPriceSalesCur2SP__c ' +
               ' FROM  ' +
               '     AsiaProfitCalculationDetail__c  ' +
               ' WHERE  ' +
               '     Parent__c = \'' + qtId + '\'' +
               ' AND  ' +
               '     Category__c = \'B\'' +
               ' ORDER BY ' +
               '     SortNo__c, Depth__c Asc ';

        iSize = 0;
        for (AsiaProfitCalculationDetail__c mcm : Database.Query(soql)) {

            if (iSize == 500) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            sRow = '';
            sRow = ConcatenateField(sRow, mcm.Body__c, true);
            sRow = ConcatenateField(sRow, mcm.ModelType__c, false);
            sRow = ConcatenateField(sRow, mcm.Quantity__c, false);
            sRow = ConcatenateField(sRow, mcm.QuantityUnit__c, false);
            sRow = ConcatenateField(sRow, mcm.UnitPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.CatalogCurrency__c, false);
            sRow = ConcatenateField(sRow, mcm.CostPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.Supplier__c, false);

            lsstrRowMCM.add(sRow);

            iSize += 1;

        }

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Subtotal (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.SubtotalB__c, false);

        lsstrRowMCM.add(sRow);

        lslsstrRowMCM.add(lsstrRowMCM);



        // Warranty Information

        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Warranty Information', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Product Name', true);
        sRow = ConcatenateField(sRow, 'Description', false);
        sRow = ConcatenateField(sRow, 'Quantity', false);
        sRow = ConcatenateField(sRow, 'Unit Price', false);
        sRow = ConcatenateField(sRow, 'Currency', false);
        sRow = ConcatenateField(sRow, 'Cost Price (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, 'Remarks', false);

        lsstrRowMCM.add(sRow);

        soql = ' SELECT ' +
               '     id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c, ' +
               '     Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode, ' +
               '     ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c, IsJProdTarget__c, IsForbiddenTarget__c, ' +
               '     IsShowDetailAmount__c, DiscountAmount__c, CostPriceJProdUnit2SP__c, RowCount2SP__c, ' +
               '     AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c, ' +
               '     CostPrice__c, SalesPrice__c, SalesPriceCalculated__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c, CostPriceJProdUnit__c, ' +
               '     Description__c, Remarks__c, Supplier__c, SalesPriceCoefficient__c, CommissionCostPct__c, CostPriceJPY2SP__c, CostPriceSalesCur2SP__c, SalesPriceSalesCur2SP__c ' +
               ' FROM  ' +
               '     AsiaProfitCalculationDetail__c  ' +
               ' WHERE  ' +
               '     Parent__c = \'' + qtId + '\'' +
               ' AND  ' +
               '     Category__c = \'C\'' +
               ' ORDER BY ' +
               '     SortNo__c, Depth__c Asc ';

        iSize = 0;
        for (AsiaProfitCalculationDetail__c mcm : Database.Query(soql)) {

            if (iSize == 500) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            sRow = '';
            sRow = ConcatenateField(sRow, mcm.Body__c, true);
            sRow = ConcatenateField(sRow, mcm.Description__c, false);
            sRow = ConcatenateField(sRow, mcm.Quantity__c, false);
            sRow = ConcatenateField(sRow, mcm.UnitPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.CatalogCurrency__c, false);
            sRow = ConcatenateField(sRow, mcm.CostPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.Remarks__c, false);

            lsstrRowMCM.add(sRow);

            iSize += 1;

        }

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Subtotal (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.SubtotalC__c, false);

        lsstrRowMCM.add(sRow);

        lslsstrRowMCM.add(lsstrRowMCM);





        // Commission Information

        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Commission Information', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Product Name', true);
        sRow = ConcatenateField(sRow, 'Description', false);
        sRow = ConcatenateField(sRow, 'Quantity', false);
        sRow = ConcatenateField(sRow, 'Unit Price', false);
        sRow = ConcatenateField(sRow, 'Currency', false);
        sRow = ConcatenateField(sRow, 'Cost Price (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, 'Remarks', false);

        lsstrRowMCM.add(sRow);

        soql = ' SELECT ' +
               '     id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c, ' +
               '     Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode, ' +
               '     ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c, IsJProdTarget__c, IsForbiddenTarget__c, ' +
               '     IsShowDetailAmount__c, DiscountAmount__c, CostPriceJProdUnit2SP__c, RowCount2SP__c, ' +
               '     AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c, ' +
               '     CostPrice__c, SalesPrice__c, SalesPriceCalculated__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c, CostPriceJProdUnit__c, ' +
               '     Description__c, Remarks__c, Supplier__c, SalesPriceCoefficient__c, CommissionCostPct__c, CostPriceJPY2SP__c, CostPriceSalesCur2SP__c, SalesPriceSalesCur2SP__c ' +
               ' FROM  ' +
               '     AsiaProfitCalculationDetail__c  ' +
               ' WHERE  ' +
               '     Parent__c = \'' + qtId + '\'' +
               ' AND  ' +
               '     Category__c = \'D\'' +
               ' ORDER BY ' +
               '     SortNo__c, Depth__c Asc ';

        iSize = 0;
        for (AsiaProfitCalculationDetail__c mcm : Database.Query(soql)) {

            if (iSize == 500) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            sRow = '';
            sRow = ConcatenateField(sRow, mcm.Body__c, true);
            sRow = ConcatenateField(sRow, mcm.Description__c, false);
            sRow = ConcatenateField(sRow, mcm.Quantity__c, false);
            sRow = ConcatenateField(sRow, mcm.UnitPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.CatalogCurrency__c, false);
            sRow = ConcatenateField(sRow, mcm.CostPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.Remarks__c, false);

            lsstrRowMCM.add(sRow);

            iSize += 1;

        }

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Subtotal (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.SubtotalD__c, false);

        lsstrRowMCM.add(sRow);

        lslsstrRowMCM.add(lsstrRowMCM);



        // Other Miscellaneous Information

        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Other Miscellaneous Information', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Product Name', true);
        sRow = ConcatenateField(sRow, 'Description', false);
        sRow = ConcatenateField(sRow, 'Quantity', false);
        sRow = ConcatenateField(sRow, 'Unit Price', false);
        sRow = ConcatenateField(sRow, 'Currency', false);
        sRow = ConcatenateField(sRow, 'Cost Price (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, 'Remarks', false);

        lsstrRowMCM.add(sRow);

        soql = ' SELECT ' +
               '     id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c, ' +
               '     Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode, ' +
               '     ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c, IsJProdTarget__c, IsForbiddenTarget__c, ' +
               '     IsShowDetailAmount__c, DiscountAmount__c, CostPriceJProdUnit2SP__c, RowCount2SP__c, ' +
               '     AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c, ' +
               '     CostPrice__c, SalesPrice__c, SalesPriceCalculated__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c, CostPriceJProdUnit__c, ' +
               '     Description__c, Remarks__c, Supplier__c, SalesPriceCoefficient__c, CommissionCostPct__c, CostPriceJPY2SP__c, CostPriceSalesCur2SP__c, SalesPriceSalesCur2SP__c ' +
               ' FROM  ' +
               '     AsiaProfitCalculationDetail__c  ' +
               ' WHERE  ' +
               '     Parent__c = \'' + qtId + '\'' +
               ' AND  ' +
               '     Category__c = \'E\'' +
               ' ORDER BY ' +
               '     SortNo__c, Depth__c Asc ';

        iSize = 0;
        for (AsiaProfitCalculationDetail__c mcm : Database.Query(soql)) {

            if (iSize == 500) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            sRow = '';
            sRow = ConcatenateField(sRow, mcm.Body__c, true);
            sRow = ConcatenateField(sRow, mcm.Description__c, false);
            sRow = ConcatenateField(sRow, mcm.Quantity__c, false);
            sRow = ConcatenateField(sRow, mcm.UnitPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.CatalogCurrency__c, false);
            sRow = ConcatenateField(sRow, mcm.CostPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.Remarks__c, false);

            lsstrRowMCM.add(sRow);

            iSize += 1;

        }

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Subtotal (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.SubtotalE__c, false);

        lsstrRowMCM.add(sRow);

        lslsstrRowMCM.add(lsstrRowMCM);



        // Expenses Information

        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Expenses Information', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, 'Product Name', true);
        sRow = ConcatenateField(sRow, 'Description', false);
        sRow = ConcatenateField(sRow, 'Quantity', false);
        sRow = ConcatenateField(sRow, 'Unit Price', false);
        sRow = ConcatenateField(sRow, 'Currency', false);
        sRow = ConcatenateField(sRow, 'Cost Price (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, 'Remarks', false);

        lsstrRowMCM.add(sRow);

        soql = ' SELECT ' +
               '     id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c, ' +
               '     Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode, ' +
               '     ProductCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c, IsJProdTarget__c, IsForbiddenTarget__c, ' +
               '     IsShowDetailAmount__c, DiscountAmount__c, CostPriceJProdUnit2SP__c, RowCount2SP__c, ' +
               '     AccompanyingPaperOutput__c, CertificationExpress__c, CommissionTarget__c, Category__c, ' +
               '     CostPrice__c, SalesPrice__c, SalesPriceCalculated__c, ModelType__c, CatalogCurrency__c, CostPriceUnit__c, CostPriceJProdUnit__c, ' +
               '     Description__c, Remarks__c, Supplier__c, SalesPriceCoefficient__c, CommissionCostPct__c, CostPriceJPY2SP__c, CostPriceSalesCur2SP__c, SalesPriceSalesCur2SP__c ' +
               ' FROM  ' +
               '     AsiaProfitCalculationDetail__c  ' +
               ' WHERE  ' +
               '     Parent__c = \'' + qtId + '\'' +
               ' AND  ' +
               '     Category__c = \'F\'' +
               ' ORDER BY ' +
               '     SortNo__c, Depth__c Asc ';

        iSize = 0;
        for (AsiaProfitCalculationDetail__c mcm : Database.Query(soql)) {

            if (iSize == 500) {
                lslsstrRowMCM.add(lsstrRowMCM);
                lsstrRowMCM = new List<String>();
                iSize = 0;
            }

            sRow = '';
            sRow = ConcatenateField(sRow, mcm.Body__c, true);
            sRow = ConcatenateField(sRow, mcm.Description__c, false);
            sRow = ConcatenateField(sRow, mcm.Quantity__c, false);
            sRow = ConcatenateField(sRow, mcm.UnitPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.CatalogCurrency__c, false);
            sRow = ConcatenateField(sRow, mcm.CostPrice__c, false);
            sRow = ConcatenateField(sRow, mcm.Remarks__c, false);

            lsstrRowMCM.add(sRow);

            iSize += 1;

        }

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Subtotal (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.SubtotalF__c, false);

        lsstrRowMCM.add(sRow);

        lslsstrRowMCM.add(lsstrRowMCM);
        lsstrRowMCM = new List<String>();

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Grand Total (Cost) (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.GrandTotal__c, false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Offer Amount (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.OfferAmount__c, false);
        sRow = ConcatenateField(sRow, '', false);

        lsstrRowMCM.add(sRow);

        sRow = '';
        sRow = ConcatenateField(sRow, '', true);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, '', false);
        sRow = ConcatenateField(sRow, 'Total Profit (' + rec.SalesCurrency__c + ')', false);
        sRow = ConcatenateField(sRow, rec.TotalProfitValue__c, false);
        sRow = ConcatenateField(sRow, (rec.TotalProfitRate__c * 100) + '%', false);

        lsstrRowMCM.add(sRow);

        lslsstrRowMCM.add(lsstrRowMCM);
        lsstrRowMCM = new List<String>();
    }

    private String ConcatenateField(String strConcat, object field, boolean fFirstField) {
        String sReturn = strConcat;
        if (!fFirstField) {
            sReturn += ',';
        }
        if (field != null) {
            if (field instanceOf boolean ||
                field instanceOf Decimal ||
                field instanceOf Date) {
                sReturn += field;
            } else {
                String sField = (String)field;
//                sField = sField.replaceAll('[\n\r]', ' ');
                sField = sField.replaceAll('\r', '');
                sReturn += '"' + sField.replace('"', '""') + '"';
            }
        }
        return sReturn;
    }


}