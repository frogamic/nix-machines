{ lib, config, ... }:
let
	inherit (lib) optionals;
	cfg = config.services.fwupd;
in
{
	impermanence.persistence.directories = optionals cfg.enable [
		"/var/lib/fwupd"
		"/var/cache/fwupd"
	];
}
