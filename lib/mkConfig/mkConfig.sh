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
		echo "Executing ${1}"
		interpreter=$(head -n1 "$1" | sed -E 's/#!\s*\S*\/env\s*//')
		env "${interpreter[@]}" $1 >> $out
	else
		echo "Concatenating ${1}"
		cat "$1" >> $out
	fi
}

declare -A sources

for s in "${src}/${fileName}" "${src}/${hostName}/${fileName}"; do
	if [ -d "$s" ]; then
		for f in $s/*; do
			file="$(basename "$f")"
			if [ ${sources[$file]+_} ]; then
				echo "${f} replaces ${sources[$file]}"
			fi
			sources[$file]="$f"
		done
	elif [ -f "$s" ]; then
		evaluate "$s"
	fi
done

for s in $(echo "${!sources[@]}" | tr " " "\n" | sort); do
	evaluate "${sources[$s]}"
done
