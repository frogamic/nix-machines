{ config, lib, pkgs, ... }:

{
	imports = [ ../../services/base-darwin.nix ];

	environment.systemPackages = with pkgs; [
		kubectl
		kubectx
		stern
		kind
		kubernetes-helm
		# kubescape
		kustomize
	]
		++ ((import ../../services/develop.nix { inherit pkgs; }).environment.systemPackages)
		++ ((import ../../services/aws.nix { inherit pkgs; }).environment.systemPackages)
	;

	homebrew.casks = [
		"visual-studio-code"
	];

	nix.settings.max-jobs = 12;

	system = {
		primaryUser = "dominic";
		stateVersion = 4;
	};
}
