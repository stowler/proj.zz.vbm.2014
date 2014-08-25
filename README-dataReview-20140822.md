My notes from my August 20 call with Zvinka:

>My notes from our call today:

>1) Today we confirmed that ZZ is correctly working from req04 and req05 (non-orth) .1D files from folder/zip file meanGMvalues-ZZ.VBM.2014-201404281300

>2) I’ll generate three draft figures for ZZ’s review. Each will be a matrix of axial slices w/ red/yellow/green overlap images. One figure per predictor (1. age, 2. pa or fit, 3. interaction)

>3) There are two clusters that appear to be outside of brain (confirmed w/ ZZ). I’ll look at the individual registered GM maps for individual participants at four coordinates: CoG and peak for each of the two clusters.

>4) I’ll read and modify ZZ’s original methods section.

>5) In the interest of reproducibility I’ll move my scripts to github, eliminating any code/notes from previous analyses that won’t be reflected in this paper.


...which generated this materail for today's follow-up call:

Questionable Clusters
=======================
Two questionable clusters (x2 coordinates each) extracted from ZZ's emailed spreadsheet:

```
PA_zstat2_PA:

cluster#: 4
cluster voxel count: 1775
z-max: 4.8
z-max (voxel coords): 50, 46, 10
z-cog (voxel coords): 42.5, 52.8, 13.3

PA_zstat3_PAxAGE:

cluster#: 1
cluster voxel count: 1782
z-max: 5.44
z-max (voxel coords): 37, 60, 10
z-cog (voxel coords): 41.5, 51, 13.3
```

First I confirmed the identity of the FEAT reports that contained those clusters:
```bash
$ grep -r 1775 *
(...snip...)
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat2.html
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat2.txt
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat_webOnly/cluster_zstat2.html
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat_webOnly/cluster_zstat2.txt

$ grep -r 1782 *
(...snip...)
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat3.html
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat3.txt
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat_webOnly/cluster_zstat3.html
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat_webOnly/cluster_zstat3.txt

```

Then I visualized these two clusters in front of the standard-space GM images that were used to generate those clusters:
```bash
$ fslview \
inputs/GM_mod_merg_s2.nii.gz \
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_mask_zstat2.nii.gz-maskOrigVal4.nii.gz \
masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_mask_zstat3.nii.gz-maskOrigVal1.nii.gz
```

...and from that visualization I excerpted these screenshots of those four coordinates. The visible GM map here is for the participant who arguably had the most non-brain material surviving skull stripping. Just click the coordinates:

