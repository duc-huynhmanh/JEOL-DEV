@IsTest
private class JEOLUtilTest {

    private static testMethod void test01() {

        NumberingMaster__c nm = new NumberingMaster__c();
        nm.Name = 'dummy';
        nm.Prefix__c = 'dummy';
        nm.Suffix__c = 'dummy';
        nm.Type__c = 'dummy';
        nm.Digit__c = 2;
        nm.CurrentNumber__c = 1;
        insert nm;
        
        String ret1 = JEOLUtil.appendBeforeLikeText('dummy', 'dummy');
        List<String> lsstr = new List<String>();
        lsstr.add('dummy');
        String ret2 = JEOLUtil.appendInText('dummy', lsstr, true);
        String ret3 = JEOLUtil.joinWhereConditions(new List<String>());
        Decimal ret4 = JEOLUtil.getTaxationValue();
        NumberingMaster__c ret5 = JEOLUtil.getTargetMaster('dummy', 'dummy', 'dummy');
        String ret6 = JEOLUtil.nextNumberingValue(ret5);
        JEOLUtil.numberingUpdate(ret5);
        JEOLUtil.paddingLeftPadding(2, 2);
        
        System.AssertEquals(JEOLUtil.nextNumberingPipelineValue(), '00000001');
        System.AssertEquals(JEOLUtil.nextNumberingPipelineValue(), '00000002');
        
    }
    
}