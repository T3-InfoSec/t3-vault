import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vault/vault.dart';

void main()  async {
  String words = "great wall";
  TestWidgetsFlutterBinding.ensureInitialized(); 
  Vault vault = Vault(1);
  FlutterSecureStorage.setMockInitialValues({});


    test('Check does encryptMyData and decryptData function work well.', () { 
      String encrypted = vault.encryptData(words);
      expect(vault.decryptData(encrypted), words);  
     }); 

    test('Check does registerVault functionality work as expected.', () async {
      expect(await vault.registerVault(words),  true); 
      expect(await vault.registerVault(words), false);  
      expect(await vault.registerVault("aa"),   false);   
      expect(await vault.registerVault(words), false);  
     }); 

     test('Check does restoreVault function work correctly.', () async {  
      // expect(await vault.restoreVault(words), true);
      expect(await vault.restoreVault(words + "aasd"), false);  
     }); 

     test('Check does lockVault function work correctly.', () async {  
      expect(await vault.lockVault(words), true);
      expect(await vault.lockVault(words+"1"), false);  
     }); 


     test('Check does unlockVault function work correctly.', () async {  
      expect(await vault.unlockVault(words), true);
      expect(await vault.unlockVault(words+"1"), false);  
     }); 

     test('Check does deleteVault function work correctly.', () async {  
      expect(await vault.deleteVault(words), true);
      /// can't delete deleted vault
      expect(await vault.deleteVault(words), false);

      String words_ = "great wall 222";
      expect(await vault.registerVault(words_), true);

      ///can't access vault 
      expect(await vault.deleteVault(words_+"ABCD"), false); 
     }); 

 
    test('Check does all functionalities work together.', () async { 
      String words = "great wall 2";   
      expect(await vault.registerVault(words), true);
      expect(await vault.registerVault(words), false);
      expect(await vault.lockVault(words),       true);
      expect(await vault.restoreVault(words),    false);
      expect(await vault.unlockVault(words),     true);
      await Future.delayed(Duration(seconds: 70)); 
      expect(await vault.restoreVault(words),    true);  
      expect(await vault.deleteVault(words), true);
      expect(await vault.restoreVault(words), false);
     }, timeout:  Timeout.none); 
 
}