- PA_zstat2_PA:
   - z-max (voxel coords): [50, 46, 10](http://note.io/1q5qmgF)
   - z-cog (voxel coords): [42.5, 52.8, 13.3](http://note.io/1t0spGw)
- PA_zstat3_PAxAGE:
   - z-max (voxel coords): [37, 60, 10](http://note.io/1q5pKI6)
   - z-cog (voxel coords): [41.5, 51, 13.3](http://note.io/1q5q4q7)


My subjective characterization of the coordinate locations and the volumes on which GM is most present per visual inspection:
```
vox coord 50, 46, 10 (medial LH anterior pons / non-brain)
screenshot: http://note.io/1q5qmgF
LARGER/MORE PRESENT THAN MOST PARTICIPANTS:
(volumes counted from 0)
vol 06
vol 07
vol 10
vol 15
vol 27


vox coord 42.5, 52.8, 13.3 (medial RH anterior pons / non-brain)
screenshot: http://note.io/1t0spGw
LARGER/MORE PRESENT THAN MOST PARTICIPANTS:
(volumes counted from 0)
vol 06
vol 10
vol 11
vol 13
vol 15
vol 23


vox coord 37, 60, 10 (medial RH): 
screenshot: http://note.io/1q5pKI6
LARGER/MORE PRESENT THAN MOST PARTICIPANTS:
(volumes counted from 0)
vol 06
vol 01
vol 11
vol 23


vox coord 41.5, 51, 13.3 (medial RH anterior pons / non-brain)
screenshot: http://note.io/1q5q4q7
LARGER/MORE PRESENT THAN MOST PARTICIPANTS:
(volumes counted from 0)
vol 06
vol 10
vol 11
vol 13
vol 15
vol 23
```

DRAFT FIGURES FOR ZVINKA
==========================
These figures are designed to show where the suprathreshold clusters from the
models overlap (green), or are limited to just one model or the other (red and
yellow).

My abbreviations for the models being contrasted here (model names "zzReq04"
and "zzReq05") refer to these two models from Zvinka's original VMB request:

- zzReq04 == voxelwiseGM ~ age+fitness+age.fitness
- zzReq05 == voxelwiseGM ~ age+physicalActivity+age.physicalActivity

Draft Figure 1: suprathreshold age-related voxels compared between two models: zzReq04 and zzReq05
--------------------------------

1) Confirm that I'm using the correct zzReq04 mask per Zvinka's spreadsheet:
```bash
# For zzReq04, ZZ's spreadsheet says age (zstat1) should have a single
# suprathreshold cluster of 968 voxels with z-max of 3.73 located in the RH
# striatum.
 
# 1. Find the text file that contains the correct voxel count and z-max:
$ grep -r '968\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 3.73
# ...which returns:
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat/cluster_zstat1.txt:1     968     0.00895 2.05    3.73    34      56      52      35      67.4    44.3    0.0224       35      77      40      0.00682
 
# 2. Visualize the mask and mask's source map to confirm that the mask is the correct input for the figure:
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat
$ fslview \
filtered_func_data \
thresh_zstat1 -l "Red-Yellow" \
cluster_mask_zstat1 -l "Blue" &
# ...confirmed: cluster mask and threshold images have matching edges, and thresh_zstat1 has intensity of 3.73 at vox coord (34,56,52)
```

2) Confirm that I'm using the correct zzReq05 mask per Zvinka's spreadsheet:
```bash
# For zzReq05, ZZ's spreadsheet says age (zstat1) should have two suprathreshold clusters:
#    835 voxels with z-max of 3.92 located in LH striatum
#   1159 voxels with z-max of 3.93 located in RH striatum 

# 1. Find the text file that contains the correct voxel count and z-max:
$ grep -r  '835\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 3.92
$ grep -r '1159\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 3.93
# ...which returns:
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat1.txt:1        835     0.0236  1.63    3.92    54      59      54      55.4    69.6    44.5    0.0371       55      74      44      0.00975
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat1.txt:2        1159    0.00248 2.61    3.93    34      56      52      35.2    67      44.6    0.0235       35      77      40      0.00691

# 2. Visualize the mask and mask's source map to confirm that the mask is the correct input for the figure:
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat
$ fslview \
filtered_func_data \
thresh_zstat1 -l "Red-Yellow" \
cluster_mask_zstat1 -l "Blue" &
# ...confirmed: cluster mask and threshold images have matching edges, and the max intensities match their vox coords.
```

3) Specify those confirmed clusters in the script to create the red/yellow/green overlap mask: `createMask_redYellowGreen_zzReq04_vs_zzReq05_onAge.sh`


Draft Figure 2: suprathreshold fitness- or physicalActivity-related voxels compared between two models: zzReq04 and zzReq05
----------------------------------------------------------------------------------------------------------------------------

1) Confirm that I'm using the correct zzReq04 mask per Zvinka's spreadsheet:
```bash
# For zzReq04, ZZ's spreadsheet says fitness (zstat2) should have a single
# suprathreshold cluster of 1130 voxels with z-max of 3.29 located in the LH
# cerebellum.
 
# 1. Find the text file that contains the correct voxel count and z-max:
$ grep -r '1130\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 3.29
# ...which returns:
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat/cluster_zstat2.txt:1     1130    0.00294 2.53    3.29    71      26      25      66.7    31.3    21.5    0.54464      30      23      0.319
 
# 2. Visualize the mask and mask's source map to confirm that the mask is the correct input for the figure:
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat
$ fslview \
filtered_func_data \
thresh_zstat2 -l "Red-Yellow" \
cluster_mask_zstat2 -l "Blue" &
# ...confirmed: cluster mask and threshold images have matching edges, and max intensity matches vox coords.
```

2) Confirm that I'm using the correct zzReq05 mask per Zvinka's spreadsheet:
```bash
# For zzReq05, ZZ's spreadsheet says physical activity (zstat2) should have three within-brain suprathreshold clusters:
#    851 voxels with z-max of 3.88 located in "Bilateral frontal pole/superior frontal gyrus"
#   1141 voxels with z-max of 4.96 located in "Left central Opercular cortex/middle temporal gyrus/STG (anterior perisylvian)"
#   1704 voxels with z-max of 4.41 located in "Left medial occipital pole, fusiform, lingual gyrus/Right lingual gyrus, occipital pole"
#
# ...and one cluster (cluster #4) that should be disregarded.  It is an
# artificat of inconsistent skull-stripping mis-identifying medial non-brain
# structures as brain:
#   1775 voxels with z-max of 4.8 located outside of brain, anterior of pons

# 1. Find the text file that contains the correct voxel count and z-max:
$ grep -r  '851\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 3.8
$ grep -r '1141\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 4.96
$ grep -r '1704\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 4.41
$ grep -r '1775\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 4.8
# ...which returns:
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat2.txt:1        851     0.021   1.68    3.88    47      90      52      45.2    87.5    50.7    0.000555     54      89      54      0.000238
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat2.txt:2        1141    0.00279 2.55    4.96    76      58      41      73.6    55.4    37.1    0.000514     73      55      41      0.000267
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat2.txt:3        1704    8.43e-05        4.07    4.41    37      17      26      37      24.8    32.30.000498 16      36      22      0.000246
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat2.txt:4        1775    5.59e-05        4.25    4.8     50      46      10      42.5    52.8    13.30.000703 42      57      15      0.000242

# 2. Visualize the mask and mask's source map to confirm that the mask is the correct input for the figure:
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat
$ fslview \
filtered_func_data \
thresh_zstat2 -l "Red-Yellow" \
cluster_mask_zstat2 -l "Blue" &
# ...confirmed: cluster mask and threshold images have matching edges, and the max intensities match their vox coords.
```

