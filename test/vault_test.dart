import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vault/vault.dart';

void main()  async {
  String words = "great wall";
  TestWidgetsFlutterBinding.ensureInitialized(); 
  Vault vault = Vault();
  FlutterSecureStorage.setMockInitialValues({});


    test('Check does encryptMyData and decryptData function work well.', () {
      String words = "hello great wall";
      String encrypted = vault.encryptData(words);
      expect(vault.decryptData(encrypted), words);  
     }); 

    test('Check does registerVault functionality work as expected.', () async {
      
      expect(await vault.registerVault(words,3),  true); 
      expect(await vault.registerVault(words,15), false);  
      expect(await vault.registerVault("aa",2),   false);   
      expect(await vault.registerVault(words,-2), false);  
     }); 

     test('Check does restoreVault function work correctly.', () async {  
      expect(await vault.restoreVault(words), true);
      expect(await vault.restoreVault(words+"1"), false);  
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
      expect(await vault.registerVault(words_,6), true);

      ///can't access vault 
      expect(await vault.deleteVault(words_+"ABCD"), false); 
     }); 

 
    test('Check does all functionalities work together.', () async { 
      String words = "great wall 2";
      expect(await vault.registerVault(words,6), true);
      expect(await vault.registerVault(words,6), false);
      expect(await vault.lockVault(words),       true);
      expect(await vault.restoreVault(words),    false);
      expect(await vault.unlockVault(words),     true);
      expect(await vault.restoreVault(words),    true); 
     }); 

     

 

 


}