{ config, lib, pkgs, ... } : {
  imports = [
    ../../services/hardware/amdcpu.nix
    ../../services/hardware/amdgpu.nix
    ../../services/hardware/ssd.nix
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
    ];

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

  };

  networking = {
    useDHCP = false;
    interfaces.enp4s0.useDHCP = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/389c0259-8dbe-4efd-9693-ddeedf66defe";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/421aae2b-d64b-4e8f-a5bd-8e4c79f3b4ae";
      fsType = "ext4";
    };
    "/efi" = {
      device = "/dev/disk/by-uuid/0D39-C351";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/a02708dd-61b9-4405-b49b-863494d06c37"; }
  ];

  nix.maxJobs = lib.mkDefault 16;
}
