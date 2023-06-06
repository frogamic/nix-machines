{ pkgs, ... }: {

	hardware.nitrokey.enable = true;

	environment.systemPackages = with pkgs; [
		pynitrokey
		opensc
		pcsctools
	];

	services.pcscd = {
		enable = true;
	};
}
