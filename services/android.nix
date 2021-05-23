{ pkgs, ... }: {
	programs.adb.enable = true;

	environment.systemPackages = with pkgs; [
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

		(pkgs.writeScriptBin "adbshot" ''
			#! ${pkgs.stdenv.shell}
			FILENAME="$(date --iso-8601=seconds).png"
			adb shell screencap -p > "$FILENAME" && \
			${pkgs.file}/bin/file "$FILENAME"
		'')
		(pkgs.writeScriptBin "adbscreen" ''
			#! ${pkgs.stdenv.shell}
			args=(
				"--render-driver" "opengl" \
				"--bit-rate" "12M" \
				"$''\@" \
			)
			exec ${pkgs.scrcpy}/bin/scrcpy "''${args[''\@]}"
		'')
	];
}
