public without sharing class JEOLAsia_ProfitCalcEditorPageCtrlNoShare {

    public static Pagereference deleteActionWithoutSharing(AsiaProfitCalculation__c parentRec) {

        delete parentRec;
        return Page.JEOLAsia_ProfitCalculationListPage;

    }

}