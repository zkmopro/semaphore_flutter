# Semaphore Flutter Package

This is a Flutter package for Semaphore protocol.

## Getting Started

Follow these steps to integrate the Semaphore Flutter package into your project.

### Adding a package dependency to an app

1.  **Add Dependency:** You can add `semaphore` to your project using the command line or by manually editing `pubspec.yaml`.

    -   **Manual Edit (Required for local path or specific Git dependencies):**
        Open your `pubspec.yaml` file and add `semaphore` under `dependencies`.

        ```yaml
        dependencies:
            flutter:
                sdk: flutter

            semaphore:
                git:
                    url: https://github.com/zkmopro/semaphore_flutter.git
        ```

2.  **Install Package:** Run the following command in your terminal from the root of your Flutter project:

    ```bash
    flutter pub get
    ```

## Usage Example

### `Identity`

```dart
import 'package:semaphore/semaphore.dart';

final privateKey = utf8.encode("secret");

final identity = Identity(privateKey);
final commitment = await identity.commitment();
final privateKey = await identity.privateKey();
final secretScalar = await identity.secretScalar();
final toElement = await identity.toElement();
```

### `Group`

```dart
import 'package:semaphore/semaphore.dart';

final member1 = await identity1.toElement();
final member2 = await identity2.toElement();
final group = Group([member1, member2]);
// get root
await group.root();
```

### `Proof`

```dart
import 'package:semaphore/semaphore.dart';

final message = "message";
final scope = "scope";
final treeDepth = 16;

final proof = await generateSemaphoreProof(
    identity,
    group,
    message,
    scope,
    treeDepth,
);

final valid = await verifySemaphoreProof(proof);
```

### Flutter Example App

-   Open the example app that uses the defined flutter package in the [`example/`](example) folder
    ```sh
    cd example
    ```
-   Install the dependencies
    ```sh
    flutter pub get
    ```
-   Open an iOS simulator/device or an Android emulator/device and run the example app
    ```sh
    flutter run
    ```
-   Clean the cache if you update the bindings and it throws errors
    ```sh
    flutter clean
    ```

## How to Build the Package

### iOS

-   Follow the instructions in the [`mopro-swift-package` README](https://github.com/zkmopro/mopro-swift-package?tab=readme-ov-file#how-to-build-the-package) to build the package.

-   Copy the bindings to the path `ios/MoproiOSBindings`.

-   Then define the native module API in [`ios/Classes/SemaphorePlugin.swift`](ios/Classes/SemaphorePlugin.swift) to match the Flutter type. Please refer to [Flutter - Data types support](https://docs.flutter.dev/platform-integration/platform-channels#codec)

### Android

-   Follow the instructions in the [`mopro-kotlin-package` README](https://github.com/zkmopro/mopro-kotlin-package?tab=readme-ov-file#how-to-build-the-package) to build the package.

-   Copy the `jniLibs` folder to [`android/src/main/jniLibs`](android/src/main/jniLibs)
    and copy the `uniffi` folder to [`android/src/main/kotlin/uniffi`](android/src/main/kotlin/uniffi)

-   Then define the native module API in [`android/src/main/kotlin/com/example/semaphore/SemaphorePlugin.kt`](android/src/main/kotlin/com/example/semaphore/SemaphorePlugin.kt) to match the Flutter type. Please refer to [Flutter - Data types support](https://docs.flutter.dev/platform-integration/platform-channels#codec)

### Flutter Library

-   Define Flutter's platform channel APIs to pass messages between Flutter and your desired platforms.
    -   [`lib/semaphore_platform_interface.dart`](lib/semaphore_platform_interface.dart)
    -   [`lib/semaphore.dart`](lib/semaphore.dart)
    -   [`lib/semaphore_types.dart`](lib/semaphore_types.dart)

## Community

-   X account: <a href="https://twitter.com/zkmopro"><img src="https://img.shields.io/twitter/follow/zkmopro?style=flat-square&logo=x&label=zkmopro"></a>
-   Telegram group: <a href="https://t.me/zkmopro"><img src="https://img.shields.io/badge/telegram-@zkmopro-blue.svg?style=flat-square&logo=telegram"></a>

## Acknowledgements

This work was initially sponsored by a joint grant from [PSE](https://pse.dev/) and [0xPARC](https://0xparc.org/). It is currently incubated by PSE.
