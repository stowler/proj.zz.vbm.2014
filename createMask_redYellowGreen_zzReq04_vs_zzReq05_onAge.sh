#!/bin/sh

# Descriptive identities of our source images:
ageFromReq04="zzReq04_age+fit+age.fit+.feat/cluster_mask_zstat1.nii.gz"
ageFromReq05="zzReq05_age+pa+age.pa.feat/cluster_mask_zstat1.nii.gz"

# In the final image inputT0 will be red, inputT1 will be yellow, and their overlap will be green.
#inputT0=$1
#inputT1=$2
inputT0="${ageFromReq04}"
inputT1="${ageFromReq05}"
echo ""
echo ""
echo "If viewing the final input image in fslview with the MGH-Cortical look-up table:"
echo "- GREEN  voxels are present in both input images,"
echo "- RED    voxels are present only in ${inputT0}, and "
echo "- YELLOW voxels are present only in ${inputT1}."
echo ""
echo ""

# Make output directory:
#outputDir=$3
outputDir="./redYellowGreen-ageAcrossModels-20140825"
rm -fr ${outputDir} 
mkdir ${outputDir}

# Pre-name output images:
onlyT0="${outputDir}/onlyT0.nii.gz"
onlyT1="${outputDir}/onlyT1.nii.gz"
onlyOverlap="${outputDir}/onlyOverlap.nii.gz"
finalCombo="${outputDir}/t0+t1+overlap_07red+27yellow+01green.nii.gz"

# first binarize the input masks just in case they have multiple values:
fslmaths ${inputT0} -bin ${outputDir}/input0_bin.nii.gz -odt char
fslmaths ${inputT1} -bin ${outputDir}/input1_bin.nii.gz -odt char

# isolate voxels only present in T0 mask and set color to 07_red:
fslmaths ${outputDir}/input0_bin.nii.gz -sub ${outputDir}/input1_bin.nii.gz -thr 0 -mul 7 ${onlyT0} -odt char

# isolate voxels only present in T1 mask and set color to 27_yellow:
fslmaths ${outputDir}/input1_bin.nii.gz -sub ${outputDir}/input0_bin.nii.gz -thr 0 -mul 27 ${onlyT1} -odt char

# isolate voxels only present in both masks and set color to 01_green:
fslmaths ${outputDir}/input0_bin.nii.gz -add ${outputDir}/input1_bin.nii.gz -thr 2 -sub 1 -thr 1 ${onlyOverlap} -odt char

# combine these outputs into a single image:
fslmaths ${onlyT0} -add ${onlyT1} -add ${onlyOverlap} ${finalCombo} -odt char

echo ${outputDir}
ls -al ${outputDir}
echo ""
echo ""

# display in fslview with the MNI brain and appropriate lesion map:
#fslview ${FSLDIR}/data/standard/MNI152_T1_1mm_brain.nii.gz /Users/stowler/Downloads/r01figure/lesionOverlap_control.nii.gz ${finalCombo} -l "MGH-Cortical" &
fslview \
${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -t 0.6 \
${finalCombo} -l "MGH-Cortical" &

