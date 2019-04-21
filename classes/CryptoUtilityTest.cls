@isTest
private class CryptoUtilityTest {
	
	@isTest static void test_method_one() {
		// Implement test code
		String uid = 'testuser';
		String psw = 'testpass'; 
		CryptoUtility.generateCryptoKey();
		CryptoUtility.generateEncryptedConnectionInfo(uid, psw);
		String decryptedValue = CryptoUtility.getDecryptedConnectionInfo();

		System.assertEquals(decryptedValue, EncodingUtil.base64Encode(Blob.valueof(uid + ':' + psw)));
	}
}