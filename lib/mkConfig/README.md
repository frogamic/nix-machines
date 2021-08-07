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
  example-conf = pkgs.mylib.mkConfig ../config "my-pc" "example.conf" {};
in {
  environment.etc."example-configuration".source = example-conf;
}
```
3. Rebuild your system as normal: `nixos-rebuild switch`

#### Explanation
What you have just done is compile a single file comprised of the content of `config/example.conf/00-basic` and the outputs of executing `config/example.conf/50-something.js` and `config/my-pc/example.conf/10-my-pc-specific.py`.

## File order

Bare configs are evaluated first, global then machine specific, then all files within a folder are enumerated and evaluated in order, machine specific files replacing global if both have the same name.

## Usage

The module `mkConfig.nix` contains a single function with the following signature:

```nix
path: hostName: fileName: derivationAttrs: derivation
```

* `path` is the folder containing the base configuration. The machine specific config (if it exists) should be in a folder in this folder.
* `hostName` is used to find the config specific to the host
* `fileName` is the name of the config file, this can be a file or a folder
* `derivationAttrs` is an optional set of attributes to be passed to the `derivation` function. For example you could pass `{ buildInputs = [ pkgs.lua ] }` if you wanted only lua to be available for executing the compiled configs.
* The returned derivation builds a single file in the nix store containing the combination of the input files.
