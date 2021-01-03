{ config, pkgs, ... } : {
  environment.systemPackages = with pkgs; [
    feh
    dmenu
    rxvt_unicode
  ];

  # services.redshift.enable = true;
  services.xserver = {
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

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        enableXfwm = false;
        noDesktop = true;
      };
    };

    displayManager = {
      defaultSession = "xfce+bspwm";
      lightdm.greeters.gtk.enable = true;
    };

    windowManager.bspwm = {
      enable = true;
      configFile = "${./bspwm/bspwmrc}";
      sxhkd.configFile = "${./bspwm/sxhkdrc}";
    };
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.lightdm}/bin/dm-tool switch-to-greeter";
  };
}
