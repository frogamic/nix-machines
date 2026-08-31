{ config, lib, pkgs, ... }:

let
	inherit (lib) getExe mkIf mkEnableOption mkOption optional optionals types;
	inherit (builtins) toString;

	doVOffset = cfg.voltageOffset != 0;
	ryzen-smu-cli-src = pkgs.fetchFromGitHub {
		owner = "frogamic";
		repo = "ryzen-smu-cli";
		rev = "0.0.3";
		hash = "sha256-2HtN15aGfdV3B+AdCQ19Fg0WsV3zkCYxyclMkq1aKac=";
	};
	ryzen-smu-cli = pkgs.callPackage "${ryzen-smu-cli-src}/package.nix" { linuxPackages = config.boot.kernelPackages; };

	cfg = config.mine.hardware.amdcpu;
in

{
	options.mine.hardware.amdcpu = with types; {
		enable = mkEnableOption "AMD CPU defaults";
		voltageOffset = mkOption {
			default = 0;
			example = -30;
			description = "Set a cpu core voltage offset (e.g. undervolt) in millivolts";
			type = int;
		};
	};

	config = mkIf cfg.enable {
		hardware = {
			cpu.amd.updateMicrocode = true;
			enableRedistributableFirmware = true;
		};

		boot = {
			kernelModules = [
				"zenpower"
			] ++ optional doVOffset "ryzen-smu";
			blacklistedKernelModules = [ "k10temp" ];
			extraModulePackages = with config.boot.kernelPackages; [
				zenpower
			] ++ optional doVOffset ryzen-smu;
		};

		programs.lm_sensors = {
			config = ''
chip "zenpower-pci-*"
	label temp1 "CPU die"
	label temp2 "CPU Tctl"
	label temp3 "CPU CCD1"
	label in1 "CPU Core Voltage"
	label in2 "CPU SoC Voltage"
	label power1 "CPU Core Power"
	label power2 "CPU SoC Power"
	label curr1 "CPU Core Amps"
	label curr2 "CPU SoC Amps"
'';
		};

		environment.systemPackages = optionals doVOffset [ ryzen-smu-cli ];

		systemd.services.ryzen-smu-voltage-offset = mkIf doVOffset {
			description = "Apply per-core CPU voltage offset";

			unitConfig.ConditionPathExists = "/sys/kernel/ryzen_smu_drv/mp1_smu_cmd";

			after = [
				"sleep.target"
				"hibernate.target"
				"hybrid-sleep.target"
				"suspend-then-hibernate.target"
			];
			wantedBy = [
				"multi-user.target"
				"suspend.target"
				"hibernate.target"
				"hybrid-sleep.target"
				"suspend-then-hibernate.target"
			];

			serviceConfig = {
				Type = "oneshot";
				ExecStart = "${getExe ryzen-smu-cli} -o ${toString cfg.voltageOffset}";
				RemainAfterExit = true;
			};
		};
	};
}
