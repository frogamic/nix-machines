{ config, pkgs, ... } : {

	imports = [
		./aws.nix
		./podman.nix
	];

	environment.systemPackages = (with pkgs; [
		vim
		nodejs
		yarn
		python3
		perl
		git
		git-crypt
		stable.nixops
	]);
}
