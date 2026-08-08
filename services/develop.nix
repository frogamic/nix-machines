{ pkgs, ... } : {

	imports = [
		./hardware-dev.nix
		./aws.nix
		./podman.nix
	];

	environment.systemPackages = (with pkgs; [
		git-lfs
		git-crypt
		python3
		perl
		powershell

		nodejs
		yarn

		go
		gopls

		rustc
		rustfmt
		cargo
		clippy

		gcc
		gnumake

		morph
		deploy-rs

		terraform
		tenv
		terraform-ls
		tofu-ls
		terraform-docs
	]);
}
