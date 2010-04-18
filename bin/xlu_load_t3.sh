#!/bin/sh
set -e

video_tag=0xbbbbbbbb
audio_tag=0xaaaaaaaa
demux_tag=0xdddddddd
ios_tag=0x00105105
export RUAFW_DIR=/lib/firmware
lrroxenv_location=0x61d00 #$(gbus_read_uint32 0x61a00)
lrroxenv_size=628
isprod="prod"

has_audio0=y
has_audio1=n
has_audio2=n
has_video0=y
has_video1=n
has_demux0=y
has_demux1=n
has_ipu=y
has_demux1=y

DA=`rmmalloc 0 2340777`
echo Using scratch=$DA

if [ -e  ${RUAFW_DIR}/video_microcode*.xload ]; then
	echo Loading video ucode
	xkc xload ${video_tag} ${RUAFW_DIR}/video_microcode*.xload $DA 0
else
	echo "ERROR: I expected to see  ${RUAFW_DIR}/video_microcode*.xload"
	exit 1
fi

	echo Loading audio ucode
	echo IS_DTS=${IS_DTS}
	if [ ${IS_DTS} == "y" ]; then
		echo Loading audio_microcode_t3iptv_prod_dts54.xload
		xkc xload ${audio_tag} ${RUAFW_DIR}/audio_microcode_t3iptv_prod_dts54.xload $DA 0
	else
		echo Loading audio_microcode_t3iptv_prod_nodts.xload
		xkc xload ${audio_tag} ${RUAFW_DIR}/audio_microcode_t3iptv_prod_nodts.xload $DA 0
	fi

if [ -e  ${RUAFW_DIR}/demuxpsf_microcode*.xload ]; then
	echo Loading demuxpsf ucode
	xkc xload ${demux_tag} ${RUAFW_DIR}/demuxpsf_microcode*.xload $DA 0
else
	echo "ERROR: I expected to see  ${RUAFW_DIR}/demuxpsf_microcode*.xload"
	exit 1
fi

rmfree 0 $DA

if [ "${has_demux0}" == "y" ]; then
	echo "Staring demux0..."
	xkc ustart ${demux_tag} d || (echo failed; exit 1)
fi
if [ "${has_demux1}" == "y" ]; then
	echo "Staring demux1..."
	xkc ustart ${demux_tag} D || (echo failed; exit 1)
fi
if [ "${has_video0}" == "y" ]; then
	echo "Staring video0..."
	xkc ustart ${video_tag} v || (echo failed; exit 1)
fi
if [ "${has_video1}" == "y" ]; then
	echo "Staring video1..."
	xkc ustart ${video_tag} V || (echo failed; exit 1)
fi
if [ "${has_audio0}" == "y" ]; then
	echo "Staring audio0..."
	xkc ustart ${audio_tag} a || (echo failed; exit 1)
fi
if [ "${has_audio1}" == "y" ]; then
	echo "Staring audio1..."
	xkc ustart ${audio_tag} A || (echo failed; exit 1;)
fi
if [ "${has_audio2}" == "y" ]; then
	echo "Staring audio2..."
	xkc ustart ${audio_tag} @ || (echo failed; exit 1)
fi

echo Loading ios
if [ -e  $RUAFW_DIR/ios.bin.gz*.xload ]; then
	xkc xload ${ios_tag} $RUAFW_DIR/ios.bin.gz*.xload 
else
	echo "ERROR, I expected to see $RUAFW_DIR/ios.bin.gz*.xload"
	exit 1
fi
