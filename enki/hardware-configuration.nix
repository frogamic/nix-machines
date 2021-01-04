{ config, lib, pkgs, ... } : {
  imports = [
    ../hardware/amdcpu.nix
    ../hardware/amdgpu.nix
    ../hardware/ssd.nix
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };

      grub = {
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        gfxmodeEfi = "1920x1200";
        splashImage = null;
      };
    };

    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  };

  networking = {
    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;
  };

  # This doesn't work for whatever reason
  # services.xserver.xrandrHeads = [
  #   {
  #     output = "DP-1";
  #     monitorConfig = ''
  #       VendorName    "Dell"
  #       ModelName     "U2412M"
  #       Option        "Position" "0 0"
  #       Option        "Rotate" "left"
  #       Option        "PreferredMode" "1920x1200"
  #     '';
  #   }
  #   {
  #     output = "DP-2";
  #     monitorConfig = ''
  #       VendorName    "Dell"
  #       ModelName     "U2412M"
  #       Option        "Position" "3760 0"
  #       Option        "Rotate" "right"
  #       Option        "PreferredMode" "1920x1200"
  #     '';
  #   }
  #   {
  #     output = "DP-3";
  #     primary = true;
  #     monitorConfig = ''
  #       VendorName    "LG"
  #       ModelName     "27GL850"
  #       Option        "VariableRefresh" "true"
  #       Option        "Position" "1200 210"
  #       Option        "PreferredMode" "2560x1440"
  #     '';
  #   }
  # ];

  services.xserver.extraConfig = ''
    Section "Monitor"
      Identifier "DP-1"
      VendorName "Dell"
      ModelName  "U2412M"
      Option     "Position"      "0 0"
      Option     "Rotate"        "left"
      Option     "PreferredMode" "1920x1200"
    EndSection

    Section "Monitor"
      Identifier "DP-2"
      VendorName "Dell"
      ModelName  "U2412M"
      Option     "Position"      "3760 0"
      Option     "Rotate"        "right"
      Option     "PreferredMode" "1920x1200"
    EndSection

    Section "Monitor"
      Identifier "DP-3"
      VendorName "LG"
      ModelName  "27GL850"
      Option     "Primary"         "true"
      Option     "VariableRefresh" "true"
      Option     "Position"        "1200 210"
      Option     "PreferredMode"   "2560x1440"
    EndSection
  '';

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/389c0259-8dbe-4efd-9693-ddeedf66defe";
    fsType = "ext4";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/0D39-C351";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/471df190-e3a1-4c0a-88bc-d9ab774b1b46"; }
  ];

  nix.maxJobs = lib.mkDefault 16;
}
