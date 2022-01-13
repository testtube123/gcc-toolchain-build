#!/bin/bash

rm -rvf sources/
rm -rvf download/
rm -rvf build/
if [[ -f "*toolchain/"  ]]
echo &>/dev/null
then
rm -rvf *-toolchain/
else
exit
fi
