{ stdenv, scrcpy, writeShellScriptBin }: { bin, name ? "", crop ? "", title ? "" }: writeShellScriptBin "${bin}" ''
	${if name != "" then ''
		adb shell monkey -p '${name}' \
			-c android.intent.category.LAUNCHER 1 \
			> /dev/null
	'' else ""}
	exec ${scrcpy}/bin/scrcpy -Sw \
		${if title != "" then "--window-title '${title}'" else ""} \
		${if crop != "" then "--crop '${crop}'" else ""} \
		--render-driver opengl \
		--video-bit-rate 12M
''
