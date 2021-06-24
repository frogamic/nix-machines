{ pkgs, ... }: {
	environment.systemPackages = [
		(pkgs.writeScriptBin "mixxx" ''
			#! ${pkgs.bash}
			exec ${pkgs.mixxx}/bin/mixxx -platform xcb
		'')
	];
	services.udev.extraRules = ''
		# Pioneer Corp.
		SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="08e4", TAG+="uaccess"
		SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="08e4", ENV{PULSE_IGNORE}="1
	'';
}
