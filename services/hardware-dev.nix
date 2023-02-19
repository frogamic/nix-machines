{ config, pkgs, ... } : {

	environment.systemPackages = (with pkgs; [
		dfu-util
		platformio
		qFlipper
	]);
}
