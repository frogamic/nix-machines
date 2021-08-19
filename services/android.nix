{ config, pkgs, ... }: {
	programs.adb.enable = true;

	boot = {
		extraModulePackages = [ (config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
			outputs = ["out"];
			postInstall = ''
				make install-utils PREFIX=$out
			'';
		})) ];
		kernelModules = [ "v4l2loopback" ];
		extraModprobeConfig = ''
			options v4l2loopback exclusive_caps=1
		'';
	};

	environment.systemPackages = with pkgs; [
		droidcam
		adbfs-rootless
		android-file-transfer
		android-udev-rules

		(mylib.mkAdbApp {
			bin = "fgo";
			name = "com.aniplex.fategrandorder.en";
			crop = "1080:1920:0:278";
			title = "Fate/Grand Order";
		})
		(mylib.mkAdbApp {
			bin = "touhoulw";
			name = "jp.goodsmile.touhoulostwordglobal_android";
			crop = "1080:2204:0:136";
			title = "Touhou LostWord";
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
