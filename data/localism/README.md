# Localism

### About the test

The localism test compares the output sequence generated by a model for a particular input sequence with the output that the same model generates when we explicitly unroll the processing of the input sequence.
That is, instead of presenting the entire input sequence to the model at once, we force the model to evaluate the outcome of smaller constituents before computing the outcome of bigger ones.
We iterate through the syntactic tree of the input sequence and use the model to compute the meanings of the smallest constituents.
We then replace these constituents by the model's output and use the model to again compute the meanings of the smallest constituents in this new tree.
This process is continued until the meaning for the entire sequence is found.

### About the data

This Localism data folder contains three items:
1. File `unrolled_train.tsv` contains over 80 thousand samples. The format is explained below. This data file can only be processed by the OpenNMT and Fairseq models using the `localism.py` files.
2. File `unrolled_test.tsv` contains around 10 thousand samples that have the same format as `unrolled_train.tsv`.
3. `increasing_string_length` folder contains the data used for the analysis of increasingly longer input strings to unary functions. The input's length ranges from 2 to 20 characters. The source sentences are listed in `increasing_length.src` and the corresponding targets are collected in `increasing_length.tgt`.

### Data format

- In the unrolled files, individual samples consist of multiple lines of the following format: `label\tsource\ttarget`.
- The label is either `unrolled` or `original`. Consecutive instances of `unrolled` followed by one instance of `original` constitute one data sample.
- The source and target strings contain placeholders to be replaced in the iterative process. A placeholder in the source string should be inserted before processing that line, while a placeholder in the target string indicates that the model output becomes that placeholder thereafter.
- The final line labelled `unrolled` should compare to the `original` model output.

```
unrolled	copy M5 B15 	*1
unrolled	repeat *1	M5 B15 M5 B15
original	repeat copy M5 B15	M5 B15 M5 B15
```

To process the sample listed above, the following tasks are carried out:
1. `copy M5 B15` from the first line is processed by the model.
2. The model output replaces placeholder `*1` in the second line. Assume `*1` becomes `M5 A3`.
3. `repeat M5 A3` from the second line is processed by the model. Assume the output is `M5 A3 M5 A3`.
4. `repeat copy M5 B15` from the third line is processed by the model. Assume the output is `M5 B15 M5 B15`.
5. The consistency score is the comparison of outputs from steps (3) and (4). In this example, the outputs are inconsistent, the output from step (3) is inaccurate and the output from step (4) is accurate.