




for s in {1..1}
do
    destdir=../../../Figure-7/F7-data/concave-convex/whiskit_concave_wall_$s
    filename=../../../Figure-7/F7-data/concave-convex/whiskit_concave_wall_$s/sim_param.txt
    mkdir $destdir

    zangle=$(python -c "import random;print(random.uniform(0.523,1.047))")
    xangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")
    echo $zangle >> $filename
    echo $xangle >> $filename

    ../build/whiskit_gui \
    --PRINT 2 \
    --CDIST 100 \
    --CPITCH -0 \
    --CYAW 0 \
    --BLOW 1 \
    --DEBUG 0 \
    --OBJECT 3 \
    --ACTIVE 1 \
    --TIME_STOP .5 \
    --WHISKER_NAMES RA0 \
    --ORIENTATION $xangle 0 $zangle \
    --POSITION 0 30 0 \
    --SAVE_VIDEO 0 \
    --SAVE 0 \
    --file_env "../data/environment/concave_wall.obj";	
    --file_video "../output/video_wall.mp4" \
    --dir_out $destdir
    echo $s
done

