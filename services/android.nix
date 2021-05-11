{ pkgs, ... } : let
  adbscreen = pkgs.writeScriptBin "adbscreen" ''
    #! ${pkgs.stdenv.shell}
    args=(
      "--render-driver" "opengl" \
      "--bit-rate" "12M" \
      "$''\@" \
    )
    exec ${pkgs.scrcpy}/bin/scrcpy "''${args[''\@]}"
  '';
  mkAdbApp = import ../lib/mkAdbApp.nix pkgs;
in {
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    (mkAdbApp {
      bin = "fgo";
      name = "com.aniplex.fategrandorder.en";
      crop = "1080:1920:0:278";
      title = "Fate/Grand Order";
    })
    (mkAdbApp {
      bin = "touhoulw";
      name = "jp.goodsmile.touhoulostwordglobal_android";
      crop = "1080:2204:0:136";
      title = "Touhou LostWord";
    })
    adbscreen
    adbfs-rootless
    android-file-transfer
    android-udev-rules
  ];
}
