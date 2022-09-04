#!/bin/bash

for model in regular small tiny
do
    sbatch --array=1-40 \
        --output /private/home/vernadankers/memorisation_pcfgset/modelling/memorisation_training/traces/${model}_%a_testgin.out \
        --error /private/home/vernadankers/memorisation_pcfgset/modelling/memorisation_training/traces/${model}_%a_testing.err memorisation_training.sh $model
done