public with sharing class JEOL_QuotationDestinationPrintPageCtrl {
    public String outputType{get; set;}
    public String renderTarget{get; set;}
    public PageBlock pdfData{get; set;}
    
    public JEOL_QuotationDestinationPrintPageCtrl() {
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
        this.pdfData = createPdfData(recId);
    }
    
    private PageBlock createPdfData(String rec) {
        List<QuotationInformation__c> recs = [
            SELECT
                Id, GuideSheetPrint__c, DestinationUndergraduate__c, DestinationNameTitle__c,
                DestinationGuideSubject__c, DestinationAccountCode__c, DestinationAccountName__c, DestinationName__c,
                DestinationAddress__c, DestinationBelong__c, DestinationPersonInCharge__c, DestinationGuideDate__c,
                DestinationPostalCode__c, PostalCode__c, Address__c, AddressLine1__c, AddressLine2__c, AddressLine3__c, Phone__c, Fax__c, SalesPerson__r.Phone,
                SalesPerson__r.Fax, SalesArea__c, OrgName__c
            FROM
                QuotationInformation__c
            WHERE
                Id =: rec
        ];
        QuotationInformation__c targetQuote = null;
        if (recs != null && recs.size() > 0) {
            targetQuote = recs.get(0);

            if (targetQuote.DestinationAddress__c != null && !String.isBlank(targetQuote.DestinationAddress__c) && targetQuote.DestinationAddress__c.length() > 0)
            {
                String sAddress = '';
                For (Integer i = 0; i < targetQuote.DestinationAddress__c.length(); i++)
                {
                    sAddress = sAddress + '<span>' + targetQuote.DestinationAddress__c.substring(i, i+1) + '</span>';
                }
                targetQuote.DestinationAddress__c = sAddress;
            }
            
        }
        return new PageBlock(targetQuote);
    }
    
    
    public class PageBlock {
        public QuotationInformation__c rec{get; set;}
        public PageBlock(QuotationInformation__c record) {
            if (record == null) {
                record = new QuotationInformation__c();
            }
            this.rec = record;
        } 
        
        public List<String> getBodyLines() {
            return JEOLUtil.createTextLines(rec.DestinationGuideSubject__c, 40, 10);
        }
        public String getDestinationGuideDate() {
            String destinationGuideDateText = '年　　月　　日';
            if (rec.DestinationGuideDate__c != null) {
                destinationGuideDateText = this.getDateFormat(rec.DestinationGuideDate__c);
            }
            return destinationGuideDateText;
        }
        private String getDateFormat(Date value) {
            String year = null;
            Map<String, String> eraData = JEOLUtil.getJapaneseEraData(value);
            if (eraData.containsKey('name') && eraData.containsKey('year')) {
                year = eraData.get('name') + '　' + eraData.get('year');
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

}