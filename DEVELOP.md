# Development Setup

## Prerequisites
Ensure you have [Nix](https://nixos.org/download.html) installed on your system.

## Setting Up the Development Environment

1. **Install Nix** (if not already installed):
   ```sh
   sh <(curl -L https://nixos.org/nix/install)
   ```

2. **Enter the development shell**:
   ```sh
   nix develop
   ```
To enable Nix flakes, add the following to your Nix configuration file (`~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):

```sh
experimental-features = nix-command flakes
```

## Building the Android App

1. **Check Flutter setup**:
   ```sh
   flutter doctor
   ```
   Ensure there are no errors.

2. **Compile CLJD code**:
   ```sh
   clj -M:cljd compile
   ```

3. **Build the APK for release**:
   ```sh
   flutter build apk --release
   ```

This will generate the final APK in the `build/app/outputs/flutter-apk/` directory.
