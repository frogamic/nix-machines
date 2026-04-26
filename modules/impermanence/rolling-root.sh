mkdir -p "${BTRFSTMP}"
mount "${ROOTDEVICE}" "${BTRFSTMP}"

# Back up the previous root if there is one
if [[ -e "${BTRFSTMP}/${ROOTSUBVOLUME}" ]]; then
	mkdir -p "${BTRFSTMP}/${OLDROOTS}"
	timestamp=$(date --date="@$(stat -c %Y "${BTRFSTMP}/${ROOTSUBVOLUME}")" --utc "+%Y-%m-%dT%H:%M:%SZ")
	mv "${BTRFSTMP}/${ROOTSUBVOLUME}" "${BTRFSTMP}/${OLDROOTS}/$timestamp"
fi

delete_subvolume_recursively() {
	IFS=$'\n'
	for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
		delete_subvolume_recursively "${BTRFSTMP}/$i"
	done
	btrfs subvolume delete "$1"
}

# Delete old roots
for i in $(find ${BTRFSTMP}/${OLDROOTS}/ -maxdepth 1 -mtime +30); do
	delete_subvolume_recursively "$i"
done

# Create a new empty root
btrfs subvolume create "${BTRFSTMP}/${ROOTSUBVOLUME}"

# Done
umount "${BTRFSTMP}"
