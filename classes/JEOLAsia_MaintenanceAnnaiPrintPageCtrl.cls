public with sharing class JEOLAsia_MaintenanceAnnaiPrintPageCtrl {
	public List<PageBlock> pdfPages{get; set;}
    public String outputType{get; set;}
    public String renderTarget{get; set;}
    //
    public AsiaMaintenanceContractManagement__c rec {get;set;}
    public SalesOrder__c prevSalesOrder {get; set;}
    public Account renewalAccount {get; set;}

    public String blankDate {get;set;}
    //

    public static final Integer MAX_LINE_SIZE_FIRST = 22;
    public static final Integer MAX_LINE_SIZE = 42;
    public static final Integer BASE_TEXT_LENGTH = 17;
    public JEOLAsia_MaintenanceAnnaiPrintPageCtrl() {
		Map<String, String> params = Apexpages.currentPage().getParameters();
        String recId = params.get('id');
        outputType = 'print';
        if (params.containsKey('preview') && String.isNotBlank(params.get('preview'))) {
            outputType = 'preview';
        }
        if (params.containsKey('print') && String.isNotBlank(params.get('print'))) {
            outputType = 'print';
        }
        if (outputType == 'print') {
            renderTarget = 'pdf';
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
        public Integer pageNo{get; set;}

        public PageBlock() {
            this.isFirst = false;
            this.isLast = false;
            this.isShowTotal = false;
            this.isAccompanyingPaper = false;
            this.isShowNote = false;
            this.isShowNoteLabel = false;
            this.head = null;
            this.pageNo = 1;
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
            return (this.noteTextLines != NULL && this.noteTextLines.size() > 0);
        }

    }

    public class QuotationHeader {
        public String CompanyAddress{get; set;}
        public AsiaMaintenanceContractManagement__c rec{get; set;}
        public List<String> quotatinNameLines{get; set;}
        public List<String> noteTextLines{get; set;}
        public List<String> otherTextLines{get; set;}

        public QuotationHeader(AsiaMaintenanceContractManagement__c quotation) {
            this.rec = quotation;

                // Just create a data with 1 line and a dummy data
                this.quotatinNameLines =  new List<String>();
                this.quotatinNameLines.add('DUMMY');

            this.CompanyAddress = '';
        }
    }
}