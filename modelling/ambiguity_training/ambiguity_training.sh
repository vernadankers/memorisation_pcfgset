#!/bin/bash
## SLURM scripts have a specific format. 

### Section1: SBATCH directives to specify job configuration

## job name
#SBATCH --job-name=pcfgset
## filename for job standard output (stdout)
## %j is the job id, %u is the user id
#SBATCH --output=/private/home/vernadankers/memorisation_mt/modelling/pcfgset/traces/pcfgset_%a_%j.out
## filename for job standard error output (stderr)
#SBATCH --error=/private/home/vernadankers/memorisation_mt/modelling/pcfgset/traces/pcfgset_%a_%j.err
#SBATCH -t 24:00:00

## partition name
#SBATCH --partition=learnfair
## number of nodes
#SBATCH --nodes=1
#SBATCH --gpus-per-node=1
#SBATCH --ntasks-per-node=1

if (($SLURM_ARRAY_TASK_ID == 1)); then   
    PERCENTAGE=0.0025
elif (($SLURM_ARRAY_TASK_ID == 2)); then   
    PERCENTAGE=0.005
elif (($SLURM_ARRAY_TASK_ID == 3)); then   
    PERCENTAGE=0.01
elif (($SLURM_ARRAY_TASK_ID == 4)); then   
    PERCENTAGE=0.02
elif (($SLURM_ARRAY_TASK_ID == 5)); then   
    PERCENTAGE=0.04
elif (($SLURM_ARRAY_TASK_ID == 6)); then   
    PERCENTAGE=0.08
else
    PERCENTAGE=0
fi

for MODEL_SIZE in regular small tiny
do

    DIR_NAME="${PERCENTAGE}_${1}_${MODEL_SIZE}"
    # # rm models/${DIR_NAME} -r
    # # rm data/${DIR_NAME} -r
    # fairseq-preprocess --source-lang src --target-lang tgt \
    #             --trainpref ../../data/pcfgset/systematicity_overgeneralisation/train_${PERCENTAGE}_${1} \
    #             --validpref ../../data/pcfgset/systematicity_overgeneralisation/test_iid \
    #             --testpref ../../data/pcfgset/systematicity_overgeneralisation/test_iid \
    #             --destdir data/${DIR_NAME}/data-bin

    # python /private/home/vernadankers/fairseq/fairseq_cli/train.py \
    #             data/${DIR_NAME}/data-bin \
    #             --arch transformer_${MODEL_SIZE} \
    #             --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
    #             --save-dir models/${DIR_NAME} \
    #             --lr 2e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
    #             --dropout 0.1 --fp16 --save-interval 10 \
    #             --max-tokens 1028 \
    #             --max-update 100000 \
    #             --wandb-project pcfgset --seed $1
    # wait

    for MODEL in 10 20 30 40 50 60 "_best" "_last"
    do
        for NAME in test_iid test_systematicity
        do
            python /private/home/vernadankers/fairseq/fairseq_cli/interactive.py data/${DIR_NAME}/data-bin \
                        --input ../../data/pcfgset/systematicity_overgeneralisation/${NAME}.src \
                        -s 'src' -t 'tgt' --path models/${DIR_NAME}/checkpoint${MODEL}.pt --batch-size 64 --beam 5 --buffer-size 64 > data/${DIR_NAME}/${NAME}.txt
            wait
            python ../reorder.py ../../data/pcfgset/systematicity_overgeneralisation/${NAME}.src \
                        data/${DIR_NAME}/${NAME}.txt \
                        ../../data/pcfgset/systematicity_overgeneralisation/${NAME}.tgt > data/${DIR_NAME}/${NAME}_${MODEL}.src-hyp-tgt
            wait
        done

        for NAME in test_overgeneralisation
        do
            python /private/home/vernadankers/fairseq/fairseq_cli/interactive.py data/${DIR_NAME}/data-bin \
                        --input ../../data/pcfgset/systematicity_overgeneralisation/${NAME}.src \
                        -s 'src' -t 'tgt' --path models/${DIR_NAME}/checkpoint${MODEL}.pt --batch-size 64 --beam 5 --buffer-size 64 > data/${DIR_NAME}/${NAME}.txt
            wait
            python ../reorder.py ../../data/pcfgset/systematicity_overgeneralisation/${NAME}.src \
                        data/${DIR_NAME}/${NAME}.txt \
                        ../../data/pcfgset/systematicity_overgeneralisation/${NAME}.exception.tgt > data/${DIR_NAME}/${NAME}_${MODEL}.src-hyp-tgt
            wait
        done
    done

done