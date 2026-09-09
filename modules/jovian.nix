{ config, lib, pkgs, ... }:
	let
		inherit (lib) mkEnableOption mkIf;
		cfg = config.mine.jovian;
	in
{
	options.mine.jovian = {
		enable = mkEnableOption "Jovian-nix steam-os like experience";
	};

	config = mkIf cfg.enable {
		jovian = {
			steam = {
				enable = lib.mkDefault true;
				autoStart = lib.mkDefault false;
				desktopSession = lib.mkDefault "plasma";
				user = lib.mkDefault config.users.users.me.name;
			};
			steamos = {
				useSteamOSConfig = false;
				enableBluetoothConfig = true;
				enableEarlyOOM = true; # Probably disable or at least tweak this later for homelabbing
				enableHdmiCecIntegration = true;
				enableSysctlConfig = true;
			};
		};
	};
}
