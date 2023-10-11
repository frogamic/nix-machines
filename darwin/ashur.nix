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
    ++ ((import ../services/develop.nix { inherit pkgs; }).environment.systemPackages)
    ++ ((import ../services/aws.nix { inherit pkgs; }).environment.systemPackages)
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
      # trusted-public-keys = [
      #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # ];
      # substituters = [
      #   "https://cache.nixos.org/"
      # ];
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

  # system.activationScripts.applications.text = let
  #   env = pkgs.buildEnv {
  #     name = "system-applications";
  #     paths = config.environment.systemPackages;
  #     pathsToLink = "/Applications";
  #   };
  # in lib.mkForce ''
  #   # Set up applications.
  #   echo "setting up ~/Applications..." >&2

  #   rm -rf ~/Applications/Nix\ Apps
  #   mkdir -p ~/Applications/Nix\ Apps

  #   find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  #       while read src; do
  #         /bin/cp -r "$src" ~/Applications/Nix\ Apps
  #       done
  # '';
}
