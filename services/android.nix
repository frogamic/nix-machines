{ config, pkgs, ... }: {
	programs.adb.enable = true;
	users.users.me.extraGroups = [ "adbusers" ];

	boot = {
		extraModulePackages = [ (config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
			meta = {
				inherit (old) meta;
				outputsToInstall = [ "out" ];
			};
		}))];
		kernelModules = [ "v4l2loopback" ];
		extraModprobeConfig = ''
			options v4l2loopback exclusive_caps=1
		'';
	};

	environment.systemPackages = with pkgs; [
		config.boot.kernelPackages.v4l2loopback
		droidcam
		adbfs-rootless
		android-file-transfer
		android-udev-rules
		scrcpy

		(mylib.mkAdbApp {
			bin = "fgo";
			name = "com.aniplex.fategrandorder.en";
			title = "Fate/Grand Order";
		})
		(mylib.mkAdbApp {
			bin = "arknights";
			name = "com.YoStarEN.Arknights";
			crop = "1080:2140:0:100";
			title = "Arknights";
		})
		(mylib.mkAdbApp {
			bin="adbscreen";
		})
		(pkgs.writeShellScriptBin "adbshot" ''
			FILENAME="$(date --iso-8601=seconds).png"
			adb shell screencap -p > "$FILENAME" && \
			${pkgs.file}/bin/file "$FILENAME"
		'')
	];
}
