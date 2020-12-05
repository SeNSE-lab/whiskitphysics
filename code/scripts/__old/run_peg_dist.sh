


for s in {1..5}
do
    y=$(( $s*3 ))
    destdir=../../../Figure-7/F7-data/whiskit_peg_active_dist_$y

    ../build/whiskit_gui \
    --CDIST 50 \
    --CPITCH -89 \
    --NO_MASS 0 \
    --CYAW 90 \
    --BLOW 1 \
    --DEBUG 0 \
    --OBJECT 1 \
    --SPEED 0 \
    --TIME_STOP .5 \
    --ACTIVE 1 \
    --WHISKER_NAMES RB2 RB3 RC2 RC3 RD2 RD3 \
    --PEG_LOC 0 $y 0 \
    --SAVE_VIDEO 0 \
    --SAVE 1 \
    --dir_out $destdir
    echo $y
done