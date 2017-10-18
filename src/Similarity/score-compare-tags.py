from __future__ import division
import json
import sys


def main():
    if len(sys.argv) == 2:
        json_path = sys.argv[1]
    else:
        usage = "Usage: %s <results JSON>\n"
        sys.stderr.write(usage % sys.argv[0])
        sys.exit(1)

    with open(json_path, 'r') as json_file:
        results = json.load(json_file)

    max_f1 = 0
    max_p = 0
    max_r = 0
    max_tp = 0
    max_fp = 0
    max_fn = 0
    max_similarity_threshold = 0
    max_params = ()

    for similarity_threshold in range(10, 91, 5):
        tp, fp, fn = 0, 0, 0

        for result in results:
            predict_same = result['similarity'] > similarity_threshold
            actual_same = result['path1'][:-7] == result['path2'][:-7]

            if predict_same and actual_same:
                tp += 1
            elif predict_same and not actual_same:
                fp += 1
            elif actual_same and not predict_same:
                fn += 1

            precision = tp / (tp + fp)
            recall = tp / (tp + fn)

            pr = precision * recall
            f1 = 2 * pr / (precision + recall)

        # Keep the best values
        if f1 > max_f1:
            max_f1 = f1
            max_r = recall
            max_p = precision
            max_tp = tp
            max_fp = fp
            max_fn = fn
            max_similarity_threshold = similarity_threshold

    max_params = (max_f1, max_similarity_threshold, tp, fp, fn, max_p, max_r)
    msg = "Maximum f1 %0.3f at threshold=%d tp=%d fp=%d fn=%d prec=%0.3f rec=%0.3f"
    print(msg % max_params)

if __name__ == '__main__':
    main()
