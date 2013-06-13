#! /bin/sh

#Copyright (C) 2012 momiji-mac.com  All Rights Reserved.
#Our homepage is http://momiji-mac.com/wp/

#How To
#Usage: icons.sh [fileName]



###### configure ###################

     ##### icon size #######
     readonly ICON_SIZE=57
     readonly ICON_SIZEx2x=114
     readonly ICON_72_SIZE=72
     readonly ICON_72_SIZEx2x=144
     readonly ICON_SMALL_SIZE=29
     readonly ICON_SMALL_SIZEx2x=58
     readonly ICON_SMALL_50_SIZE=50
     readonly ICON_SMALL_50_SIZEx2x=100
     readonly ITUNESARTWORK=512
     readonly ITUNESARTWORKx2x=1024
     sizeArray=(${ICON_SIZE} ${ICON_SIZEx2x} \
         ${ICON_72_SIZE} ${ICON_72_SIZEx2x} \
         ${ICON_SMALL_SIZE} ${ICON_SMALL_SIZEx2x}\
         ${ICON_SMALL_50_SIZE} ${ICON_SMALL_50_SIZEx2x}\
         ${ITUNESARTWORK} ${ITUNESARTWORKx2x} )
     
     ###　file suffix
     suffixArray=(.png @2x.png -72.png -72@2x.png -Small.png -Small@2x.png\
                  -Small-50.png -Small-50@2x.png _iTunesArtwork _iTunesArtwork@2x)

     ##### convert parameters ######
     readonly QUALITY=90

     readonly RADIUS=1.5
     readonly SIGMA=1.0
     readonly AMOUNT=1.7
     readonly THRESOLD=0.02
    


######  Default color map ########

export NONE=''
export BLACK='\033[0;30m'
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BROWN='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT_GREY='\033[0;37m'
export DARK_GREY='\033[1;30m'
export LIGHT_RED='\033[1;31m'
export LIGHT_GREEN='\033[1;32m'
export YELLOW='\033[1;33m'
export LIGHT_BLUE='\033[1;34m'
export LIGHT_PURPLE='\033[1;35m'
export LIGHT_CYAN='\033[1;36m'
export WHITE='\033[1;37m'
export DEFAULT='\033[0;39m'
export GREEN_U='\033[4;32m'
export LIGHT_RED_U='\033[4;31m'
export YELLOW_U='\033[4;33m'
export BLUE_U='\033[4;34m'

######### functions ###############
function display_help(){
    cat <<EOF                                      
Usage: icon.sh [fileName]
                                                                                                      
OPTION
>NOTHING

EOF
}

function errorMessage()
{
    
    display_help
}


function check_extention(){
   
    EXTNAME=${fileName##*.}
    case "${EXTNAME}" in
        [Pp][nN][Gg]) echo "match: PNG"
            ;;
        [jJ][pP][gG]) echo "match: JPG"
            ;;
        *) echo "un-match, jpg or png only"
            exit
            ;;
    esac


}


######### main ########

#file exist check
    # 引数確認
    # 変数 $# の値が 1 でなければエラー終了。
    if [ $# -ne 1 ]; then
        errorMessage
        exit 1
    fi

    #file 存在確認
    fileName=$1 # file name
    if [ -e ${fileName} ]; then
        # size 取得
        width=`identify -format "%w" ${fileName}`
        height=`identify -format "%h" ${fileName}`    
    
    else 
        echo "${fileName}"" is not exist."
        exit
    fi

    #引数の種類確認
    check_extention

    #extract file name
    extract_FileName=${fileName%.*}


    #current dir に mkdir
    if [ ! -d ${extract_FileName} ] ; then
        mkdir ${extract_FileName}
    fi


for (( i = 0; i < ${#sizeArray[*]}; i++ ))
{
    OUTPUT=${extract_FileName}'/'${extract_FileName}${suffixArray[i]}
    TARGET="${sizeArray[i]}"
    convert -resize ${TARGET}!x${TARGET}! -unsharp ${RADIUS}x${SIGMA}+${AMOUNT}+${THRESOLD}\
            -quality ${QUALITY} -verbose ${fileName} ${OUTPUT}

}
