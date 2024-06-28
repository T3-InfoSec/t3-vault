# t3-vault

The T3 Vault cross platform application built using flutter_secure_storage package.

 
## Features

-  
- 
-


## Getting started
To start using Vault, add it to your `pubspec.yaml`:
- dependencies:
    vault: ^1.0.0
 
Then, run `dart pub get` to install the package.
Then, run `flutter pub get` to install the package.

### Running tests
To run the tests for Vault, use the following command in the root directory:
```bash
dart test test/vault_test.dart
```
or simply:
```
flutter test
```

#### Example
In order to visualize the behavior of the module, an example with flutter has been developed. To run these test, the following commands must be executed:
```bash
dart test
cd example
code .
flutter run
```

## Usage
Example code on how to use Vault:
```
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
```