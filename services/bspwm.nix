{ config, pkgs, ... } : {
  environment = {
    etc = {
      "bspwmrc".source = ./bspwm/bspwmrc;
      "sxhkdrc".source = ./bspwm/sxhkdrc;
    };

    systemPackages = with pkgs; [
      feh
      dmenu
      rxvt_unicode
    ];
  };


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

    displayManager = {
      defaultSession = "none+bspwm";
      lightdm.greeters.mini = {
        enable = true;
        user = "dominic";
        extraConfig = ''
          [greeter]
          show-password-label = false
          invalid-password-text = Access Denied
          show-input-cursor = true
          password-alignment = left
          [greeter-theme]
          font-size = 1em
          background-image = ""
        '';
      };
    };

    windowManager.bspwm = {
      enable = true;
      configFile = "/etc/bspwmrc";
      sxhkd.configFile = "/etc/sxhkdrc";
    };
  };

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.lightdm}/bin/dm-tool switch-to-greeter";
  };
}
