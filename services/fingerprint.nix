{ ... } : {
	services.fprintd.enable = true;
	security = {
		pam.services.login.fprintAuth = true;
		polkit.extraConfig = ''
			polkit.addRule(function (action, subject) {
				if (action.id == "net.reactivated.fprint.device.enroll") {
					return subject.user == "root" ? polkit.Result.YES : polkit.Result.NO
				}
			})
		'';
	};
}
