#!/bin/bash

################################################################################
#            TRANSFORMING ALTO-XML FILES EXPORTED FROM TRANSKRIBUS			   
#		  TO ALTO-XML FILES TO BE INJECTED INTO GROBID DICTIONARIES           				                                   
                                             								   
# author: Ljudmila Petkovic  

# date: 11/06/2020                                                              	  
      										       				   
# Changelog: 

# Added:
# - two functions: one for the mm10 to pixels conversion
#				   the other one for deleting the already transformed files  
# - the option -d which requires only the catalogue folder name in order to transform only that folder

# Removed:
# - the option -p which requires to specify the absolute path to the new catalogue folder
                                             						   
                                                                              
################################################################################
################################################################################
################################################################################
	

############### OPTION FLAGS  ###########################

# -a, -h, -d
while getopts "ahd:" opt; do 
	case ${opt} in
	a ) option_total=${opt}
	  ;;
	h ) option_help=${opt}; echo '########## Help ##########'
	  ;;	
	d ) option_name_single_directory=${opt}; name_single_directory=${OPTARG}
	  ;;	
	\? ) echo 'Invalid flag, use -a to transform all files'; exit 1 # if the user specifies any other argument that is not -a, -h or -d, throw error
	  ;;
	esac
done

################### FUNCTIONS  ##########################


#  fetch the dpi info from one catalogue image and transform the whole folder
function transform {
	echo Processing $1
	liste_image=( $1/*.jpg ) # create the list of images located in the catalogue folder
	image=${liste_image[0]} # locate the image in the catalogue folder
	#dpi=$(convert $image -format "%x" info:) # fetch the dpi 
	for f in $1/*.xml # find the ALTO-XML files
	do 
		python3 $path_ALTO_XML/scripts/corr_trans_ALTO_sans_typo.py $f #$dpi # transform those files with respect to their resolution
		echo "Processing $f" 
	done	
}

# delete already transformed files 
function suppr_transformed {
	liste_trans=$(find $1  -type f -name "*trans.xml") # find all the files ending with 'trans.xml'
	for f in $liste_trans
	do
		rm $f # remove those files
	done
}



#################### WORKING PATH ##############################

path_ALTO_XML=$(dirname `pwd`)   # defines the relative path, implies that the script is in the 'doc_sans_typo''s neighbouring folder ('scripts')
	 


################. MAIN.  ######################################


if [ "${option_help}" == "h" ]; then
	echo "Flag description:
	-a 	Transform all files in all catalogue folders, whether they have already been transformed or not;
		Intended to handle the situations if somebody incorrectly modifies the transformed file, so we want to make sure that all the files are transformed in a regular way defined by the .py and .sh scripts:

	-d 	When we add new (non-transformed) files, we can transform only those files, and ignore those already transformed;
		Run the code, followed by the -d flag and the folder name containing those files;
		For the already transformed files, the script throws the error that these files have already been transformed.

	-h 	Get help/text description of the flags.

For the detailed explanation of the script, go to https://github.com/ljpetkovic/OCR-cat/tree/master/ALTO_XML_trans.

			"
	exit 0
fi

# transform only the specified folder with the flag -d
if [ "${option_name_single_directory}" == "d" ]; then
	g=$path_ALTO_XML/doc_sans_typo/$name_single_directory
	suppr_transformed $g # delete already transformed files
	transform $g # convert mm10 to pixels
	exit 0
fi


# transform all files (the transformed and the new ones) with the flag -a
if [ "${option_total}" == "a" ]; then 

	for g in $path_ALTO_XML/doc_sans_typo/* # locate catalogues
	do  
		suppr_transformed $g # delete already transformed files
		transform $g # convert mm10 to pixels
	done	
else
	for g in $path_ALTO_XML/doc_sans_typo/*  
	do
		if compgen -G "$g/*_trans.xml" > /dev/null; then # check whether the file ending with '_trans.xml' already exists
        	echo $g "already transformed" # print message that the file is already transformed
		else
			transform $g
		fi
	done
fi  

