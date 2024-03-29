{ pkgs, ... } : {
	environment.systemPackages = with pkgs.stable; [
		python39Packages.cfn-lint
		aws-sam-cli
		awscli2
	];
}
