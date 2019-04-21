public with sharing class JEOLAsia_MaintenanceAccountBookCtrl {

    public AsiaMaintenanceContractManagement__c so{get; set;}

    public List<AsiaMaintenanceAccountBook__c> lsAccountBookRow {get; set;}

    public String firstMonth {get; set;}
    public JEOLAsia_MaintenanceAccountBookCtrl(ApexPages.StandardController ctrl) {

        List<String> fields = new List<String>();
        fields.add('NewContractStartDate__c');
        fields.add('NewContractEndDate__c');
        fields.add('PreviousYearPipeline__c');
        if (!Test.isRunningTest()) {
            ctrl.addFields(fields);
        }
        this.so = (AsiaMaintenanceContractManagement__c) ctrl.getRecord();
        lsAccountBookRow = [SELECT
                                  Id,
                                  Name,
                                  Inspection__c,
                                  InspectionDone__c,
                                  MaintenanceContractManagement__c,
                                  Month__c,
                                  BillingDone__c,
                                  BillingAmount__c,
                                  BillingAmountFormula__c,
                                  InvoiceNumber__c,
                                  Percentage__c,
                                  PaymentAmount__c
                            FROM  AsiaMaintenanceAccountBook__c
                            WHERE MaintenanceContractManagement__c = :so.Id
                            ORDER BY Month__c ASC];
        // Check if there is some data entered
        boolean fExistData = false;
        for (AsiaMaintenanceAccountBook__c row : lsAccountBookRow) {
            if (row.BillingDone__c ||
                row.BillingAmount__c != null ||
                row.Inspection__c ||
                row.InspectionDone__c ||
                row.InvoiceNumber__c != null ||
                row.PaymentAmount__c != null 
                ){
                    fExistData = true;
                    break;
            }
        }
        if (!fExistData) {
            lsAccountBookRow = new List<AsiaMaintenanceAccountBook__c>();
        }

        // In case of the first call, create the rows from StartDate to EndDate
        if (lsAccountBookRow.size() == 0) {
            String sStartMonth;
            String sEndMonth;

            if (so.NewContractStartDate__c != null && so.NewContractEndDate__c != null) {
                if (so.NewContractEndDate__c >= so.NewContractStartDate__c) {
                    sStartMonth = datetime.newInstance(so.NewContractStartDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');
                    sEndMonth = datetime.newInstance(so.NewContractEndDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');
                } else {
                    sEndMonth = datetime.newInstance(so.NewContractStartDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');
                    sStartMonth = datetime.newInstance(so.NewContractEndDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');
                }
            } else if (so.NewContractStartDate__c != null) {
                sStartMonth = datetime.newInstance(so.NewContractStartDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');
                sEndMonth = sStartMonth;
            } else if (so.NewContractEndDate__c != null) {
                sStartMonth = datetime.newInstance(so.NewContractEndDate__c, Time.newInstance(0,0,0,0)).format('yyyyMM');
                sEndMonth = sStartMonth;
            } else {
                sStartMonth = datetime.newInstance(date.today(), Time.newInstance(0,0,0,0)).format('yyyyMM');
                sEndMonth = sStartMonth;
            }

            integer iStartYear = Integer.valueOf(sStartMonth.substring(0, 4));
            integer iStartMonth = Integer.valueOf(sStartMonth.substring(4));
            integer iEndYear = Integer.valueOf(sEndMonth.substring(0, 4));
            integer iEndMonth = Integer.valueOf(sEndMonth.substring(4));

            if (iEndYear > iStartYear + 10) {
                iEndYear = iStartYear;
                iEndMonth = iStartMonth;
            }

            firstMonth = sStartMonth;
            while (
                    (iStartYear < iEndYear) ||
                    (
                        iStartYear == iEndYear &&
                        iStartMonth <= iEndMonth
                    )
                  ) {
                    // Create a row
                    AsiaMaintenanceAccountBook__c maintRow = new AsiaMaintenanceAccountBook__c();
                    maintRow.MaintenanceContractManagement__c = so.id;
                    maintRow.Month__c = ('0000' + string.valueof(iStartYear)).substring(string.valueof(iStartYear).length()) + ('00' + string.valueof(iStartMonth)).substring(string.valueof(iStartMonth).length());
                    maintRow.Name = maintRow.Month__c.Substring(0, 4) + '/' + maintRow.Month__c.Substring(4);

                    lsAccountBookRow.add(maintRow);

                    // Get the next month
                    iStartMonth += 1;
                    if (iStartMonth > 12) {
                        iStartYear += 1;
                        iStartMonth = 1;
                    }
                }
        }
	}

    public PageReference addFirstRow(){
        Integer iYear = 0;
        Integer iMonth = 0;
        Integer iIdxFirstRow = getIndiceFirstRowNotReturn();
         if (iIdxFirstRow >= 0) {
            // Return the month before the 1st one
            String sMonth = lsAccountBookRow.get(iIdxFirstRow).month__c;
            iYear = Integer.valueOf(sMonth.substring(0, 4));
            iMonth = Integer.valueOf(sMonth.substring(4));

            iMonth -= 1;
            if (iMonth < 1) {
                iYear -= 1;
                iMonth = 12;
            }
        } else{
            // Return the current month
            String sMonth = datetime.newInstance(date.today(), Time.newInstance(0,0,0,0)).format('yyyyMM');
            iYear = Integer.valueOf(sMonth.substring(0, 4));
            iMonth = Integer.valueOf(sMonth.substring(4));
        }
        // Create a row
        AsiaMaintenanceAccountBook__c maintRow = new AsiaMaintenanceAccountBook__c();
        maintRow.MaintenanceContractManagement__c = so.id;
        maintRow.Month__c = ('0000' + string.valueof(iYear)).substring(string.valueof(iYear).length()) + ('00' + string.valueof(iMonth)).substring(string.valueof(iMonth).length());
        maintRow.Name = maintRow.Month__c.Substring(0, 4) + '/' + maintRow.Month__c.Substring(4);

        Integer iIdx = getIndiceInsertion(maintRow.Month__c);
        if (iIdx >= 0) {
            lsAccountBookRow.add(iIdx, maintRow);
        } else {
            lsAccountBookRow.add(maintRow);
        }
        return null;
    }

    private Integer getIndiceFirstRowNotReturn() {

        Integer iReturn = -1;

        if (lsAccountBookRow != null && lsAccountBookRow.size() > 0) {
            iReturn = 0;
        }

        return iReturn;
    }

    private Integer getIndiceInsertion(String month) {

        Integer iReturn = -1;

        Integer iIdx = 0;
        if (lsAccountBookRow != null && lsAccountBookRow.size() > 0) {
            for (AsiaMaintenanceAccountBook__c row : lsAccountBookRow) {
                if (row.month__c >= month) {
                    iReturn = iIdx;
                    break;
                }
                iIdx++;
            }
        }

        return iReturn;
    }

    public PageReference addLastRow(){
        Integer iYear = 0;
        Integer iMonth = 0;
        Integer iIdxLastRow = getIndiceLastRowNotReturn();
        if (iIdxLastRow >= 0) {
            // Return the month before the 1st one
            String sMonth = lsAccountBookRow.get(iIdxLastRow).month__c;
            iYear = Integer.valueOf(sMonth.substring(0, 4));
            iMonth = Integer.valueOf(sMonth.substring(4));

            iMonth += 1;
            if (iMonth > 12) {
                iYear += 1;
                iMonth = 1;
            }
        } else {
            // Return the current month
            String sMonth = datetime.newInstance(date.today(), Time.newInstance(0,0,0,0)).format('yyyyMM');
            iYear = Integer.valueOf(sMonth.substring(0, 4));
            iMonth = Integer.valueOf(sMonth.substring(4));
        }
        // Create a row
        AsiaMaintenanceAccountBook__c maintRow = new AsiaMaintenanceAccountBook__c();
        maintRow.MaintenanceContractManagement__c = so.id;
        maintRow.Month__c = ('0000' + string.valueof(iYear)).substring(string.valueof(iYear).length()) + ('00' + string.valueof(iMonth)).substring(string.valueof(iMonth).length());
        maintRow.Name = maintRow.Month__c.Substring(0, 4) + '/' + maintRow.Month__c.Substring(4);

        Integer iIdx = getIndiceInsertion(maintRow.Month__c);
        if (iIdx >= 0) {
            lsAccountBookRow.add(iIdx, maintRow);
        } else {
            lsAccountBookRow.add(maintRow);
        }

        return null;
    }

    private Integer getIndiceLastRowNotReturn() {

        Integer iReturn = -1;

        if (lsAccountBookRow != null && lsAccountBookRow.size() > 0) {
            iReturn = lsAccountBookRow.size() - 1;
        }

        return iReturn;
    }

    public PageReference removeFirstRow(){

        removeRow(getIndiceFirstRowNotReturn());
        return null;

    }

    public PageReference removeLastRow(){

        removeRow(getIndiceLastRowNotReturn());
        return null;

    }

    private void removeRow(integer idxRow){

        if (idxRow >= 0) {
            lsAccountBookRow.remove(idxRow);
        }

    }


    public PageReference importPreviousYearData(){
        if (so.PreviousYearPipeline__c == null) {
            // Should not happen, the button is not enabled
            return null;
        }

        List<AsiaMaintenanceAccountBook__c> lsPast = [
                                                        SELECT
                                                            Id,
                                                            Name,
                                                            Inspection__c,
                                                            InspectionDone__c,
                                                            MaintenanceContractManagement__c,
                                                            Month__c,
                                                            BillingDone__c,
                                                            BillingAmount__c,
                                                            Percentage__c,
                                                            PaymentAmount__c
                                                        FROM AsiaMaintenanceAccountBook__c
                                                        WHERE MaintenanceContractManagement__c = :so.PreviousYearPipeline__c
                                                        ORDER BY Month__c ASC
                                                 ];
        if (lsPast == null || lsPast.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '前年の台帳情報がありません。'));
            return null;
        }
        // Clear the data already present
        for (AsiaMaintenanceAccountBook__c row : lsAccountBookRow) {
            row.Inspection__c = false;
            row.InspectionDone__c = false;
            row.BillingAmount__c = null;
            row.BillingDone__c = false;
            row.PaymentAmount__c = null;
            row.InvoiceNumber__c = null;
        }

        for (Integer idx = 0; idx < lsPast.size(); idx++) {

            if (lsAccountBookRow.size() <= idx) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, '今回の期間は前年より短かったので、ある部分をコピーできませんでした。'));
                return null;
            }

            lsAccountBookRow[idx].Inspection__c = lsPast[idx].Inspection__c;
            lsAccountBookRow[idx].BillingAmount__c = lsPast[idx].BillingAmount__c;
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '前年の情報をコピーしました。'));
        return null;
    }

    public PageReference save(){
        try {
            // for account book percentage ,calculate target is billing amount
            Decimal toTargetMonthTotalPaymentAmount = 0;
            Decimal toTargetMonthTotalBillingAmount = 0;
            for (AsiaMaintenanceAccountBook__c row : lsAccountBookRow) {
                    // payment amount
                    if(row.PaymentAmount__c == null){
                        toTargetMonthTotalPaymentAmount += 0;
                    }else{
                        toTargetMonthTotalPaymentAmount += row.PaymentAmount__c;
                    }
                    // billing amount
                    if(row.BillingAmount__c == null){
                        toTargetMonthTotalBillingAmount += 0;
                    }else{
                        toTargetMonthTotalBillingAmount += row.BillingAmount__c;
                    }
                    // conditions that percentage value is "-"
                    if(
                        toTargetMonthTotalPaymentAmount == 0 ||
                        toTargetMonthTotalPaymentAmount == null ||
                        toTargetMonthTotalBillingAmount == 0 ||
                        toTargetMonthTotalBillingAmount == null
                       ){
                        row.Percentage__c = '-';
                    }else {
                        // total (divide payment amount by billing amount) and result length is 3
                        Decimal calculate = toTargetMonthTotalPaymentAmount.divide(toTargetMonthTotalBillingAmount,3)*100;
                        // divide result  by 1 and this result length is 1
                        row.Percentage__c = String.valueOf(calculate.divide(1,1)) + '%';
                    }
            }

            // Delete the data that has been deleted
            List<id> lsIDKept = new List<id>();
            for (AsiaMaintenanceAccountBook__c row : lsAccountBookRow) {
                row.Name = row.Month__c.Substring(0, 4) + '/' + row.Month__c.Substring(4);
                if (row.id != null) {
                    lsIDKept.add(row.id);
                }
            }
            List<AsiaMaintenanceAccountBook__c> lsOldRows;
            if (lsIDKept != null && lsIDKept.size() > 0) {
                // delete the rows not kept
                lsOldRows = [
                            SELECT
                                Id
                            FROM AsiaMaintenanceAccountBook__c
                            WHERE MaintenanceContractManagement__c = :so.Id
                            AND id NOT IN :lsIDKept
                            ];
            } else {
                // delete all
                lsOldRows = [SELECT Id FROM AsiaMaintenanceAccountBook__c WHERE MaintenanceContractManagement__c = :so.Id];
            }
            if (lsOldRows != null && lsOldRows.size() > 0) {
                delete lsOldRows;
            }

            upsert lsAccountBookRow;
            upsert so;

            PageReference pr = new PageReference('/apex/JEOLAsia_MaintenanceDetailView');
            pr.getParameters().put('id', so.id);
            pr.setRedirect(true);
            return pr;
        }catch (Exception ex) {
            return null;
        }
    }
}