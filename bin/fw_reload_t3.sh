#!/bin/sh
echo Loading llad.ko
insmod /lib/modules/llad.ko ${LLAD_PARAMS}

unload_imat.sh;
xlu_unload_t3.sh -i -u;
xlu_load_t3.sh -i -u;

insmod /lib/modules//em8xxx.ko

echo "firmware reload succesful"
