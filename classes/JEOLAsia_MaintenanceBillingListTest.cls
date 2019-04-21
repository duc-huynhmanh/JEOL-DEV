@IsTest
private class JEOLAsia_MaintenanceBillingListTest {
    // User(ユーザ)
    private static User testUser = JEOLAsia_TestDataFactory.createTestUser();

    private static Date dTodayFirstDay = Date.newInstance(Date.today().year(), Date.today().month(), 1);
    //Account(取引先)
    private static Account testAccount = JEOLAsia_TestDataFactory.createAccountTestObject('AccountName', 'T123456', false, '有効', false, '有効');
    private static Map<Id, AsiaProjectMaster__c> projectMasterMap;

    /*
     * Description: Test Constructor(without search conditions)
     * MethodName : JEOL_MaintenanceListToRenew_ctrl_Test01
     */
    private static testMethod void JEOLAsia_MaintenanceBillingList_ctrl_Test01() {
        // Preparation(None)
        System.runAs (testUser) {
            Test.startTest();

            JEOLAsia_MaintenanceBillingList_ctrl ctrl = new JEOLAsia_MaintenanceBillingList_ctrl();

            Test.stopTest();
        }
    }

    /*
     * Description: Test series Button(selected series is two)
     * MethodName : seriesSelectBtn_Test01
     */
    private static testMethod void seriesSelectBtn_Test01() {
        JEOLAsia_MaintenanceBillingList_ctrl ctrl = new JEOLAsia_MaintenanceBillingList_ctrl();
        Integer selectedCount = 1;
        for(JEOLAsia_MaintenanceBillingList_ctrl.OptionDetail od :ctrl.SeriesOptions){
            if(selectedCount < 3){
                od.isSelected = true;
            }
        }
        System.runAs (testUser) {
            Test.startTest();

            ctrl.seriesSelectApply();
            ctrl.getSelectedSeries();

            Test.stopTest();
        }
    }

    /*
     * Description: Test series Button(All select)
     * MethodName : seriesSelectBtn_Test01
     */
    private static testMethod void seriesSelectBtn_Test02() {
        JEOLAsia_MaintenanceBillingList_ctrl ctrl = new JEOLAsia_MaintenanceBillingList_ctrl();
        ctrl.seriesSelectAllSelect();
        System.runAs (testUser) {
            Test.startTest();

            ctrl.seriesSelectApply();
            ctrl.getSelectedSeries();

            Test.stopTest();
        }
    }



    /*
     * Description: Test Search/Clear Method(with search coditions)
     * MethodName : doSearch_Clear_Test01
     */
    private static testMethod void doSearch_Clear_Test01() {
        // Preparation
        createTestData01();
        // Set Search Conditions
        JEOLAsia_MaintenanceBillingList_ctrl ctrl = new JEOLAsia_MaintenanceBillingList_ctrl();
        ctrl.month = '2016';
        ctrl.customerCode = '0001';
        ctrl.customerName = 'TestName';


        ctrl.getStatusOptions();
        ctrl.status = 'Only Inspected';

        ctrl.invoiceNumber = '';

        ctrl.getCCategoryOptions();

        System.runAs (testUser) {
            Test.startTest();

            // Search
            ctrl.doSearch();
            // Search Reult
            ctrl.getSalesPipelines();
            // Clear
            ctrl.doFormClear();

            Test.stopTest();
        }
    }

