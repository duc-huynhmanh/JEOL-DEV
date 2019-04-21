@IsTest
private class JEOL_SalesPipelineEdit_ctrlTest {

    private static testMethod void test01() {
        
        Department__c dep = new Department__c();
        dep.Name = 'dummy';
        dep.DepartmentCode__c = '111';
        upsert dep;

        SalesPipeline__c sp = new SalesPipeline__c();
        sp.RegionName__c = 'dummy';
        sp.KigyoTani__c = 'dummy';
        sp.Series__c = 'dummy';
        sp.CountryName__c = 'dummy';
        sp.YosanKakudoValue__c = 10;
        sp.JuchuKakudoValue__c = 10;
        sp.PipelineType__c = 'A';
        sp.Department__c = [SELECT id from Department__c LIMIT 1].id;
        sp.Name = 'Z12345';
        sp.RegionName__c = '010';
        upsert sp;
        sp.RegionName__c = '011';
        upsert sp;

        Pagereference ref = Page.JEOL_SalesPipelineEdit;
        Map<String, String> params = new Map<String, String>();
        params.put('id', '' + [SELECT id from SalesPipeline__c LIMIT 1].id);
        ref.getParameters().putAll(params);
        Test.setCurrentPage(ref);
        
        JEOL_SalesPipelineEdit_ctrl ctrl = new JEOL_SalesPipelineEdit_ctrl(new ApexPages.StandardController(sp));
    
        List<SelectOption> ret1 = ctrl.getCountries();
        List<SelectOption> ret2 = ctrl.getSeries();
        List<SelectOption> ret3 = ctrl.getOrgUnit();
        List<SelectOption> ret4 = ctrl.getArea();
        String ret5 = ctrl.getCurrentCountry();
        String ret6 = ctrl.getCurrentArea();
        String ret7 = ctrl.getCurrentOrgUnit();
        String ret8 = ctrl.getCurrentSerie();
        ctrl.DepartmentCode = '111';
        PageReference ret9 = ctrl.save();
        String ret10 = ctrl.getCurrencyLabel();
        List<SelectOption> ret11 = ctrl.getDepartments();
        PageReference ret12 = ctrl.cloneData();

        delete sp;

    }

    private static testMethod void test02() {
        
        Department__c dep = new Department__c();
        dep.Name = 'dummy';
        dep.DepartmentCode__c = '111';
        upsert dep;

        SalesPipeline__c sp = new SalesPipeline__c();
        sp.RegionName__c = 'dummy';
        sp.KigyoTani__c = 'dummy';
        sp.Series__c = 'dummy';
        sp.CountryName__c = 'dummy';
        sp.YosanKakudoValue__c = 10;
        sp.JuchuKakudoValue__c = 10;
        sp.PipelineType__c = 'A';
        sp.Department__c = [SELECT id from Department__c LIMIT 1].id;
        sp.Name = 'Z12345';
        sp.RegionName__c = '011';
        sp.RecordTypeID = Schema.SObjectType.SalesPipeline__c.getRecordTypeInfosByName().get('JEOL').getRecordTypeId();            

        upsert sp;

        try {
            delete sp;
        } catch (Exception e) {

        }

    }    
}