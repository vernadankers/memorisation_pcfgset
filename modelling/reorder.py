import sys


if __name__ == "__main__":
    src = sys.argv[1]
    out = sys.argv[2]
    tgt = sys.argv[3]
    src_lines = [line.strip() for line in open(src, 'r', encoding="utf-8").readlines()]
    out_lines = [line.strip() for line in open(out, 'r', encoding="utf-8").readlines()]
    tgt_lines = [line.strip() for line in open(tgt, 'r', encoding="utf-8").readlines()]

    hyp_idx = []
    all_prds = []
    for line in out_lines:
        if "H-" in line[:2]:
            idx = line.split("\t")[0].replace("H-", "")
            score = float(line.split("\t")[1])

            try:
                hyp = line.split("\t")[2]
            except:
                hyp = score
                score = 1000
            hyp_idx.append((int(idx), hyp, score))

        if "P-" in line[:2]:
            all_prds.append((int(line.split('\t')[0].split('-')[1]),  line))

    hyps = [(None, None, None, None)] * len(src_lines)
    hyp_idx = sorted(hyp_idx, key=lambda item: item[0])
    all_prds = sorted(all_prds, key=lambda item: item[0])

    for x in hyp_idx:
        hyps[x[0]] = x
    for x in all_prds:
        hyps[x[0]] = hyps[x[0]] + (x[1],)
    hyp_idx = hyps

    assert len(src_lines) == len(tgt_lines) == len(hyp_idx), (len(src_lines), len(tgt_lines), len(hyp_idx), hyp_idx[-1][0])

    for s, t, hi in zip(src_lines, tgt_lines, hyp_idx):
        try:
            if hi[0] is None:
                continue
            print(f"{s}\t{hi[1]}\t{t}\t{hi[2]:.5f}\t{hi[3]}")
        except:
            continue