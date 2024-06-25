import 'package:vault/vault.dart';

void main() async {
  Vault vault = Vault(1);
  String words = "a2il1 	bb2e a2o2 a22e abs2n3 absorb"; 
  print(await vault.registerVault(words)); 
  print(await vault.lockVault(words)); 
  print(await vault.restoreVault(words)); 
  print(await vault.unlockVault(words));
  await Future.delayed(Duration(seconds: 70));
  print("vault after time has run out:");
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
  /// sleep of 70 secs
  /// true
  /// false
  /// true
  /// true 
  /// false
}
