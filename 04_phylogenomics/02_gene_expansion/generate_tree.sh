# step1, run iqtree using all MSA, iqtree (v1.6.12)
iqtree -nt 8 -s SpeciesTreeAlignment.fa

# Step2, use r8s to estimate divergence time [14/04/2022], calibration divergence times were 
# referred from 
# use figtree to import treefile (SpeciesTreeAlignment.fa.treefile) and export as rooted tree,
# save the rooted tree as (SpeciesTreeAlignment.fa.treefile_figtree). Then add r8s settings to
# the output tree file (SpeciesTreeAlignment.fa.treefile_figtree). The settings are as follow:
#  
#  begin r8s;
#  blformat lengths=persite nsites=49573 ultrametric=no;
#  MRCA n1 Nnuc Vvin;
#  MRCA n2 Lang Gmax;
#  MRCA n3 Ljap Mtru;
#  constrain taxon=n1 min_age=122.59 max_age=126.00;
#  constrain taxon=n2 min_age=45.42 max_age=62.84;
#  constrain taxon=n3 min_age=36.46 max_age=53.58;
#  divtime method=LF algorithm=TN;
#  showage shownamed=yes;
#  describe plot=chronogram;
#  describe plot=phylo_description;
#  describe plot=ratio_description;
#  describe plot=chrono_description;
#  end;
#
# Then run r8s with following command, the output tree with divergence time estimations will
# be in file "SpeciesTreeAlignment.fa.treefile_figtree_r8s" listed as [Tree DESCRIPTION of tree tree_1]

~/Apps/r8s1.81/src/r8s -f SpeciesTreeAlignment.fa.treefile_figtree -b 

