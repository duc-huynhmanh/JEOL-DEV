@IsTest
public class JEOLAsia_QuotationExportCSVCtrlTest {
    // User(ユーザ)
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();
    /*
* Description: Test Constructor
* MethodName : Test01
*/
    private static testMethod void test01() {
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();
            Id id = createCalculationData();
           	createCalculationDetail2SP(id);
            createCalculationRateData(id,'USD');
            
            
            Pagereference ref = Page.JEOLAsia_QuotationExportCSV;
            Map<String, String> params = new Map<String, String>();
            
            params.put('ID', id);
            ref.getParameters().putAll(params);
            
            Test.setCurrentPage(ref);
            JEOLAsia_QuotationExportCSVCtrl ctrl = new JEOLAsia_QuotationExportCSVCtrl();
            ctrl.getFileName();
            List<List<String>> rowList =  ctrl.lslsstrRowMCM;
            Id i=  ctrl.qtId;
            String s = ctrl.sTitle;
            
            Test.stopTest();
        }
    }
   
    /**
* [createCalculation create project master records]
* @return [AsiaProfitCalculation Id]
*/
    private static Id createCalculationData(){
        AsiaProfitCalculation__c entity = new AsiaProfitCalculation__c();
        entity.JProdCostCurrency__c = 'USD';
        entity.SubtotalACostUnit__c = 999999;
        entity.SubtotalASalesUnit__c = 99999.64;
        entity.SubtotalADiscountRate__c = 99;
        entity.SubtotalADiscount__c = 9999;
        entity.SubtotalADiscountType__c = 'Value';
        entity.TotalProfitRate__c = 10;
        try{
            insert entity;
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculation Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculation Insert Error  end ★★★★★★★★');
        }
        return entity.Id;
    }
    /**
* [createCalculationRateData create project master records]
* @return [AsiaProfitCalculationRate records]
*/
    private static List<AsiaProfitCalculationRate__c> createCalculationRateData(Id id,String currencyBase){
        List<AsiaProfitCalculationRate__c> entityList = new List<AsiaProfitCalculationRate__c>(); 
        AsiaProfitCalculationRate__c entity;
        for(Integer i = 0; i < 2; i ++){
            entity = new AsiaProfitCalculationRate__c();            
            entity.CurrencyToConvert__c  = 'JPY';
            entity.CurrencyBase__c = currencyBase;            
            entity.Profit_Calculation__c = id;
            entity.Type__c  = '2'; 
            entity.ReadOnly__c=false;
            entity.Rate__c=0.01;
            entityList.add(entity);
        }
        try{
            insert entityList;
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationRate Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationRate Insert Error  end ★★★★★★★★');
        }
        
        return entityList;
    }
    /**
* [createCalculationDetailData create project master records]
* @return [AsiaProfitCalculationDetail records]
*/
    private static List<AsiaProfitCalculationDetail__c> createCalculationDetailData(Id id){
        List<AsiaProfitCalculationDetail__c> entityList = new List<AsiaProfitCalculationDetail__c>();        
        AsiaProfitCalculationDetail__c entity;
        for(Integer i = 0; i < 5; i ++){
            entity = new AsiaProfitCalculationDetail__c();            
            entity.CurrencyIsoCode = 'JPY';
            entity.Depth__c = 1;            
            entity.Parent__c = id;
            entity.SortNo__c = i; 
            entity.Quantity__c=3;
            entity.UnitPrice__c=0;
            entity.CostPriceJProdUnit__c=0;
            entity.Category__c='A';
            entityList.add(entity);
            
        }
        try{
            insert entityList;
           
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail Insert Error  end ★★★★★★★★');
        }
        
        return entityList;
    }
    /**
* [createdetail2SP create AsiaProfitCalculationDetail2SP records]
* @return [AsiaProfitCalculationDetail2SP records]
*/
    private static List<AsiaProfitCalculationDetail2SP__c> createCalculationDetail2SP(Id asiaProfitCalculationId){
        List<AsiaProfitCalculationDetail2SP__c> detail2SPList = new List<AsiaProfitCalculationDetail2SP__c>();
        
        try{
            List<AsiaProfitCalculationDetail__c> detailList = createCalculationDetailData(asiaProfitCalculationId);
            
            AsiaProfitCalculationDetail2SP__c detail2SP = new AsiaProfitCalculationDetail2SP__c();
            integer count= detailList.size();
            Id parentId;
            
            for(Integer i = 0; i <count; i++){
                parentId=detailList[i].Id;               
                detail2SP = new AsiaProfitCalculationDetail2SP__c();
                detail2SP.CurrencyIsoCode = 'JPY';
                detail2SP.ProfitCalculationDetail__c = parentId;
                detail2SP.IsSelected__c=true;
                detail2SP.CostPriceJPY__c=17000;
                detail2SPList.add(detail2SP);
            }
            
            insert detail2SPList;
            
            
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail2SP Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ AsiaProfitCalculationDetail2SP Insert Error  end ★★★★★★★★');
        }
        return detail2SPList;
    }
}