#! /usr/bin/env python3
"""
orthofinder2cafe.py: Format orthogroup count table from orthoFinder to be used by cafe
Author: Zhipeng Qu
Data: 07/02/2022
"""

# import modules
import argparse
import re
import os

# Get arguments. Two arguments will be required:
# og: orthogroups count table from orthoFinder 
# cafe: raw table can be used as CAFE input
# cafe_large: Table used as CAFE input with filtered gene families
# cafe_small: Table used as CAFE input with gene families for lambda estimation

parser = argparse.ArgumentParser(description = 'Format orthoFinder orthogroups count to CAFE input')
parser.add_argument('og', help = 'orthogroups count table from orthoFinder')
parser.add_argument('cafe', help = 'Table used as CAFE input.')
parser.add_argument('cafe_large', help = 'Table used as CAFE input with big gene count')
parser.add_argument('cafe_small', help = 'Table used as CAFE input with big gene count filtered')


args = parser.parse_args()
og_file = args.og
cafe_file = args.cafe
cafe_large_file = args.cafe_large
cafe_small_file = args.cafe_small

# process mcl dump output
with open(og_file, 'r') as og, open(cafe_file, 'w') as cafe, open(cafe_large_file, 'w') as cafe_large, open(cafe_small_file, 'w') as cafe_small:

    for ortho in og:
        ortho = ortho.rstrip()
        ortho_genes = ortho.split('\t')
        ortho_genes.pop()
        if re.search('^Orthogroup', ortho):
            del ortho_genes[0]
            sp_header = '\t'.join(sp_id for sp_id in ortho_genes)
            cafe.write('Desp\tFamily\t' + sp_header + '\n')
            cafe_large.write('Desp\tFamily\t' + sp_header + '\n')
            cafe_small.write('Desp\tFamily\t' + sp_header + '\n')
        else:
            ortho_id = ortho_genes[0]
            ortho_ct = ortho_genes[1:]

            # write raw cafe input and get count info
            cafe.write(ortho_id + '\t' + ortho_id + '\t')
            clade_count = 0
            size_filter = True
            for sp_ct in ortho_ct:
                cafe.write(str(sp_ct) + '\t')
                if int(sp_ct) > 0: # caution: sp_ct is not int!! 
                    clade_count += 1
                if int(sp_ct) >= 100:
                    size_filter = False
            cafe.write("\n")
            print(str(clade_count) + '\t' + str(size_filter) + '\n')

            # filter cafe input based on clade presence and gene numbers
            if clade_count >= 2 and size_filter:
                cafe_small.write(ortho_id + '\t' + ortho_id + '\t')
                for sp_ct in ortho_ct:
                    cafe_small.write(str(sp_ct) + '\t')
                cafe_small.write('\n')
            else:
                cafe_large.write(ortho_id + '\t' + ortho_id + '\t')
                for sp_ct in ortho_ct:
                    cafe_large.write(str(sp_ct) + '\t')
                cafe_large.write('\n')
