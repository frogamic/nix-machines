{ config, pkgs, ... } : {
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };
}
