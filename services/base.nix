{ config, pkgs, ... } : {
  i18n.defaultLocale = "en_AU.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  time.timeZone = "Australia/Melbourne";

  environment.systemPackages = with pkgs; [
    bind
    curl
    vim
    killall
    pciutils
    usbutils
    parted
    tree
    pstree
    rxvt_unicode.terminfo
  ];

  services.xserver = {
    layout = "dvorak";
    xkbOptions = "caps:swapescape";
  };
}
