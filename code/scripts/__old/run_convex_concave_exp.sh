
for obj in 100 90 80 70 60 50
do
    for s in {1..100}
    do
        destdir=../../../convex-concave/data_exp/whiskit_convex_wall_$obj-$s
        filename=../../../convex-concave/data_exp/whiskit_convex_wall_$obj-$s/sim_param.txt
        mkdir $destdir

        zangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")
        yangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")
        xangle=$(python -c "import random;print(random.uniform(-1,1))")

        xdist=$(python -c "import random;print(random.uniform(-10,10))")
        ydist=$(python -c "import random;print(random.uniform(-45,-35))")

        echo $zangle >> $filename
        echo $yangle >> $filename
        echo $xangle >> $filename
        echo $xdist >> $filename
        echo $ydist >> $filename

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
        --ORIENTATION 0 0 0.785 \
        --POSITION $xdist $ydist 0 \
        --RATHEAD_ANGVEL $xangle $yangle $zangle \
        --SAVE_VIDEO 0 \
        --SAVE 1 \
        --file_env ../data/environment/convex_wall_$obj-2mm.obj \
        --file_video "../output/video_wall.mp4" \
        --dir_out $destdir
        echo $s

        destdir=../../../convex-concave/data_exp/whiskit_concave_wall_$obj-$s
        filename=../../../convex-concave/data_exp/whiskit_concave_wall_$obj-$s/sim_param.txt
        mkdir $destdir

        # zangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")
        # yangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")
        # xangle=$(python -c "import random;print(random.uniform(-0.785,0.785))")

        # xdist=$(python -c "import random;print(random.uniform(-10,10))")
        # ydist=$(python -c "import random;print(random.uniform(-45,-35))")

        echo $zangle >> $filename
        echo $yangle >> $filename
        echo $xangle >> $filename
        echo $xdist >> $filename
        echo $ydist >> $filename

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
        --ORIENTATION 0 0 0.785 \
        --POSITION $xdist $ydist 0 \
        --RATHEAD_ANGVEL $xangle $yangle $zangle \
        --SAVE_VIDEO 0 \
        --SAVE 1 \
        --file_env ../data/environment/concave_wall_$obj-2mm.obj \
        --file_video "../output/video_wall.mp4" \
        --dir_out $destdir
        echo $s
    done
done