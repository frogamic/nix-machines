{ pkgs, ... } : {
	environment.systemPackages = (with pkgs; [
		python3Packages.cfn-lint
		aws-sam-cli
		awscli2
		ssm-session-manager-plugin
	]) ++ (with pkgs.frogamic; [
		stack_master
	]);
	impermanence.persistence.user.directories = [
		".aws"
	];
}
