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
import 'package:semaphore/src/rust/third_party/semaphore_bindings/identity.dart';

final privateKey = utf8.encode("secret");

final identity = await Identity.newInstance(privateKey: privateKey);
final commitment = await identity!.commitment();
final privateKey = await identity!.privateKey();
final secretScalar = await identity!.secretScalar();
final toElement = await identity!.toElement();
```

### `Group`

```dart
import 'package:semaphore/semaphore.dart';

final element1 = await identity1.toElement();
final element2 = await identity2.toElement();
final group = await Group.newInstance(members: [element1, element2]);

final root = await group!.root();
```

### `Proof`

```dart
import 'package:semaphore/semaphore.dart';

final arcIdentity = await ideneity!.toArc();
final arcGroup = await group!.toArc();
final message = "message";
final scope = "scope";
final treeDepth = 16;

final proof = await generateSemaphoreProof(
    identity: arcIdentity,
    group: arcGroup,
    message: message,
    scope: scope,
    merkleTreeDepth: treeDepth,
);

final valid = await verifySemaphoreProof(proof: proof);
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

### Build bindings from Mopro CLI

### Setup

-   Install the latest mopro CLI on GitHub

```sh
git clone https://github.com/zkmopro/mopro
cd mopro/cli
cargo install --path .
```

<!-- TODO: publish this version of mopro-cli -->

-   Follow the [Getting Started](https://zkmopro.org/docs/getting-started/) guide to run
    ```sh
    mopro init
    ```
    (select your preferred adapter) and then
    ```sh
    mopro build
    ```
    to generate the `mopro_flutter_bindings`.

### Copy bindings

After running `mopro build`, copy all folders in the generated `mopro_flutter_bindings` (e.g. `android`, `cargokit`,...) to this folder and keep `example` folder. If you add new functions with `flutter_rust_bridge` and want to use them in Flutter, run `mopro build` again to regenerate and update the bindings.

### Update bindings name

<!-- TODO: automatically update the bindings' name https://github.com/zkmopro/mopro/issues/609 -->

-   Rename all the `mopro_flutter_bindings` to `semaphore`.

## Community

-   X account: <a href="https://twitter.com/zkmopro"><img src="https://img.shields.io/twitter/follow/zkmopro?style=flat-square&logo=x&label=zkmopro"></a>
-   Telegram group: <a href="https://t.me/zkmopro"><img src="https://img.shields.io/badge/telegram-@zkmopro-blue.svg?style=flat-square&logo=telegram"></a>

## Acknowledgements

This work was initially sponsored by a joint grant from [PSE](https://pse.dev/) and [0xPARC](https://0xparc.org/). It is currently incubated by PSE.
