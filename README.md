<!--
This README describes the our package. If we publish this package to pub.dev,
this README's contents appear on the landing page for our package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# t3-vault

The T3 Vault cross platform application.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting Started
This section is a technical introduction for developers who want to try out the t3-vault Flutter application. Please make sure you have a valid SSH key generated and added to your GitHub account to be able to clone the project and fetch the necessary dependencies.

### Prerequisites
Ensure that you have Git installed.
Ensure that you have Flutter installed on your machine.
Make sure you have an SSH key generated and added to your GitHub account.

### Clone the Repository
To clone the project repository, run the following command in your terminal:
```bash
git clone git@github.com:T3-InfoSec/t3-vault.git
```
Navigate to the Project Directory
```bash
cd t3-vault
```

### Install the Dependencies
Once you're in the project directory, run the following command to fetch the necessary dependencies:
```bash
flutter pub get
```

### Run the Application
After all dependencies have been installed, you can start the application by running:
```bash
flutter run
```

## Usage

TODO: List application usage

## Storage

The T3Vault application uses a JSON file to store and manage memorization cards. This approach allows for persistent storage of user data, ensuring that memorization cards are available across sessions. 

### Reading Memo Cards

Memo cards are read from a JSON file located at a specified path. The application performs the following steps:

1. **File Existence Check**: It first checks if the file exists. If the file is not found, an empty map is returned.
2. **File Reading**: If the file exists, it reads the contents and decodes the JSON data into a list of objects.
3. **Object Conversion**: Each JSON object is converted into a `MemoCard` instance using the `MemoCardConverter.fromJson` method, extracting an ID from each object to serve as the key in a map.
4. **Return Value**: The method returns a map where the keys are memo card IDs and the values are the corresponding `MemoCard` instances.

### Writing Memo Cards

When users create or modify memorization cards, the application writes these changes back to the JSON file using the following steps:

1. **Object Preparation**: The method takes a map of memo cards, where each entry is converted to a JSON-compatible format using `MemoCardConverter.toJson`. An additional 'id' field is included for each memo card.
2. **File Writing**: The resulting list of JSON objects is encoded as a string and written to the specified file path. If the file does not already exist, it will be created.
3. **Future Considerations**: The writing operation is asynchronous, and it does not return a value, allowing for non-blocking file operations.

### Storage Example Usage

```dart
final memoCardRepository = MemoCardRepository(filePath: 'path/to/your/file.json');
await memoCardRepository.writeMemoCards(memoCardMap);
final memoCards = await memoCardRepository.readMemoCards();
```


## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

