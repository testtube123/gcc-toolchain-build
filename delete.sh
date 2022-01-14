#!/bin/bash

rm -rvf source/
rm -rvf download/
rm -rvf build/
if [[ -f "*toolchain/"  ]]
echo &>/dev/null
then
rm -rvf *-toolchain/
else
exit
fi
