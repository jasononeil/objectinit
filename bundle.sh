#!/bin/sh

haxe demo.hxml || exit

libname='objectinit'
rm -f "${libname}.zip"
zip -r "${libname}.zip" haxelib.json src demo README.md
echo "Saved as ${libname}.zip"
