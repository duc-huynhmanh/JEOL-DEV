public class CryptoUtility{
	
	public static AuthenticationSettings__c getIns() {
		AuthenticationSettings__c setting = AuthenticationSettings__c.getOrgDefaults();
		if (setting == null) setting = new AuthenticationSettings__c();
		return setting;
	}

	public static void generateCryptoKey(){
		Blob blobKey = crypto.generateAesKey(128);
		String newKey = EncodingUtil.base64Encode(blobKey);
	
		AuthenticationSettings__c setting = getIns();
		setting.CryptoKey__c = newKey;
		upsert setting;
	}

	public static void generateEncryptedConnectionInfo(String uname, String passwd)
	{
		String connectionInfo = EncodingUtil.base64Encode(Blob.valueof(uname + ':' + passwd));

		AuthenticationSettings__c setting = getIns();

        if(setting.CryptoKey__c == null)
    	{
    		throw new EventMonitoringLogException('CryptoKey__c in not initialized in AuthenticationSettings__c');
    		return;
    	}
    	else
    	{
    		Blob key = EncodingUtil.base64Decode(setting.CryptoKey__c);
        	Blob encrypted = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(connectionInfo));
        	setting.EncryptedData__c = EncodingUtil.base64Encode(encrypted);
        	upsert setting;
    	}
	}

	public static String getDecryptedConnectionInfo()
	{
		AuthenticationSettings__c setting = AuthenticationSettings__c.getOrgDefaults();
		if(setting == null)
			return null;

		Blob key = EncodingUtil.base64Decode(setting.CryptoKey__c);
		Blob encrypted = EncodingUtil.base64Decode(setting.EncryptedData__c);
		Blob decrypted = Crypto.decryptWithManagedIV('AES128', key, encrypted);
		String decryptedString = decrypted.toString();
		return decryptedString;
	}}