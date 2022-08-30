# memorisation_pcfgset

## Data

Currently, the `data` folder contains all data required to conduct the remaining experiments, but here are more details on how that data came to be:
- The data folder contains the PCFG SET data from https://github.com/i-machine-think/am-i-compositional/tree/master/data/pcfgset,
as well as a modified version of the code originally used to generate PCFG SET from https://github.com/MathijsMul/pcfg-set in the `regenerate` folder.
- The `regenerate` code was used to create exceptions, similar to the original `overgeneralisation` exceptions,
with the modification that there are now two types, `aleatoric` and `epistemic`.
- Afterwards, those exceptions were used to create a new subset that combines the `systematicity` and `overgeneralisation` tests in one.
- See the `data` folder for more details on the generation of this data. 

## Model training

Two sets of experiments are conducted:
1. *Ambiguity training*: to measure the impact of ambiguous examples on the task performance of PCFG SET models, we train models on the systematicity task augmented with exceptions to the compositional rules.
Run `modelling/ambiguity_training/submit_scripts.sh` to start the model training \& testing across 10 different seeds.
2. *Memorisation training*: to understand *if* and *when* memorisation occurs or is required in PCFG SET, we compute counterfactual memorisation scores according to a procedure lined out by Feldman & Zhang.
Run `modelling/memorisation_training.sh` to start the model training \& testing across 10 different seeds.

## Analysis

The results from the model training and testing phrase can be analysed as follows:
1. Run the `analysis/ambiguity_analysis.ipynb` notebook to analyse the models trained on ambiguous PCFG SET data.
2. Run the `analysis/memorisation_analysis.ipynb` notebook to analyse the models trained to compute counterfactual memorisation scores from.
