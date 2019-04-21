public with sharing class JEOL_QuotationCertificationPrintPageCtrl {
    public List<PageBlock> pdfPages{get; set;}
    public String outputType{get; set;}
    public String renderTarget{get; set;}
    public Boolean isShowPriceExpress{get; set;}
    public String departmentOutputText {get; set;}
    
    public static final Integer MAX_LINE_SIZE_FIRST = 16;
    public static final Integer MAX_LINE_SIZE = 39;

    public JEOL_QuotationCertificationPrintPageCtrl() {
        Map<String, String> params = Apexpages.currentPage().getParameters();
        String recId = params.get('id');
        if (params.containsKey('preview') && String.isNotBlank(params.get('preview'))) {
            outputType = 'preview';
        }
        if (params.containsKey('print') && String.isNotBlank(params.get('print'))) {
            outputType = 'print';
        }
        if (outputType == 'print') {
            renderTarget = 'pdf';
        }
        String targetId = null;
        if (params.containsKey('id') && String.isNotBlank(params.get('id'))) {
            targetId = params.get('id') ;
        }
        this.pdfPages = createPdfData(targetId);
    }
    public Integer getPageSize() {
        Integer pageSize = 0;
        if (this.pdfPages != null) {
            pageSize = this.pdfPages.size();
        }
        return pageSize;
    }
    
    private List<PageBlock> createPdfData(String targetId) {
        List<PageBlock> pages = null;
        List<QuotationInformation__c> recs = [
                SELECT
                    Id, ContractName1__c, ContractName2__c, ShipmentName1__c, ShipmentName2__c, Addressee__c, Addressee2__c, CustomerExpress__c,
                    PostalCode__c, AddressLine1__c, AddressLine2__c, AddressLine3__c, OrgName__c, Fax__c, Phone__c, SalesArea__c,
                    SupervisorName__c, SupervisorPosition__c, CalendarExpress__c, DirectSalesExpress__c,
                    DirectSalesSheetIssueDate__c, RegulerPriceExpress__c, RegulerPriceSheetIssueDate__c,
                    RegulerPriceCommentExpress__c, OverrideDepartmentOutputText__c, DepartmentOutput__c, RepresentativeNameExpress__c
                FROM
                    QuotationInformation__c
                WHERE
                    Id =: targetId
        ];
        QuotationInformation__c targetRec = null;
        if (recs != null && recs.size() > 0) {
            targetRec = recs.get(0);
        }
        if (targetRec != null) {

            List<QuotationDetailInformation__c> detailRecs = [
                    SELECT
                        Id, Name, Body__c, Type__c, Depth__c, SortNo__c, Quantity__c,
                        QuantityUnit__c, Amount__c, CertificationExpress__c
                    FROM 
                        QuotationDetailInformation__c
                    WHERE
                        CertificationExpress__c = true
                        AND
                        Parent__c =: targetRec.id
                    ORDER BY
                        SortNo__c, Depth__c 
            ];
            Pageblock firstpage = new Pageblock(targetRec);
            firstpage.isFirst = true;

            pages = new List<Pageblock>();
            Pageblock currentPage = firstpage ;
            pages.add(currentPage);
            Integer totalLineSize = 0;
            Integer pageNo = 1;
            currentPage.pageNo = pageNo;
            Integer maxLieSize = MAX_LINE_SIZE_FIRST;
            
            // Add 2 rows if the Responsible is hidden
            if (!targetRec.RepresentativeNameExpress__c) {
                totalLineSize -= 2;
            }
            for (QuotationDetailInformation__c rec: detailRecs) {
                PageBlockDetail detail = new PageBlockDetail(rec, maxLieSize);
                Integer currentDetailLineSize = detail.getLineSize();
                system.debug('XXXXXXXXXXXcurrentDetailLineSize:' + currentDetailLineSize);
                if ((currentDetailLineSize + totalLineSize > MAX_LINE_SIZE_FIRST && currentPage.isFirst) || currentDetailLineSize + totalLineSize > MAX_LINE_SIZE) {
                    pageNo++;
                    currentPage = new PageBlock(targetRec);
                    currentPage.pageNo = pageNo;
                    pages.add(currentPage);
                    totalLineSize = 0;
                    maxLieSize = MAX_LINE_SIZE;
                }
                currentPage.push(detail);
                totalLineSize += currentDetailLineSize;
            }
            currentPage.isLast = true;
            //Modification-VAIB-Begin(2015/05/21 UAT_QA_List No.44)
            this.departmentOutputText = (targetRec.DepartmentOutput__c)? targetRec.OverrideDepartmentOutputText__c : targetRec.SalesArea__c;
            //Modification-VAIB-End(2015/05/21 UAT_QA_List No.44)
        }
        return pages;
    }
    public class PageBlock {
        public QuotationInformation__c rec{get; set;}
        private List<PageBlockDetail> details = new List<PageBlockDetail>();
        public Integer pageNo{get; set;}
        public Boolean isFirst{get; set;}
        public Boolean isLast{get; set;}
        
        public PageBlock(QuotationInformation__c rec) {
            if (rec == null) {
                rec = new QuotationInformation__c();
            }
            this.rec = rec;
            this.isFirst = false;
            this.isLast = false;
        }
        
        public void push(PageBlockDetail detail) {
            if (detail != null) {
                this.details.add(detail);
            }
        }
        public List<PageBlockDetail> getDetails() {
            return this.details;
        }
        public Integer detailSize() {
            return this.details.size();
        }

    
        public String getCustomerName() {
    
            String ret = '';
            
            String tmp = '';
            String addressee = '';
            if (this.rec.Addressee__c != null && this.rec.Addressee__c.length() > 0) {
                addressee = ' ' + this.rec.Addressee__c;
            }
                    
            if (this.rec.CustomerExpress__c == '契約先') {
                if (this.rec.ContractName1__c != null && this.rec.ContractName1__c.length() > 0) {
                    tmp += this.rec.ContractName1__c;
                }
            } else if (this.rec.CustomerExpress__c == '納入先') {
                if (this.rec.ShipmentName1__c != null && this.rec.ShipmentName1__c.length() > 0) {
                    tmp += this.rec.ShipmentName1__c;
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
            if (this.rec.Addressee__c != null && this.rec.Addressee__c.length() > 0) {
                addressee = ' ' + this.rec.Addressee__c;
            }
    
            if (this.rec.CustomerExpress__c == '契約先') {
                if (this.rec.ContractName1__c != null && this.rec.ContractName1__c.length() > 0) {
                    tmp += this.rec.ContractName1__c;
                }
            } else if (this.rec.CustomerExpress__c == '納入先') {
                if (this.rec.ShipmentName1__c != null && this.rec.ShipmentName1__c.length() > 0) {
                    tmp += this.rec.ShipmentName1__c;
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
            if (this.rec.Addressee2__c != null && this.rec.Addressee2__c.length() > 0) {
                addressee2 = ' ' + this.rec.Addressee2__c;
            }
    
            if (this.rec.CustomerExpress__c == '契約先') {
                if (this.rec.ContractName2__c != null && this.rec.ContractName2__c.length() > 0) {
                    tmp += this.rec.ContractName2__c;
                }
            } else if (this.rec.CustomerExpress__c == '納入先') {
                if (this.rec.ShipmentName2__c != null && this.rec.ShipmentName2__c.length() > 0) {
                    tmp += this.rec.ShipmentName2__c;
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
        
        public String getDirectSalesIssueDate() {
            String issueDateText = '年　　月　　日';
            if (this.rec.DirectSalesExpress__c && this.rec.DirectSalesSheetIssueDate__c != null) {
                issueDateText = this.getDateFormat(this.rec.DirectSalesSheetIssueDate__c);
            }
            return issueDateText;
        }
        public String getRegulerPriceIssueDate() {
            String issueDateText = '年　　月　　日';
            if (this.rec.RegulerPriceExpress__c && this.rec.RegulerPriceSheetIssueDate__c != null) {
                issueDateText = this.getDateFormat(this.rec.RegulerPriceSheetIssueDate__c);
            }
            return issueDateText;
        }

        private String getDateFormat(Date value) {
            String year = null;
            if (this.rec.CalendarExpress__c == '和暦') {
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
            return year + '年　' + month + '月　' + day + '日';
        }
    }
    
    public class PageBlockDetail {
        public QuotationDetailInformation__c rec{get; set;}
        public List<String> bodyLines {get; set;} 
        
        public PageBlockDetail(QuotationDetailInformation__c rec, Integer maxLineSize) {
            if (rec == null) {
                rec = new QuotationDetailInformation__c();
            }
            String bodyText = rec.body__c;
            if (bodyText != null && bodyText.startsWith('{{{{')) {
                bodyText = bodyText.substring(4);
            }
            this.bodyLines = JEOLUtil.createTextLines(bodyText, 24, maxLineSize);
            this.rec = rec;
        }
        public String getQuantityFormat() {
            Decimal quantity = this.rec.Quantity__c;
            String ret = null;
            if (quantity != null && quantity != 0) { //Modification-VAIB (2015/05/29 UAT_QA_List No.87)
                String quantityText = String.valueOf(quantity);
                List<String> numberParts = quantityText.split('(\\.)',2);
                if (numberParts.size() > 1 && numberParts[1].isNumeric() && Integer.valueOf(numberParts[1]) == 0) {
                    ret = numberParts[0];
                } else {
                    ret = quantityText;
                }
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
    }

}