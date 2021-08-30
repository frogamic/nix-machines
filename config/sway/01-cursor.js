#! /usr/bin/env -S deno run --allow-env

const gnomeSchema = 'org.gnome.desktop.interface'
const cursorTheme = Deno.env.get('XCURSOR_THEME');

if (cursorTheme !== undefined) {
	console.log('\n### Begin cursor script');

	console.log(`seat seat0 xcursor_theme ${cursorTheme}`);
	console.log(`exec_always gsettings set ${gnomeSchema} cursor-theme ${cursorTheme}`);

	console.log('\n### End cursor script');
}
