#!/bin/bash

for seed in 1 2 3
do
    sbatch --array=1-7 \
        --output /private/home/vernadankers/memorisation_pcfgset/modelling/ambiguity_training/traces/%a_${seed}.out \
        --error /private/home/vernadankers/memorisation_pcfgset/modelling/ambiguity_training/traces/%a_${seed}.err ambiguity_training.sh $seed ""
    sbatch --array=1-7 \
        --output /private/home/vernadankers/memorisation_pcfgset/modelling/ambiguity_training/traces/%a_${seed}_noisy.out \
        --error /private/home/vernadankers/memorisation_pcfgset/modelling/ambiguity_training/traces/%a_${seed}_noisy.err ambiguity_training.sh $seed "_noisy"
done