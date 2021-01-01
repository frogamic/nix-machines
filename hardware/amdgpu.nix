{ config, pkgs, ... } : {
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "AMDGPU" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
}
