@IsTest
private class JEOLAsia_ProjectMasterCtrlTest {
    
    private static final String QUOTATION_COMPANY_ASIA = 'ASIA';
    public static final String PARAM_ID = 'id';
    public static final String SCROLL_TOP = 'top';
    public static final String URL_PARAM_NAME_ISCOPY = 'isCopy';
    public static Account testAccount{get;set;}
    // User(ユーザ)
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
    
    private static testMethod void test01() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'true');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProfitCalculation__c calculationEntity =  createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail(calculationEntity.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,calculationEntity.Id,true);
            createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.getPicklist('AsiaProjectMaster__c', 'CurrencyContractPrice__c');
            ctrl.getCurrencyContractPriceItems();
            ctrl.getSeriesOptions();
            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();
            ctrl.shipmentContactAttachment();
            ctrl.copyFromPC_onclick();
            ctrl.copyFromPC_PI_onclick();
            ctrl.contractAccountInputCopy();
            ctrl.deleteMultiRows();//--------------
            ctrl.saveAction();//--------------          
            ctrl.getAsiaProjectMaster();
            ctrl.qdm.accountCheck();
            ctrl.qdm.getItemsA();
            ctrl.qdm.getItemsB();
            ctrl.qdm.getItemsAll();
            ctrl.qdm.getBaseItemsAll();
            
            Test.stopTest();
        }
    }
    //Save with ReadOnly True
    private static testMethod void test01_4() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'true');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProfitCalculation__c calculationEntity =  createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail(calculationEntity.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,calculationEntity.Id,false);
            createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.getPicklist('AsiaProjectMaster__c', 'CurrencyContractPrice__c');
            ctrl.getCurrencyContractPriceItems();
            ctrl.getSeriesOptions();
            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();
            ctrl.shipmentContactAttachment();
            ctrl.copyFromPC_onclick();
            ctrl.copyFromPC_PI_onclick();
            ctrl.contractAccountInputCopy();
            ctrl.isReadOnly=true;
            ctrl.saveAction();
            Test.stopTest();
        }
    }
    //Save with validation pass and isCopy=false
    private static testMethod void test01_5() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProfitCalculation__c calculationEntity =  createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail(calculationEntity.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,calculationEntity.Id,true);
            createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.saveAction();
            Test.stopTest();
        }
    }
    //Save with validation pass and isCopy=false and (parentRec.LastModifiedDate != refreshedParentRec.LastModifiedDate) 
    private static testMethod void test01_6() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProfitCalculation__c calculationEntity =  createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail(calculationEntity.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,calculationEntity.Id,true);
            createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            entity.ContractName2__c='123456789012345678901';
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.qdm=new JEOLAsia_ProjectMasterCtrl.QuotationDetailManage(entity,false,false);           
            ctrl.saveAction();
            Test.stopTest();
        }
    }
    //Save with validation pass and isCopy=false and (qdm.parentRec.ContractName2__c != null) && (JEOLUtil.getSizeInBytes(qdm.parentRec.ContractName2__c) <> qdm.parentRec.ContractName2__c.length()) && (qdm.parentRec.ContractName2__c.length() > 20) 
    private static testMethod void test01_7() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProfitCalculation__c calculationEntity =  createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail(calculationEntity.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,calculationEntity.Id,true);
            entity= [Select Id,ContractCode__c,ShipmentCode__c,ContractAccount_dummyField__c,ShipmentAccount_dummyField__c,ContractContact_dummyField__c,ShipmentContact_dummyField__c,ProfitCalculation__c,ContractName2__c,/*Series__c,*/SalesPerson__c,LastModifiedDate 
                     FROM AsiaProjectMaster__c];
            createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            Test.setCurrentPage(testPage);   
            entity.ContractName2__c='1234567890 ｡｡｠｠｠｠｠｠｡｡｡｡｡｡｡｡';
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.qdm=new JEOLAsia_ProjectMasterCtrl.QuotationDetailManage(entity,false,false);
            
            ctrl.saveAction();//--------------
            
            Test.stopTest();
        }
    }
    //Save with validation pass and isCopy=false and (qdm.parentRec.ShipmentName2__c != null) && (JEOLUtil.getSizeInBytes(qdm.parentRec.ShipmentName2__c) <> qdm.parentRec.ShipmentName2__c.length()) && (qdm.parentRec.ContractName2__c.length() > 20) 
    private static testMethod void test01_8() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProfitCalculation__c calculationEntity =  createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail(calculationEntity.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,calculationEntity.Id,true);
            entity= [Select Id,ContractCode__c,ShipmentCode__c,ContractAccount_dummyField__c,ShipmentAccount_dummyField__c,ContractContact_dummyField__c,ShipmentContact_dummyField__c,ProfitCalculation__c,ContractName2__c,/*Series__c,*/SalesPerson__c,LastModifiedDate 
                     FROM AsiaProjectMaster__c];
            AsiaProjectMasterDetail__c masterDetailEntity = createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            entity.ShipmentName2__c='1234567890 ｡｡｠｠｠｠｠｠｡｡｡｡｡｡｡｡';
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.qdm=new JEOLAsia_ProjectMasterCtrl.QuotationDetailManage(entity,false,false);
            
            /* List<AsiaProjectMasterDetail__c> deleteList = new List<AsiaProjectMasterDetail__c>();
deleteList.add(masterDetailEntity);
ctrl.deleteTargets=deleteList;*/
            List<AsiaProjectMasterDetail__c> recs = [
                SELECT
                id, name, Depth__c, /*SortNo__c,*/ Type__c, Amount__c, Parent__c,
                Quantity__c, /*Body__c,*/ Category__c, IsTaxationTarget__c, IsOverheadTarget__c,
                IsShowDetailAmount__c, AccompanyingPaperOutput__c,
                CostPrice__c, SalesPrice__c, /*ModelType__c,*/ UnitPrice__c, CatalogCurrency__c, CostPriceUnit__c,
                Description__c, Supplier__c
                FROM
                AsiaProjectMasterDetail__c
                WHERE
                Parent__c =: entity.Id
                ORDER BY
                /*SortNo__c,*/ Depth__c Asc
            ];
            
            ctrl.copyFromPC_PI_onclick();
            ctrl.deleteAction();
            ctrl.saveAction();//--------------
            
            Test.stopTest();
        }
    }
    //Delete Action
    private static testMethod void test01_9() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProfitCalculation__c calculationEntity =  createAsiaProfitCalculation();
            createAsiaProfitCalculationDetail(calculationEntity.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,calculationEntity.Id,true);
            entity= [Select Id,ContractCode__c,ShipmentCode__c,ContractAccount_dummyField__c,ShipmentAccount_dummyField__c,ContractContact_dummyField__c,ShipmentContact_dummyField__c,ProfitCalculation__c,ContractName2__c/*,Series__c*/,SalesPerson__c,LastModifiedDate 
                     FROM AsiaProjectMaster__c];
            AsiaProjectMasterDetail__c masterDetailEntity = createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.qdm=new JEOLAsia_ProjectMasterCtrl.QuotationDetailManage(entity,false,false);
            
            String div=ctrl.productDivision;
            String add=ctrl.address;
            
            ctrl.deleteAction();
            
            
            Test.stopTest();
        }
    }
    private static testMethod void test01_3() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'true');
            Account acc= createAccountTestObject('T111111','UNITED MICROELECTRONICS CORPORATION');
            Contact contact = createContactTestObject(acc.Id);
            
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,null,false);
            createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.getPicklist('AsiaProjectMaster__c', 'CurrencyContractPrice__c');
            ctrl.getCurrencyContractPriceItems();
            ctrl.getSeriesOptions();
            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();
            ctrl.shipmentContactAttachment();
            ctrl.copyFromPC_onclick();
            Test.stopTest();
        }
    }
    private static testMethod void test01_1() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            createAccountTestObject('T111111','');
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'true');
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('1111111',null,null,null,false);
            createAsiaProjectMasterDetail(entity.Id);           
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.getPicklist('AsiaProjectMaster__c', 'CurrencyContractPrice__c');
            ctrl.getCurrencyContractPriceItems();
            ctrl.getSeriesOptions();
            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();
            ctrl.shipmentContactAttachment();
            Test.stopTest();
        }
    }
    private static testMethod void test01_2() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'true');
            Account acc= createAccountTestObject('T111111','');
            Contact contact = createContactTestObject(acc.Id);
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',acc.Id,contact.Id,null,false);
            createAsiaProjectMasterDetail(entity.Id);
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            ctrl.getPicklist('AsiaProjectMaster__c', 'CurrencyContractPrice__c');
            ctrl.getCurrencyContractPriceItems();
            ctrl.getSeriesOptions();
            ctrl.ContractAttachmentFromCode();
            ctrl.ShipmentAttachmentFromCode();
            ctrl.ContractAttachment();
            ctrl.ShipmentAttachment();
            ctrl.contractContactAttachment();
            ctrl.shipmentContactAttachment();
            Test.stopTest();
        }
    }
    private static testMethod void test02() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');
            AsiaProjectMaster__c entity =   createAsiaProjectMaster('T111111',null,null,null,false);
            
            params.put(PARAM_ID, entity.Id);
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(entity);
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            
            
            Test.stopTest();
        }
    }
    private static testMethod void test03() {
        System.runAs (testUser) {
            Test.startTest();
            createAsiaCompanyData();
            updateTestUser(QUOTATION_COMPANY_ASIA);
            
            PageReference testPage = Page.JEOLAsia_ProjectMaster;
            Map<String, String> params = new Map<String, String>();           
            params.put(SCROLL_TOP, '0');
            params.put(URL_PARAM_NAME_ISCOPY, 'false');           
            testPage.getParameters().putAll(params);
            
            Test.setCurrentPage(testPage);   
            ApexPages.StandardController sc = new ApexPages.StandardController(new AsiaProjectMaster__c());
            
            JEOLAsia_ProjectMasterCtrl ctrl = new JEOLAsia_ProjectMasterCtrl(sc);
            
            
            Test.stopTest();
        }
    }
    private static AsiaProfitCalculation__c createAsiaProfitCalculation(){
        AsiaProfitCalculation__c entity= new AsiaProfitCalculation__c();
        try{ 
            insert entity;
        }
        catch(System.Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculation Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculation Insert Error  end ★★★★★★★★');
        }
        return entity;
    }
    
    private static AsiaProjectMaster__c createAsiaProjectMaster(String accountCode,Id accountId,Id contactId,Id profitCalculation,boolean validRequired){
        AsiaProjectMaster__c entity= new AsiaProjectMaster__c();
        try{
            
            entity.ContractCode__c=accountCode;
            entity.ShipmentCode__c=accountCode;
            entity.ContractAccount_dummyField__c=accountId;
            entity.ShipmentAccount_dummyField__c=accountId;
            entity.ContractContact_dummyField__c=contactId;
            entity.ShipmentContact_dummyField__c=contactId;
            entity.ProfitCalculation__c=profitCalculation;
            entity.ContractName2__c='Contract Name 2';
            entity.CurrencyIsoCode ='JPY';
            if(validRequired){
                //entity.Series__c='AP';
                entity.SalesPerson__c=testUser.Id;                
            }
            insert entity;
            
        }
        catch(System.Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProjectMaster Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProjectMaster Insert Error  end ★★★★★★★★');
        }
        return entity;
    }
    private static AsiaProjectMasterDetail__c createAsiaProjectMasterDetail(Id parentId){
        AsiaProjectMasterDetail__c entity= new AsiaProjectMasterDetail__c();
        try{
            entity.Depth__c=0;
            //entity.SortNo__c=0;
            entity.Parent__c=parentId;
            insert entity;
        }
        catch(System.Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProjectMasterDetail Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProjectMasterDetail Insert Error  end ★★★★★★★★');
        }
        return entity;
    }
    private static void updateTestUser(String companyName){
        testUser.CompanyName=companyName;
        update testUser;       
    }
    private static void createAsiaCompanyData(){
        CompanyName__c company=new CompanyName__c();
        company.Name=QUOTATION_COMPANY_ASIA;
        company.CompanyName__c=QUOTATION_COMPANY_ASIA;
        company.Company__c=QUOTATION_COMPANY_ASIA;
        company.CompanyLabel__c=QUOTATION_COMPANY_ASIA;
        company.OrgAddress__c=QUOTATION_COMPANY_ASIA;
        company.OrgPhone__c=QUOTATION_COMPANY_ASIA;
        insert company;
    }
    public static Account createAccountTestObject(String accountCode,String officialNameRow1){
        
        RecordType accountRecType = JEOLAsia_TestDataFactory.getRecordType('Account');
        Account a = new Account(Name='Test',
                                Code__c = accountCode,
                                RecordTypeId = accountRecType.Id,
                                SalesAccountFlag__c = true,
                                SalesAccountSituation__c = '',
                                ShipmentAccountFlag__c = true,
                                ShipmentAccountSituation__c = '',
                                OfficialNameRow1__c=officialNameRow1
                               );
        
        System.runAs (testUser) {
            insert a;
            
        }
        return a;
    }
    public static Contact createContactTestObject(Id accountId){
        Contact c = new Contact(
            AccountId = accountId,
            LastName='Test'
        );
        System.runAs (testUser) {
            insert c;
        }
        return c;
    }
    private static AsiaProfitCalculationDetail__c createAsiaProfitCalculationDetail(Id parentId){       
        List<AsiaProfitCalculationDetail__c> entityList = new List<AsiaProfitCalculationDetail__c>();         
        AsiaProfitCalculationDetail__c entity= new AsiaProfitCalculationDetail__c();
        entity.Parent__c=parentId;
        entity.Depth__c=0;
        //entity.SortNo__c=0;
        entity.Category__c='A';
        entityList.add(entity);
        try{ 
            
            insert entityList;
        }
        catch(System.Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail Insert Error  end ★★★★★★★★');
        }
        return entity;
    }
}