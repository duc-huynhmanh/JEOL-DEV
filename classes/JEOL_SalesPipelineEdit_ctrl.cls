public with sharing class JEOL_SalesPipelineEdit_ctrl {

    SalesPipeline__c so;

    public String DepartmentCode {get; set;}
    
    public JEOL_SalesPipelineEdit_ctrl(ApexPages.StandardController controller) {
        If (!Test.isRunningTest()) {
            controller.addFields(new List<String>{'RecordType'});
            controller.addFields(new List<String>{'RecordType.DeveloperName'});
            controller.addFields(new List<String>{'CountryName__c'});
            controller.addFields(new List<String>{'RegionName__c'});
            controller.addFields(new List<String>{'KigyoTani__c'});
            controller.addFields(new List<String>{'Series__c'});
            controller.addFields(new List<String>{'WinLossAddedDate__c'});
            controller.addFields(new List<String>{'Department__c'});
            controller.addFields(new List<String>{'Department__r.Name'});
            controller.addFields(new List<String>{'Department__r.DepartmentCode__c'});
        }
        so = (SalesPipeline__c) controller.getRecord();

        if (so.Department__r != NULL && so.Department__r.DepartmentCode__c != NULL) {
            DepartmentCode = so.Department__r.DepartmentCode__c;
        }

        String recClone = ApexPages.currentPage().getParameters().get('clone');
        if(recClone != null && recClone == '1') {
            so.id = null;
            so.Name = null;
            so.SalesOrder__c = null;
            so.SalesOrderLkUp__c = null;
            so.Quotation__c = null;
            so.LastQuotationNumber__c = null;

            // For new PL, it is with the record type JEOL (even if it is a copy of PCS PL)
            so.RecordTypeId = Schema.SObjectType.SalesPipeline__c.getRecordTypeInfosByName().get('JEOL').getRecordTypeId();            
        }

    }

    public List<SelectOption> getDepartments() {
        List<SelectOption> options = new List<SelectOption>();
        List<Department__c> masterRecs = [SELECT Id, Name, DepartmentCode__c FROM Department__c ORDER BY SortNo__c];
        options.add(new SelectOption('', ''));
        for (Department__c rec: masterRecs) {
            options.add(new SelectOption(rec.DepartmentCode__c, rec.Name));
        }
        return options;
    }
    public List<SelectOption> getCountries() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_COUNTRY);
    }

    public List<SelectOption> getSeries() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_SERIES);
    }

    public List<SelectOption> getOrgUnit() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_ORG_UNIT);
    }

    public List<SelectOption> getArea() {
        return JEOLUtil.getSelectList(JEOLUtil.REFERENCE_NAME_QUOTATION_AREA_CODE);
    }
    
    public String getCurrentCountry() {
        return getLabelPicklist(JEOLUtil.REFERENCE_NAME_COUNTRY, so.CountryName__c);
    }

    public String getCurrentArea() {
        return getLabelPicklist(JEOLUtil.REFERENCE_NAME_QUOTATION_AREA_CODE, so.RegionName__c);
    }
    
    public String getCurrentOrgUnit() {
        return getLabelPicklist(JEOLUtil.REFERENCE_NAME_ORG_UNIT, so.KigyoTani__c);
    }
    
    public String getCurrentSerie() {
        return getLabelPicklist(JEOLUtil.REFERENCE_NAME_SERIES, so.Series__c);
    }

    private String getLabelPicklist(String ReferenceName, String Value) {
        String sReturn = '';
        
        For(SelectListManage__c listopt : [SELECT Label__c FROM SelectListManage__c WHERE ReferenceName__c = :ReferenceName AND Value__c = :Value]) {
            sReturn = listopt.Label__c;
        }
        
        return sReturn;
    }
    
    public PageReference save(){

        boolean fExistProblem = checkFields();
        if (fExistProblem) {
            return null;
        }

        so.Department__c = NULL;
        if (DepartmentCode != NULL) {
            List<Department__c> lsDep = [SELECT Id, Name, DepartmentCode__c FROM Department__c where DepartmentCode__c = :DepartmentCode ORDER BY SortNo__c];
            for (Department__c dep: lsDep) {
                so.Department__c = dep.id;
            }
        }

        // Modified 2015/09/25 by B. Polus: Change also the Linkage status for modifications of BaaN PL
        // if (so.RecordType.DeveloperName == 'JEOL')
        // {
        so.LinkageStatus__c = '未連携';
        // }

        // Create / Update the Name
        if (so.PipelineType__c != null && so.PipelineType__c.length() == 1) {        
            if (so.id == null) {
                // New record
                so.Name = so.PipelineType__c + JEOLUtil.nextNumberingPipelineValue();
            } else {
                // Existing record: If PipelineType__c has changed, we must update the Name
                if (so.Name.length() >= 1 && so.Name.substring(0, 1) != so.PipelineType__c) {
                    so.Name = so.PipelineType__c + so.Name.substring(1);
                }
            }
        }
        
        // Update systematically ShodanNo_sync__c
        so.ShodanNo_sync__c = so.Name;
        
        try {
            upsert so;
        } catch (Exception e) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));   
            return null;
        }
            
        PageReference newPage = New PageReference('/' + so.id);
        newPage.setRedirect(true);
        return newPage;
        
    }

    public String getCurrencyLabel() {
        List<CurrencyType> lstCur = [SELECT ToLabel(IsoCode) from CurrencyType where IsoCode = :so.CurrencyIsoCode];
        if (lstCur != NULL && lstCur.size() > 0 && lstCur[0].IsoCode != NULL && lstCur[0].IsoCode.length() > 6)
        {
            return lstCur[0].IsoCode.substring(6);
        } else {
            return so.CurrencyIsoCode;
        }
    } 

    // Modified 2015/09/25 by B. Polus: BaaN PL is no more read-only
