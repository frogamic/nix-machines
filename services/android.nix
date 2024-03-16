{ config, pkgs, ... }: {
	programs.adb.enable = true;
	users.users.me.extraGroups = [ "adbusers" ];

	environment.systemPackages = with pkgs; [
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
