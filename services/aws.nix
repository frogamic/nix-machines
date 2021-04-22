{ pkgs, ... } : {
  environment.systemPackages = with pkgs; [
    python39Packages.cfn-lint
    aws-sam-cli
    awscli
  ];
}
