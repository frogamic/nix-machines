{ pkgs, ... } : {
  environment.systemPackages = with pkgs; [
    aws-sam-cli
    awscli
  ];
}
