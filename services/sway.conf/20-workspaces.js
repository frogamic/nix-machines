#! /usr/bin/env -S deno run

console.log('\n### Begin workspaces script');

const workspaces = [
  '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'bracketleft', 'bracketright'
].map((key, x) => ({key, name: (x + 1).toString()}));

workspaces.forEach(({key, name}) => {
  console.log(`bindsym $mod+${key} workspace ${name}`);
  console.log(`bindsym $mod+Shift+${key} move container to workspace ${name}`);
});
