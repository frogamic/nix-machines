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
		ghc
		git
		git-crypt
		morph
	]);
}
