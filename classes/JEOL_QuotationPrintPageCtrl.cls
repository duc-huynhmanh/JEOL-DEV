/*
 * Updated : 2015/06/01 by Polus (Voxer) - Add of PageNo & PageSize
 * Updated : 2015/06/02 by Polus (Voxer) - Delete of the FOR UPDATE
 * Updated : 2015/06/12 by Polus (Voxer) - Always show the decimals in Quantity if at least one row has decimals
 */
public with sharing class JEOL_QuotationPrintPageCtrl {
    
    public List<PageBlock> pdfPages{get; set;}
    public String outputType{get; set;}
    public String renderTarget{get; set;}
    public Boolean isShowPriceExpress{get; set;}
    public String language{get; set;}

    public static final Integer MAX_LINE_SIZE_FIRST = 22;
    public static final Integer MAX_LINE_SIZE = 42;
    public static final Integer BASE_TEXT_LENGTH = 17;

    private QuotationInformation__c targetRec;

    public JEOL_QuotationPrintPageCtrl() {

        this.language = UserInfo.getLanguage();

        Map<String, String> params = Apexpages.currentPage().getParameters();
        String recId = params.get('id');
        
        // Always use the print mode (there are some differences between the preview and the print mode)
        outputType = 'print';
        // if (params.containsKey('preview') && String.isNotBlank(params.get('preview'))) {
        //     outputType = 'preview';
        // }
        // if (params.containsKey('print') && String.isNotBlank(params.get('print'))) {
        //     outputType = 'print';
        // }
        if (outputType == 'print') {
            renderTarget = 'pdf';
        }
        this.pdfPages = createPdfPages(recId);
    }
    
    private List<PageBlock> createPdfPages(String targetId) {
    
        integer iCurrentPageNo = 1;
        List<PageBlock> pdfPages = new List<PageBlock>();

        targetRec = getTargetRecord(targetId);
        PageBlock headerPage = new PageBlock();
        headerPage.isFirst = true;
        QuotationHeader head = new QuotationHeader(targetRec);
        headerPage.setHead(head);
        this.isShowPriceExpress = targetRec.PriceExpress__c;

        List<QuotationDetailInformation__c> targetDetailRecs = getDetails(targetRec.id);
        List<QuotationDetailInformation__c> accompanyingPaperDetailRecs = new List<QuotationDetailInformation__c>();

        Integer totalLineSize = 0;
        PageBlock page = headerPage;
        totalLineSize += page.getQuotatinNameLinesSize();
        pdfPages.add(page);
        
        // Section with line items
        Integer lineBodySize = BASE_TEXT_LENGTH;
        lineBodySize += (head.rec.PriceExpress__c ? 0 : 5);
        lineBodySize += (head.rec.ProductCodeExpress__c ? 0 : 7);
        Integer countLineSize = 0;
        Boolean displayDecimalInQuantityFormat = targetRec.IsDisplayDecimal__c;
        if (displayDecimalInQuantityFormat)
        {
            // Display decimals if at least one quantity is decimal
            for (QuotationDetailInformation__c rec: targetDetailRecs) {
                Decimal quantity = rec.Quantity__c;
                if (quantity != null && quantity != 0 && (quantity - quantity.intValue() > 0))
                {
                    displayDecimalInQuantityFormat = false;
                    break;
                }
            }                        
        }
        
        for (QuotationDetailInformation__c rec: targetDetailRecs) {
            if (!rec.AccompanyingPaperOutput__c) {
                QuotationDetail detailBlock = new QuotationDetail(rec, lineBodySize, displayDecimalInQuantityFormat); //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.xx)
                Integer currentLineSize = detailBlock.getLineSize();
                Integer temp = totalLineSize + currentLineSize;
                countLineSize = totalLineSize + currentLineSize;
                if ((temp > MAX_LINE_SIZE_FIRST && page.isFirst) || temp > MAX_LINE_SIZE) {
                    iCurrentPageNo++;
                    page = new PageBlock();
                    page.pageNo = iCurrentPageNo;
                    page.setHead(head);
                    pdfPages.add(page);
                    totalLineSize = 0;
                }
                page.details.add(detailBlock);
                totalLineSize += currentLineSize;
            } else {
                accompanyingPaperDetailRecs.add(rec);
            }
        }
        
        // Section TOTAL
        Integer amountTotalLineSize = page.head.getAmountTotalLineSize();
system.debug('Section Total: ' + amountTotalLineSize + ' rows.');
        Integer sizeTemp = totalLineSize + amountTotalLineSize;
        if ((sizeTemp > MAX_LINE_SIZE_FIRST && page.isFirst) || sizeTemp > MAX_LINE_SIZE) {
            iCurrentPageNo++;
            page = new PageBlock();
            page.pageNo = iCurrentPageNo;
            page.setHead(head);
            pdfPages.add(page);
            sizeTemp = amountTotalLineSize;
        }
        totalLineSize = sizeTemp;       
        page.isShowTotal = true;

        // Section NOTES    
        Integer noteTextLineSize = page.getNoteTextLineSize();
system.debug('Section Notes: ' + noteTextLineSize + ' rows.');
        sizeTemp = totalLineSize + noteTextLineSize;
        if ((sizeTemp > MAX_LINE_SIZE_FIRST - 4  && page.isFirst) || sizeTemp > MAX_LINE_SIZE - 4) {
            List<String> baseLines = page.head.noteTextLines;
            List<String> textLines = new List<String>();
            for (String line: baseLines) {
                Boolean isShowNoteLabel = true;
                if ((totalLineSize > MAX_LINE_SIZE_FIRST - 4 && page.isFirst) || totalLineSize > MAX_LINE_SIZE - 4) {
                    page.isShowNote = true;
                    page.noteTextLines = textLines;
//                    if (textLines.size() > 0 && isShowNoteLabel) {
//                        page.isShowNoteLabel = isShowNoteLabel;
//                        isShowNoteLabel = false;
//                    }

                    iCurrentPageNo++;
                    page = new PageBlock();
                    page.pageNo = iCurrentPageNo;
                    page.setHead(head);
                    pdfPages.add(page);
                    totalLineSize = 0;
                    page.setHead(head);
                    textLines = new List<String>();
                }
                page.isShowNoteLabel = true;
                textLines.add(line);
                totalLineSize++;
            }
            page.isShowNote = true;
            page.noteTextLines = textLines;
        } else {
            page.isShowNoteLabel = true;
            page.isShowNote = true;
        }
        
        if (accompanyingPaperDetailRecs.size() > 0) {
            iCurrentPageNo++;
            page = new PageBlock();
            page.pageNo = iCurrentPageNo;
            page.setHead(head);
            page.isAccompanyingPaper = true;
            pdfPages.add(page);
            totalLineSize = 0;
            for (QuotationDetailInformation__c rec: accompanyingPaperDetailRecs) {
                QuotationDetail detailBlock = new QuotationDetail(rec, lineBodySize, displayDecimalInQuantityFormat);// //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.xx)
                Integer currentLineSize = detailBlock.getLineSize();
                Integer temp = totalLineSize + currentLineSize;
                if (temp > MAX_LINE_SIZE - 4) {
                    iCurrentPageNo++;
                    page = new PageBlock();
                    page.pageNo = iCurrentPageNo;
                    page.setHead(head);
                    page.isAccompanyingPaper = true;
                    pdfPages.add(page);
                    totalLineSize = 0;
                }
                page.details.add(detailBlock);
                totalLineSize += currentLineSize;
            }
        }
        page.isLast = true;

        return pdfPages;
    }
    private QuotationInformation__c getTargetRecord(String targetId) {
        QuotationInformation__c targetaRecord = null;
        List<QuotationInformation__c> recs = [
            SELECT
                id, name, CurrencyIsoCode, LastModifiedDate, CreatedDate, SalesPerson__r.Phone, SalesPerson__r.Fax,
                CustomerQuotationRequestedNo__c, TotalAmount__c, ContractCode__c, ContractAddress__c, ContractBelong__c,
                ContractPersonInCharge__c, ContractPhone__c, ContractName__c, ContractPost__c, Series__c, QuoteNo__c,
                QuotationRequestedDate__c, QuotationType__c, PostalCode__c, Phone__c, SalesAssistant__c, GroupLeaderApproval__c,
                BranchManagerApproval__c, PrintedDate__c, BranchNo__c, SalesArea__c, RegisterDate__c, ShipmentCode__c,
                ShipmentAddress__c, ShipmentBelong__c, ShipmentPersonInCharge__c, ShipmentPhone__c, ShipmentName__c, ShipmentPost__c,
                IssueDate__c, DepartmentCode__c, DepartmentName__c, createdById, createdBy.name, OrgName__c, Address__c, AddressLine1__c, AddressLine2__c, AddressLine3__c, Subtitle__c,
                Note__c, Memo__c, QuotationDivision__c, CustomReductionName1__c, CustomReductionAmount1__c, CustomReductionName2__c, 
                Fax__c, CustomReductionAmount2__c, CustomReductionName3__c, CustomReductionAmount3__c, ConsumptionTaxAmount__c,
                TotalTaxAmount__c, CustomerExpress__c, Addressee__c, TaxRate__c, ProductCodeExpress__c, SupervisorName__c, SupervisorPosition__c,
                DeliveryCondition1__c, DeliveryCondition2__c, toLabel(DeliveryLocationSection__c), DeliveryLocationText__c, DeliveryPeriod__c,
                DeliveryDeadline__c, DeliveryDate_Arbitrarily__c, toLabel(PaymentConditionSection__c), PaymentConditionText__c, QuoteValidityPeriod__c,
                QuoteExpirationDate__c, quoteExpirationDate_Arbitrarily__c, RepresentativeNameExpress__c, ReferenceExpress__c, DepartmentOutput__c, OverrideDepartmentOutputText__c,
                SubtitleLabel__c, PriceExpress__c, TaxExemptionTextOutput__c, OutputTotalTaxAmount__c, OutputConsumptionTaxAmount__c,
                OutputTotalAmount__c, OutputSubtitle__c, CalendarExpress__c, OtherText__c, UnitBody__c, UnitbodyExpress__c, IsDisplayDecimal__c,
                RecordTypeId, RecordType.DeveloperName, QuotationNameExpress__c,
                SubtotalReductionName1__c, SubtotalReductionAmount1__c, OutputSubtotalReduction1__c, 
                SubtotalReductionName2__c, SubtotalReductionAmount2__c, OutputSubtotalReduction2__c, 
                TotalAmountName__c, TotalTaxAmountName__c, OverrideDepartmentCode__c,
                ContractName1__c, ContractName2__c, ShipmentName1__c, ShipmentName2__c, Addressee2__c
            FROM
                QuotationInformation__c
            WHERE
                Id =: targetId
        ];
        if (recs != null && recs.size() > 0) {
            targetaRecord = recs.get(0);
            
            // Overwrite the JEOL information if necessary
            //targetaRecord.PostalCode__c = '123-4567';
            if (targetaRecord.DepartmentOutput__c) {
            
                // Sales Area
                if (targetaRecord.OverrideDepartmentOutputText__c != NULL && targetaRecord.OverrideDepartmentOutputText__c.length() > 0) {
                    targetaRecord.SalesArea__c = targetaRecord.OverrideDepartmentOutputText__c;
                }
                
                // Fields dependent of the Department
                if (targetaRecord.OverrideDepartmentCode__c != NULL && targetaRecord.OverrideDepartmentCode__c.length() > 0) {
        
                    List<Department__c> masterRecs = [SELECT Id, Name, SupervisorPosition__c, SupervisorName__c, PostalCode__c, AddressLine1__c, AddressLine2__c, AddressLine3__c, Series__c, Phone__c, Fax__c, DepartmentCode__c FROM Department__c WHERE DepartmentCode__c =:targetaRecord.OverrideDepartmentCode__c ORDER BY SortNo__c];
                    for (Department__c rec : masterRecs) {
        
                        //targetaRecord.DepartmentName__c = rec.Name;
                        //targetaRecord.DepartmentCode__c = rec.DepartmentCode__c;
                        targetaRecord.PostalCode__c = rec.PostalCode__c;
                        targetaRecord.AddressLine1__c = rec.AddressLine1__c;
                        targetaRecord.AddressLine2__c = rec.AddressLine2__c;
                        targetaRecord.AddressLine3__c = rec.AddressLine3__c;
                        targetaRecord.Phone__c = rec.Phone__c;
                        targetaRecord.Fax__c = rec.Fax__c;
                        targetaRecord.SupervisorPosition__c = rec.SupervisorPosition__c;
                        targetaRecord.SupervisorName__c = rec.SupervisorName__c;
                        break;
                        
                    }
                }
            }
        } else {
            throw new JEOLException('不正な操作が行われました。');
        }
        return targetaRecord;
    }
    public List<QuotationDetailInformation__c> getDetails(String parentId) {
        List<QuotationDetailInformation__c> recs = [
                SELECT 
                    id, name, Depth__c, SortNo__c, Type__c, Amount__c, Parent__c,
                    Quantity__c, QuantityUnit__c, UnitPrice__c, Body__c, CurrencyIsoCode,
                    productCode__c, IsTaxationTarget__c, IsOverheadTarget__c, IsDiscountTarget__c,
                    IsShowDetailAmount__c, DiscountRate__c, DiscountAmount__c, TotalDiscountAmount__c,
                    AccompanyingPaperOutput__c, IsDisplayDecimal__c
                FROM 
                    QuotationDetailInformation__c 
                WHERE 
                    Parent__c =: parentId 
                ORDER BY
                    SortNo__c, Depth__c Asc
        ];
        if (recs == null) {
            recs = new List<QuotationDetailInformation__c>();
        }
        return recs;
    }


    public String getCustomerName() {

        String ret = '';
        
        String tmp = '';
        String addressee = '';
        if (this.targetRec.Addressee__c != null && this.targetRec.Addressee__c.length() > 0) {
            addressee = ' ' + this.targetRec.Addressee__c;
        }
                
        if (this.targetRec.CustomerExpress__c == '契約先') {
            if (this.targetRec.ContractName1__c != null && this.targetRec.ContractName1__c.length() > 0) {
                tmp += this.targetRec.ContractName1__c;
            }
        } else if (this.targetRec.CustomerExpress__c == '納入先') {
            if (this.targetRec.ShipmentName1__c != null && this.targetRec.ShipmentName1__c.length() > 0) {
                tmp += this.targetRec.ShipmentName1__c;
            }
        }

        if (tmp.length() + addressee.length() > 40) {
            ret = tmp;
            if (ret.length() > 40) {
                ret = ret.substring(0, 40);
            }
        }
        
        // Add the addressee if possible
        if (ret.length() > 0 && addressee != null && addressee.length() > 0) {
            if ((ret + addressee).length() <= 40) {
                ret = ret + addressee;
            }
        }
        
        if (ret.length() > 0) {
            return ret;
        } else {
            return '　';
        }
    }

    public String getCustomerName2() {
        String ret = '';
        
        String tmp = '';
        String addressee = '';
        if (this.targetRec.Addressee__c != null && this.targetRec.Addressee__c.length() > 0) {
            addressee = ' ' + this.targetRec.Addressee__c;
        }

        if (this.targetRec.CustomerExpress__c == '契約先') {
            if (this.targetRec.ContractName1__c != null && this.targetRec.ContractName1__c.length() > 0) {
                tmp += this.targetRec.ContractName1__c;
            }
        } else if (this.targetRec.CustomerExpress__c == '納入先') {
            if (this.targetRec.ShipmentName1__c != null && this.targetRec.ShipmentName1__c.length() > 0) {
                tmp += this.targetRec.ShipmentName1__c;
            }
        }

        if (tmp.length() + addressee.length() > 40) {
            if (tmp.length() > 40) {
                ret = tmp.substring(40);            
            }
            if (ret.length() > 40 - addressee.length()) {
                ret = ret.substring(0, 40 - addressee.length());
            }   
        } else {
            ret = tmp;
        }
        
        ret = ret + addressee;

        if (ret.length() > 0) {
            return ret;
        } else {
            return '　';
        }
    }

    public String getCustomerName3() {
        String ret = '';
        
        String tmp = '';
        String addressee2 = '';
        if (this.targetRec.Addressee2__c != null && this.targetRec.Addressee2__c.length() > 0) {
            addressee2 = ' ' + this.targetRec.Addressee2__c;
        }

        if (this.targetRec.CustomerExpress__c == '契約先') {
            if (this.targetRec.ContractName2__c != null && this.targetRec.ContractName2__c.length() > 0) {
                tmp += this.targetRec.ContractName2__c;
            }
        } else if (this.targetRec.CustomerExpress__c == '納入先') {
            if (this.targetRec.ShipmentName2__c != null && this.targetRec.ShipmentName2__c.length() > 0) {
                tmp += this.targetRec.ShipmentName2__c;
            }
        }

        integer iLengthField = 33;
        if (JEOLUtil.getSizeInBytes(tmp) != tmp.length()) {
            // There is some 全角 character
            iLengthField = 23;
        }
        
        if (tmp.length() > iLengthField - addressee2.length()) {
            ret = tmp.substring(0, iLengthField - addressee2.length());
        } else {
            ret = tmp;
        }         

        ret = ret + addressee2;

        if (ret.length() > 0) {
            return ret;
        } else {
            return '　';
        }
    }
    
        
    public class PageBlock {
        public Boolean isFirst{get; set;}
        public Boolean isLast{get; set;}
        public Boolean isShowTotal{get; set;}
        public Boolean isAccompanyingPaper{get; set;}
        public Boolean isShowNote{get; set;}
        public Boolean isShowNoteLabel{get; set;}
        public QuotationHeader head{get; set;}
        public List<String> quotatinNameLines{get; set;}
        public List<String> noteTextLines{get; set;}
        public List<QuotationDetail> details{get; set;}
        public Integer pageNo{get; set;}
        
        public PageBlock() {
            this.isFirst = false;
            this.isLast = false;
            this.isShowTotal = false;
            this.isAccompanyingPaper = false;
            this.isShowNote = false;
            this.isShowNoteLabel = false;
            this.head = null;
            this.details = new List<QuotationDetail>();
            this.pageNo = 1;
        }
        public Integer getDetailSize() {
            return details.size();
        }
        public void setHead(QuotationHeader head) {
            this.head = head;
            this.noteTextLines = head.noteTextLines;
            this.quotatinNameLines = head.quotatinNameLines;
        }
        public Integer getNoteTextLineSize() {
            return this.noteTextLines.size();
        }
        public Integer getQuotatinNameLinesSize() {
            return this.quotatinNameLines.size();
        }
        public Boolean getHasNoteText() {
            return (this.noteTextLines.size() > 0);
        }

    }
    public class QuotationHeader {
        Public String CompanyAddress{get; set;}
        public QuotationInformation__c rec{get; set;}
        private Boolean isJapaneseEraOutput;
        public List<String> quotatinNameLines{get; set;}
        public List<String> noteTextLines{get; set;}
        public List<String> otherTextLines{get; set;}
        
        public QuotationHeader(QuotationInformation__c quotation) {
            this.rec = quotation;
            this.isJapaneseEraOutput = (rec.CalendarExpress__c == '和暦');
            String noteText = rec.Note__c;
            if (rec.TaxExemptionTextOutput__c) {
                if (String.isBlank(noteText)) {
                    noteText = Label.JEOL_QuotPrint_Message_QuotationTax;
                } else {
                    noteText = Label.JEOL_QuotPrint_Message_QuotationTax + '\n　\n' + noteText;
                }
            }
            this.noteTextLines = JEOLUtil.createTextLines(noteText, 50);
            If (this.noteTextLines != null && this.noteTextLines.size() > 0) {
                For (integer i = 0; i < this.noteTextLines.size(); i++) {
                    if (this.noteTextLines[i] == NULL || this.noteTextLines[i].length() == 0) {
                        this.noteTextLines[i] = '　';
                    }
                }
            }
            this.otherTextLines = JEOLUtil.createTextLines(rec.OtherText__c, 20, 3);
            If (this.otherTextLines != null && this.otherTextLines.size() > 0) {
                For (integer i = 0; i < this.otherTextLines.size(); i++) {
                    if (this.otherTextLines[i] == NULL || this.otherTextLines[i].length() == 0) {
                        this.otherTextLines[i] = '　';
                    }
                }
            }
            
            if (this.rec.QuotationNameExpress__c) {
                this.quotatinNameLines = JEOLUtil.createTextLines(rec.Name, 44, 2);
            } else {
                // Just create a data with 1 line and a dummy data
                this.quotatinNameLines =  new List<String>();
                this.quotatinNameLines.add('DUMMY');
            }
            
            this.CompanyAddress = '';
            if (this.rec.Address__c != null && !String.isBlank(this.rec.Address__c) && this.rec.Address__c.length() > 0)
            {
                For (Integer i = 0; i < this.rec.Address__c.length(); i++)
                {
                    this.CompanyAddress = this.CompanyAddress + '<span>' + this.rec.Address__c.substring(i, i+1) + '</span>';
                }
            }
            
        }
        public Integer getAmountTotalLineSize() {
            Integer ret = 0;
            if (this.rec.OutputSubtitle__c) ret++;//小計表示
            if (this.rec.CustomReductionAmount1__c != null && this.rec.CustomReductionAmount1__c > 0) ret++;//カスタム値引金額１
            if (this.rec.CustomReductionAmount2__c != null && this.rec.CustomReductionAmount2__c > 0) ret++;//カスタム値引金額2
            if (this.rec.CustomReductionAmount3__c != null && this.rec.CustomReductionAmount3__c > 0) ret++;//カスタム値引金額3
            if (this.rec.OutputSubtotalReduction1__c) ret++;
            if (this.rec.OutputSubtotalReduction2__c) ret++;
            if (this.rec.OutputTotalAmount__c) ret++;//合計金額表示
            if (this.rec.OutputConsumptionTaxAmount__c) ret++;//消費税額表示
            if (this.rec.OutputTotalTaxAmount__c) ret++;//総合計金額表示
            return ret;
        }
        public List<String> getDeliveryLocation() {
            String locationText = rec.DeliveryLocationSection__c;
            if (String.isNotBlank(rec.DeliveryLocationText__c)) {
                locationText = rec.DeliveryLocationText__c;
            }
            return JEOLUtil.createTextLines(locationText, 20, 3);
        }
        
        public List<String> getCustomerQuotationRequestedNo() {
            return JEOLUtil.createTextLines(rec.CustomerQuotationRequestedNo__c, 20, 3);
        }
        
        public List<String> getDeliveryCondition() {
            String conditionText = '';
            if (String.isNotBlank(rec.DeliveryCondition2__c)) {
                conditionText = rec.DeliveryCondition2__c;
            }
            return JEOLUtil.createTextLines(conditionText, 20, 3);
        }
        
        public List<String> getDeliveryPeriod() {
            String deliveryText = '';
            Decimal period = rec.DeliveryPeriod__c;
            if (period != null && period != 0) {
                deliveryText = period.format();
                if (UserInfo.getLanguage() != 'ja') {
                    deliveryText += ' ';
                }
                deliveryText += Label.JEOL_QuotPrint_Label_Month;
            }
            if (rec.DeliveryDeadline__c != null) {
                deliveryText = this.getDateFormat(rec.DeliveryDeadline__c);
            }
            if (String.isNotBlank(rec.DeliveryDate_Arbitrarily__c)) {
                deliveryText = rec.DeliveryDate_Arbitrarily__c;
            }
            return JEOLUtil.createTextLines(deliveryText, 20, 3);
        }
        public List<String> getPaymentCondition() {
            String paymentText = rec.PaymentConditionSection__c;
            if (String.isNotBlank(rec.PaymentConditionText__c)) {
                paymentText = rec.PaymentConditionText__c;
            }
            return JEOLUtil.createTextLines(paymentText, 20, 3);
        }
        public List<String> getQuotationVlidityPeriod() {
            String validityPeriod = '';
            Decimal period = rec.QuoteValidityPeriod__c;
            if (period != null && period != 0) {
                validityPeriod = String.valueOf(period);

                if (UserInfo.getLanguage() != 'ja') {
                    validityPeriod += ' ';
                }
                validityPeriod += Label.JEOL_QuotPrint_Label_Month;
            }
            if (rec.QuoteExpirationDate__c != null) {
                validityPeriod = this.getDateFormat(rec.QuoteExpirationDate__c);
            }
            if (String.isNotBlank(rec.quoteExpirationDate_Arbitrarily__c)) {
                validityPeriod = rec.quoteExpirationDate_Arbitrarily__c;
            }
            return JEOLUtil.createTextLines(validityPeriod, 20, 3);
        }
        public String getQuotationRequestDate() {
            String requestDate = '';
            if (rec.QuotationRequestedDate__c != null) {
                requestDate = this.getDateFormat(rec.QuotationRequestedDate__c);
            }
            return requestDate;
        }
        public String getIssueDate() {
            String issueDateText;
            if (UserInfo.getLanguage() != 'ja') {
                issueDateText = '/　　　/　　　';
            } else {
                issueDateText = '年　　月　　日';
            }

            if (rec.IssueDate__c != null) {
                issueDateText = this.getDateFormat(rec.IssueDate__c);
            }
            return issueDateText;
        }
        public Integer getColspan() {
            Integer colspan = 1;
            if (rec.ProductCodeExpress__c) {colspan++;}
            if (rec.PriceExpress__c) {colspan++;}
            return colspan;
        }
        
        private String getDateFormat(Date value) {
            String year = null;
            if (this.isJapaneseEraOutput) {
                Map<String, String> eraData = JEOLUtil.getJapaneseEraData(value);
                if (eraData.containsKey('name') && eraData.containsKey('year')) {
                    year = eraData.get('name') + '　' + eraData.get('year');
                } else {
                    year = String.valueOf(value.year());
                }
            } else {
                year = String.valueOf(value.year());
            }
            String month = String.valueOf(value.month());
            if (month.length() < 2) {
                month = ' ' + month;
            }
            String day = String.valueOf(value.day());
            if (day.length() < 2) {
                day = ' ' + day;
            }
            if (UserInfo.getLanguage() != 'ja') {
                return year + ' / ' + month + ' / ' + day;
            } else {
                return year + '年　' + month + '月　' + day + '日';
            }
        }
    }
    public class QuotationDetail {
        public QuotationDetailInformation__c rec{get; set;}
        public List<String> bodyLines{get; set;}
        private Boolean isDisplayDecimal;

        public QuotationDetail(QuotationDetailInformation__c detail, Integer bodyTextSize, Boolean displayDecimal) {
            this.rec = detail;
            this.isDisplayDecimal = displayDecimal;
            String bodyText = detail.body__c;
            if (bodyText != null && bodyText.startsWith('{{{{')) {
                bodyText = bodyText.substring(4);
            }
            this.bodyLines = JEOLUtil.createTextLines(bodyText, bodyTextSize - Integer.valueOf(detail.depth__c));
        }
        public String getQuantityFormat() {
            Decimal quantity = this.rec.Quantity__c;
            String ret = null;
            if (quantity != null && quantity != 0) { //Modification-VAIB (2015/05/29 UAT_QA_List No.87)
                //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.xx)
                String quantityText = String.valueOf(quantity);
                if(!this.isDisplayDecimal)
                    ret = quantityText;
                else
                {
                    List<String> numberParts = quantityText.split('(\\.)',2);
                    if (numberParts.size() > 1 && numberParts[1].isNumeric() && Integer.valueOf(numberParts[1]) == 0) {
                        ret = numberParts[0];
                    } else {
                        ret = quantityText;
                    }
                }
                //Modification-VAIB-End(2015/05/21 UAT_QA_List No.xx)
            }
            //Modification-VAIB (2015/05/29 UAT_QA_List No.87) 
            /*else {
                ret = '0';
            }*/
            return ret;
        }
        public Integer getLineSize() {
            Integer lineSize = this.bodyLines.size();
            if (lineSize <= 0) {
                lineSize = 1;
            }
            return lineSize;
        }

        //Modification-VAIB-Begins(2015/05/28 UAT_QA_List No.81)
        public Boolean getIsProductCodeStartsWithNumber()
        {
            if(this.rec == null) return false;

            String productCode = this.rec.productCode__c;
            if(productCode == null) return false;

            List<String> productCodeArray = productCode.Split('');
            if(productCodeArray.size() <1) return false;

            Pattern isnumbers = Pattern.Compile('^[-]?[0-9]+$');
            Matcher numberMatch = isnumbers.matcher(productCodeArray[1]);
            if(numberMatch.matches())
                return true;
            else
                return false;
        }
        //Modification-VAIB-Ends(2015/05/28 UAT_QA_List No.81)
    }

    public Integer getPageSize() {
        Integer pageSize = 0;
        if (this.pdfPages != null) {
            pageSize = this.pdfPages.size();
        }
        return pageSize;
    }

}