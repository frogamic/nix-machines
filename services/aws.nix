{ pkgs, ... } : {
	environment.systemPackages = (with pkgs.stable; [
		python3Packages.cfn-lint
		aws-sam-cli
		awscli2
		ssm-session-manager-plugin
	]) ++ (with pkgs.frogamic; [
		stack_master
	]);
}
