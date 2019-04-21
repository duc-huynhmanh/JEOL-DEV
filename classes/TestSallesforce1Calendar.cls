@isTest
private class TestSallesforce1Calendar{
    static testMethod void testMethod1() {
        Event data = new Event();
        data.Subject = 'test';
        data.StartDateTime = system.now();
        data.EndDateTime = system.now();
        insert data;
        
        Sallesforce1CalendarController logic = new Sallesforce1CalendarController();
        logic.pageLoad();
        
    }
}