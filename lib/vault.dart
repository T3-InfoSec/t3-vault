import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

class Vault { 
  /// Class provides abstraction of Vault using flutter_secure_storage with
  /// following functionalities:
  ///  - log in (restore vault)
  ///  - register new vault (create new vault) 
  final FlutterSecureStorage secure_storage = const FlutterSecureStorage(); 
  
  ///used to encrypt and decrypt data
  final key = Key.fromUtf8('7Ks2Xp9Qr4Tz6Wy3Uv8Tw5Sx1Pq2Rz43'); 
  final iv = IV.fromUtf8('G9a3e1d2c5b6F4h7');  

  Vault() {}
 
  String encryptData(String text) {
    ///Encrypts data from given text.
    ///
    ///[text] (String) : Words to be encrypted.
    ///
    ///Returns:
    ///String - Encrypted data.
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted_data = e.encrypt(text, iv: iv);
    return encrypted_data.base64;
  }
 
  String decryptData(String text) {
    ///Decrypts data from given text.
    ///
    ///[text] (String) : Words to be decrypted.
    ///
    ///Returns:
    ///String - Decrypted data.
     final e = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted_data = e.decrypt(Encrypted.fromBase64(text), iv: iv);
    return decrypted_data;
  } 

  Future<bool> restore_vault(String words) async{
    ///Restores vault based on set of words.
    ///
    ///[words] (String) : Words used to restore vault (password).
    ///
    ///Returns:
    ///bool - Returns True if vault is unlocked.
    ///       Returns False if vault is not unlocked with provided set of words.
    var encrypted_data = await secure_storage.read(key: words);
    print(encrypted_data);
    // encrypted
    if (encrypted_data == null){
      return false;
    }
    var decrypted_data = decryptData(encrypted_data);
    return decrypted_data == words;
  }

  Future<bool> register_vault(String words, int time_lock) async {
    ///Registers vault based on set of words.
    ///
    ///[words] (String) : Words used to register vault (password).
    ///
    ///Returns:
    ///bool - Returns True if vault is created.
    ///       Returns False if vault is not created.
    if (time_lock<0 || time_lock > 50){
      throw Exception("Time lock can't be lover than 0 or higher than 50 hours.");
    }
    if (words.length<5){ // this  should be discussed
      throw Exception("Words are too short."); 
    }
    
    /// check is vault already registered with unique set of words
    var try_accessing_vault = await secure_storage.read(key: words);
    if (try_accessing_vault  != null){
      throw Exception("Vault is already registered for unique set of words.");
    }

    var encrypted_words = encryptData(words); 
    // encrypted_words = encrypted_words + time_lock.toString(); #TODO
    await secure_storage.write(key: words, value: encrypted_words); 
  return true; 
  }
}