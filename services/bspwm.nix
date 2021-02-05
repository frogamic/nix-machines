{ config, pkgs, ... } : let
  bspwm-config = pkgs.stdenvNoCC.mkDerivation {
    name = "bspwm-config";
    #phases = "installPhase";
    dependencies = [
      pkgs.python3
    ];
    src = [
      ./config/bspwm/config
    ];
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp * $out
    '';
  };
in {
  environment.systemPackages = with pkgs; [
    scrot
    feh
    dmenu
    rxvt_unicode
    xsel
  ];

  services = {
    #redshift.enable = true;

    xserver = {
      enable = true;

      # Disable mouse acceleration
      config = ''
        Section "InputClass"
          Identifier "mouse accel"
          Driver "libinput"
          MatchIsPointer "on"
          Option "AccelProfile" "flat"
          Option "AccelSpeed" "0"
        EndSection
      '';

      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      displayManager = {
        defaultSession = "none+bspwm";
        lightdm.enable = true;
        lightdm.extraSeatDefaults = ''
          user-session = ${config.services.xserver.displayManager.defaultSession}
        '';
        lightdm.greeters.gtk.enable = true;
      };

      windowManager.bspwm = {
        enable = true;
        configFile = "${bspwm-config}/bspwmrc";
        sxhkd.configFile = "${bspwm-config}/sxhkdrc";
      };
    };
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.lightdm}/bin/dm-tool switch-to-greeter";
  };
}
