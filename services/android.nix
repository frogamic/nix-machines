{ pkgs, lib, config, ... } : let
  fate-go = pkgs.writeScriptBin "fgo" ''
    #! /bin/sh
    adb shell monkey -p com.aniplex.fategrandorder.en \
                     -c android.intent.category.LAUNCHER 1 \
    && scrcpy -Sw \
              --window-title 'Fate/Grand Order' \
              --crop 1080:1920:0:278
  '';
in {
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    fate-go
    adbfs-rootless
    scrcpy
    android-file-transfer
    android-udev-rules
  ];
}
