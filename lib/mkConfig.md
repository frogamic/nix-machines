# mkConfig

`mkConfig` is a nix helper function to compile configuration files from one or more plaintext or executable source files. The need for this module came about when I realised I was repeating a lot of similar commands in my Sway config which I'd rather be able to generate programmatically.

## Overview

1. Create config file(s) somewhere such as `config/example.conf` or `config/example.conf/00-something.js` and also more machine specific configs under `config/{hostname}/example.conf` or `config/{hostname}/example.conf/50-specific-thing.py`:
```shell
tree
.
├── ...
├── services
│   ├── example.nix
│   └── ...
└── config
    ├── example.conf
    │   ├── 00-basic
    │   └── 50-something.js
    └── my-pc
        └── example.conf
            └── 10-my-pc-specific.py
```

2. Import and call this module from another nix module, referring to the first config stored in `services` in the example above (assuming this module is also in `services` for the sake of local file referencing):
```nix
# example.nix
{ config, pkgs, ... } : let
  example-conf = import ../lib/mkConfig.nix { inherit pkgs config; } ../config/example.conf {};
in {
  environment.etc."example-configuration".source = example-conf;
}
```
3. Rebuild your system as normal: `nixos-rebuild switch`

#### Explanation
What you have just done is compile a single file comprised of the content of `config/example.conf/00-basic` and the outputs of executing `config/example.conf/50-something.js` and `config/my-pc/example.conf/10-my-pc-specific.py`

## Usage

The module `mkConfig.nix` contains a single function with the following signature:

```nix
{ pkgs, config } : path : derivationAttrs : derivation
```

* `{ pkgs, config }` are the packages and configuration of your NixOS system.
  * `pkgs` provides the build prerequisites and environment.
  * `config` is used to determine the hostname of the target system.
* `path` is the path to the base configuration, this can be a file or a folder. The machine specific config (if it exists) should be in a folder alongside the configuration.
* `derivationAttrs` is an optional set of attributes to be passed to the `derivation` function. For example you could pass `{ buildInputs = [ pkgs.lua ] }` if you wanted only lua to be available for executing the compiled configs.
* The returned derivation builds a single file in the nix store containing the combination of the input files.

## Todo

* Ensure file ordering works as expected between machines and base config.
* Make files from the machine config overwrite files of the same name in the base config folder.
