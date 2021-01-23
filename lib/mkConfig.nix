pkgs: config: file: attrs:
  let
    name = builtins.baseNameOf file;
  in with pkgs; let
    defaultAttrs = {
      builder = "${bash}/bin/bash";
      args = [ ./mkConfig.sh ];
      baseInputs = [ coreutils gawk gnused gnugrep ];
      buildInputs = [ python3 perl deno nodejs ];
      system = builtins.currentSystem;
      name = name;
      src = [
        file
      ] ++ (
        let
          hostpath = ../. + "/machines/${config.networking.hostName}/${name}";
        in
        if builtins.pathExists hostpath
          then [ hostpath ]
          else [ ]
      );
    };
  in derivation (defaultAttrs // attrs)
