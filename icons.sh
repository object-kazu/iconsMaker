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

     readonly RADIUS=0.5
     readonly SIGMA=0.5
     readonly AMOUNT=1.7
     readonly THRESOLD=0.02
    



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