    private static void createTestData01(){
        // create maintenance contract management records
        List<AsiaMaintenanceContractManagement__c> mcmList = createMcm();

        String sType = '1';
        String sStartMonth;
        String sEndMonth;
        Integer mcmCount = 0;
        for(AsiaMaintenanceContractManagement__c mcm :mcmList){
            if(mcmCount < 3){
                List<AsiaMaintenanceAccountBook__c> mabList = new List<AsiaMaintenanceAccountBook__c>();
                sStartMonth = Datetime.newInstance(projectMasterMap.get(mcm.ProjectMaster__c).ContractStartDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');
                sEndMonth = datetime.newInstance(projectMasterMap.get(mcm.ProjectMaster__c).ContractEndDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');

                Integer iStartYear = Integer.valueOf(sStartMonth.substring(0, 4));
                Integer iStartMonth = Integer.valueOf(sStartMonth.substring(4));
                Integer iEndYear = Integer.valueOf(sEndMonth.substring(0, 4));
                Integer iEndMonth = Integer.valueOf(sEndMonth.substring(4));

                if (iEndYear > iStartYear + 10) {
                    iEndYear = iStartYear;
                    iEndMonth = iStartMonth;
                }

                for(Integer i = 0; i < 12; i ++){
                    AsiaMaintenanceAccountBook__c mabRow = new AsiaMaintenanceAccountBook__c();
                    mabRow.MaintenanceContractManagement__c = mcm.Id;
                    mabRow.Month__c = ('0000' + string.valueof(iStartYear)).substring(string.valueof(iStartYear).length()) + ('00' + string.valueof(iStartMonth)).substring(string.valueof(iStartMonth).length());
                    mabRow.Name = mabRow.Month__c.Substring(0, 4) + '/' + mabRow.Month__c.Substring(4);
                    mabList.add(mabRow);
                    // Get the next month
                    iStartMonth += 1;
                    if (iStartMonth > 12) {
                        iStartYear += 1;
                        iStartMonth = 1;
                    }
                }
                try{
                    //insert mabList;
                }catch(Exception e){
                    system.debug('★★★★★★★★★★★★★ Maintenance Account Book Insert Error  start ★★★★★★★★');
                    system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
                    system.debug('★★★★★★★★★★★★★ Maintenance Account Book Insert Error  end ★★★★★★★★');
                }
            }
            mcmCount ++;
        }

    }

    /**
     * [createMcm create maintenance contract management records]
     * @return [maintenance contract management records]
     */
    private static List<AsiaMaintenanceContractManagement__c> createMcm(){
        List<AsiaMaintenanceContractManagement__c> mcmList = new List<AsiaMaintenanceContractManagement__c>();
        List<AsiaProjectMaster__c> pmList = createProjectMasterData();
        projectMasterMap = new Map<Id, AsiaProjectMaster__c>();
        for(AsiaProjectMaster__c pm :pmList){
            projectMasterMap.put(pm.Id, pm);
        }
        // create maintenance contract management record (2 Pages Records)
        for(Integer i = 0; i < 102; i ++){
            AsiaMaintenanceContractManagement__c mcm = new AsiaMaintenanceContractManagement__c();
            mcm.NewOdrSalesAccount__c = testAccount.Id;
            mcm.NewOdrShipmentAccount__c = testAccount.Id;
            mcm.NewOdrSalesStaff__c = testUser.Id;
            if(i < 10){
                mcm.NewOdrSeries__c = 'CA';
            }else if( i < 20){
                mcm.NewOdrSeries__c = 'AP';
            }else if(i < 30){
                mcm.NewOdrSeries__c = 'BS';
            }else if(i < 50){
                mcm.NewOdrSeries__c = 'GC';
            }else if(i < 70){
                mcm.NewOdrSeries__c = 'EM';
            }else if(i < 102){
                mcm.NewOdrSeries__c = 'XP';
            }
            if(i < 70){
                mcm.ProjectMaster__c = pmList[i].Id;
            }else{
                mcm.ProjectMaster__c = pmList[0].Id;
            }

            mcm.QuotationSentDate__c = dTodayFirstDay.addDays(i);
            mcm.NewContractStartDate__c = dTodayFirstDay.addDays(i);
            mcm.NewContractEndDate__c = dTodayFirstDay.addDays((i+30));
            mcmList.add(mcm);
        }
        try{
            insert mcmList;
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ Maintenance Contract Management Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ Maintenance Contract Management Insert Error  end ★★★★★★★★');
        }
        return mcmList;
    }

    /**
     * [createProjectMasterData create project master records]
     * @return [project master records]
     */
    private static List<AsiaProjectMaster__c> createProjectMasterData(){
        List<AsiaProjectMaster__c> projectMasterList = new List<AsiaProjectMaster__c>();
        for(Integer i = 0; i < 70; i ++){
            AsiaProjectMaster__c projectMaster = new AsiaProjectMaster__c();
            if(i < 10){
                projectMaster.ProjectNumber__c = 'PM-00000' + String.valueOf(i);
            }else {
                projectMaster.ProjectNumber__c = 'PM-0000' + String.valueOf(i);
            }
            projectMaster.ContractAccount__c = testAccount.Id;
            projectMaster.ShipmentAccount__c = testAccount.Id;
            /*if(i < 10){
                projectMaster.Series__c = 'CA';
            }else if( i < 20){
                projectMaster.Series__c = 'AP';
            }else if(i < 30){
                projectMaster.Series__c = 'BS';
            }else if(i < 50){
                projectMaster.Series__c = 'GC';
            }else if(i < 70){
                projectMaster.Series__c = 'EM';
            }*/
            projectMaster.SalesPerson__c = testUser.Id;
            projectMaster.ContractStartDate__c = dTodayFirstDay.addDays(i);
            projectMaster.ContractEndDate__c = dTodayFirstDay.addDays((i+30));
            projectMaster.ContractPrice__c = i*1000;
            projectMasterList.add(projectMaster);
        }
        try{
            insert projectMasterList;
        }catch(Exception e){
            system.debug('★★★★★★★★★★★★★ ProjectMaster Insert Error  start ★★★★★★★★');
            system.debug('★★ LineNo' + e.getLineNumber() + ': ' + e.getMessage() + ' ★★');
            system.debug('★★★★★★★★★★★★★ ProjectMaster Insert Error  end ★★★★★★★★');
        }
        return projectMasterList;
    }
}