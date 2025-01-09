# this file is useful to load all toolset for dataplatorm
# in a shell environment using nix
# use `nix-shell`
{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  name = "tools-env";

  buildInputs = with pkgs; [
    direnv
    emacs 
    clojure
    flutter
  ];
}

