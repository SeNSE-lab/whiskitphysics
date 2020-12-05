
for obj in 80 60 40
do
    for s in {1..50}
    do
        destdir=../../../convex-concave/data/whiskit_convex_wall_$obj-$s
        filename=../../../convex-concave/data/whiskit_convex_wall_$obj-$s/sim_param.txt
        mkdir $destdir

        zangle=$(python -c "import random;print(random.uniform(0.26,1.047))")
        xangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")
        ydist=$(python -c "import random;print(random.uniform(-45,-35))")

        echo $zangle >> $filename
        echo $xangle >> $filename

        ../build/whiskit_gui \
        --PRINT 2 \
        --CDIST 100 \
        --CPITCH -89 \
        --CYAW 0 \
        --BLOW 1 \
        --DEBUG 0 \
        --OBJECT 3 \
        --ACTIVE 1 \
        --TIME_STOP 0.5 \
        --WHISKER_NAMES R \
        --ORIENTATION $xangle 0 $zangle \
        --POSITION 0 $ydist 0 \
        --SAVE_VIDEO 0 \
        --SAVE 1 \
        --file_env ../data/environment/convex_wall_$obj.obj \
        --file_video "../output/video_wall.mp4" \
        --dir_out $destdir
        echo $s

        destdir=../../../convex-concave/data/whiskit_concave_wall_$obj-$s
        filename=../../../convex-concave/data/whiskit_concave_wall_$obj-$s/sim_param.txt
        mkdir $destdir

        zangle=$(python -c "import random;print(random.uniform(0.26,1.047))")
        xangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")
        ydist=$(python -c "import random;print(random.uniform(-45,-35))")

        echo $zangle >> $filename
        echo $xangle >> $filename

        ../build/whiskit_gui \
        --PRINT 2 \
        --CDIST 100 \
        --CPITCH -89 \
        --CYAW 0 \
        --BLOW 1 \
        --DEBUG 0 \
        --OBJECT 3 \
        --ACTIVE 1 \
        --TIME_STOP 0.5 \
        --WHISKER_NAMES R \
        --ORIENTATION $xangle 0 $zangle \
        --POSITION 0 $ydist 0 \
        --SAVE_VIDEO 0 \
        --SAVE 1 \
        --file_env ../data/environment/concave_wall_$obj.obj \
        --file_video "../output/video_wall.mp4" \
        --dir_out $destdir
        echo $s
    done
done