/*
 * Create    : Jun.1,2016 by Zhu (Voxer)
 * Class Name:JEOLAsia_QuotationPrintPageCtrl
 * Descripte :output pdf for per product
 * ====================Changed History===============================
 * =====      Date    =====  method Name  =====  By   ===============
 * ===== July 26, 2016       All               someone
 * ==================================================================
 */
public with sharing class JEOLAsia_QuotationPrintPageCtrl {

    // PDFに一行に各文字の出力数(Detail)
    private Map<String, Integer> mapCharWidthDetail = new Map<String, Integer>{
        '™' => 48 ,
        '©' => 61 ,
        ' ' => 186,
        ' ' => 186,
        'a' => 106,
        'A' => 65 ,
        'b' => 94 ,
        'B' => 70 ,
        'c' => 106,
        'C' => 70 ,
        'd' => 94 ,
        'D' => 65 ,
        'e' => 106,
        'E' => 77 ,
        'f' => 141,
        'F' => 85 ,
        'g' => 94 ,
        'G' => 65 ,
        'h' => 94 ,
        'H' => 65 ,
        'i' => 169,
        'I' => 141,
        'j' => 169,
        'J' => 121,
        'k' => 94 ,
        'K' => 65 ,
        'l' => 169,
        'L' => 77 ,
        'm' => 60 ,
        'M' => 53 ,
        'n' => 94 ,
        'N' => 65 ,
        'o' => 94 ,
        'O' => 65 ,
        'p' => 94 ,
        'P' => 85 ,
        'q' => 94 ,
        'Q' => 65 ,
        'r' => 140,
        'R' => 70 ,
        's' => 120,
        'S' => 84 ,
        't' => 169,
        'T' => 77 ,
        'u' => 94 ,
        'U' => 65 ,
        'v' => 94 ,
        'V' => 65 ,
        'w' => 65 ,
        'W' => 50 ,
        'x' => 94 ,
        'X' => 65 ,
        'y' => 94 ,
        'Y' => 65 ,
        'z' => 106,
        'Z' => 77 ,
        '1' => 94 ,
        '2' => 94 ,
        '3' => 94 ,
        '4' => 94 ,
        '5' => 94 ,
        '6' => 94 ,
        '7' => 94 ,
        '8' => 94 ,
        '9' => 94 ,
        '0' => 94 ,
        '!' => 141,
        '"' => 115,
        '#' => 94 ,
        '$' => 94 ,
        '%' => 56 ,
        '&' => 60 ,
        '(' => 141,
        '-' => 141,
        '=' => 83 ,
        '^' => 100,
        '~' => 87 ,
        '\\' => 169,
        '|' => 235,
        '@' => 51 ,
        '`' => 141,
        '[' => 141,
        '{' => 98 ,
        ';' => 169,
        '+' => 83 ,
        ':' => 169,
        '*' => 94 ,
        ']' => 141,
        '}' => 98 ,
        ',' => 188,
        '<' => 83 ,
        '.' => 188,
        '>' => 83 ,
        '/' => 169,
        '?' => 106,
        '_' => 94 ,
        'default' => 50 };

    // PDFに一行に各文字の出力数(Terms)
    private Map<String, Integer> mapCharWidthTerms = new Map<String, Integer>{
        '™' => 41 ,
        '©' => 53 ,
        ' ' => 160,
        ' ' => 160,
        'a' => 92 ,
        'A' => 57 ,
        'b' => 82 ,
        'B' => 61 ,
        'c' => 93 ,
        'C' => 62 ,
        'd' => 82 ,
        'D' => 57 ,
        'e' => 93 ,
        'E' => 67 ,
        'f' => 123,
        'F' => 74 ,
        'g' => 82 ,
        'G' => 57 ,
        'h' => 82 ,
        'H' => 57 ,
        'i' => 148,
        'I' => 123,
        'j' => 148,
        'J' => 106,
        'k' => 82 ,
        'K' => 57 ,
        'l' => 147,
        'L' => 67 ,
        'm' => 53 ,
        'M' => 46 ,
        'n' => 82 ,
        'N' => 57 ,
        'o' => 82 ,
        'O' => 57 ,
        'p' => 82 ,
        'P' => 74 ,
        'q' => 82 ,
        'Q' => 57 ,
        'r' => 123,
        'R' => 62 ,
        's' => 106,
        'S' => 74 ,
        't' => 148,
        'T' => 67 ,
        'u' => 82 ,
        'U' => 56 ,
        'v' => 81 ,
        'V' => 56 ,
        'w' => 56 ,
        'W' => 43 ,
        'x' => 81 ,
        'X' => 56 ,
        'y' => 81 ,
        'Y' => 56 ,
        'z' => 92 ,
        'Z' => 67 ,
        '1' => 80 ,
        '2' => 80 ,
        '3' => 80 ,
        '4' => 80 ,
        '5' => 80 ,
        '6' => 80 ,
        '7' => 80 ,
        '8' => 80 ,
        '9' => 80 ,
        '0' => 80 ,
        '!' => 120,
        '"' => 48 ,
        '#' => 80 ,
        '$' => 80 ,
        '%' => 48 ,
        '&' => 52 ,
        '(' => 121,
        '-' => 120,
        '=' => 71 ,
        '^' => 85 ,
        '~' => 74 ,
        '\\' => 144,
        '|' => 200,
        '@' => 44 ,
        '`' => 121,
        '[' => 121,
        '{' => 84 ,
        ';' => 146,
        '+' => 72 ,
        ':' => 146,
        '*' => 81 ,
        ']' => 122,
        '}' => 85 ,
        ',' => 163,
        '<' => 72 ,
        '.' => 163,
        '>' => 72 ,
        '/' => 146,
        '?' => 91 ,
        '_' => 81 ,
        'default' => 40 };

    // Control variable
    public String outputType {get; set;}
    public String renderTarget {get; set;}
    public String language {get; set;}
    public Boolean isError {get; set;}
    public String errorMsg {get; set;}
    public String userName {get; set;}
    public String userTitle {get; set;}
    public User userDetail {get; set;}
    public Integer section2row {get; set;}
    public Integer section2LastPageNo {get; set;}
    public Integer section3row {get; set;}
    public Integer section2Margin {get;set;}
    public Integer userSignHeight {get;set;}
    public Integer forcePageBreakCount {get;set;}

    // PDFにおけるページ表示対象のトータルページ数
    // - この値をPDFにおけるページ表示対象のトータルページ数として表示している。
    //
    // - 理想的なのはCSSの count(pages) を利用することだが、
    // - 「ページ表示対象」でないとトータルページ数にカウントしてはならないという制約がある為に
    // - ロジックで無理矢理算出している。
    //
    // - 本質的にはレンダリングされるまで最大ページ数は分からない。
    public Integer totalPageNumber {get;set;}

    /** Constant variable*/

    // This is THE Magic Number
    // - スペック情報における1ページにおける最大行数を表す
    // - 実際にはレンダリングされるまで何行表示できるかは分からないので
    // - この数値に達するまでに改行が起きている場合はこの値を減らす必要がある。
    public static final Integer MAX_LINE_SIZE = 56;

    // スペック情報における強制改ページ用 タグ文字列
    // - 画面側ではこの文字列が存在した場合に、強制改ページを行っている
    private static final String PAGE_BREAK_TAG = '$PageBreak$';
    public String pageBreakTag {
        get { return PAGE_BREAK_TAG; }
    }

    public static final String ERROR_MESSAGE = 'An unexpected error occured.';
    private static final String CR = '<br>';
    private static final String NT = '\r\n';
    private static final String NT2 = '\n';
    public static final String PARAM_ID = 'id';
    // Spare Parts
    public List<SpPageBlock> spPageBlockList {get; set;}
    //page break control
    private static final Integer S1A_HEIGHT = 20;// section1 table A height
    private static final Integer S1B_1_PER_ROW_HEIGHT = 10;// section1 table B heigtht patter1:has cover page
    private static final Integer S1B_2_HEIGHT = 71;// section1 table B heigtht patter2:no cover page
    private static final Integer S1B_3_HEIGHT = 67;// section1 table B heigtht patter3:no no sales man Tel
    private static final Integer SECTION2_MAGIN = 2;// section2 margin top and bottom height
    private static final Integer USERSIGN_HEIGHT = 25;// user sign area height
    public List<FirstPageBlock> pageBlockList{get;set;}
    // per page : per row byte limit
    // with spec row limit lenght
    private static final Integer MAXBYTE = 80;
    // only rich text row limit lenght
    private static final Integer ROWLENGHT = 80;

    /**Page block　variable group*/

    // base parent
    public AsiaProfitCalculation__c quotation {get; set;}

    // Terms And Conditions Of sale
    public List<AsiaTermsAndConditons__c> lsTermsAndConditions {get; set;}

    // base parent's first child: no recommend
    public List<PageBlock> noRecommendedPageBlockList {get; set;}
    public List<AsiaProfitCalculationDetail__c> noRecommendedQuotationDetailList {get; set;}

    // Spec情報表示用 PageBlock List
    public List<PageBlock> noRecommendedSpecPageBlockList {get; set;}
    public List<PageBlock> recommendedSpecPageBlockList {get; set;}

    // base parent's second child: recomment
    public List<PageBlock> recommendedPageBlockList {get; set;}
    public List<AsiaProfitCalculationDetail__c> recommendedQuotationDetailList {get; set;}

    // base parent's third child: terms & conditons
    public AsiaQuotationTermsConditions__c quotTC {get; set;}

    public String productName {get; set;}
    public String modelType {get; set;}

    // User Sing Img URL
    public String imgURL {get; set;}
    public String userSignURL {get; set;}
    public Map<Id,List<String>> noRecommendBodyMap {get; set;}
    public Map<Id,List<String>> noRecommendModelTypeMap {get; set;}
    public Map<Id,List<String>> recommendBodyMap {get; set;}
    public Map<Id,List<String>> recommendModelTypeMap {get; set;}
    public List<String> modelTypeDisplay1List {get; set;}
    public String modelTypeDisplay2 {get; set;}
    public String modelTypeDisplay3 {get; set;}

    // SpecificationMap (コンストラクタ内で設定)
    // - AsiaProductItemSpecification__c の <ModelType__c, Specification__c>
    private Map<String, String> itemSpecificationMap;

    // Constructor
    public JEOLAsia_QuotationPrintPageCtrl() {
        try{
            // Variable init
            this.language = UserInfo.getLanguage();
            this.isError = false;
            this.section2Margin = SECTION2_MAGIN;
            this.userSignHeight = USERSIGN_HEIGHT;
            this.section2row = 0;
            this.section2LastPageNo = 0;
            this.section3row = 0;
            this.forcePageBreakCount = 0;

system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 1');

            Map<String, String> params = Apexpages.currentPage().getParameters();
            String quotationId = params.get(PARAM_ID);

            // Guard Clause
            if(String.isEmpty(quotationId)){
                this.outputType = 'preview';
                if (this.outputType == 'preview') {
                    this.renderTarget = '';
                }
                this.isError = true;
                this.errorMsg = 'Quotation Id : is Required';
                return;
            }

system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 2');

            // get base parent's third child record
            List<String> quotTCFieldList = new List<String>();
            String queryquotTC = getSelectAllQuery('AsiaQuotationTermsConditions__c',
                                                   'WHERE ProfitCalculation__c=\''+ quotationId + '\'',
                                                    false,
                                                    quotTCFieldList);
            this.quotTC = this.getQuotTC(queryquotTC);

            this.outputType = 'print';
            if (this.outputType == 'print') {
                this.renderTarget = 'pdf';
            }

system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 3');

            // Quotation(Base Parent record)
            List<String> qutationFieldList = new List<String>();
            qutationFieldList.add('ContractContact_dummyField__r.Name');
            qutationFieldList.add('ContractContact_dummyField__r.Email');
            qutationFieldList.add('ContractAccount__r.Name');
            qutationFieldList.add('ContractAccount__r.OfficialName1__c');
            qutationFieldList.add('ContractAccount__r.Address__c');
            qutationFieldList.add('ContractAccount__r.State__c');
            qutationFieldList.add('ContractAccount__r.PostalCode__c');
            qutationFieldList.add('SalesPerson__r.Name');
            qutationFieldList.add('SalesPerson__r.Email ');
            qutationFieldList.add('SalesPerson__r.Phone');
            qutationFieldList.add('SalesPerson__r.MobilePhone');
            qutationFieldList.add('SalesPerson__r.Title');
            qutationFieldList.add('SalesAssistant__r.Name');
            qutationFieldList.add('SalesAssistant__r.Email');
            qutationFieldList.add('Approver__r.UserSign__c');
            qutationFieldList.add('Approver__r.Email');
            qutationFieldList.add('Approver__r.Name');
            qutationFieldList.add('Approver__r.Title');
            qutationFieldList.add('RecordType.DeveloperName');
            String queryQ = getSelectAllQuery('AsiaProfitCalculation__c', 'WHERE Id=\''+ quotationId + '\'', false, qutationFieldList);
            this.quotation = this.getQuotationRecord(queryQ);
            system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 4');
            // DUC
            getUserSignId();
            system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 5');
            // From here is parent record's child record List(First is no recommend, Second is rocommend)
            // QuotationDetail
            List<String> quotationDetailFieldList = new List<String>();
            quotationDetailFieldList.add(' , (SELECT Id withComma ');
            quotationDetailFieldList.add('Description__c withComma');
            quotationDetailFieldList.add('Quantity__c withComma ');
            quotationDetailFieldList.add('SalesPrice__c withComma ');
            quotationDetailFieldList.add('PartNumber__c withoutComma');
            quotationDetailFieldList.add('FROM Profit_Calculation_2SP_Parts__r withoutComma');
            quotationDetailFieldList.add('WHERE IsSelected__c = true ORDER BY PartNumber__c) withoutComma ');
            // From here is First: no recommend parent's child list and child's child record
            // Query
            system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 6');
            String condition = 'WHERE Parent__c=\''+ quotationId + '\'' + ' AND Category__c IN (\'A\', \'B\')' + 'ORDER BY Category__c, SortNo__c ASC';
            String noRecommendedQueryQD = getSelectAllQuery('AsiaProfitCalculationDetail__c',
                                                            condition,
                                                            false,
                                                            quotationDetailFieldList);
            // Run Query
            this.noRecommendedQuotationDetailList = this.getQuotationDetail(noRecommendedQueryQD);

            if (quotation.TitleRow5__c != NULL && quotation.TitleRow5__c.length() > 0) {
                this.productName = quotation.TitleRow1__c.escapeHtml4() + CR + quotation.TitleRow2__c.escapeHtml4() + CR + quotation.TitleRow3__c.escapeHtml4() + CR + quotation.TitleRow4__c.escapeHtml4() + CR + quotation.TitleRow5__c.escapeHtml4();
            } else if (quotation.TitleRow4__c != NULL && quotation.TitleRow4__c.length() > 0) {
                this.productName = CR + quotation.TitleRow1__c.escapeHtml4() + CR + quotation.TitleRow2__c.escapeHtml4() + CR + quotation.TitleRow3__c.escapeHtml4() + CR + quotation.TitleRow4__c.escapeHtml4();
            } else if (quotation.TitleRow3__c != NULL && quotation.TitleRow3__c.length() > 0) {
                this.productName = CR + CR + quotation.TitleRow1__c.escapeHtml4() + CR + quotation.TitleRow2__c.escapeHtml4() + CR + quotation.TitleRow3__c.escapeHtml4();
            } else if (quotation.TitleRow2__c != NULL && quotation.TitleRow2__c.length() > 0) {
                this.productName = CR + CR + CR + quotation.TitleRow1__c.escapeHtml4() + CR + quotation.TitleRow2__c.escapeHtml4();
            } else if (quotation.TitleRow1__c != NULL && quotation.TitleRow1__c.length() > 0) {
                this.productName = CR + CR + CR + CR + quotation.TitleRow1__c.escapeHtml4();
            } else {
                this.productName = CR + CR + CR + CR + CR;
            }

system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 7');
            if(noRecommendedQuotationDetailList != null && noRecommendedQuotationDetailList.size() > 0){

                // Model Type
                this.modelType = quotation.ModelTypeScreen__c;

                // ModelType Display
                // noRecommendBody　Model Typeの取得
                List<String> modelType1List = textToList(noRecommendedQuotationDetailList[0].ModelType__c, mapCharWidthDetail, Decimal.valueOf(20) / Decimal.valueOf(95));
                List<String> modelType2List = textToList(noRecommendedQuotationDetailList[0].ModelType__c, mapCharWidthDetail, Decimal.valueOf(35) / Decimal.valueOf(95));
                List<String> modelType3List = textToList(noRecommendedQuotationDetailList[0].ModelType__c, mapCharWidthDetail, Decimal.valueOf(35) / Decimal.valueOf(95));
                this.modelTypeDisplay1List = new List<String>();
                if (modelType1List.size() > 0){
                    this.modelTypeDisplay1List.add(modelType1List.get(0));
                }
                if (modelType1List.size() > 1){
                    this.modelTypeDisplay1List.add(modelType1List.get(1));
                }
                this.modelTypeDisplay2 = '';
                if (modelType2List.size() > 0){
                    this.modelTypeDisplay2 = modelType2List.get(0);
                }
                this.modelTypeDisplay3 = '';
                if (modelType3List.size() > 0){
                    this.modelTypeDisplay3 = modelType3List.get(0);
                }

                // AsiaProductItemSpecificationからProduct ImgのＵＲＬを取得する
                List<AsiaProductItemSpecification__c> productImgList =
                    [select id, Product_Img__c from AsiaProductItemSpecification__c where ModelType__c = :modelType];
                if (productImgList.size() > 0){
                    if (productImgList.get(0).Product_Img__c != null) {
                        Integer startpo = productImgList.get(0).Product_Img__c.indexOf('" src="') + 7;
                        Integer endpo = productImgList.get(0).Product_Img__c.indexOf('"', startpo);
                        imgURL = productImgList.get(0).Product_Img__c.substring(startpo, endpo);
                    }
                }

                // スペック情報マップを取得
                // - AsiaProductItemSpecification__c の <ModelType__c, Specification__c>
                this.itemSpecificationMap = JEOLAsia_QuotationSpecificationCtrl.getItemSpecification();

                Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + quotation.Name + '.pdf');
system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 8');
            }else{
                this.modelType = '';
                this.modelTypeDisplay1List = new List<String>();
                this.modelTypeDisplay2 = '';
                this.modelTypeDisplay3 = '';
            }

system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 9');
            // From here is Second : recommend parent's child list and child's child record
            // Query
            condition = 'WHERE Parent__c=\''+ quotationId + '\'' + ' AND Category__c = \'G\'' + 'ORDER BY Category__c, SortNo__c ASC';
            String recommendedQueryQD = getSelectAllQuery('AsiaProfitCalculationDetail__c',
                                                          condition,
                                                          false,
                                                          quotationDetailFieldList);
            // Run Query
            this.recommendedQuotationDetailList = this.getQuotationDetail(recommendedQueryQD);

            // Set first page break
            this.pageBlockList = this.judgePageBlock(this.quotation, this.noRecommendedQuotationDetailList, this.recommendedQuotationDetailList);

            //----------------------------------------------------------------------------------------------------
            // SPECIFICATIONS
            //----------------------------------------------------------------------------------------------------
            this.noRecommendedSpecPageBlockList = new List<PageBlock>();
            this.recommendedSpecPageBlockList = new List<PageBlock>();
            system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 10');
            if (this.quotation.PrintQuotationSpecificationsPage__c) {

                // おすすめ機器以外
                List<AsiaProfitCalculationDetail__c> noRecommendedQuotationDetailList = this.getNoRecommendedQuotationDetailList(quotationId);
                this.noRecommendedSpecPageBlockList = this.createDescriptionPageBlock(noRecommendedQuotationDetailList);

                // おすすめ機器
                List<AsiaProfitCalculationDetail__c> recommendedQuotationDetailList = this.getRecommendedQuotationDetailList(quotationId);
                this.recommendedSpecPageBlockList = this.createDescriptionPageBlock(recommendedQuotationDetailList);
            }

            // SP PARTS DESCRIPTION
            this.spPageBlockList = new List<SpPageBlock>();
            if (this.quotation.Print2SPDetail__c) {
                if(noRecommendedQuotationDetailList != null && noRecommendedQuotationDetailList.size() > 0){
                    this.spPageBlockList = creatSpPageBlock(noRecommendedQuotationDetailList);
                }
            }

system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 11');
            // TERMS AND CONDITIONS OF SALE
            String target = quotation.Company__c;
            if(quotation.TargetMarket__c == '1') {
                target = 'THAILAND';
            }
            this.lsTermsAndConditions = new List<AsiaTermsAndConditons__c>();
            if (this.quotation.PrintJeolTerms__c) {
                this.lsTermsAndConditions = [SELECT Company__c,
                                                    SortNo__c,
                                                    TermsAndConditions__c
                                             FROM AsiaTermsAndConditons__c
                                             WHERE Company__c = :target
                                             ORDER BY SortNo__c
                                            ];
            }
system.debug('JEOLAsia_QuotationPrintPageCtrl CheckPoint 12');
            //----------------------------------------------------------------------------------------------------
            // トータルページ番号設定
            //----------------------------------------------------------------------------------------------------
            this.totalPageNumber = pageBlockList.size()
                                 + noRecommendedSpecPageBlockList.size()
                                 + recommendedSpecPageBlockList.size()
                                 + spPageBlockList.size()
                                 + forcePageBreakCount;

        }catch (QueryException e) {
            throw new JEOLException(e.getMessage());
        }
    }

    // DUC added
    public void getUserSignId(){
        // sign info
        String userId;
        User usr = [SELECT CompanyName FROM User WHERE id = :UserInfo.getUserId()];
        String sCompanyNameProfile = usr.CompanyName;

        system.debug( usr );
        system.debug( sCompanyNameProfile );
        system.debug(  CompanyName__c.getAll().values() );

        for (CompanyName__c companyCustSettings : CompanyName__c.getAll().values()) {
            //if company matched and is Thai's or ASIA
            if(companyCustSettings.Company__c == 'ASIA' &&
                (
                    (quotation.TargetMarket__c == '1' && companyCustSettings.Name.indexOf('THAILAND') >= 0 )||
                    ((quotation.TargetMarket__c == '0' || String.isBlank(quotation.TargetMarket__c)) && companyCustSettings.Name.indexOf('-') < 0 && companyCustSettings.Name.indexOf('ASIA') >= 0)
                )
              ){
                userId = companyCustSettings.QuotationPrintSignUserID__c;
                break;
            }
        }

        system.debug( userId );

        this.userDetail = [SELECT Id, Name, Title, UserSign__c FROM User WHERE Id =:userId];
        User targetUser = [SELECT Id, Name, Division FROM User WHERE Id =:userId];
        if(targetUser != null){
            this.userName = targetUser.Name;
            this.userTitle = targetUser.Division;
        }else {
            this.userName = '';
            this.userTitle = '';
        }

        // User Sign
        if(this.userDetail != null &&
            String.isNotEmpty(this.userDetail.UserSign__c) && this.userDetail.UserSign__c.indexOf('" src="') > 0){
            //tableに表示させる画像URL
            Integer startpo = this.userDetail.UserSign__c.indexOf('" src="') + 7;
            Integer endpo = this.userDetail.UserSign__c.indexOf('"', startpo);

            this.userSignURL = this.userDetail.UserSign__c.substring(startpo, endpo);
        }
    }

    public String getQuotationNoFirstPage() {

        String sReturn = '';

        if (!quotation.PrintProformaInvoice__c) {
            sReturn = quotation.ProfitCalculationNo__c + '_' + quotation.BranchNo__c;
        } else {
            sReturn = quotation.ProfitCalculationNo__c.replace('QT', 'OA') + '_' + quotation.BranchNo__c;
        }

        return sReturn;
    }

    public String getQuotationNoOtherPage() {

        String sReturn = '';

        if (!quotation.PrintProformaInvoice__c) {
            sReturn = quotation.ProfitCalculationNo__c + '_' + quotation.BranchNo__c;
        } else {
            sReturn = quotation.ProfitCalculationNo__c.replace('QT', 'PI') + '_' + quotation.BranchNo__c;
        }

        return sReturn;
    }

    public String getQuotationValidityLabel() {

        String sReturn = '';

        if (quotation.QuoteExpirationDate__c != null) {

            sReturn = sReturn + 'until ' + Datetime.newInstance(quotation.QuoteExpirationDate__c.year(), quotation.QuoteExpirationDate__c.month(), quotation.QuoteExpirationDate__c.day()).format('dd/MMM/yyyy');

        } else if (quotation.QuoteValidityPeriodDays__c != null && quotation.QuoteValidityPeriodDays__c > 0) {

            sReturn = sReturn + 'for ' + quotation.QuoteValidityPeriodDays__c + ' day' + (quotation.QuoteValidityPeriodDays__c <= 1 ? '' : 's');

        } else {

            sReturn = sReturn + 'for ' + quotation.QuoteValidityPeriod__c + ' month' + (quotation.QuoteValidityPeriod__c <= 1 ? '' : 's');

        }

        return sReturn;
    }

    public String getPaymentTermsLabel() {
        String result = '';
        if (String.isNotEmpty(quotation.PaymentConditionTextarea__c)){
            String targetStr = '';
            targetStr = quotation.PaymentConditionTextarea__c;
            targetStr = targetStr.replace('　', ' ');
            targetStr = targetStr.replace(' ', ' ');
            targetStr = targetStr.replace(NT2, NT);
            List<String> lineList = targetStr.split(NT);
            for(String strLine : lineList){
                List<String> subLineList = stringToTangoList(mapCharWidthTerms, strLine, null);
                for (String strSubLine : subLineList){
                    result = result + strSubLine.replace(' ', '&nbsp;').replace('<', '&lt;').replace('>', '&gt;') + '<br/>';
                }
            }
        } else {
            if(quotation.PaymentConditionSection__c != null && quotation.PaymentConditionSection__c != ''){
                result = quotation.PaymentConditionSection__c.replace(' | ', '<br/>');
            }else{
                result = '';
            }
        }

        return result;
    }

    public Integer getCospanCol1(){
        // init section 2 coloums is 6
        Integer disColspanQty = 6;
        if(quotation != null){
            if(!quotation.PrintQuantityUnit__c){
                disColspanQty -= 1;
            }
            if(!quotation.PrintUnitPrice__c){
                disColspanQty -= 1;
            }
            if(quotation.PrintNotDetailAmounts__c){
                disColspanQty -= 1;
            }
        }
        return disColspanQty;
    }

    public Integer getCospanCol2(){
        // init section 4 coloums is 5
        Integer disColspanQty = 5;
        if(quotation != null){
            if(!quotation.PrintQuantityUnit__c){
                disColspanQty -= 1;
            }
            if(!quotation.PrintUnitPrice__c){
                disColspanQty -= 1;
            }
            if(quotation.PrintNotDetailAmounts__c){
                disColspanQty -= 1;
            }
        }
        return disColspanQty;
    }

    public Integer getCospanCol3(){
        // init section 4 coloums is 5
        Integer disColspanQty = 6;
        if(quotation != null){
            if(!quotation.PrintQuantityUnit__c){
                disColspanQty -= 1;
            }
            if(!quotation.PrintUnitPrice__c){
                disColspanQty -= 1;
            }
        }
        return disColspanQty - 2;
    }

    public Integer getCospanCol4(){
        // init section 2 coloums with checkbox is 3
        Integer disColspanQty = 1;
        if(quotation != null){
            if(quotation.PrintQuantityUnit__c){
                disColspanQty += 1;
            }
            if(quotation.PrintUnitPrice__c){
                disColspanQty += 1;
            }
            if(!quotation.PrintNotDetailAmounts__c){
                disColspanQty += 1;
            }
        }
        return disColspanQty;
    }

    public String getContractName() {
        String result = '';

        if (String.isNotEmpty(quotation.ContractName1__c) || String.isNotEmpty(quotation.ContractName2__c)){
            String strBR ='';
            if (String.isNotEmpty(quotation.ContractName1__c)) {
                result = result + quotation.ContractName1__c;
                strBR = '<br/>';
            }
            if (String.isNotEmpty(quotation.ContractName2__c)) {
                result = result + strBR + quotation.ContractName2__c;
            }
        } else {
            if (String.isNotEmpty(quotation.ContractName__c)) {
                result = quotation.ContractName__c;
            }
        }

        return result;
    }
    public Boolean getShipmentNameDispFlg() {
        if (quotation.ShipmentName__c == quotation.ContractName__c &&
            quotation.ShipmentName1__c == quotation.ContractName1__c &&
            quotation.ShipmentName2__c == quotation.ContractName2__c){
            return false;
        }
        return true;
    }

    public String getShipmentName() {
        String result = '';
        if (String.isNotEmpty(quotation.ShipmentName1__c) || String.isNotEmpty(quotation.ShipmentName2__c)){
            String strBR ='';
            if (String.isNotEmpty(quotation.ShipmentName1__c)) {
                result = result + quotation.ShipmentName1__c;
                strBR = '<br/>';
            }
            if (String.isNotEmpty(quotation.ShipmentName2__c)) {
                result = result + strBR + quotation.ShipmentName2__c;
            }
        } else {
            if (String.isNotEmpty(quotation.ShipmentName__c)) {
                result = quotation.ShipmentName__c;
            }
        }

        return result;
    }

    /**
     * [Get Target Quotation Record]
     * @param  targetQuery [All Field Query String]
     * @return             [Target Quotation Record]
     */
    private AsiaProfitCalculation__c getQuotationRecord(String targetQuery) {
        AsiaProfitCalculation__c targetRecord = null;
        List<AsiaProfitCalculation__c> recList = Database.query(targetQuery);
        if (recList != null && recList.size() > 0) {
            targetRecord = recList.get(0);
        } else {
            throw new JEOLException(ERROR_MESSAGE);
        }
        return targetRecord;
    }

    /**
     * [Get QuotationDescription]
     * @param  targetQuery [target Query String]
     * @return             [QuotationDescription Record List]
     */
    private List<AsiaProfitCalculationDetail__c> getQuotationDetail(String targetQuery){
        List<AsiaProfitCalculationDetail__c> recList = Database.query(targetQuery);
        if (recList != null && recList.size() > 0) {
            return recList;
        } else {
            return new List<AsiaProfitCalculationDetail__c>();
        }
    }

    /**
     * [getDescription get quotationDescription]
     * @param  targetQuery [target query]
     * @return             [quotationDescription Record List]
     */
    private List<AsiaQuotationDescription__c> getDescription(String targetQuery){
        List<AsiaQuotationDescription__c> recList = Database.query(targetQuery);
        if (recList != null && recList.size() > 0) {
            return recList;
        } else {
            return new List<AsiaQuotationDescription__c>();
        }
    }

    private AsiaQuotationTermsConditions__c getQuotTC(String targetQuery){
        List<AsiaQuotationTermsConditions__c> recList = Database.query(targetQuery);
        if (recList != null && recList.size() > 0) {
            return recList[0];
        } else {
            return new AsiaQuotationTermsConditions__c();
        }
    }

    /**
     * [Get target table all field query string]
     * @param  tableName         [Target sObj]
     * @param  whereCondition    [Query Condition String]
     * @param  isCustomFieldOnly [True: Only CustomField]
     * @param  staticFields      [For Only CustomField]
     * @return                   [Target sObj all Field Query String]
     */
    private static String getSelectAllQuery(String tableName, String whereCondition, Boolean isCustomFieldOnly, String[] staticFields) {
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(tableName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String, Schema.SObjectField> fields = r.fields.getMap() ;
        string soql = '';
        for (String fieldName : fields.keyset()) {
            if(isCustomFieldOnly && (fieldName.indexOf('__c') < 0)) {
                continue;
            }
            if (soql != '') {
                soql += ', ';
            }
            if (fieldName == 'PaymentConditionSection__c') {
                soql += 'TOLABEL(' + fieldName + ')';
            } else {
                soql += fieldName;
            }
        }
        for (String fieldName : staticFields) {
            // no sub query
            if (soql != '' && !fieldName.contains('withComma') && !fieldName.contains('withoutComma')) {
                soql += ', ';
                soql += fieldName;
            }
            // sub query
            if (soql != '' && fieldName.contains('withComma') && !fieldName.contains('withoutComma')) {
                soql += fieldName.replace('withComma', ', ');
            }
            // sub query
            if (soql != '' && fieldName.contains('withoutComma') && !fieldName.contains('withComma')) {
                soql += fieldName.replace('withoutComma', ' ');
            }

        }
        soql = 'SELECT ' + soql + ' FROM ' + tableName + ' ' + whereCondition;
        return soql;
    }

    /**
     * [getNoRecommendedQuotationDetailList: Get No Recommended QuotationDetail List]
     * @param  targetId            [String Quotation ID]
     * @return quotationDetailList [AsiaProfitCalculationDetail__c List]
     */
    private List<AsiaProfitCalculationDetail__c> getNoRecommendedQuotationDetailList(String quotationId){

        List<String> categories = new List<String>();
        categories.add('A');
        categories.add('B');

        return JEOLAsia_QuotationSpecificationCtrl.getProfitCalculationDetails(quotationId, categories);
    }

    /**
     * [getRecommendedQuotationDetailList: Get Recommended QuotationDetail List]
     * @param  targetId            [String Quotation ID]
     * @return quotationDetailList [AsiaProfitCalculationDetail__c List]
     */
    private List<AsiaProfitCalculationDetail__c> getRecommendedQuotationDetailList(String quotationId){

        List<String> categories = new List<String>();
        categories.add('G');

        return JEOLAsia_QuotationSpecificationCtrl.getProfitCalculationDetails(quotationId, categories);
    }

    /**
     * [createDescriptionPageBlock: create Description PageBlock List]
     * @param  quotationDetailList [AsiaProfitCalculationDetail__c List]
     * @return                     [PageBlock List]
     */
    private List<PageBlock> createDescriptionPageBlock(List<AsiaProfitCalculationDetail__c> quotationDetailList){

        // PageBlock List
        List<PageBlock> pages = new List<PageBlock>();

        // Guard Clause
        if(quotationDetailList == null || quotationDetailList.isEmpty()){
            return pages;
        }

        // init per page block
        PageBlock page = new PageBlock();
        String recordRowKey;

        Integer currentPageNo = 0;

        for(AsiaProfitCalculationDetail__c quotationDetail : quotationDetailList){

            // Record Key
            recordRowKey = quotationDetail.Name;

            //----------------------------------------------------------------------------------------------------
            // レコード情報
            //----------------------------------------------------------------------------------------------------

            // レコード情報をオブジェクトとして保存
            page.recordRowMapPCD.put(recordRowKey, quotationDetail);

            //----------------------------------------------------------------------------------------------------
            // スペック情報
            //----------------------------------------------------------------------------------------------------

            // AsiaProfitCalculationDetail__c から AsiaQuotationDescription__cを取得
            List<AsiaQuotationDescription__c> descriptionList = quotationDetail.getSObjects('QuotationSpecifications__r');
            AsiaQuotationDescription__c description = new AsiaQuotationDescription__c();
            if (descriptionList == null) {
                // 存在しない場合はデフォルト値を取得
                // - ProductSpecification__cはレコードから直接取得するのではなく、
                // - AsiaProductItemSpecification__cの<ModelType__c, Specification__c>マッピングから取得する
                description = new AsiaQuotationDescription__c();
                description.ProductSpecification__c = this.itemSpecificationMap.get(quotationDetail.ModelType__c);
            }else{
                description = descriptionList[0];
            }

            // 出力対象でなければ以降の処理をスキップ
            if(String.isEmpty(description.ProductSpecification__c)){
                continue;
            }

            // 改ページ算出用 行数計算
            // - ページ内で描画が想定される行数を算出する
            // - この時点では、ModelTypeとBodyの行数のうち大きいほうの値と、レコード自身の値を1として追加している
            List<String> pdcModelTypeList = textToList(quotationDetail.ModelType__c, mapCharWidthDetail, Decimal.valueOf(22) / Decimal.valueOf(95));
            List<String> bodyList = textToList(quotationDetail.Body__c, mapCharWidthDetail, Decimal.valueOf(33) / Decimal.valueOf(95));

            Integer rowPlusCount = 0;
            if (pdcModelTypeList.size() > bodyList.size()) {
                rowPlusCount = pdcModelTypeList.size();
            } else {
                rowPlusCount = bodyList.size();
            }

            page.rowCounter += rowPlusCount + 1;


            // 概要情報をオブジェクトとして保存
            page.recordRowMapDescription.put(recordRowKey, description);

            // プレーンテキスト化
            List<String> plainTextSpecList = new List<String>();
            String plainTextSpec = description.ProductSpecification__c.replace('　',' ').stripHtmlTags();
            List<String> tmpPlainTextSpecList = plainTextSpec.split(NT2);
            for(String perRow : tmpPlainTextSpecList){
                List<String> splitInsertBrList = this.stringToTangoList(mapCharWidthDetail, perRow, null);
                for(String splitInsertBr : splitInsertBrList){
                    plainTextSpecList.add(splitInsertBr);

                    // スペック情報として1行増えたので、rowCounterを増やしている
                    page.rowCounter = (page.rowCounter + 1);

                    // 特定条件下において、画面側での改ページを強制する
                    // - 描画が想定される行数がページ内 最大行数を超えたら改ページタグ（画面でハンドリングさせる）を挿入する
                    // - トータルページ数が変わるので、カウントを取ってトータルページ数の算出に利用する
                    // - チェック条件として、ページ内 最大行数の剰余で判定を行っている
                    if(this.getSurplus(page.rowCounter, MAX_LINE_SIZE) == 0){
                        // 改ページするのでrowCounterをリセットしている
                        page.rowCounter = 0;

                        this.forcePageBreakCount = this.forcePageBreakCount + 1;
                        plainTextSpecList.add(PAGE_BREAK_TAG);
                    }
                }
            }

            // スペック情報をプレーンテキスト化して保存
            page.recordRowMapSpec.put(recordRowKey, plainTextSpecList);

            //----------------------------------------------------------------------------------------------------
            // 出力対象としてAdd
            // - splitResultListにデータが存在すれば、画面側で出力する
            //----------------------------------------------------------------------------------------------------
            page.splitResultList.add(recordRowKey);

            //----------------------------------------------------------------------------------------------------
            // 改ページ
            //----------------------------------------------------------------------------------------------------
            if(MAX_LINE_SIZE <= page.rowCounter){
                currentPageNo++;
                page.isBreak = true;
                page.pageNo = currentPageNo;
                pages.add(page);
                page = new PageBlock();
            }

        }

        //----------------------------------------------------------------------------------------------------
        // 最終ページ
        //----------------------------------------------------------------------------------------------------
        if(!page.splitResultList.isEmpty()){// && pages.isEmpty()){
            currentPageNo++;
            page.isBreak = true;
            page.pageNo = currentPageNo;
            pages.add(page);
            page = new PageBlock();
        }

        return pages;
    }

    private List<FirstPageBlock> judgePageBlock(AsiaProfitCalculation__c quot, List<AsiaProfitCalculationDetail__c> noRecommend, List<AsiaProfitCalculationDetail__c> recommend){
        // init variable
        Integer PER_PAGE_REMAIN_HEIGHT;
        if(quot.PrintQuotationFirstPage__c){
            PER_PAGE_REMAIN_HEIGHT = 276;
        }else{
            PER_PAGE_REMAIN_HEIGHT = 258;
        }
        Integer currentHeight = 0;
        Integer currentPageNo = 0;
        final Integer HEADER_HEIGHT = 13;
        final Integer DETAIL_HEIGHT = 4;
        for (AsiaProfitCalculationDetail__c detailNoRecommend : noRecommend){
            if (detailNoRecommend.Depth__c == 0 && detailNoRecommend.Type__c == '1') {
                this.section2row = this.section2row + 1;
            }
        }

        for (AsiaProfitCalculationDetail__c detailRecommend : recommend){
            if (detailRecommend.Depth__c == 0 && detailRecommend.Type__c == '1') {
                this.section3row = this.section3row + 1;
            }
        }

        List<FirstPageBlock> pageList = new List<FirstPageBlock>();
        // init page block
        FirstPageBlock judgeBreak = new FirstPageBlock();

        //----------------------------------------------------------------------------------------------------
        // section1
        //----------------------------------------------------------------------------------------------------
        if(quot != null){
            // + Base 5 rows
            currentHeight += S1B_1_PER_ROW_HEIGHT*5;
            // + Contract Mail none
            if(quot.ContractContact_dummyField__r.Email != null &&
                quot.ContractContact_dummyField__r.Email != ''){
                currentHeight += S1B_1_PER_ROW_HEIGHT;
                currentHeight += DETAIL_HEIGHT;
            }

            if(!quot.PrintQuotationFirstPage__c){
                // + Contract Address
                Integer contractAddressHeight = 0;
                if (String.isNotBlank(quot.ContractAddress__c)) {
                    contractAddressHeight = S1B_1_PER_ROW_HEIGHT;
                }

                // + Contact
                Integer contactHeight = 0;
                // contact name
                if(quot.SalesPerson__r.Name != null && quot.SalesPerson__r.Name != ''){
                    contactHeight += DETAIL_HEIGHT;
                }
                // contact mail
                if(quot.ContractEmail__c != null && quot.ContractEmail__c != ''){
                    contactHeight += DETAIL_HEIGHT;
                }
                // contact Phone
                if(quot.SalesPerson__r.Phone != null && quot.SalesPerson__r.Phone != ''){
                    contactHeight += DETAIL_HEIGHT;
                }
                // SalesAssistant mail
                if(quot.SalesAssistant__r.Email != null && quot.SalesAssistant__r.Email != ''){
                    contactHeight += DETAIL_HEIGHT;
                }
                // SalesAssistant Label
                if((quot.SalesAssistant__r.Email != null &&
                    quot.SalesAssistant__r.Email != '')){
                    contactHeight += DETAIL_HEIGHT;
                }

                if (contractAddressHeight > contactHeight){
                    currentHeight += contractAddressHeight;
                } else {
                    currentHeight += contactHeight;
                }
                currentHeight += DETAIL_HEIGHT;
            }

            // set section1
            judgeBreak.pageQuotation = quot;
            judgeBreak.section1AppearTime = 1;
        }

        //----------------------------------------------------------------------------------------------------
        // section2
        //----------------------------------------------------------------------------------------------------
        if(noRecommend != null && noRecommend.size() > 0){
            PER_PAGE_REMAIN_HEIGHT = 260;//20170522
            // + header height
            currentHeight += HEADER_HEIGHT;
            // + table margin top
            currentHeight += 2;
            judgeBreak.pageQuotation = quot;
            for(AsiaProfitCalculationDetail__c noRe :noRecommend){
                Integer maxRows = 0;

                // noRecommendBody　Model Typeの取得
                List<String> modelTypeRows = textToList(noRe.ModelType__c, mapCharWidthDetail, Decimal.valueOf(22) / Decimal.valueOf(95));
                if (noRecommendModelTypeMap == null) {
                    noRecommendModelTypeMap = new map<Id, List<String>>();
                }
                noRecommendModelTypeMap.put(noRe.id, modelTypeRows);

                // noRecommend　Descriptionの取得
                List<String> bodyRows = textToList(noRe.Body__c, mapCharWidthDetail, Decimal.valueOf(33) / Decimal.valueOf(95));
                if (noRecommendBodyMap == null) {
                    noRecommendBodyMap = new map<Id, List<String>>();
                }
                noRecommendBodyMap.put(noRe.id, bodyRows);

                // Model TypeとDescriptionを比較して、最大Rowsを取得する
                if (modelTypeRows.size() > bodyRows.size()){
                    maxRows = modelTypeRows.size();
                } else {
                    maxRows = bodyRows.size();
                }

                // 最大RowsからHeightを取得する
                Integer rowsHeight = 0;
                if (maxRows == 0){
                    rowsHeight = 4;
                } else {
                    rowsHeight = maxRows * 4;
                }

                // + detail height
                if( (currentHeight + rowsHeight) >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    // set init value
                    PER_PAGE_REMAIN_HEIGHT = 269;
                    currentHeight = 0;
                    currentHeight += HEADER_HEIGHT;
                    judgeBreak.pageQuotation = quot;
                }
                currentHeight = currentHeight + rowsHeight;
                judgeBreak.noRecommendList.add(noRe);
            }
        }
        // + subtotal height
        if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
            currentPageNo++;
            judgeBreak.pageNo = currentPageNo;
            judgeBreak.pageBreak = true;
            pageList.add(judgeBreak);
            judgeBreak = new FirstPageBlock();
            currentHeight = 0;
            judgeBreak.pageQuotation = quot;
        }
        currentHeight = currentHeight + 5;

        // + subtotal height margin-top and bottom
        if( (currentHeight + 4) > PER_PAGE_REMAIN_HEIGHT){
            currentPageNo++;
            judgeBreak.pageNo = currentPageNo;
            judgeBreak.pageBreak = true;
            pageList.add(judgeBreak);
            judgeBreak = new FirstPageBlock();
            currentHeight = 0;
            judgeBreak.pageQuotation = quot;
        }
        currentHeight = currentHeight + 4;
        //// 2017/06/07
        this.section2LastPageNo = currentPageNo + 1;

        //----------------------------------------------------------------------------------------------------
        // section3
        //----------------------------------------------------------------------------------------------------
        // subtotal table row1 height
        if(quotation.CustomReductionAmount1__c != null &&
           quotation.CustomReductionAmount1__c != 0){
            if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5;
        }
        // subtotal table row2 height
        if(quotation.OutputSubtotalReduction1__c){
            if((quotation.SubtotalReductionName1__c != null &&
                quotation.SubtotalReductionName1__c != '') ||
                (quotation.SubtotalReductionAmount1__c != null &&
                quotation.SubtotalReductionAmount1__c != 0)){
                if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }
                currentHeight = currentHeight + 5;
            }
        }
        // subtotal table row3 height
        if(quotation.CustomReductionAmount2__c != null &&
           quotation.CustomReductionAmount2__c != 0){
            if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5;
        }
        // subtotal table row4 height
        if(quotation.OutputSubtotalReduction2__c){
            if((quotation.SubtotalReductionName2__c != null &&
                quotation.SubtotalReductionName2__c != '') ||
                (quotation.SubtotalReductionAmount2__c != null &&
                quotation.SubtotalReductionAmount2__c != 0)){
                if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }
                currentHeight = currentHeight + 5;
            }
        }
        // subtotal table row5 height
        if(quotation.CustomReductionAmount3__c != null &&
           quotation.CustomReductionAmount3__c != 0){
            if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5;
        }
        // subtotal table row6 height
        if(quotation.OutputTotalAmount__c == true &&
            quotation.TotalAmount__c != null &&
            quotation.TotalAmount__c != 0){
            if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5;
        }
        // subtotal table row7 height
        if(quotation.OutputConsumptionTaxAmount__c == true &&
            quotation.ConsumptionTaxAmount__c != null &&
            quotation.ConsumptionTaxAmount__c != 0){
            if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5;
        }
        // subtotal table row8 height
        if(quotation.OutputTotalTaxAmount__c == true &&
            quotation.TotalTaxAmount__c != null &&
            quotation.TotalTaxAmount__c != 0){
            if( (currentHeight + 10) > PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 10;
        }
        // + all prices.... sentence height
        if( (currentHeight + 5) > PER_PAGE_REMAIN_HEIGHT){
            currentPageNo++;
            judgeBreak.pageNo = currentPageNo;
            judgeBreak.pageBreak = true;
            pageList.add(judgeBreak);
            judgeBreak = new FirstPageBlock();
            currentHeight = 0;
            judgeBreak.pageQuotation = quot;
        }
        currentHeight = currentHeight + 5;
        judgeBreak.section3AppearTime = 1;

        //----------------------------------------------------------------------------------------------------
        // section 4
        //----------------------------------------------------------------------------------------------------
        PER_PAGE_REMAIN_HEIGHT = 258;//260 ⇒　250
        if(recommend != null && recommend.size() > 0){
            // + Optionall Avilable.... sentence height
            currentHeight = currentHeight + 5;
            // + Optionall Avilable.... margin top and bottom
            currentHeight = currentHeight + 4;
            // + header height
            currentHeight += HEADER_HEIGHT;
            judgeBreak.pageQuotation = quot;

            for(AsiaProfitCalculationDetail__c reco :recommend){

                Integer maxRows = 0;

                // noRecommendBody　Model Typeの取得
                List<String> modelTypeRows = textToList(reco.ModelType__c, mapCharWidthDetail, Decimal.valueOf(22) / Decimal.valueOf(95));
                if (recommendModelTypeMap == null) {
                    recommendModelTypeMap = new map<Id, List<String>>();
                }
                recommendModelTypeMap.put(reco.id, modelTypeRows);

                // Recommend　Descriptionの取得
                List<String> bodyRows = textToList(reco.Body__c, mapCharWidthDetail, Decimal.valueOf(33) / Decimal.valueOf(95));
                if (recommendBodyMap == null) {
                    recommendBodyMap = new map<Id, List<String>>();
                }
                recommendBodyMap.put(reco.id, bodyRows);

                // Model TypeとDescriptionを比較して、最大Rowsを取得する
                if (modelTypeRows.size() > bodyRows.size()){
                    maxRows = modelTypeRows.size();
                } else {
                    maxRows = bodyRows.size();
                }

                // 最大RowsからHeightを取得する
                Integer rowsHeight = 0;
                if (maxRows == 0){
                    rowsHeight = 4;
                } else {
                    rowsHeight = maxRows * 4;
                }

                // + detail height
                if( (currentHeight + rowsHeight) >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    currentHeight += HEADER_HEIGHT;
                    judgeBreak.pageQuotation = quot;
                }

                judgeBreak.section4TitleAppearTime = 1;
                judgeBreak.recommendList.add(reco);
                currentHeight = currentHeight + rowsHeight;
            }
        }

        //----------------------------------------------------------------------------------------------------
        // section5
        //----------------------------------------------------------------------------------------------------
        // + Freight terms above blank height
        currentHeight = currentHeight + 2;
        if(String.isNotEmpty(quotation.DeliveryCondition3__c)){
            // + Freight Terms height
            if( currentHeight + 5 >= PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5;
            judgeBreak.section5_Freight_AppearTime++;
        }

        // + Estimated Delivery height
        currentHeight = currentHeight + 5;
        if(quot.DeliveryDeadline__c != null || String.isNotEmpty(quot.DeliveryDate_Arbitrarily__c) || String.isNotEmpty(quot.DeliveryDate_ArbitrarilyTitle__c)){
            if( currentHeight + 5 >= PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5;
            judgeBreak.section5_Estimated_AppearTime++;
        }

        // + Payment Terms height
        if(String.isNotEmpty(getPaymentTermsLabel())){
            List<String> paymentStrL = new List<String>();
            if(getPaymentTermsLabel() != null && getPaymentTermsLabel() != ''){
                paymentStrL = getPaymentTermsLabel().split('<br/>');
            }

            if( (currentHeight + 5 + 4*(paymentStrL.size() - 1)) >= PER_PAGE_REMAIN_HEIGHT){
                currentPageNo++;
                judgeBreak.pageNo = currentPageNo;
                judgeBreak.pageBreak = true;
                pageList.add(judgeBreak);
                judgeBreak = new FirstPageBlock();
                currentHeight = 0;
                judgeBreak.pageQuotation = quot;
            }
            currentHeight = currentHeight + 5 + 4 * (paymentStrL.size() - 1);
            judgeBreak.section5_Payment_AppearTime++;
        }

        // + others height
        List<String> currentList = this.getOthers(quot.OtherText__c);
        if(currentList != null && currentList.size() > 0){
            PER_PAGE_REMAIN_HEIGHT = 220;
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.otherList.add(currentList[i]);
                judgeBreak.section5_Others_AppearTime++;
                judgeBreak.section5_Others_Title_AppearTime++;
            }
        }  else {
            PER_PAGE_REMAIN_HEIGHT = 240;
        }

        //----------------------------------------------------------------------------------------------------
        // Section6
        //----------------------------------------------------------------------------------------------------
        // + section6 margin-top height
        currentHeight = currentHeight + 10;
        if( currentHeight >= PER_PAGE_REMAIN_HEIGHT){
            currentPageNo++;
            judgeBreak.pageNo = currentPageNo;
            judgeBreak.pageBreak = true;
            pageList.add(judgeBreak);
            judgeBreak = new FirstPageBlock();
            currentHeight = 0;
            judgeBreak.pageQuotation = quot;
        }
        if( (this.getOthers(quotTC.Warranty__c) != null &&
             this.getOthers(quotTC.Warranty__c).size() > 0) ||
            (this.getOthers(quotTC.Installation__c) != null &&
             this.getOthers(quotTC.Installation__c).size() > 0) ||
            (this.getOthers(quotTC.Packing__c) != null &&
             this.getOthers(quotTC.Packing__c).size() > 0) ||
            (this.getOthers(quotTC.Export__c) != null &&
            this.getOthers(quotTC.Export__c).size() > 0) ||
            String.isNotEmpty(this.getQuotationValidityLabel()) ){

            judgeBreak.section6_Title_AppearTime++;
        }

        // +Section6 title height
        currentHeight = currentHeight + 5;
        if (quotation.RecordType.DeveloperName != 'SVC'){
            // + Warranty height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Warranty__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.warrantyList.add(currentList[i]);
                judgeBreak.section6_Warranty_AppearTime++;
                judgeBreak.section6_Warranty_Title_AppearTime++;
            }

            // + Installation height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Installation__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.installationList.add(currentList[i]);
                judgeBreak.section6_Installation_AppearTime++;
                judgeBreak.section6_Installation_Title_AppearTime++;
            }

            // + Packing height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Packing__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.packingList.add(currentList[i]);
                judgeBreak.section6_Packing_AppearTime++;
                judgeBreak.section6_Packing_Title_AppearTime++;
            }

            // + Training height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Training__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.trainingList.add(currentList[i]);
                judgeBreak.section6_Training_AppearTime++;
                judgeBreak.section6_Training_Title_AppearTime++;
            }

            // + Export height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Export__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.exportList.add(currentList[i]);
                judgeBreak.section6_Export_AppearTime++;
                judgeBreak.section6_Export_Title_AppearTime++;
            }
        } else {
            // + Price height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Price__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.priceList.add(currentList[i]);
                judgeBreak.section6_Price_AppearTime++;
                judgeBreak.section6_Price_Title_AppearTime++;
            }

            // + Remarks height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Remarks__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.remarksList.add(currentList[i]);
                judgeBreak.section6_Remarks_AppearTime++;
                judgeBreak.section6_Remarks_Title_AppearTime++;
            }
        }

        if (quotation.PrintProformaInvoice__c){
            // + Manufacturer height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.Manufacturer__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if(currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.section6_Manufacturer_AppearTime++;
                judgeBreak.section6_Manufacturer_Title_AppearTime++;
                judgeBreak.manufacturerList.add(currentList[i]);
            }

            // + BankDetail height
            currentList = new List<String>();
            currentList = this.getOthers(quotTC.BankDetail__c);
            for(Integer i = 0; i < currentList.size(); i++){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.bankDetailList.add(currentList[i]);
                judgeBreak.section6_BankDetail_AppearTime++;
                judgeBreak.section6_BankDetail_Title_AppearTime++;

            }
        } else {
            // + Validity height
            if(String.isNotEmpty(this.getQuotationValidityLabel())){
                if( currentHeight + 4 >= PER_PAGE_REMAIN_HEIGHT){
                    currentPageNo++;
                    judgeBreak.pageNo = currentPageNo;
                    judgeBreak.pageBreak = true;
                    pageList.add(judgeBreak);
                    judgeBreak = new FirstPageBlock();
                    currentHeight = 0;
                    judgeBreak.pageQuotation = quot;
                }

                currentHeight = currentHeight + 4;
                judgeBreak.section6_Validity_AppearTime++;
                judgeBreak.section6_Validity_Title_AppearTime++;
            }
        }

        // the session 6 last page add
        currentPageNo++;
        judgeBreak.pageNo = currentPageNo;
        judgeBreak.pageBreak = true;
        pageList.add(judgeBreak);

        //----------------------------------------------------------------------------------------------------
        // section7
        //----------------------------------------------------------------------------------------------------
        // + section7 userSign
        if(currentHeight + userSignHeight + 12 > PER_PAGE_REMAIN_HEIGHT){
            judgeBreak = new FirstPageBlock();
            judgeBreak.pageQuotation = quot;
            currentPageNo++;
            judgeBreak.pageNo = currentPageNo;
            judgeBreak.pageBreak = true;
            pageList.add(judgeBreak);
        }

        return pageList;
    }

    /**
     * [getOthers process rich text string]
     * @param  targetStr [target string]
     * @return results    [with CR string list]
     */
    private List<String> getOthers(String targetStr) {
        List<String> results = new List<String>();

        // Guard Clause
        if(String.isEmpty(targetStr)){
            return results;
        }

        targetStr = targetStr.replace('　', ' ');
        targetStr = targetStr.replace(' ', ' ');
        targetStr = targetStr.replace(NT2, NT);
        List<String> lineList = targetStr.split(NT);
        for(String strLine : lineList){
            List<String> subLineList = this.stringToTangoList(mapCharWidthTerms, strLine, null);
            for (String strSubLine : subLineList){
                results.add(strSubLine.replace(' ', '&nbsp;').replace('<', '&lt;').replace('>', '&gt;'));
            }
        }

        return results;
    }

    private List<String> textToList(String targetStr, Map<String, Integer> mapCharWidthDetail, Decimal referenceValue) {
        List<String> results = new List<String>();

        // Guard Clause
        if(String.isEmpty(targetStr)){
            return results;
        }

        targetStr = targetStr.replace('　', ' ');
        targetStr = targetStr.replace(' ', ' ');
        targetStr = targetStr.replace(NT2, NT);
        List<String> lineList = targetStr.split(NT);
        for(String strLine : lineList){
            List<String> subLineList = this.stringToTangoList(mapCharWidthDetail, strLine, referenceValue);
            results.addAll(subLineList);
        }

        return results;
    }

    private List<SpPageBlock> creatSpPageBlock(List<AsiaProfitCalculationDetail__c> qtDetailList){
        List<SpPageBlock> spPageBlocks = new List<SpPageBlock>();
        Integer currentPageNo = 0;
        SpPageBlock sp = new SpPageBlock();

        // Guard Clause
        if(qtDetailList == null || qtDetailList.isEmpty()){
            return spPageBlocks;
        }

        for(AsiaProfitCalculationDetail__c qtDetail:qtDetailList){
            List<sObject> spPageDetailList = new List<sObject>();
            if(qtDetail.Profit_Calculation_2SP_Parts__r != null && qtDetail.Profit_Calculation_2SP_Parts__r.size() > 0){
                Integer currentCount = 0;
                for(sObject spDetail : qtDetail.Profit_Calculation_2SP_Parts__r){
                    currentCount++;
                    spPageDetailList.add(spDetail);

                    if(currentCount >= 54){
                        sp.spMap.put(qtDetail.Id, spPageDetailList);
                        sp.parent = qtDetail;
                        sp.pageBreak = true;
                        spPageBlocks.add(sp);
                        currentPageNo++;
                        sp.pageNo = currentPageNo;
                        sp = new SpPageBlock();
                        currentCount = 0;
                        spPageDetailList = new List<sObject>();
                    }
                }
            }
            if(spPageDetailList != null && spPageDetailList.size() > 0){
                sp.spMap.put(qtDetail.Id, spPageDetailList);
                sp.parent = qtDetail;
                sp.pageBreak = true;
                spPageBlocks.add(sp);
                currentPageNo++;
                sp.pageNo = currentPageNo;
                sp = new SpPageBlock();
                spPageDetailList = new List<sObject>();
            }
        }

        return spPageBlocks;
    }

    /**
     * [stringToTangoList]
     * @param  charWidthMap
     * @param  oldLine [targe row]
     * @return         [List<String>]
     */
    private List<String> stringToTangoList(Map<String, Integer> charWidthMap, String oldLine, Decimal referenceValue){
        // 基準値は未指定の場合、Default：Decimal.valueOf(1)に設定する。
        if (referenceValue == null) {
            referenceValue = Decimal.valueOf(1);
        }

        List<String> newLineList = new List<String>();
        if (String.isEmpty(oldLine)) {
            newLineList.add('<br/>');
            return newLineList;
        }

        String newLine = '';
        Decimal sum = Decimal.valueOf(0);
        List<String> wordList = oldLine.split(' ');

        for(String  strWord : wordList){
            Decimal wordSum = Decimal.valueOf(0);
            String strChars = '';
            if (String.isEmpty(strWord)){
                strChars = ' ';
                wordSum = (Decimal.valueOf(1) / Decimal.valueOf(charWidthMap.get(' ')));
            } else {
                if (String.isNotEmpty(newLine)){
                    newLine = newLine + ' ';
                    sum = sum + (Decimal.valueOf(1) / Decimal.valueOf(charWidthMap.get(' ')));
                }
                for(Integer j = 0; j < strWord.length(); j++){
                    String strChar = strWord.substring(j, (j+1) );
                    Decimal charWidth = Decimal.valueOf(0);
                    if (charWidthMap.containsKey(strChar)){
                        charWidth = (Decimal.valueOf(1) / Decimal.valueOf(charWidthMap.get(strChar)));
                    } else {
                        charWidth = (Decimal.valueOf(1) / Decimal.valueOf(charWidthMap.get('default')));
                    }

                    if ((wordSum + charWidth) > referenceValue){
                        newLineList.add(strChars);

                        strChars = '';
                        wordSum = Decimal.valueOf(0);
                    } else if ((sum + wordSum + charWidth) > referenceValue){
                        newLineList.add(newLine);

                        newLine = '';
                        sum = Decimal.valueOf(0);
                    }

                    strChars = strChars + strChar;
                    wordSum = wordSum + charWidth;
                }
            }

            if ((sum + wordSum) > referenceValue){
                newLineList.add(newLine);
                newLine = '';
                sum = Decimal.valueOf(0);
            }
            newLine = newLine + strChars;
            sum = sum + wordSum;
        }

        if (String.isNotEmpty(newLine)){
            newLineList.add(newLine);
        }

        return newLineList;
    }

    /**
     * [getSafeString : NULLまたは空文字の場合は指定したsafeValueを返します。それ以外の場合はそのまま文字列を返します。]
     * @param  Object [obj]
     * @param  String [safeValue]
     * @return String [Safe String]
     */
    private String getSafeString(Object obj, String safeValue){
        String safeString = null;

        if(String.valueOf(obj) == null || String.valueOf(obj) == ''){
            safeString = safeValue;
        }else{
            safeString = String.valueOf(obj);
        }

        return safeString;
    }


    /**
     * [getSurplus : a % b (剰余) を返します。]
     * @param  Integer [a]
     * @param  Integer [b]
     * @return Integer [Surplus]
     */
    private Integer getSurplus(Integer a, Integer b){
        Integer c = a / b;
        return a - ( c * b );
    }


    public class SpPageBlock {
        public Map<String, List<sObject>> spMap {get; set;}
        public Boolean pageBreak {get; set;}
        public AsiaProfitCalculationDetail__c parent {get; set;}
        public Integer pageNo {get; set;}

        public SpPageBlock(){
            this.pageBreak = false;
            this.parent = new AsiaProfitCalculationDetail__c();
            this.spMap = new Map<String, List<sObject>>();
            this.pageNo = 0;
        }
    }

    // judge page break
    public class FirstPageBlock {
        public List<AsiaProfitCalculationDetail__c> noRecommendList {get; set;}
        public List<AsiaProfitCalculationDetail__c> recommendList {get; set;}
        public AsiaProfitCalculation__c  pageQuotation {get; set;}
        public Boolean pageBreak {get; set;}
        public Integer pageNo {get; set;}
        // section 1
        public Integer section1AppearTime {get; set;}
        // section 3
        public Integer section3AppearTime {get; set;}
        // section 4
        public Integer section4TitleAppearTime {get; set;}
        // section 5 var
        public Integer section5_Freight_AppearTime {get; set;}
        public Integer section5_Estimated_AppearTime {get; set;}
        public Integer section5_Payment_AppearTime {get; set;}
        public Integer section5_Others_AppearTime {get; set;}
        public Integer section5_Others_Title_AppearTime {get; set;}
        public Integer section5otherAppearTime {get; set;}
        // section 6 var
        public Integer section6_Title_AppearTime {get; set;}

        public Integer section6_Warranty_AppearTime {get; set;}
        public Integer section6_Warranty_Title_AppearTime {get; set;}

        public Integer section6_Installation_AppearTime {get; set;}
        public Integer section6_Installation_Title_AppearTime {get; set;}

        public Integer section6_Packing_AppearTime {get; set;}
        public Integer section6_Packing_Title_AppearTime {get; set;}

        public Integer section6_Training_AppearTime {get; set;}
        public Integer section6_Training_Title_AppearTime {get; set;}

        public Integer section6_Export_AppearTime {get; set;}
        public Integer section6_Export_Title_AppearTime {get; set;}

        public Integer section6_Manufacturer_AppearTime {get; set;}
        public Integer section6_Manufacturer_Title_AppearTime {get; set;}

        public Integer section6_BankDetail_AppearTime {get; set;}
        public Integer section6_BankDetail_Title_AppearTime {get; set;}

        public Integer section6_Price_AppearTime {get; set;}
        public Integer section6_Price_Title_AppearTime {get; set;}

        public Integer section6_Remarks_AppearTime {get; set;}
        public Integer section6_Remarks_Title_AppearTime {get; set;}

        public Integer section6_Validity_AppearTime {get; set;}
        public Integer section6_Validity_Title_AppearTime {get; set;}

        public List<String> otherList {get; set;}
        public List<String> warrantyList {get; set;}
        public List<String> installationList {get; set;}
        public List<String> packingList {get; set;}
        public List<String> trainingList {get; set;}
        public List<String> exportList {get; set;}
        public List<String> manufacturerList {get; set;}
        public List<String> bankDetailList {get; set;}
        public List<String> priceList {get; set;}
        public List<String> remarksList {get; set;}

        public FirstPageBlock(){
            this.noRecommendList = new List<AsiaProfitCalculationDetail__c>();
            this.recommendList = new List<AsiaProfitCalculationDetail__c>();
            this.otherList = new List<String>();
            this.warrantyList = new List<String>();
            this.installationList = new List<String>();
            this.packingList = new List<String>();
            this.trainingList = new List<String>();
            this.exportList = new List<String>();
            this.manufacturerList = new List<String>();
            this.bankDetailList = new List<String>();
            this.priceList = new List<String>();
            this.remarksList = new List<String>();
            this.pageQuotation = new AsiaProfitCalculation__c();
            this.pageBreak = false;
            this.pageNo = 1;

            this.section1AppearTime = 0;

            this.section3AppearTime = 0;

            this.section4TitleAppearTime = 0;

            this.section5_Freight_AppearTime = 0;
            this.section5_Estimated_AppearTime = 0;
            this.section5_Payment_AppearTime = 0;
            this.section5_Others_AppearTime = 0;
            this.section5_Others_Title_AppearTime = 0;

            this.section6_Title_AppearTime = 0;

            this.section6_Warranty_Title_AppearTime = 0;
            this.section6_Warranty_AppearTime = 0;

            this.section6_Installation_Title_AppearTime = 0;
            this.section6_Installation_AppearTime = 0;

            this.section6_Packing_Title_AppearTime = 0;
            this.section6_Packing_AppearTime = 0;

            this.section6_Training_AppearTime = 0;
            this.section6_Training_Title_AppearTime = 0;

            this.section6_Export_Title_AppearTime = 0;
            this.section6_Export_AppearTime = 0;

            this.section6_Manufacturer_AppearTime = 0;
            this.section6_Manufacturer_Title_AppearTime = 0;

            this.section6_BankDetail_AppearTime = 0;
            this.section6_BankDetail_Title_AppearTime = 0;

            this.section6_Price_Title_AppearTime = 0;
            this.section6_Price_AppearTime = 0;

            this.section6_Remarks_Title_AppearTime = 0;
            this.section6_Remarks_AppearTime = 0;

            this.section6_Validity_Title_AppearTime = 0;
            this.section6_Validity_AppearTime = 0;
        }
    }

    // Page block
    public class PageBlock {
        // base parent record's child list
        public List<AsiaProfitCalculationDetail__c> detailList {get; set;}
        // child record's child list
        public List<AsiaQuotationDescription__c> descriptionList {get; set;}
        // list for page block
        public List<String> splitResultList {get; set;}
        // Map for output
        public Map<String, AsiaQuotationDescription__c> recordRowMap {get; set;}
        public Map<String, List<String>> recordRowMapBody {get; set;}
        public Map<String, List<String>> recordRowMapPCDModelType {get; set;}
        public Map<String, AsiaProfitCalculationDetail__c> recordRowMapPCD {get; set;}
        public Map<String, AsiaQuotationDescription__c> recordRowMapDescription {get; set;}
        public Map<String, List<String>> recordRowMapSpec {get; set;}

        // page break flag
        public Boolean isBreak {get; set;}
        // page No.
        public Integer pageNo {get; set;}
        // Row Counter
        public Integer rowCounter {get; set;}

        // Constructor
        public PageBlock(){
            this.detailList = new List<AsiaProfitCalculationDetail__c>();
            this.descriptionList = new List<AsiaQuotationDescription__c>();
            this.splitResultList = new List<String>();
            this.recordRowMap = new Map<String, AsiaQuotationDescription__c>();
            this.recordRowMapBody = new Map<String, List<String>>();
            this.recordRowMapPCDModelType = new Map<String, List<String>>();
            this.recordRowMapPCD = new Map<String, AsiaProfitCalculationDetail__c>();
            this.recordRowMapDescription = new Map<String, AsiaQuotationDescription__c>();
            this.recordRowMapSpec = new Map<String, List<String>>();
            this.isBreak = false;
            this.rowCounter = 0;
            this.pageNo = 1;
        }
    }

}