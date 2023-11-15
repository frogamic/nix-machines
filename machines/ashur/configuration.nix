{ config, lib, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		python39Packages.yq
		jq
		yj
		ripgrep
		fzf
		bat
		tree
		pstree
		# nix-index
		gnumake
		ffmpeg
		gnupg
		pinentry_mac
		ntfs3g

		alacritty

		kubectl
		kubectx
		stern
		kind
		kubernetes-helm
		# kubescape
		kustomize

		pv
	]
		++ ((import ../../services/develop.nix { inherit pkgs; }).environment.systemPackages)
		++ ((import ../../services/aws.nix { inherit pkgs; }).environment.systemPackages)
	;

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = true;

	programs.zsh = {
		enable = true;
		enableFzfHistory = true;
	};

	system.stateVersion = 4;

	nix = {
		settings = {
			max-jobs = 12;
			trusted-users = [
				"@admin"
			];
		};
		configureBuildUsers = true;
		gc = {
			automatic = true;
		};
		extraOptions = ''
			experimental-features = nix-command flakes
		'';
	};

	security.pam.enableSudoTouchIdAuth = true;
}
