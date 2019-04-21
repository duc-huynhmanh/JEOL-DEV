global class JEOLAsia_MaintenanceListToRenewAdd_sch implements Schedulable {
    global void execute(SchedulableContext SC) {
        JEOLAsia_MaintenanceListToRenewAdd_ctrl.addContractMaintenanceBatch();
   }
}