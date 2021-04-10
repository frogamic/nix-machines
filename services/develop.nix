{ pkgs, ... } : {

  imports = [
    ./aws.nix
    ./podman.nix
  ];

  environment.systemPackages = (with pkgs; [
    nodejs
    yarn
    python3
    perl
    nixops
  ]);
}
