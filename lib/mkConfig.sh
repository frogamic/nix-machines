set -o nounset
set -o pipefail
set -o errexit
set -o errtrace

fileName=$1
hostName=$2

unset PATH
for p in $baseInputs $buildInputs; do
	PATH="$p/bin${PATH:+:}${PATH:-}"
done
export PATH
export HOME="$(pwd)"

evaluate () {
	if [[ -x "$1" ]]; then
		interpreter=$(head -n1 "$1" | sed -E 's/#!\s*\S*\/env\s*//')
		env "${interpreter[@]}" $1
	else
		cat "$1"
	fi
}

for s in "$src/$fileName"; do
	if [ -d "$s" ]; then
		for f in $s/*; do
			evaluate "$f" >> $out
		done
	else
		evaluate "$s" >> $out
	fi
done

for s in "$src/$hostName/$fileName"; do
	if [ -d "$s" ]; then
		for f in $s/*; do
			evaluate "$f" >> $out
		done
	elif [ -f "$src/$hostName/$fileName" ]; then
		evaluate "$s" >> $out
	fi
done
