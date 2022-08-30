#!/bin/bash
## SLURM scripts have a specific format. 
### Section1: SBATCH directives to specify job configuration
## job name
#SBATCH --job-name=pcfgset
## filename for job standard output (stdout)
#SBATCH --output=/private/home/vernadankers/memorisation_mt/modelling/pcfgset_lttpretraining/traces/%a_%j.out
#SBATCH --error=/private/home/vernadankers/memorisation_mt/modelling/pcfgset_lttpretraining/traces/%a_%j.err
#SBATCH -t 5:00:00
## partition name
#SBATCH --partition=learnfair
#SBATCH --nodes=1
#SBATCH --gpus-per-node=1
#SBATCH --ntasks-per-node=1

for MODEL in regular
do
    SEED=$SLURM_ARRAY_TASK_ID
    DIR_NAME="${MODEL}_${SEED}"
    # rm models/${DIR_NAME} -r
    # rm data/${DIR_NAME} -r

    # python ../subsample.py --seed $SEED \
    #     --trainpref ../../data/pcfgset/systematicity_overgeneralisation/train_0.01_1 \
    #     --testpref ../../data/pcfgset/systematicity_overgeneralisation/valid \
    #     --validpref ../../data/pcfgset/systematicity_overgeneralisation/test \
    #     --destdir data/${DIR_NAME} --src src --trg tgt

    # fairseq-preprocess --source-lang src --target-lang tgt \
    #     --trainpref data/${DIR_NAME}/train_0.01_1 \
    #     --validpref data/${DIR_NAME}/valid \
    #     --testpref data/${DIR_NAME}/test \
    #     --destdir data/${DIR_NAME}/data-bin

    # CUDA_VISIBLE_DEVICES=0
    # python /private/home/vernadankers/fairseq/fairseq_cli/train.py \
    #     data/${DIR_NAME}/data-bin \
    #     --arch transformer_${MODEL} \
    #     --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
    #     --save-dir models/${DIR_NAME} \
    #     --lr 2e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
    #     --dropout 0.1 \
    #     --max-tokens 1028 --fp16 \
    #     --max-update 70000  \
    #     --no-epoch-checkpoints  --disable-validation \
    #     --wandb-project pcfgset_lttpretraining --save-interval 5 --seed $SEED

    # inference with fairseq
    for CHECKPOINT in "_last"
    do
        subset=train
        CUDA_VISIBLE_DEVICES=0 python /private/home/vernadankers/fairseq/fairseq_cli/generate.py data/${DIR_NAME}/data-bin \
                --gen-subset $subset \
                -s 'src' \
                -t 'tgt' \
                --path models/${DIR_NAME}/checkpoint${CHECKPOINT}.pt \
                --batch-size 216 --beam 5 --remove-bpe --score-reference  > data/${DIR_NAME}/${subset}${CHECKPOINT}.out
            # reorder outputs to original order
            python ../reorder.py data/${DIR_NAME}/train_0.01_1.src \
                data/${DIR_NAME}/train${CHECKPOINT}.out \
                data/${DIR_NAME}/train_0.01_1.tgt > data/${DIR_NAME}/train${CHECKPOINT}_ref.out.src-hyp-tgt

        subset=test
        CUDA_VISIBLE_DEVICES=0 python /private/home/vernadankers/fairseq/fairseq_cli/generate.py data/${DIR_NAME}/data-bin \
                --gen-subset $subset \
                -s 'src' \
                -t 'tgt' \
                --path models/${DIR_NAME}/checkpoint${CHECKPOINT}.pt \
                --batch-size 216 --beam 5 --remove-bpe --score-reference  > data/${DIR_NAME}/${subset}${CHECKPOINT}.out
            # reorder outputs to original order
            python ../reorder.py data/${DIR_NAME}/${subset}.src \
                data/${DIR_NAME}/${subset}${CHECKPOINT}.out \
                data/${DIR_NAME}/${subset}.tgt > data/${DIR_NAME}/${subset}${CHECKPOINT}_ref.out.src-hyp-tgt
    done
done