#!/bin/bash
#
# LOCATION:     github.com/stowler/proj.zz.vbm.2014
# USAGE:        see the fxnPrintUsage() function below 
#
# CREATED:      ???????? by stowler@gmail.com
# LAST UPDATED: 20140501 by stowler@gmail.com
# CHANGELOG:	See the github repo above.
#
# DESCRIPTION:
# This script outputs anatomical localizations for suprathreshold VBM clusters.
# 
# SYSTEM REQUIREMENTS:
# - awk must be installed for fxnCalc
# - FSL
# - AFNI
#
# INPUT FILES AND PERMISSIONS FOR OUTPUT:
# The inputs to this script are one or more feat directories containing cluster mask files. 
# Output is created in the script's temporary directory, and can be manually copied to 
# another writable location.
#
# OTHER ASSUMPTIONS:
# None worth mentioning at the moment.
#
#
# NOTES TO HELP YOU READ AND EDIT THIS SCRIPT:
# 
# This script contains a few first-level sections, each starting with one of these headings:
# ------------------------- START: define functions ------------------------- #
# ------------------------- START: define basic script constants ------------------------- #
# ------------------------- START: greet user/logs ------------------------- #
# ------------------------- START: body of script ------------------------- #
# ------------------------- START: restore environment and say bye to user/logs ------------------------- #
#
# These are searchable keywords that mark areas of code:
#   EDITME :  areas that should be edited to meet specific needs of system/script/experiment/whatever
#   TBD :     areas where I have work to do or decisions to make
#   DEBUG :   areas that I only intend to uncomment and execute duing debugging
#
#



# ------------------------- START: define functions ------------------------- #



fxnPrintUsage() {
   # EDITME: customize for each script:
   #echo >&2 "$0 - a script to do something. Example of a usage note:"
   #echo >&2 "Usage: scriptname [-r|-n] -v file {file2 ...}"
   #echo >&2 "  -r   print data rows only (no column names)"
   #echo >&2 "  -n   pring column names ONLY (no data rows)"
   #echo >&2 "  -v   be verbose"
   echo >&2 "${scriptName} - a script to provide anatomical localizations of suprathreshold VBM clusters."
   echo >&2 "Usage: ${scriptName} "
   echo >&2 "(no command-line arguments after script name: everything is defined in the script)"
}


fxnProcessInvocation() {
   # always: check for number of arguments, even if expecting zero:
   if [ "${scriptArgsCount}" -ne "0" ] ; then
      echo ""
      echo "ERROR: this script isn't expecting any arguments. It was called with $scriptArgsCount arguments."
      echo ""
      fxnPrintUsage
      echo ""
      exit 1
   fi
   
}


