#! /usr/bin/env -S deno run --allow-env

const lockCmd = Deno.env.get('LOCKER_COMMAND');
const lockTimeout = 300;
const screenOffDelay = 30;
const sleepDelay = 180;
const resumeCmd = "swaymsg \"output * dpms on\"";

console.log('\n### Begin lockCmd script');

if (lockCmd !== undefined) {
	console.log(
		`exec swayidle -w \
		timeout ${lockTimeout} '${lockCmd}' \
		timeout ${lockTimeout + screenOffDelay} 'swaymsg "output * dpms off"' \
		resume '${resumeCmd}' \
		timeout ${lockTimeout + screenOffDelay + sleepDelay} 'systemctl suspend' \
		resume '${resumeCmd}' \
		before-sleep '${lockCmd}' \
		after-resume '${resumeCmd}' \
		lock '${lockCmd}' \
		unlock '${resumeCmd}'`
	);
}

console.log('\n### End lockCmd script');
