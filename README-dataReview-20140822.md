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
```
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
j
Then I visualized these two clusters in front of the standard-space GM images that were used to generate those clusters:
```
fslview \
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