fxnSelftestBasic() {
   # Tests the basic administrative internal funcions and variables of the
   # template on which this script is based. For manual auditing, valid output
   # may appear as comment text at the bottom of this script (TBD). This
   # self-test can be used to confirm that the basic functions of the script
   # are working on a particular system, or that they haven't been broken by
   # recent edits.

   echo ""
   echo "---------------------------------------------------"
   echo "Running internal function 'fxnSelftestBasic' :"
   echo "---------------------------------------------------"
   echo ""

   # expose the basic constants defined in the script:
   echo "Some basic constants have been defined in this script:"
   #echo "Their names are listed in variable \${listOfBasicConstants} : "
   #echo "${listOfBasicConstants}"
   #echo ""
   #echo "...and here are their values:"
   echo ""
   for scriptConstantName in ${listOfBasicConstants}; do
      echo "\$${scriptConstantName} == ${!scriptConstantName}"
   done

   echo ""
   echo ""
   echo "This is the usage note the user should see if asking for help or incorrectly calling the script:"
   echo "(produced by script's internal fxn 'fxnPrintUsage')"
   fxnPrintUsage
   

   # test internal function fxnSetTempDir:
   echo ""
   echo ""
   echo "Creating temporary directory by calling internal funciton 'fxnSetTempDir'..."
   fxnSetTempDir
   deleteTempDirAtEndOfScript=0
   if [ -n "${tempDir}" ] && [ -d "${tempDir}" ] && [ -w "${tempDir}" ]; then
	echo "...success: confirmed that you have file sysem write permissions for \${tempDir}:"
	ls -ald ${tempDir}
   else
	echo "WARNING: was not able to create a writable temporary directory."
   fi


   # Strip out all comments that are marked as training. This will create a
   # slimmer, more readable version of the script :
   trainingMarker='###'       # trainingMarker must be sed-friendly. See below:
   cp ${scriptPath}/${scriptName} ${tempDir}/script-orig.sh
   sed "/^${trainingMarker}/ d" ${tempDir}/script-orig.sh > ${tempDir}/script-withoutTrainingComments.sh
   linecountOrig="`wc -l ${tempDir}/script-orig.sh | awk '{print $1}'`"
   linecountSkinny="`wc -l ${tempDir}/script-withoutTrainingComments.sh | awk '{print $1}'`"
   echo ""
   echo ""
   echo "This script has ${linecountOrig} lines, and the version without training comments has ${linecountSkinny} lines:"
   ls -l ${tempDir}/*
}


fxnSelftestFull() {
  # Tests the full function of the script. Begins by calling fxnSelftestBaic() , and then...
  # <EDITME: add description of tests and validating data>
  fxnSelftestBasic
}


fxnCalc() {
   # fxnCalc is also something I include in my .bash_profile:
   # e.g., calc(){ awk "BEGIN{ print $* }" ;}
   # use quotes if parens are included in the function call:
   # e.g., calc "((3+(2^3)) * 34^2 / 9)-75.89"
   awk "BEGIN{ print $* }" ;
}


fxnSetTempDir() {
   # Attempt to create a temporary directory ${tempDir} .  It will be a child
   # of directory ${tempParent}, which may be set prior to calling this fxn, or
   # will be set to something sensible by this function.
   #
   # NB: ${tempParent} might need to change on a per-system, per-script, or per-experiment basis.
   #    If tempParent or tempDir needs to include identifying information from the script,
   #    remember to assign values before calling fxnSetTempDir !
   #    e.g., tempParent=${participantDirectory}/manyTempProcessingDirsForThisParticipant && fxnSetTempDir()

   # Is $tempParent already defined as a writable directory? If not, try to define a reasonable one:
   tempParentPrevouslySetToWritableDir=''
   hostname=`hostname -s`
   kernel=`uname -s`
   if [ -n "${tempParent}" ] && [ -d "${tempParent}" ] && [ -w "${tempParent}" ]; then
      tempParentPreviouslySetToWritableDir=1
   elif [ $hostname = "stowler-mba" ]; then
      tempParent="/Users/stowler/temp"
   elif [ $kernel = "Linux" ] && [ -d /tmp ] && [ -w /tmp ]; then
      tempParent="/tmp"
   elif [ $kernel = "Darwin" ] && [ -d /tmp ] && [ -w /tmp ]; then
      tempParent="/tmp"
   else
      echo "fxnSetTempDir cannot find a suitable parent directory in which to \
	    create a new temporary directory. Edit script's $tempParent variable. Exiting."
      exit 1
   fi
   # echo "DEBUG"
   # echo "DEBUG: \${tempParent} is ${tempParent}"
   # echo "DEBUG:"

   # Now that writable ${tempParent} has been confirmed, create ${tempDir}:
   # e.g., tempDir="${tempParent}/${startDateTime}-from_${scriptName}.${scriptPID}"
   tempDir="${tempParent}/${startDateTime}-tempDirFrom_${scriptName}.${scriptPID}.d"
   mkdir ${tempDir}
   if [ $? -ne 0 ] ; then
      echo ""
      echo "ERROR: fxnSetTempDir was unable to create temporary directory ${tempDir}."
      echo 'You may want to confirm the location and permissions of ${tempParent}, which is understood as:'
      echo "${tempParent}"
      echo ""
      echo "Exiting."
      echo ""
      exit 1
   fi
}


fxnSetSomeFancyConstants() {
	# project-specific constants (EDITME)
	# TBD: at the moment this hard-coding means these paths must be changed before executing on another machine

	# 4D GM volume used in VBM analysis: 
	sourceGM4D="/Users/stowler/ZZ.VBM.2014/inputs/GM_mod_merg_s2.nii.gz"

	# a priori 1mm MNI 152 block masks to separate left and right hemispheres:
	blockLH="/Users/stowler/ZZ.VBM.2014/inputs/MNI152_T1_1mm_blockMask_LH.nii.gz"
	blockRH="/Users/stowler/ZZ.VBM.2014/inputs/MNI152_T1_1mm_blockMask_RH.nii.gz"

	# identity matrix to be used in upsampling from 2mm to 1mm:
	idMatrix="/Users/stowler/ZZ.VBM.2014/inputs/id.mat"

	# parent directory of FEAT VBM models whose cluster masks we'll be localizing:
	sourceDirModels="/Users/stowler/ZZ.VBM.2014/masked.GM_thresh.z165"

	# list of models represented as their existing subdirectory names:
	modelList="zzReq01_age+fit+exec+age.fit+exec.fit+.feat zzReq02_age+pa+exec+age.pa+exec.pa+.feat zzReq03_age+fitness+pa+age.fit+age.pa+.feat zzReq04_age+fit+age.fit+.feat zzReq05_age+pa+age.pa.feat"

}

# ------------------------- FINISHED: define functions ------------------------- #


# ------------------------- START: define basic script constants ------------------------- #


# NB: these are per-script constants, so it's safer to define them here rather
# than in an internal function.

# initialize array:
listOfBasicConstants=''	

scriptName="`basename $0`"
listOfBasicConstants="${listOfBasicConstants} scriptName"

# getting scriptPath is non-trivial, and this is adapted from
# http://stackoverflow.com/a/12197518 :
pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
while([ -h "${SCRIPT_PATH}" ]); do
    cd "`dirname "${SCRIPT_PATH}"`"
    SCRIPT_PATH="$(readlink "`basename "${SCRIPT_PATH}"`")";
done
cd "`dirname "${SCRIPT_PATH}"`" > /dev/null
scriptPath="`pwd`";
popd  > /dev/null
listOfBasicConstants="${listOfBasicConstants} scriptPath"
# ...or there is this less robust 1-line solution:
# scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

scriptPWD="`pwd`"
listOfBasicConstants="${listOfBasicConstants} scriptPWD"

scriptHostname="`hostname`"
listOfBasicConstants="${listOfBasicConstants} scriptHostname"

scriptUnameOS="`uname -s`"
listOfBasicConstants="${listOfBasicConstants} scriptUnameOS"

scriptUnameLong="`uname -a`"
listOfBasicConstants="${listOfBasicConstants} scriptUnameLong"

scriptPID="$$"
listOfBasicConstants="${listOfBasicConstants} scriptPID"

scriptArgsCount=$#
listOfBasicConstants="${listOfBasicConstants} scriptArgsCount"

scriptUser="`whoami`"
listOfBasicConstants="${listOfBasicConstants} scriptUser"

startDate="`date +%Y%m%d`"
listOfBasicConstants="${listOfBasicConstants} startDate"

startDateTime="`date +%Y%m%d%H%M%S`"
listOfBasicConstants="${listOfBasicConstants} startDateTime"

deleteTempDirAtEndOfScript=0
listOfBasicConstants="${listOfBasicConstants} deleteTempDirAtEndOfScript"

# echo "DEBUG: \${listOfBasicConstants} is:"
# echo "${listOfBasicConstants}"



# ------------------------- FINISH: define basic script constants ------------------------- #


# ------------------------- START: greet user/logs ------------------------- #

clear 

echo ""
echo ""
echo "#################################################################"
echo "START: \"${scriptName}\""
      date
echo "#################################################################"
echo ""
echo ""
# ------------------------- FINISHED: greet user/logs------------------------- #


# ------------------------- START: body of script ------------------------- #



# use script's internal function to create ${tempDir} :
fxnSetTempDir                 
deleteTempDirAtEndOfScript=0  # <- set to 1 to delete ${tempDir} or 0 to leave it. See end of script.


# confirm that the script was launched correctly:
fxnProcessInvocation


# set project-specific constants:
fxnSetSomeFancyConstants

echo ""
echo "Each VBM model has a directory of results in which there are masks that we are"
echo "going to localize. The directories are named for the models:"
echo ""
for model in ${modelList}; do
	ls -ald ${sourceDirModels}/${model}
done


# loop start: perform cluster localization for clusters within each model:
for model in ${modelList}; do

	echo ""
	echo "================================================================="
	echo " MODEL: ${model}"
	echo "================================================================="
	echo -n "started: "
	      date
	echo "================================================================="
	echo ""

	# for access to input data:
	cd ${sourceDirModels}/${model}
	
	# this is where we'll write output:
	mkdir ${tempDir}/${model}

	# loop start: each file containing cluster masks will be processed in its own iteration of this loop:
	for clusterMask in cluster_mask_zstat?.nii.gz; do
		cd ${sourceDirModels}/${model}
		echo ""
		echo "================================================================="
		echo " MODEL: ${model}"
		echo "     CLUSTER MASK: ${clusterMask}"
		echo "================================================================="
		echo -n "started: "
		      date
		echo "================================================================="
		echo ""
		echo "Cluster mask:"
		ls -l ${clusterMask}
		fslinfo ${clusterMask}
		#rm -f ${sourceDirModels}/meanGM-${model}++++${clusterMask}.1D
		#3dROIstats -mask ${clusterMask} ${gm4D} > ${sourceDirModels}/meanGM-${model}++++${clusterMask}.1D

	
		# (TBD below: generalize this by wrapping in a test: does input cluster match 1mm MNI152 geometry already?)
		#
		echo ""
		echo "Converting from 2mm MNI152 resolution (odd number of sagittal"
		echo "slices) to 1mm MNI 152 resolution (even number of sagittal"
		echo "slices) so that the volume can be split into left and right halves"
		echo "of equal numbers of saggital slices:"
		rm -f ${clusterMask}-1mm.nii.gz
		flirt \
		-interp nearestneighbour \
		-datatype char \
		-in ${clusterMask} \
		-ref $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
		-init ${idMatrix} \
		-applyisoxfm 1 \
		-out ${tempDir}/${model}/${clusterMask}-1mm 
		echo "...done:"
		ls -altr ${tempDir}/${model}/${clusterMask}-1mm.nii.gz
		#fslinfo ${clusterMask}-1mm.nii.gz
		#3dinfo ${clusterMask}-1mm.nii.gz
		
		# provide some evidence that upsampling didn't destroy the input mask:
		# (TBD maybe add more evidence, like histogram/mean/sd/etc)
		echo ""
		echo "These are the unique non-zero intensities in the upsampled mask per 3dmaskdump:"
		maskValues=`3dmaskdump -noijk -nozero -quiet ${tempDir}/${model}/${clusterMask}-1mm.nii.gz | sort | uniq`
		echo "${maskValues}"
		echo ""
		echo "...they should be identical to the unique non-zero intensities in original mask per 3dmaskdump:"
		maskValuesLowRes=`3dmaskdump -noijk -nozero -quiet ${clusterMask} | sort | uniq`
		echo "${maskValuesLowRes}"
		echo ""



		# Create one new volume per mask value per hemisphere, and run atlasquery against each of those volumes:
		for maskValue in ${maskValues}; do
			cd ${sourceDirModels}/${model}
			echo ""
			echo "================================================================="
			echo " MODEL: ${model}"
			echo "     CLUSTER MASK: ${clusterMask}"
			echo "          MASK VALUE: ${maskValue}"
			echo "================================================================="
			echo -n "started: "
			      date
			echo "================================================================="
			echo ""

			echo "Because FSL's atlasquery doesn't allow user to point"
			echo "at a specific mask intensity of a multi-intensity"
			echo "mask, we must first isolate each mask value into its own"
			echo "file. While doing this we also split the mask into"
			echo "left and right hemispheres because many of"
			echo "atlasquery's a priori regions don't have separate left"
			echo "and right hemisphere compartments:"

			rm -f ${tempDir}/${model}/${clusterMask}-1mm-?H-maskOrigValue${maskValue}*
			fslmaths ${tempDir}/${model}/${clusterMask}-1mm -thr ${maskValue} -uthr ${maskValue} -mul ${blockLH} ${tempDir}/${model}/${clusterMask}-1mm-LH-maskOrigValue${maskValue} -odt char
			fslmaths ${tempDir}/${model}/${clusterMask}-1mm -thr ${maskValue} -uthr ${maskValue} -mul ${blockRH} ${tempDir}/${model}/${clusterMask}-1mm-RH-maskOrigValue${maskValue} -odt char
			#ls -al ${tempDir}/${model}/${clusterMask}-1mm-?H-maskOrigValue${maskValue}*

			# now that we have created upsampled copies of input images, it's convenient to cd to the output dir:
			cd ${tempDir}/${model}
			echo ""
			ls -al ${clusterMask}-1mm-?H-maskOrigValue${maskValue}*

			echo ""
			echo "CREATING LISTS of atlas regions that overlap with ${clusterMask}-1mm-?H-maskOrigValue${maskValue}:"

			for hem in LH RH; do
				echo ""
				echo "================================================================="
				echo " MODEL: ${model}"
				echo "     CLUSTER MASK: ${clusterMask}"
				echo "          MASK VALUE: ${maskValue}"
				echo "                HEMISPHERE: ${hem}"
				echo "================================================================="
				echo -n "started: "
					date
				echo "================================================================="
				echo ""

				echo "~~~~~~~~~~~~~~~ START RESULTS: mask value ${maskValue}, hemisphere ${hem} ~~~~~~~~~~~~~~~"
				atlas=hoCortical
				atlasquery -a "Harvard-Oxford Cortical Structural Atlas" -m ${clusterMask}-1mm-${hem}-maskOrigValue${maskValue} > ${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				# create a version of the text file that is prepended with colon-separated identifiers for easy importing into spreadsheets/SPSS/R:
				# (colon-separated because that's the convention that FSL atlasquery uses already)
				rm -f colonSeparatedValues-${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				rowIdentifiersForPrepend="${model}:${clusterMask}:${maskValue}:${hem}:${atlas}"
				while read -r line; do
					echo "${rowIdentifiersForPrepend}:${line}"
				done <${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt > colonSeparatedValues-${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt


				atlas=hoSubcortical
				atlasquery -a "Harvard-Oxford Subcortical Structural Atlas" -m ${clusterMask}-1mm-${hem}-maskOrigValue${maskValue} > ${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				# create a version of the text file that is prepended with colon-separated identifiers for easy importing into spreadsheets/SPSS/R:
				# (colon-separated because that's the convention that FSL atlasquery uses already)
				rm -f colonSeparatedValues-${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				rowIdentifiersForPrepend="${model}:${clusterMask}:${maskValue}:${hem}:${atlas}"
				while read -r line; do
					echo "${rowIdentifiersForPrepend}:${line}"
				done <${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt > colonSeparatedValues-${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt

				echo ""	
				echo "DEBUG: Confirm that we have the same number of lines in the prefixed output as the original output:"	
				ls -al hoCortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				wc -l  hoCortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				ls -al colonSeparatedValues-hoCortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				wc -l  colonSeparatedValues-hoCortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				ls -al hoSubcortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				wc -l  hoSubcortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				ls -al colonSeparatedValues-hoSubcortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				wc -l  colonSeparatedValues-hoSubcortical-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt
				echo ""

				# generate copy-and-paste commands for manually auditing the most granular version of the output:
				for atlas in hoCortical hoSubcortical; do
					echo ""
					echo "================================================================="
					echo " MODEL: ${model}"
					echo "     CLUSTER MASK: ${clusterMask}"
					echo "          MASK VALUE: ${maskValue}"
					echo "                HEMISPHERE: ${hem}"
					echo "                       ATLAS: ${atlas}"
					echo "================================================================="
					echo -n "started: "
						date
					echo "================================================================="
					echo ""
					echo "To manually audit overlap list for HEMISPHERE ${hem} in ATLAS ${atlas}"
					echo "just copy-and-paste these commands:"
					echo ""
					echo "      cat ${tempDir}/${model}/${atlas}-${model}+++${clusterMask}+++${hem}+++cluster${maskValue}.txt"
					echo ""
					echo "      sourceDirModels=${sourceDirModels}"
					echo ""
					echo "      outDirModels=${tempDir}"
					echo ""
					echo "      fslview -m ortho,lightbox \\"
					echo "         \${FSLDIR}/data/standard/MNI152_T1_1mm.nii.gz -t .4 \\"
					echo "         \${outDirModels}/${model}/${clusterMask}-1mm-${hem}-maskOrigValue${maskValue} \\"
					echo "         \${FSLDIR}/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr25-1mm.nii.gz -l MGH-Cortical -t .1 &"
					echo ""
					echo "      fslview -m ortho,lightbox \\"
					echo "         \${FSLDIR}/data/standard/MNI152_T1_2mm.nii.gz -t .4 \\"
					echo "         \${sourceDirModels}/${model}/${clusterMask} -l \"Random-Rainbow\" &"
					echo ""
				done # <- end of loop: $atlas
				echo "~~~~~~~~~~~~~~~ END RESULTS: mask value ${maskValue}, hemisphere ${hem} ~~~~~~~~~~~~~~~"
			done # <- end of loop: $hem
		done # <- end of loop: $maskValue
	done # <- end of loop: $clusterMask
done # <- end of loop: $model


# ------------------------- FINISHED: body of script ------------------------- #


# ------------------------- START: restore environment and say bye to user/logs ------------------------- #
#
# Output some final status info to the user/log and clean-up any resources.

# If a ${tempDir} was defined, remind the user about it and (optionally) delete it:
if [ -n "${tempDir}" ]; then 
	#tempDirSize=`du -sh ${tempDir} | cut -d ' ' -f 1`
	tempDirSize=`du -sh ${tempDir} | cut -f 1`
	tempDirFileCount=`find ${tempDir} | wc -l`
	echo ""
	echo ""
	echo "Script complete. This script's temporary directory is:"
	ls -ld ${tempDir}
	echo "...and it contains: ${tempDirFileCount} files and folders taking up total disk space of ${tempDirSize}"
	echo ""
	# if previously indicated, delete $tempDir
	if [ ${deleteTempDirAtEndOfScript} = "1" ]; then
		echo -n "...which I am now removing..."
		rm -fr ${tempDir}
		echo "done." 
      echo "Proof of removal per \"ls -ld \${tempDir}\" :"
		ls -ld ${tempDir}
	fi
	echo ""
fi

# Did we change any environmental variables? It would be polite to set them to their original values:
# export FSLOUTPUTTYPE=${FSLOUTPUTTYPEorig}

echo ""
echo ""
echo "#################################################################"
echo "FINISHED: \"${scriptName}\""
      date
echo "#################################################################"
echo ""
echo ""
# ------------------------- FINISHED: restore environment and say bye to user/logs ------------------------- #

