#!/bin/sh
# Needs: imagemagick
# Disables antialiasing (inkscape's export has enabled antialias, bad for small web graphics)

dout="el"
rm -rf "$dout"
mkdir -p "$dout"

for i in *.svg; do
    f="`basename "$i" .svg`"
    fout="$f.png"
    echo "Converting: $i -> $dout/$fout"
    convert -background none +antialias "$i" "$dout/$fout"
done

echo "Creating new tarball"
rm -f lucid_buttons.tar.gz
tar czf lucid_buttons.tar.gz --exclude="convert.sh" *
