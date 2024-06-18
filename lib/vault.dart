import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

class Vault { 
  /// Class provides abstraction of Vault using flutter_secure_storage with
  /// following functionalities:
  ///  - log in (restore vault)
  ///  - register new vault (create new vault) 
  ///  - lock and unlock the vault
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
    ///bool - Returns True if vault is unlocked with provided set of words.
    ///       Returns False if:
    ///                         - vault is not found with provided set of words
    ///                         - vault is locked
    var encrypted_data = await secure_storage.read(key: words); 
     
    if (encrypted_data == null){
      return false;
    }
    var decrypted_data = decryptData(encrypted_data);

    String decrypted_data_ = decrypted_data.toString();
    var is_vault_locked = decrypted_data_.substring(decrypted_data_.length-4, decrypted_data_.length);

    decrypted_data = decrypted_data_.substring(0,decrypted_data.length-4);
    if (is_vault_locked == "UUUU" && decrypted_data == words){
      return true;
    }
    else return false;
  }

  Future<bool> register_vault(String words, int time_lock) async {
    ///Registers vault based on set of words.
    ///By default vault is not locked so 'U' is hardcoded as Unlocked.
    ///[words] (String) : Words used to register vault (password).
    ///
    ///Returns:
    ///bool - Returns True if vault is created.
    ///       Returns False when:
    ///                         - vault is not created
    ///                         - when time lock is too big or too small
    ///                         - when vault is already registered with set of words
    ///                         - when input words are too short
    if (time_lock<0 || time_lock > 50){
      ///"Time lock can't be lover than 0 or higher than 50 hours."
      return false; 
    }
    if (words.length<5){ 
    ///Words are too short.
      return false;
    }
    
    /// check is vault already registered with unique set of words
    var try_accessing_vault = await secure_storage.read(key: words);
    if (try_accessing_vault  != null){
      ///Vault is already registered for unique set of words.
      return false;
    }

    var encrypted_words = encryptData(words + "UUUU") ;  
    await secure_storage.write(key: words, value: encrypted_words); 
  return true; 
  }


  Future<bool> lock_vault(String words) async {
    ///Locks the vault.
    ///By default vault is not locked so 'U' is hardcoded as Unlocked.
    ///When volt is not locked then 'L' is present. 
    ///
    ///[words] (String) : Words used to access vault (password).
    ///
    ///Returns:
    ///bool - Returns True if vault is successfully locked.
    ///       Returns False when:
    ///                         - vault with provided set of words is not found
    
    var try_accessing_vault = await secure_storage.read(key: words);
    if (try_accessing_vault  == null){
      ///Vault can't be accessed by this set of words.
      return false;
    }

    var encrypted_words = encryptData(words + "LLLL") ;  
    await secure_storage.write(key: words, value: encrypted_words); 
  return true; 
  }

  Future<bool> unlock_vault(String words) async {
    ///Unlocks the vault.
    ///By default vault is not locked so 'U' is hardcoded as Unlocked.
    ///When volt is not locked then 'L' is present. 
    ///
    ///[words] (String) : Words used to access vault (password).
    ///
    ///Returns:
    ///bool - Returns True if vault is successfully unlocked.
    ///       Returns False when:
    ///                         - vault with provided set of words is not found
    
    var try_accessing_vault = await secure_storage.read(key: words);
    if (try_accessing_vault  == null){
      ///Vault can't be accessed by this set of words.
      return false;
    }

    var encrypted_words = encryptData(words + "UUUU") ;  
    await secure_storage.write(key: words, value: encrypted_words); 
  return true; 
  }
 

}