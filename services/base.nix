{ config, pkgs, ... } : {
  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.xserver = {
    layout = "dvorak";
    xkbOptions = "caps:swapescape";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    variables = {
      EDITOR = "vim";
    };

    systemPackages = with pkgs; [
      curl
      vim
      git
      git-crypt
      stow
      bind
      parted
      ripgrep
      jq
      bat
      tree
      killall
      pstree
      pciutils
      usbutils
      nix-index
      rxvt_unicode.terminfo
    ];
  };

  services.fwupd = {
    enable = true;
    enableTestRemote = true;
  };
}
