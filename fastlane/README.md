fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Mac

### mac release

```sh
[bundle exec] fastlane mac release
```

Build and sign for App Store distribution

### mac upload

```sh
[bundle exec] fastlane mac upload
```

Upload macOS app to App Store Connect

### mac deploy

```sh
[bundle exec] fastlane mac deploy
```

Build and upload macOS app to App Store Connect

### mac dev

```sh
[bundle exec] fastlane mac dev
```

Build for development/testing (Developer ID)

### mac notarize

```sh
[bundle exec] fastlane mac notarize
```

Notarize macOS app for distribution outside App Store

----


## iOS

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and sign iOS app for App Store distribution

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Upload iOS app to App Store Connect

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Build and upload iOS app to App Store Connect

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Upload to TestFlight

### ios dev

```sh
[bundle exec] fastlane ios dev
```

Build iOS app for development

### ios screenshots

```sh
[bundle exec] fastlane ios screenshots
```

Take screenshots for App Store

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

Update App Store metadata only

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
