import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:GreatWall/knowledge/vault.dart';

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

    test('Check does register_vault functionality work as expected.', () async {
      
      expect(await vault.register_vault(words,3),  true); 
      expect(await vault.register_vault(words,15), false);  
      expect(await vault.register_vault("aa",2),   false);   
      expect(await vault.register_vault(words,-2), false);  
     }); 

     test('Check does restore_vault function work correctly.', () async {  
      expect(await vault.restore_vault(words), true);
      expect(await vault.restore_vault(words+"1"), false);  
     }); 

     test('Check does lock_vault function work correctly.', () async {  
      expect(await vault.lock_vault(words), true);
      expect(await vault.lock_vault(words+"1"), false);  
     }); 


     test('Check does unlock_vault function work correctly.', () async {  
      expect(await vault.unlock_vault(words), true);
      expect(await vault.unlock_vault(words+"1"), false);  
     }); 

 
    test('Check does all functionalities work together.', () async { 
      String words = "great wall 2";
      expect(await vault.register_vault(words,6), true);
      expect(await vault.register_vault(words,6), false);
      expect(await vault.lock_vault(words),       true);
      expect(await vault.restore_vault(words),    false);
      expect(await vault.unlock_vault(words),     true);
      expect(await vault.restore_vault(words),    true); 
     }); 



 
}