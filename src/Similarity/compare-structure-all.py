import difflib
import glob
import json
import lxml.html
import sys
import csv
import os

from pprint import pprint


def main():
    if len(sys.argv) == 2:
        data_dir = sys.argv[1]
    else:
        usage = "Usage: %s <data dir>\n"
        sys.stderr.write(usage % sys.argv[0])
        sys.exit(1)

    data_dir = data_dir.rstrip('/') + '/'
    html_paths = glob.glob(data_dir + 'html/*.html')
    diff = difflib.SequenceMatcher()

    total = len(html_paths)
    results = list()
    results_json = list()

    for i, path1 in enumerate(html_paths):
        print('%s (%d/%d)' % (path1, i+1, total))

        diff.set_seq1(get_tags(lxml.html.parse(path1)))

        for path2 in html_paths:
            diff.set_seq2(get_tags(lxml.html.parse(path2)))
            similarity = diff.ratio() * 100

            # Paths for .csv
            head1, tail1 = os.path.split(path1)
            head2, tail2 = os.path.split(path2)

            final1 = str(tail1).rstrip('.html')
            final2 = str(tail2).rstrip('.html')

            results.append([final1,final2,similarity])

            # Paths for .json
            results_json.append({
                'path1': final1,
                'path2': final2,
                'similarity': similarity
            })

    with open('datasets/similarity.csv', 'wb') as f:
        w = csv.writer(f)
        w.writerow(['SS1', 'SS2', 'Similarity'])
        for data in results:
            w.writerow(data)

    with open('datasets/similarity.json', 'wb') as json_path:
        json.dump(results_json, json_path, indent=4)

def get_tags(doc):
    tags = list()

    for el in doc.getroot().iter():
        if isinstance(el, lxml.html.HtmlElement):
            tags.append(el.tag)
        elif isinstance(el, lxml.html.HtmlComment):
            tags.append('comment')
        else:
            raise ValueError('Don\'t know what to do with element: %s' % el)

    return tags


if __name__ == '__main__':
    main()
