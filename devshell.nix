{ pkgs }:

with pkgs;

let
  # android-studio is not available in aarch64-darwin
  conditionalPackages = if pkgs.system != "aarch64-darwin" then [ android-studio ] else [];
in
with pkgs;

# Configure your development environment.
devshell.mkShell {
  name = "flutter-project";
  motd = ''
    Entered the flutter app development environment.
  '';
  env = [
    {
      name = "ANDROID_HOME";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "ANDROID_SDK_ROOT";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "CHROME_EXECUTABLE";
      value = "${google-chrome}/bin/google-chrome-stable";

    }
    {
      name = "JAVA_HOME";
      value = jdk.home;
    }
  ];
  packages = [
    emacs
    gnumake
    yq-go
    gradle
    jdk
    flutter
    clojure
    google-chrome
    fastlane
    jekyll
  ] ++ conditionalPackages;
}
