{ pkgs, config }: file: attrs:
  let
    fileName = builtins.baseNameOf file;
  in with pkgs; let
    defaultAttrs = {
      builder = "${bash}/bin/bash";
      args = [ ./mkConfig.sh ];
      baseInputs = [ coreutils gawk gnused gnugrep ];
      buildInputs = [ python3 perl deno nodejs ];
      system = builtins.currentSystem;
      name = fileName;
      src = [
        file
      ] ++ (
        let
          hostpath = ../. + "/machines/${config.system.name}/${fileName}";
        in
        if builtins.pathExists hostpath
          then [ hostpath ]
          else [ ]
      );
    };
  in derivation (config.environment.variables // defaultAttrs // attrs)
