public with sharing class VoxerEventLogMonitorPlusSettingsCtrl {
    
    public String userid {get; set;}
    public String passwd {get; set;}
    public String voxerURL {get; set;}
    public String accessType {get; set;}
    public String organizationId {get; set;}
    
    public VoxerEventLogMonitorPlusSettingsCtrl() {
        AuthenticationSettings__c setting = CryptoUtility.getIns();
        voxerURL = setting.ServicePlatformURL__c;
        accessType = setting.AccessType__c;
    }
    
    public PageReference generateKey() {
//      try {
            CryptoUtility.generateCryptoKey();
            AuthenticationSettings__c setting = CryptoUtility.getIns();
            setting.EncryptedData__c = '';
            upsert setting;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'キーを再生成しました。'));
//      } catch (Exception e) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'キーを再生成できませんでした。(' + e.getMessage() + ')')); 
//      }
        return null;
    }
    
    public PageReference saveAuth() {
//      try {
            CryptoUtility.generateEncryptedConnectionInfo(userid, passwd);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '認証情報を保存しました。'));
//      } catch (Exception e) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '認証情報を保存できませんでした。(' + e.getMessage() + ')'));
//      }
        return null;
    }
    
    public PageReference saveURL() {
//      try {
            AuthenticationSettings__c setting = CryptoUtility.getIns();
            setting.ServicePlatformURL__c = voxerURL;
            setting.AccessType__c = accessType;
        	setting.OrganizationId__c = organizationId;
            upsert setting;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, '接続先URLを更新しました'));
//      } catch (Exception e) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '接続先URLを更新できませんでした。(' + e.getMessage() + ')'));
//      }
        return null;
    }

}