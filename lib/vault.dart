import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';

class Vault { 
  /// Class provides abstraction of Vault using flutter_secureStorage with
  /// following functionalities:
  ///  - log in (restore vault)
  ///  - register new vault (create new vault) 
  ///  - lock and unlock the vault
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(); 
  
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
    final encryptedData = e.encrypt(text, iv: iv);
    return encryptedData.base64;
  }
 
  String decryptData(String text) {
    ///Decrypts data from given text.
    ///
    ///[text] (String) : Words to be decrypted.
    ///
    ///Returns:
    ///String - Decrypted data.
     final e = Encrypter(AES(key, mode: AESMode.cbc));
    final decryptedData = e.decrypt(Encrypted.fromBase64(text), iv: iv);
    return decryptedData;
  } 

  Future<bool> restoreVault(String words) async{
    ///Restores vault based on set of words.
    ///
    ///[words] (String) : Words used to restore vault (password).
    ///
    ///Returns:
    ///bool - Returns True if vault is unlocked with provided set of words.
    ///       Returns False if:
    ///                         - vault is not found with provided set of words
    ///                         - vault is locked
    var encryptedData = await secureStorage.read(key: words); 
     
    if (encryptedData == null){
      return false;
    }
    var decryptedData = decryptData(encryptedData);

    String decryptedData_ = decryptedData.toString();
    var isVaultLocked = decryptedData_.substring(decryptedData_.length-4, decryptedData_.length);

    decryptedData = decryptedData_.substring(0,decryptedData.length-4);
    if (isVaultLocked == "UUUU" && decryptedData == words){
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> registerVault(String words, int timeLock) async {
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
    if (timeLock<0 || timeLock > 50){
      ///"Time lock can't be lover than 0 or higher than 50 hours."
      return false; 
    }
    if (words.length<5){ 
    ///Words are too short.
      return false;
    }
    
    /// check is vault already registered with unique set of words
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  != null){
      ///Vault is already registered for unique set of words.
      return false;
    }

    var encryptedWords = encryptData("${words}UUUU") ;  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }


  Future<bool> lockVault(String words) async {
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
    
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  == null){
      ///Vault can't be accessed by this set of words.
      return false;
    }

    var encryptedWords = encryptData("${words}LLLL") ;  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }

  Future<bool> unlockVault(String words) async {
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
    
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  == null){
      ///Vault can't be accessed by this set of words.
      return false;
    }

    var encryptedWords = encryptData("${words}UUUU") ;  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }




}