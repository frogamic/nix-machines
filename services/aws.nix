{ pkgs, ... } : {
	environment.systemPackages = (with pkgs.stable; [
		python3Packages.cfn-lint
		aws-sam-cli
		awscli2
	]) ++ (with pkgs.frogamic; [
		stack_master
	]);
}
