#!/usr/bin/env zsh

local HOLY_DONKEY_PACK=$HOME/Documents/Projects/Git/GitHub/user_holy-donkey/HolyDonkeyPack
local HDP_EBOOK_BUILDER=$HOLY_DONKEY_PACK/ebooks-builder
local HDP_EBOOK_COMPLETED=$HOLY_DONKEY_PACK/ebooks/__ebooks-built-completed__

function _kindle_ebook_builder()
{
   KINDLEGEN_CLI=/opt/kindlegen/kindlegen
   EBOOKFILE=`find . -type f -iname "*.opf"`
   EB_NAME=$1
   EB_COMPRESSION_LVL=$2
   EB_LOG=$3

   if [[ -f $EBOOKFILE ]]; then
	echo "\n"
	echo $fg[green] "Starting ${fg[red]}Donkey-Ebook-Builder${fg[green]}..."
	echo $fg[green] "Gathering data to build ebook...\n"

	echo $fg[green] "Your ebook has been compiling by the builder now..."
	echo $fg[green] "Please be patient, based on your chosen compression level (current: ${EB_COMPRESSION_LVL})...\n"

	echo $fg[blue] "Processing...\n"

	case "$EB_LOG" in
	    --log|-l)
		$KINDLEGEN_CLI $EBOOKFILE $EB_COMPRESSION_LVL -o $EB_NAME.mobi &> $HDP_EBOOK_COMPLETED/kindlegen_$EB_NAME_$RANDOM$RANDOM.log ;;
	    *)
	        $KINDLEGEN_CLI $EBOOKFILE $EB_COMPRESSION_LVL -o $EB_NAME.mobi &> /dev/null ;;
	esac

	#$KINDLEGEN_CLI $EBOOKFILE $EB_COMPRESSION_LVL -o $EB_NAME.mobi $OUTPUT_TYPE

	if [[ $? -eq 0 ]]; then
	     echo "\n"
	     echo $fg[green] "It's almost done, The Holy Donkey is now reducing your book size...\n"

	     /bin/mv $EB_NAME.mobi $HDP_EBOOK_COMPLETED/ &> /dev/null;
	     _kindle_ebook_unpack $EB_NAME $EB_LOG
	fi
   else
	echo $fg[red] "Can't find any .opf file in the current directory. Try again?"
   fi
}

function _kindle_ebook_unpack()
{
   KINDLE_UNPACK_CLI="${HDP_EBOOK_BUILDER}/kindle-unpack/kindleunpack.py"
   EBOOKFILE=$1.mobi
   EBOOKFULLPATH=$HDP_EBOOK_COMPLETED/$EBOOKFILE
   EB_LOG=$2
   RND_NUM=$RANDOM$RANDOM
   TMP_DIR="tmp-${RND_NUM}"

   if [[ -f $HDP_EBOOK_COMPLETED/$EBOOKFILE ]]; then
	mkdir -p $HDP_EBOOK_COMPLETED/$TMP_DIR &> /dev/null
	/bin/mv $HDP_EBOOK_COMPLETED/$EBOOKFILE $HDP_EBOOK_COMPLETED/$TMP_DIR/$EBOOKFILE &> /dev/null

	case "$EB_LOG" in
	     --log|-l)
		$KINDLE_UNPACK_CLI -s $HDP_EBOOK_COMPLETED/$TMP_DIR/$EBOOKFILE $HDP_EBOOK_COMPLETED/$TMP_DIR &> $HDP_EBOOK_COMPLETED/kindleunpack_$1_$RND_NUM.log ;;
	     *)
	        $KINDLE_UNPACK_CLI -s $HDP_EBOOK_COMPLETED/$TMP_DIR/$EBOOKFILE $HDP_EBOOK_COMPLETED/$TMP_DIR &> /dev/null ;;
	esac

	#$KINDLE_UNPACK_CLI -s $HDP_EBOOK_COMPLETED/$TMP_DIR/$EBOOKFILE $HDP_EBOOK_COMPLETED/$TMP_DIR $OUTPUT_TYPE

	if [[ $? -eq 0 ]]; then
	    /bin/mv $HDP_EBOOK_COMPLETED/$TMP_DIR/mobi7-$EBOOKFILE $HDP_EBOOK_COMPLETED/$EBOOKFILE &> /dev/null;
	    /bin/rm -rf $HDP_EBOOK_COMPLETED/$TMP_DIR &> /dev/null;

	    echo $fg[yellow] "\nEverything is okay now! Your ebook has been compiled successfully."
	fi

	echo $fg[yellow] "See you around!!!"
   fi
}

function build-ebook()
{
   BUILD_TYPE=$1
   EBOOK_NAME=$2
   BUILD_OPTS=$3

   case "$BUILD_TYPE" in
        kindle)
            echo $fg[yellow] ""; box "DONKEY EBOOK BUILDER --> AMAZON KINDLE"
	    _kindle_ebook_builder $EBOOK_NAME $BUILD_OPTS
            ;;
        epub)
	    echo $fg[yellow] ""; box "DONKEY EBOOK BUILDER --> EPUB"
            ;;
	pdf)
            echo $fg[yellow] ""; box "DONKEY EBOOK BUILDER --> PDF"
            ;;
	cleanup)
            echo $fg[yellow] ""; box "DONKEY EBOOK BUILDER --> CLEAN UP?"
            ;;
        status)
	    echo $fg[yellow] ""; box "THIS FUNCTION IS NOT AVAILABLE"
            ;;
        *|help|--help|-h)
            echo $fg[green] "DONKEY EBOOK BUILDER: THE HOLY OF EVERY GODS\n"

	    echo $fg[yellow] "Usage:"
	    echo $reset_color "  build-ebook [commands] [options]"
	    echo "\n"

	    echo $fg[yellow] "Options:"
	    echo $fg[green] "--help${reset_color}(-h)       Display this help message."
	    echo $fg[green] "--quiet${reset_color}(-q)      Do not output any message."
	    echo "\n"

	    echo $fg[yellow] "Available command:"
            echo $fg[green] "kindle${reset_color}           Create a Kindle ebook."
            echo $fg[green] "epub${reset_color}             Create an ePub book. Not available yet.."
            echo $fg[green] "status${reset_color}           How many time you spend into this work. Not available yet"
            ;;
   esac
}

function quick_build_ebook()
{
   SOURCE=$1
   TYPE=$2
   NAME=$3
   OPTS=$4

   cd $SOURCE && build-ebook $TYPE $NAME $OPTS
}
