import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';


/// Class provides abstraction of Vault using flutter_secureStorage with
/// following functionalities:
///  - log in ([restoreVault]) 
///  - register new vault ([registerVault]) 
///  - [lockVault] and [unlockVault]  
///  - delete existing vault ([deleteVault])
class Vault { 
  
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(); 
  
  //used to encrypt and decrypt data
  final key = Key.fromUtf8('7Ks2Xp9Qr4Tz6Wy3Uv8Tw5Sx1Pq2Rz43'); 
  final iv = IV.fromUtf8('G9a3e1d2c5b6F4h7');  


  /// Vault constructor returns instance of [Vault].
  Vault() {}
 
  /// The [encryptData] method returns encrypted [text].
  String encryptData(String text) {
    final e = Encrypter(AES(key, mode: AESMode.cbc));
    final encryptedData = e.encrypt(text, iv: iv);
    return encryptedData.base64;
  }
 
  /// The [decryptData] method returns decrypted [text].
  String decryptData(String text) { 
     final e = Encrypter(AES(key, mode: AESMode.cbc));
    final decryptedData = e.decrypt(Encrypted.fromBase64(text), iv: iv);
    return decryptedData;
  } 

  /// The [restoreVault] method restores vault based on [words].
  /// Returns 'true' if vault is unlocked with provided set of words.
  /// Else, returns 'false' if:  vault is not found with provided set of words.
  ///                            vault is locked.
  Future<bool> restoreVault(String words) async{ 
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

  /// The [registerVault] method registers vault based on [words].
  /// Returns 'true' if vault is created.
  /// Returns 'false' if: vault is not created
  ///                     time lock is too big or too small
  ///                     vault is already registered with set of words
  ///                     input words are too short 
  Future<bool> registerVault(String words, int timeLock) async { 
    if (timeLock<0 || timeLock > 50){
      //"Time lock can't be lover than 0 or higher than 50 hours."
      return false; 
    }
    if (words.length<5){ 
    //Words are too short.
      return false;
    }
    
    // check is vault already registered with unique set of words
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  != null){
      //Vault is already registered for unique set of words.
      return false;
    }

    var encryptedWords = encryptData("${words}UUUU") ;  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }

  /// The [lockVault] method registers locks the vault by accessing the vault with [words].
  /// Returns 'true' if vault is successfully locked.
  /// Returns 'false' if vault with provided set of [words] doesn't exist.
  Future<bool> lockVault(String words) async { 
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  == null){
      //Vault can't be accessed by this set of words.
      return false;
    }

    var encryptedWords = encryptData("${words}LLLL") ;  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }

  /// The [unlockVault] method registers unlocks the vault by 
  /// accessing the vault with [words].
  /// Returns 'true' if vault is successfully unlocked.
  /// Returns 'false' if vault with provided set of words is not found.
  Future<bool> unlockVault(String words) async { 
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  == null){
      //Vault can't be accessed by this set of words.
      return false;
    }

    var encryptedWords = encryptData("${words}UUUU") ;  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }

  /// The [deleteVault] method registers deletes the vault which
  /// is accessed by [words].
  /// Returns 'true' if vault is successfully deleted.
  /// Returns 'false' if: vault with provided set of words is not found
  ///                     vault exists, but it's locked 
  Future<bool> deleteVault(String words) async { 
    var encryptedData = await secureStorage.read(key: words); 
     
    if (encryptedData == null){
       //Vault can't be accessed by this set of words.
      return false;
    }
    var decryptedData = decryptData(encryptedData);

    String decryptedData_ = decryptedData.toString();
    var isVaultLocked = decryptedData_.substring(decryptedData_.length-4, decryptedData_.length);

    decryptedData = decryptedData_.substring(0,decryptedData.length-4);
    if (isVaultLocked == "UUUU" && decryptedData == words){
      secureStorage.delete(key: words);
      return true;
    }
    else {
      // Vault exists but it's locked.
      return false;
    } 
  }


}