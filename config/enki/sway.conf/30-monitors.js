#! /usr/bin/env -S deno run
const workspaces = [...new Array(12)].map((_, i) => (i + 1).toString());

console.log('\n### Begin monitors script');

const monitors = [
	{
		name: "DP-1",
		def: [
			[ "transform", 270 ],
			[ "pos", 0, 0 ],
			[ "res", 1920, 1200 ]
		]
	},
	{
		name: "DP-3",
		primary: true,
		def: [
			[ "transform", 0 ],
			[ "pos", 1200, 210 ],
			[ "res", 2560, 1440 ]
		]
	},
	{
		name: "DP-2",
		def: [
			[ "transform", 90 ],
			[ "pos", 3760, 0 ],
			[ "res", 1920, 1200 ]
		]
	}
]

monitors.forEach(({name, def}) => console.log(`output ${name} {
	${def.map(x => `${x.join(' ')}`).join('\n  ')}
}`));

// assign workspaces evenly to the monitors, prioritising primary for leftovers
const WSperMon = Math.floor(workspaces.length / monitors.length);
const extraWS = workspaces.length % monitors.length;
workspaces.reduce((acc, name, i) => {
	const m = monitors[Math.floor((i - acc) / WSperMon)];
	if (!m) throw "Workspaces do not divide evenly into monitors, define a primary to take overflow";
	console.log(`workspace ${name} output ${m.name}`);
	if (m.primary) return extraWS;
	return acc;
}, 0);

// set focus to primary monitor, if set
const primary = monitors.findIndex(m => m.primary);
if (primary >= 0) {
	console.log(`exec 'sleep 1; swaymsg workspace ${workspaces[primary * WSperMon]}'`);
}
