{ pkgs ? import <nixpkgs> {} } : pkgs.stdenvNoCC.mkDerivation {
    name = "bspwm-config";
    #phases = "installPhase";
    src = [
      ./config
    ];
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp * $out
    '';
  }