/*
    public PageReference redirect(){

        if (so.RecordType.DeveloperName != NULL && so.RecordType.DeveloperName != 'JEOL') {
            PageReference pageRef = new PageReference('/apex/JEOL_SalesPipelineView');
            pageRef.getParameters().put('id', so.ID);
            pageRef.setRedirect(true);
            return pageRef;
        }

        return null;

    }
*/

    public PageReference cloneData(){

        id recId = ApexPages.currentPage().getParameters().get('id');
        if(recId == null) return null;

        Pagereference targetClonePg = Page.JEOL_SalesPipelineEdit;
        targetClonePg.getParameters().put('clone', '1');
        targetClonePg.getParameters().put('id', recId);
        targetClonePg.getParameters().put('retURL', recId);
        targetClonePg.setRedirect(true);
        return targetClonePg;

    }
    
    private boolean checkFields() {
    
        boolean fExistProblem = false;
        
        try {

            if (!fExistProblem) {
                String sListFields = '';
                
                // Checks #1: Required fields
                if (so.KigyoTani__c == null || so.KigyoTani__c.length() == 0) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.KigyoTani__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (so.PipelineType__c == null || so.PipelineType__c.length() == 0) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.PipelineType__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (so.CountryName__c == null || so.CountryName__c.length() == 0) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.CountryName__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (so.RegionName__c == null || so.RegionName__c.length() == 0) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.RegionName__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (so.Series__c == null || so.Series__c.length() == 0) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.Series__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (DepartmentCode == null || DepartmentCode.length() == 0) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.Department__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (so.ShodanSituation__c == null || so.ShodanSituation__c.length() == 0) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.ShodanSituation__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (so.YosanKakudoValue__c == null) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.YosanKakudoValue__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                if (so.JuchuKakudoValue__c == null) {
                    if (sListFields != null && sListFields.length() > 0) {
                        sListFields += ', ';
                    }
                    sListFields += Schema.SalesPipeline__c.fields.JuchuKakudoValue__c.getDescribe().getLabel();
                    fExistProblem = true;
                }
                
                if (fExistProblem) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '値を入力してください: [' + sListFields + ']'));   
                }
            }
            
            if (!fExistProblem) {
            
                // Checks #2: Validation rules
                
                // VR01_CustomerLabel
                if (so.CustomerAccount__c != NULL && so.CustomerAccountNameInput__c != NULL) {
                    so.CustomerAccountNameInput__c.addError('「顧客名称」の項目は「顧客名称」の項目が設定されてないときだけ使えます。');
                    fExistProblem = true;                
                }
            
                // VR01_ProductLabel
                if (so.Shohin__c != NULL && so.ShohinNameInput__c != NULL) {
                    so.ShohinNameInput__c.addError('「商品名」の項目は「商品」の項目が設定されてないときだけ使えます。');
                    fExistProblem = true;                
                }

                // VR02_JuchuYoteiTsuki
                if (so.JuchuYoteiTsuki__c != NULL && so.JuchuYoteiTsuki__c.length() > 0 && (so.JuchuYoteiTsuki__c.length() != 6 || !so.JuchuYoteiTsuki__c.isNumeric() || (so.JuchuYoteiTsuki__c.right(2) != '01' && so.JuchuYoteiTsuki__c.right(2) != '02' && so.JuchuYoteiTsuki__c.right(2) != '03' && so.JuchuYoteiTsuki__c.right(2) != '04' && so.JuchuYoteiTsuki__c.right(2) != '05' && so.JuchuYoteiTsuki__c.right(2) != '06' && so.JuchuYoteiTsuki__c.right(2) != '07' && so.JuchuYoteiTsuki__c.right(2) != '08' && so.JuchuYoteiTsuki__c.right(2) != '09' && so.JuchuYoteiTsuki__c.right(2) != '10' && so.JuchuYoteiTsuki__c.right(2) != '11' && so.JuchuYoteiTsuki__c.right(2) != '12'))) {
                    so.JuchuYoteiTsuki__c.addError('年月の入力は「yyyymm」に入力してください。 [受注予定月]');
                    fExistProblem = true;                
                }
            
                // VR03_UriageYoteiTsuki
                if (so.UriageYoteiTsuki__c != NULL && so.UriageYoteiTsuki__c.length() > 0 && (so.UriageYoteiTsuki__c.length() != 6 || !so.UriageYoteiTsuki__c.isNumeric() || (so.UriageYoteiTsuki__c.right(2) != '01' && so.UriageYoteiTsuki__c.right(2) != '02' && so.UriageYoteiTsuki__c.right(2) != '03' && so.UriageYoteiTsuki__c.right(2) != '04' && so.UriageYoteiTsuki__c.right(2) != '05' && so.UriageYoteiTsuki__c.right(2) != '06' && so.UriageYoteiTsuki__c.right(2) != '07' && so.UriageYoteiTsuki__c.right(2) != '08' && so.UriageYoteiTsuki__c.right(2) != '09' && so.UriageYoteiTsuki__c.right(2) != '10' && so.UriageYoteiTsuki__c.right(2) != '11' && so.UriageYoteiTsuki__c.right(2) != '12'))) {
                    so.UriageYoteiTsuki__c.addError('年月の入力は「yyyymm」に入力してください。 [売上予定月]');
                    fExistProblem = true;                
                }
            
                // VR04_ReceiveMonthHonbu
                if (so.ReceiveMonthHonbu__c != NULL && so.ReceiveMonthHonbu__c.length() > 0 && (so.ReceiveMonthHonbu__c.length() != 6 || !so.ReceiveMonthHonbu__c.isNumeric() || (so.ReceiveMonthHonbu__c.right(2) != '01' && so.ReceiveMonthHonbu__c.right(2) != '02' && so.ReceiveMonthHonbu__c.right(2) != '03' && so.ReceiveMonthHonbu__c.right(2) != '04' && so.ReceiveMonthHonbu__c.right(2) != '05' && so.ReceiveMonthHonbu__c.right(2) != '06' && so.ReceiveMonthHonbu__c.right(2) != '07' && so.ReceiveMonthHonbu__c.right(2) != '08' && so.ReceiveMonthHonbu__c.right(2) != '09' && so.ReceiveMonthHonbu__c.right(2) != '10' && so.ReceiveMonthHonbu__c.right(2) != '11' && so.ReceiveMonthHonbu__c.right(2) != '12'))) {
                    so.ReceiveMonthHonbu__c.addError('年月の入力は「yyyymm」に入力してください。 [受注月(本部)]');
                    fExistProblem = true;                
                }
                
                // VR05_ReceiveMonthGroupTop
                if (so.ReceiveMonthGroupTop__c != NULL && so.ReceiveMonthGroupTop__c.length() > 0 && (so.ReceiveMonthGroupTop__c.length() != 6 || !so.ReceiveMonthGroupTop__c.isNumeric() || (so.ReceiveMonthGroupTop__c.right(2) != '01' && so.ReceiveMonthGroupTop__c.right(2) != '02' && so.ReceiveMonthGroupTop__c.right(2) != '03' && so.ReceiveMonthGroupTop__c.right(2) != '04' && so.ReceiveMonthGroupTop__c.right(2) != '05' && so.ReceiveMonthGroupTop__c.right(2) != '06' && so.ReceiveMonthGroupTop__c.right(2) != '07' && so.ReceiveMonthGroupTop__c.right(2) != '08' && so.ReceiveMonthGroupTop__c.right(2) != '09' && so.ReceiveMonthGroupTop__c.right(2) != '10' && so.ReceiveMonthGroupTop__c.right(2) != '11' && so.ReceiveMonthGroupTop__c.right(2) != '12'))) {
                    so.ReceiveMonthGroupTop__c.addError('年月の入力は「yyyymm」に入力してください。 [受注月(グループ長)]');
                    fExistProblem = true;                
                }  
            
                // VR06_YosanKakudoValue
                if (so.YosanKakudoValue__c < 0 || so.YosanKakudoValue__c > 100) {
                    so.YosanKakudoValue__c.addError('「0%〜100%」に入力してください。 [予算確度]');
                    fExistProblem = true;                
                }
            
                // VR07_JuchuKakudoValue
                if (so.JuchuKakudoValue__c < 0 || so.JuchuKakudoValue__c > 100) {
                    so.JuchuKakudoValue__c.addError('「0%〜100%」に入力してください。 [受注確度]');
                    fExistProblem = true;   
                }

                // VR08_ShukkaYokyuTsuki
                if (so.ShukkaYokyuTsuki__c != NULL && so.ShukkaYokyuTsuki__c.length() > 0 && (so.ShukkaYokyuTsuki__c.length() != 6 || !so.ShukkaYokyuTsuki__c.isNumeric() || (so.ShukkaYokyuTsuki__c.right(2) != '01' && so.ShukkaYokyuTsuki__c.right(2) != '02' && so.ShukkaYokyuTsuki__c.right(2) != '03' && so.ShukkaYokyuTsuki__c.right(2) != '04' && so.ShukkaYokyuTsuki__c.right(2) != '05' && so.ShukkaYokyuTsuki__c.right(2) != '06' && so.ShukkaYokyuTsuki__c.right(2) != '07' && so.ShukkaYokyuTsuki__c.right(2) != '08' && so.ShukkaYokyuTsuki__c.right(2) != '09' && so.ShukkaYokyuTsuki__c.right(2) != '10' && so.ShukkaYokyuTsuki__c.right(2) != '11' && so.ShukkaYokyuTsuki__c.right(2) != '12'))) {
                    so.ShukkaYokyuTsuki__c.addError('年月の入力は「yyyymm」に入力してください。 [出荷要求月]');
                    fExistProblem = true;                
                }
            
                // VR09_ShodanSituation_Required
                // Done in required fields
           
            }
            
        } catch (exception ex) {
            fExistProblem = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));   
        }
        
        return fExistProblem;
        
    }

}