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
