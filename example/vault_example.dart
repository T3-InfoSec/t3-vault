import 'package:vault/vault.dart';

void main() async {
  Vault vault = Vault();
  String words = "ability285	bble about above absen3 absorb"; 
  print(await vault.registerVault(words,5)); 
  print(await vault.lockVault(words)); 
  print(await vault.restoreVault(words)); 
  print(await vault.unlockVault(words));
  print(await vault.restoreVault(words)); 
  print(await vault.deleteVault(words));
  print(await vault.restoreVault(words));

  ///expected output is:
  /// true
  /// true
  /// false
  /// true
  /// true
  /// true
  /// true 
}
