{ pkgs }:

with pkgs;

let
  isCI = builtins.getEnv "CI" == "true";

  basePackages = [
    gnumake
    gradle
    jdk
    flutter327
    clojure
    android-sdk
  ];

  devPackages = [
    emacs
    cljfmt
    google-chrome
  ] ++ (if pkgs.system != "aarch64-darwin" then [ android-studio ] else []);
  # android-studio is not available in aarch64-darwin

in
with pkgs;

# Configure your development environment.
devshell.mkShell {
  name = "bhikers-club";
  motd = ''
    Entered the bhikers club app ${if isCI then "CI" else "dev"} environment.
  '';
  env = [
    {
      name = "JAVA_HOME";
      value = jdk.home;
    }
    {
      name = "FLUTTER_HOME";
      value = flutter;
    }
  ]  ++ (if !isCI then [
    {
      name = "ANDROID_HOME";
      value = "${builtins.getEnv "HOME"}/android-sdks";
    }
    {
      name = "ANDROID_SDK_ROOT";
      value = "${builtins.getEnv "HOME"}/android-sdks";
    }
    {
      name = "CHROME_EXECUTABLE";
      value = "${google-chrome}/bin/google-chrome-stable";

    }
  ] else [
    {
      name = "ANDROID_HOME";
      value = "${android-sdk}/share/android-sdk";
    }
    {
      name = "ANDROID_SDK_ROOT";
      value = "${android-sdk}/share/android-sdk";
    }  
  ]);
  
  packages =  basePackages ++ (if isCI then [] else devPackages);
}
