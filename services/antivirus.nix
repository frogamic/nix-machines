{ pkgs, config, ...}: {
	services.clamav = {
		updater.enable = true;
		daemon = {
			enable = true;
			settings = {
				Debug = true;
				LocalSocketMode = "660";
				OnAccessExcludeUname = "clamav";
				OnAccessPrevention = true;
				OnAccessIncludePath = "/home/";
				FollowFileSymlinks = true;
				VirusEvent = "${pkgs.dbus}/bin/dbus-send --system / net.nuetzlich.SystemNotifications.Notify \"string:ClamAV: $CLAM_VIRUSEVENT_VIRUSNAME\" \"string:$CLAM_VIRUSEVENT_FILENAME\"";
			};
		};
	};
	# Updater requires network
	systemd.services.clamav-freshclam.requires = [ "network-online.target" ];

	systemd.services.clamav-daemon.serviceConfig.restart = "always";
	systemd.services.clamav-onaccess = {
		description = "ClamAV on-access scanner (clamd)";
		after = [ "clamav-daemon.service" ];
		requires = [ "clamav-daemon.service" ];
		partOf = [ "clamav-daemon.service" ];
		wantedBy = [ "multi-user.target" ];

		serviceConfig = {
			restart = "always";
			ExecStart = "${pkgs.clamav}/bin/clamonacc -F";
			ExecReload = "${pkgs.coreutils}/bin/kill -USR2 $MAINPID";
			PrivateTmp = "yes";
			PrivateDevices = "yes";
			PrivateNetwork = "yes";
		};
	};
}
