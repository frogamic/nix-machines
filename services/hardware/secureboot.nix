{ pkgs, lib, ... } : {
	environment.systemPackages = with pkgs; [
		sbctl
		tpm2-tools
	];

	boot = {
		loader.systemd-boot.enable = lib.mkForce false;
		lanzaboote = {
			enable = true;
			pkiBundle = "/etc/secureboot";
		};
	};
}
