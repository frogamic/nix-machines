{ pkgs, ... } : {
	environment.systemPackages = with pkgs; [
		python39Packages.cfn-lint
		stable.aws-sam-cli
		awscli
	];
}
