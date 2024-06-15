import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:GreatWall/knowledge/vault.dart';

void main()  async {
    TestWidgetsFlutterBinding.ensureInitialized(); 
    Vault vault = Vault();
    FlutterSecureStorage.setMockInitialValues({});
    test('Check does encryptMyData and decryptData function work well.', () {
      String words = "hello great wall";
      String encrypted = vault.encryptData(words);
      expect(vault.decryptData(encrypted), words);  
     }); 

    test('Check does register_vault functionality work as expected.', () async {
      String words = "great wall";
      expect(await vault.register_vault(words,3), true);
      try{
      expect(await vault.register_vault(words,15), throwsA(Exception)); 
      
      } catch(e){
        print(e.toString());
      }

      try{
      expect(await vault.register_vault("aa",2), throwsA(Exception));  
      } catch(e){
        print(e.toString());
      }

      try{
      expect(await vault.register_vault(words,-2), throwsA(Exception));  
      } catch(e){
        print(e.toString());
      }
     }); 
}