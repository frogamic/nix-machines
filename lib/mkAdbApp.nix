pkgs : { bin, name, crop, title } : pkgs.writeScriptBin "${bin}" ''
  #! ${pkgs.stdenv.shell}
  adb shell monkey -p '${name}' \
    -c android.intent.category.LAUNCHER 1 \
    > /dev/null
  exec ${pkgs.scrcpy}/bin/scrcpy -Sw \
    --render-driver opengl \
    --bit-rate 12M \
    --window-title '${title}' \
    --crop '${crop}'
''
