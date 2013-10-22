#!/usr/bin/env sh
for f in $(ls *.sh); do
 echo "Executing '$f'"
 ./$f
done