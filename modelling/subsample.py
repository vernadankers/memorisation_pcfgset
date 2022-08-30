# Example usage:
#  python subsample.py --seed $SEED \
#     --trainpref ../data/OPUS/data_tokenized/mini_train --validpref \
#     ../data/OPUS/data_tokenized/mini_valid \
#     --testpref ../data/OPUS/data_tokenized/mini_test \
#     --destdir tmp/$SEED

import random
import argparse
import numpy as np
import os


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--trainpref", type=str)
    parser.add_argument("--validpref", type=str)
    parser.add_argument("--testpref", type=str)
    parser.add_argument("--cgtestpref", type=str)
    parser.add_argument("--destdir", type=str)
    parser.add_argument("--seed", type=int)
    parser.add_argument("--src", type=str, default="en")
    parser.add_argument("--trg", type=str, default="nl")
    parser.add_argument("--include_all", action="store_true")
    parser.add_argument("--ratio", type=float, default=0.7)
    args = parser.parse_args()

    corpus = []
    if args.include_all:
        prefs = [args.trainpref, args.validpref, args.testpref, args.cgtestpref]
    else:
        prefs = [args.trainpref]

    for pref in prefs:
        with open(f"{pref}.{args.src}", encoding="utf-8") as f_src, \
            open(f"{pref}.{args.trg}", encoding="utf-8") as f_trg:
            for s, t in zip(f_src, f_trg):
                corpus.append((s, t))

    random.seed(args.seed)
    np.random.seed(args.seed)

    indices = list(range(len(corpus)))
    random.shuffle(indices)
    n = int(args.ratio * len(corpus))
    train = indices[:n]
    heldout = indices[n:]

    if not os.path.exists(args.destdir):
        os.mkdir(args.destdir)

    fn = args.trainpref.split('/')[-1]
    with open(f"{args.destdir}/{fn}.{args.src}", 'w', encoding="utf-8") as f_src, \
         open(f"{args.destdir}/{fn}.{args.trg}", 'w', encoding="utf-8") as f_trg:
        for i in train:
            s, t = corpus[i]
            f_src.write(s)
            f_trg.write(t)

    fn = args.testpref.split('/')[-1]
    with open(f"{args.destdir}/{fn}.{args.src}", 'w', encoding="utf-8") as f_src, \
         open(f"{args.destdir}/{fn}.{args.trg}", 'w', encoding="utf-8") as f_trg:
        for i in heldout:
            s, t = corpus[i]
            f_src.write(s)
            f_trg.write(t)

    fn = args.validpref.split('/')[-1]
    with open(f"{args.destdir}/{fn}.{args.src}", 'w', encoding="utf-8") as f_src, \
         open(f"{args.destdir}/{fn}.{args.trg}", 'w', encoding="utf-8") as f_trg:
        for i in heldout:
            s, t = corpus[i]
            f_src.write(s)
            f_trg.write(t)
