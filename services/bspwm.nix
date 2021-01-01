{ config, pkgs, ... } : {
  environment.systemPackages = with pkgs; [
    dmenu
    feh
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

    libinput.enable = true;
    libinput.naturalScrolling = true;

    displayManager.lightdm.greeters.mini = {
      enable = true;
      user = "dominic";
      extraConfig = ''
        [greeter]
        show-password-label = false
        invalid-password-text = Access Denied
        show-input-cursor = true
        password-alignment = left
        password-input-width = 20
        [greeter-theme]
        font-size = 1em
        error-color = "#d40001"
        password-color = "#1f5dae"
        border-width = 3px
        border-color = "#c0863f"
        window-color = "#b7b6be"
        password-background-color = "#b7b6be"
        password-border-color = "#b7b6be"
        password-border-width = 1px
      '';
    };

    windowManager.bspwm = {
      enable = true;
      configFile = "/etc/nixos/bspwmrc";
      sxhkd.configFile = "/etc/nixos/sxhkdrc";
    };
  };
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.lightdm}/bin/dm-tool switch-to-greeter";
  };

}
