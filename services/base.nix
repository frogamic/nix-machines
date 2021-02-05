{ config, pkgs, ... } : {

  imports = [
    ./updates.nix
    ./emulatedSystems.nix
    ./sound.nix
    ./ssh.nix
    ./sway.nix
    ./steam.nix
    ./desktop-apps.nix
    ./android.nix
  ];

  time.timeZone = "Australia/Melbourne";
  i18n.defaultLocale = "en_AU.UTF-8";

  services.xserver = {
    layout = "dvorak,us";
    xkbOptions = "caps:swapescape";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    shellAliases = {
      ll = "ls -alh";
      ns = "function _ns() { nix-shell -p \"$1\" --run \"$*\"; }; _ns";
    };
    variables = {
      EDITOR = "vim";
    };

    systemPackages = with pkgs; [
      curl
      vim
      nodejs
      yarn
      python3
      perl
      git
      git-crypt
      stow
      bind
      parted
      ripgrep
      file
      jq
      bat
      tree
      killall
      pstree
      pciutils
      usbutils
      nix-index
      nixops
      rxvt_unicode.terminfo
    ];
  };

  services.fwupd = {
    enable = true;
    enableTestRemote = true;
  };

  nix.autoOptimiseStore = true;
}
