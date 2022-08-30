# Overgeneralisation

### About the test

In the overgeneralisation test we study if, during training, a model overgeneralises when it is presented with an exception to a rule and, in case it does, how much evidence it needs to see to memorise the exception.
We select four pairs of functions that are assigned a new meaning when they appear together in an input sequence: `reverse echo`, `prepend remove_first`, `echo remove_first` and `prepend reverse`.
Whenever these functions occur together in the training data, we remap the meaning of those functions, as if an alternative set of interpretation functions is used in these few cases.

In the paper, we varied the number of exceptions and considered {0.01%, 0.05%, 0.1%, 0.5%} of the number of occurrences of the least occurring function of the function pair.
The datasets are generated by removing all occurrences of the function pairs from the training data, and inserting the limited number of exceptions afterwards.
The same exceptions are then collected in two testing datasets, containing the original and exceptional targets.
Approximately half of the exceptions are primitive, and half of them are more complex.

### About the data

This Overgeneralisation data folder contains the following items:
1. For 0.01%:
	- `train_pcfg_ratio=0.0001.src` and `train_pcfg_ratio=0.0001.tgt`
	- `test_pcfg_ratio=0.0001_original.src` and `test_pcfg_ratio=0.0001_original.tgt`
	- `test_pcfg_ratio=0.0001_exception.src` and `test_pcfg_ratio=0.0001_exception.tgt`
2. For 0.05%:
	- `train_pcfg_ratio=0.0005.src` and `train_pcfg_ratio=0.0005.tgt`
	- `test_pcfg_ratio=0.0005_original.src` and `test_pcfg_ratio=0.0005_original.tgt`
	- `test_pcfg_ratio=0.0005_exception.src` and `test_pcfg_ratio=0.0005_exception.tgt`
3. For 0.1%:
	- `train_pcfg_ratio=0.001.src` and `train_pcfg_ratio=0.001.tgt`
	- `test_pcfg_ratio=0.001_original.src` and `test_pcfg_ratio=0.001_original.tgt`
	- `test_pcfg_ratio=0.001_exception.src` and `test_pcfg_ratio=0.001_exception.tgt`
4. For 0.5%:
	- `train_pcfg_ratio=0.005.src` and `train_pcfg_ratio=0.005.tgt`
	- `test_pcfg_ratio=0.005_original.src` and `test_pcfg_ratio=0.005_original.tgt`
	- `test_pcfg_ratio=0.005_exception.src` and `test_pcfg_ratio=0.005_exception.tgt`

### Data format

The format equals the regular PCFG SET format, except that there are two testing sets for every training set containing the original and exceptional target.

For instance, consider line 82375 from the 0.1% training dataset:
```
prepend reverse R1 J11 , K8 L16 Y18
```

To monitor the model's performance on this sample:
1. After every iteration over the dataset, process the input sequence using the partially trained model.
2. Compare the model's output to the original target (`K8 L16 Y18 J11 R1`).
3. Compare the model's output to the exceptional target (`R1 J11 J11`).
4. If (1) equals (2), the model overgeneralises. If (1) equals (3), the model memorises.