# Web structure similarity calculation using three methods:
To understand the specific meaning of each method, see the paper from [Gottron],
Clustering Template Based Web Documents at ECIR conference, 2008.

## TV algorithm:
A label vector method for counting how many times each possible tag appears, which
converts the document D in a vector v(D) of fixed dimension N as the number of
possible tags is limited.

## LCTS
The longest public tag sub-sequence method uses the distance of two documents
expressed based on their longest common tag subsequence.

## CTSS
The public tag sequence shingle method. Useful to overcome the computational costs of
the previous distance techniques, as this method uses shingles.
