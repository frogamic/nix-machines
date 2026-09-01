{ config, lib, ... }:
let
	inherit (lib) mkEnableOption mkIf;
	cfg = config.mine.rgb;
in
{
	options.mine.rgb = {
		enable = mkEnableOption "RGB lighting control";
	};

	config = mkIf cfg.enable {
		services.hardware.openrgb.enable = true;
	};
}
