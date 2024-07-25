{
  disko.devices = {
    disk.nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/efi";
              mountOptions = [
                "defaults"
              ];
            };
          };
          luks_root = {
            size = "100%";
            content = {
              type = "luks";
              name = "luks_root";
              settings = {
                allowDiscards = true;
                bypassWorkqueues = true;
                preOpenCommands = ''
                  for bl in /sys/class/backlight/*/brightness; do
                    echo 100 > $bl
                  done
                  echo 1 > /sys/class/leds/tpacpi::kbd_backlight/brightness
                '';
              };
              content = {
                type = "lvm_pv";
                vg = "lvm_pool";
              };
            };
          };
        };
      };
    };
    lvm_vg.lvm_pool = {
      type = "lvm_vg";
      lvs = {
        nixos = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            mountOptions = [ "autodefrag" "compress=zstd" "noatime" ];
            subvolumes = {
              "current_root" = {
                mountpoint = "/";
              };
              "home" = {
                mountpoint = "/home";
              };
              "root" = {
                mountpoint = "/root";
              };
              "nix" = {
                mountpoint = "/nix";
              };
            };
          };
        };
        swap = {
          size = "16G";
          content = {
            type = "swap";
            #discardPolicy = "both";
            resumeDevice = true; # resume from hiberation from this device
          };
        };
      };
    };
  };
}
