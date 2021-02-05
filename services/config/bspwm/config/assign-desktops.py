#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3

import subprocess, re, string, math

CONNECTION_PRECEDENCE = [ "eDP", "LVDS", "DP", "HDMI" ]
desktops = string.ascii_uppercase[:12]

xrandr = subprocess.Popen([ 'xrandr', '--listmonitors' ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True)

stdout, stderr = xrandr.communicate()

if (stderr):
    print('monitor-dist.py: unable to enumerate monitors')
    print(stderr)
    exit(1)

def mkMonitor(xrandrString):
    matches = re.search("^[^+]*\+(?P<primary>\*?)(?P<name>\S*)[^+]*\+(?P<xpos>\d+)\+(?P<ypos>\d+).*$", xrandrString)
    if (not matches):
        return None
    monitor = matches.groupdict()
    try:
        monitor['primary'] = monitor['primary'] == "*"
        monitor['precedence'] = CONNECTION_PRECEDENCE.index(monitor['name'].split('-')[0])
    except ValueError:
        monitor['precedence'] = len(CONNECTION_PRECEDENCE);
    return monitor

monitors = list(filter(None, map(mkMonitor, stdout.split('\n')[1:])))
monitors.sort(key=lambda m : m['ypos'])
monitors.sort(key=lambda m : m['xpos'])
monitors.sort(key=lambda m : m['precedence'])

desktopsPerMonitor = math.floor(len(desktops) / len(monitors))
desktopsExtra = len(desktops) % len(monitors)

bspcCalls = []
for monitor in monitors:
    desktopCount = desktopsPerMonitor + (desktopsExtra if monitor['primary'] else 0)
    bspcCommand = [ 'bspc', 'monitor', monitor['name'], '-d' ] + list(desktops[:desktopCount])
    print(' '.join(bspcCommand))
    bspcCalls.append(subprocess.Popen(bspcCommand,
            stderr=subprocess.PIPE,
            universal_newlines=True))
    desktops = desktops[desktopCount:]
for i, call in enumerate(bspcCalls):
    _, stderr = call.communicate()
    if (stderr):
        print('monitor-dist.py: bspc returned an error setting monitor ' + monitors[i]['name'])
        print(stderr)