3) Remove the outside-of-brain cluster:
```bash
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat
# 1. Get voxel counts for mask intensities 0 through 4:
$ fslstats cluster_mask_zstat2.nii.gz -H 5 0 4
#...which produces:
# 897158.000000
# 851.000000
# 1141.000000
# 1704.000000
# 1775.000000

# 2. Assign intensity of zero to all voxels with current intensities > 3:
$ fslmaths cluster_mask_zstat2.nii.gz -uthr 3 cluster_mask_zstat2_cluster4removed.nii.gz -odt char

# 3. Confirm new voxel counts show that cluster 4's 1775 voxels have now been added to the count for voxels with zero intensity:
$ fslstats cluster_mask_zstat2_cluster4removed.nii.gz -H 4 0 3
# ...which produces:
# 898933.000000
# 851.000000
# 1141.000000
# 1704.000000
```

3) Specify those confirmed clusters in the script to create the red/yellow/green overlap mask: `createMask_redYellowGreen_zzReq04_vs_zzReq05_onFitnessPA.sh`


Draft Figure 3: suprathreshold age X (fitness OR PA) interaction voxels compared between two models: zzReq04 and zzReq05
------------------------------------------------------------------------------------------------------------------------

1) Confirm that I'm using the correct zzReq04 mask per Zvinka's spreadsheet:
```bash
# For zzReq04, ZZ's spreadsheet says age.fitness (zstat3) should have three suprathreshold clusters:
#     1146 voxels with max-z of 4.32 located in "Left Postcentral Gyrus"
#     1318 voxels with max-z of 3.9  located in "Right Superior temporal gyrus"
#    10718 voxels with max-z of 4.06 located in "Bilateral Cerebellum"
 
# 1. Find the text file that contains the correct voxel count and z-max:
$ grep -r  '1146\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 4.32
$ grep -r  '1318\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 3.9
$ grep -r '10718\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 4.06
# ...which returns:
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat/cluster_zstat3.txt:1     1146    0.00265 2.58    4.32    76      58      53      73.2    56.2    49.9    0.12276      56      53      0.0576
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat/cluster_zstat3.txt:2     1318    0.000863        3.06    3.9     18      54      38      17.8    46.9    39.80.109    19      39      29      0.0497
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat/cluster_zstat3.txt:3     10718   1.93e-20        19.7    4.06    21      25      22      43.8    32.7    23  0.152    45      33      10      0.0517
 
# 2. Visualize the mask and mask's source map to confirm that the mask is the correct input for the figure:
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq04_age+fit+age.fit+.feat
$ fslview \
filtered_func_data \
thresh_zstat3 -l "Red-Yellow" \
cluster_mask_zstat3 -l "Blue" &
# ...confirmed: cluster mask and threshold images have matching edges, and max intensity matches vox coords.
```

2) Confirm that I'm using the correct zzReq05 mask per Zvinka's spreadsheet:
```bash
# For zzReq05, ZZ's spreadsheet says age.pa interaction (zstat3) has no
# clusters inside of the brain. It has one cluster (#1) that should be
# disregarded because it is an artificat of inconsistent skull-stripping
# mis-identifying medial non-brain structures as brain:
#   1782 voxels with z-max of 5.44 located outside of brain, anterior of pons

# 1. Find the text file that contains the correct voxel count and z-max:
$ grep -r  '1782\t' ~/ZZ.VBM.2014/masked.GM_thresh.z165/* | grep 5.44
# ...which returns:
# /Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat/cluster_zstat3.txt:1        1782    5.37e-05        4.27    5.44    37      60      10      41.5    51      13.30.000191 39      57      11      5.7e-05

# 2. Visualize the mask and mask's source map to confirm that the mask is the correct input for the figure:
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat
$ fslview \
filtered_func_data \
thresh_zstat3 -l "Red-Yellow" \
cluster_mask_zstat3 -l "Blue" &
# ...confirmed: cluster mask and threshold images have matching edges, and the max intensities match their vox coords.
```

3) Remove the outside-of-brain cluster:
```bash
$ cd ~/ZZ.VBM.2014/masked.GM_thresh.z165/zzReq05_age+pa+age.pa.feat
# 1. Get voxel counts for mask intensities 0 through 1:
$ fslstats cluster_mask_zstat3.nii.gz -H 2 0 1
#...which produces:
# 900847.000000
# 1782.000000

# 2. Assign intensity of zero to all voxels with current intensities > 0:
$ fslmaths cluster_mask_zstat3.nii.gz -uthr 0 cluster_mask_zstat3_cluster1removed.nii.gz -odt char

# 3. Confirm new voxel counts show that cluster 1's 1782 voxels have now been added to the count for voxels with zero intensity:
$ fslstats cluster_mask_zstat3_cluster1removed.nii.gz -H 1 0 0
# ...which produces:
# 902629.000000
```

3) Specify those confirmed clusters in the script to create the red/yellow/green overlap mask: `createMask_redYellowGreen_zzReq04_vs_zzReq05_onInteractionAge.FitOrPA.sh`


