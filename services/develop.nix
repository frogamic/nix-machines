{ config, pkgs, ... } : {

	imports = [
		./hardware-dev.nix
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
		gitAndTools.gitFull
		git-crypt
		morph
	]);
}
