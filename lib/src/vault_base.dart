import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';


/// Class provides abstraction of Vault with time locking feature 
/// using flutter_secure_storage with following functionalities:
///  - log in ([restoreVault]) 
///  - register new vault ([registerVault]) 
///  - [lockVault] and [unlockVault]  
///  - delete existing vault ([deleteVault])
class Vault { 
  
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(); 
  
  //used to encrypt and decrypt data
  final key = Key.fromUtf8('7Ks2Xp9Qr4Tz6Wy3Uv8Tw5Sx1Pq2Rz43'); 
  final iv = IV.fromUtf8('G9a3e1d2c5b6F4h7');  
  int timeLockAmmount = 0; 

  /// Vault constructor returns instance of [Vault].
  /// It takes [time] as argument. Throws [ArgumentError] if time selected 
  /// for time lock is negative or is higher than 200 minutes.
  Vault(int time) : timeLockAmmount = time {
    if (time<0 || time > 200){ 
      throw ArgumentError("Time lock can't be lover than 0 or higher than 200 minutes."); 
    }
    else{ 
      timeLockAmmount = time;
    }
  }
 
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
  /// Else, returns 'false' and sets time lock on vault if:  vault is locked   
  /// Returns 'false' if:        time lock is present on the vault
  ///                            vault is not found with provided set of words
  Future<bool> restoreVault(String words) async{ 
    var encryptedData = await secureStorage.read(key: words); 
     
    if (encryptedData == null){
      return false;
    }
    var decryptedData = decryptData(encryptedData);

    String decryptedData_ = decryptedData.toString();
    int dataLen = decryptedData_.length;
    var timeLock = int.parse(decryptedData_.substring(dataLen-19, dataLen-15).replaceAll("F", ""));
    var isVaultLocked = decryptedData_.substring(dataLen-23, dataLen-19);
    int timeStamp = int.parse(decryptedData_.substring(dataLen-15, dataLen).replaceAll("T", "")); 
    var savedTime = DateTime.fromMillisecondsSinceEpoch(timeStamp); 
    var currentTime = DateTime.now();
    var difference  = currentTime.difference(savedTime); 
    if (difference.inMinutes<timeLock){ 
        //time lock is still active
        return false;
    } 
    decryptedData = decryptedData_.substring(0,decryptedData.length-23);
    if (isVaultLocked == "UUUU" && decryptedData == words){
      return true;
    }
    else {
      String timeLock = timeLockAmmount.toString().padLeft(4, "F");
      String timeStamp = (DateTime.now().millisecondsSinceEpoch-timeLockAmmount*60*1000).toString().padLeft(15,"T");
      // we encrypt following data:  vault password | vault locked/unlocked | time lock value | timestamp when vault can be unlocked
      var encryptedWords = encryptData("${words}UUUU${timeLock}${timeStamp}");  
      await secureStorage.write(key: words, value: encryptedWords); 
      return false;
    }
  }

  /// The [registerVault] method registers vault based on [words].
  /// Returns 'true' if vault is created.
  /// Returns 'false' if: vault is not created 
  ///                     vault is already registered with set of words
  ///                     input words are too short 
  Future<bool> registerVault(String words) async {  
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
    String timeLock = timeLockAmmount.toString().padLeft(4, "F");
    String timeStamp = (DateTime.now().millisecondsSinceEpoch-timeLockAmmount).toString().padLeft(15,"T");
    // we encrypt following data:  vault password | vault locked/unlocked | time lock value | timestamp when vault can be unlocked
    var encryptedWords = encryptData("${words}UUUU${timeLock}${timeStamp}");  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }

  /// The [lockVault] method registers locks the vault by accessing the vault with [words].
  /// Returns 'true' if vault is successfully locked.
  /// Returns 'false' if: vault with provided set of [words] doesn't exist
  ///                     vault is already locked
  Future<bool> lockVault(String words) async { 
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  == null){
      //Vault can't be accessed by this set of words.
      return false;
    }
    var decryptedData = decryptData(tryAccessingVault); 
    int dataLenght = decryptedData.length; 
    if (decryptedData.toString().substring(dataLenght-23, dataLenght-19) == "LLLL"){
      return false;
    } 
    var data = decryptedData.replaceRange(dataLenght-23, dataLenght-19, "LLLL"); 
    var encryptedWords = encryptData(data);  
    await secureStorage.write(key: words, value: encryptedWords); 
  return true; 
  }

  /// The [unlockVault] method registers unlocks the vault by 
  /// accessing the vault with [words].
  /// Returns 'true' if vault is successfully unlocked.
  /// Returns 'false' if : vault with provided set of words is not found.
  ///                      if time lock is present 
  Future<bool> unlockVault(String words) async { 
    var tryAccessingVault = await secureStorage.read(key: words);
    if (tryAccessingVault  == null){
      //Vault can't be accessed by this set of words.
      return false;
    }
    var decryptedData = decryptData(tryAccessingVault);
    int dataLenght = decryptedData.length;  
    if (decryptedData.toString().substring(dataLenght-23, dataLenght-19) == "UUUU"){
      return false;
    }  
    var data = decryptedData.replaceRange(dataLenght-23, dataLenght-19, "UUUU"); 
    var encryptedWords = encryptData(data) ;  
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
    int dataLen = decryptedData_.length;
    var isVaultLocked = decryptedData_.substring(dataLen-23, dataLen-19);

    decryptedData = decryptedData_.substring(0,decryptedData.length-23);
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