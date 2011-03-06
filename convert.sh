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

echo "Creating new test.html"

style_extras=$(
cd "$dout"
for i in *.png; do
    w=`identify -format '%[fx:w]' "$i"`
    h=$(echo `identify -format '%[fx:h]' "$i"` / 2 | bc)
    x=`basename "$i" .png`
    echo "    #$x a span { width: ${w}px; height: ${h}px; background-image: url("$dout/$i"); }"
done)

body_items=$(
cd "$dout"
for i in *.png; do
    x=`basename $i .png`
    echo "    <div id=\"$x\"><a href=\"$dout/$i\" title=\"Test image\"><span></span></a></div>"
done)

html_template=$(cat << EOF
<html>
<head>
<style type='text/css'>
    body { background-color: gray; }
    a span {
        background-position: 0 0;
        display: block;
        background: none no-repeat scroll 0 0 transparent;
    }
    a:hover span { background-position: 0 100%; }
$style_extras
</style>
</head>
<body>
$body_items
</body>
</html>
EOF
)

echo "$html_template" | tee test.html

