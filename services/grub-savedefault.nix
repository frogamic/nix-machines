{ config, lib, pkgs, ... } : {
  boot.loader.grub = {
    default = "\"\${saved_entry}\"";
    extraPerEntryConfig = "savedefault";
    extraPrepareConfig = ''
      ${pkgs.gnused}/bin/sed -i '/^\s*menuentry/a savedefault' /boot/grub/grub.cfg
    '';
    extraConfig = ''
      function savedefault {
        if [ -z "''${boot_once}" ]; then
          saved_entry="''${chosen}"
          save_env saved_entry
        fi
      }
    '';
  };
}
