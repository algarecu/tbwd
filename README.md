Algorithms for page HTML similarity in the paper: 

"Movie Pirates of the Caribbean: Exploring Illegal Streaming Cyberlockers"
The 12th International AAAI Conference on Web and Social Media (ICWSM)
[pdf](https://arxiv.org/pdf/1804.02679)

Additionally, freebies are the correlation matrices/heatmaps.

# Web structure similarity calculation using three methods:
To understand the specific meaning of each method, see the paper from [Gottron],
Clustering Template Based Web Documents at ECIR conference, 2008.

## TV algorithm
- [ ] A label vector method for counting how many times each possible tag appears, which
converts the document D in a vector v(D) of fixed dimension N as the number of
possible tags is limited.

## LCTS
- [x] The Longest Common Tag sub-Sequence method uses the distance of two documents expressed based on their longest common tag subsequence. Note that we use difflib's SequenceMatcher to find any contiguous matching blocks from the two sequences and then calculate the longest sequence of tags that appear in the same order in both original sequences.

Some of the code is extracted from https://github.com/TeamHG-Memex/page-compare and adapted to our input format requirements. Crawler (crawler.py) and output to json/csv by @algarecu, P-R (score-compare-tags.py) corrected from original.

## CTSS
- [ ] The public tag sequence shingle method. Useful to overcome the computational costs of
the previous distance techniques, as this method uses shingles.

Contact:
algarecu@gmail.com
