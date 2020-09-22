# Running the `corr_ALTO.sh` script

In order to run the script directly on the command line, add your path to the script to the `$PATH` variable with the command  `export PATH="$PATH:/path/to/my/script"`.

### 1. Without the additional flags:  

* if the files are not transformed, the script transforms those files;
* if the files have been transformed, the script throws the error that those files have already been transformed:

```
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_ALTO.sh
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1845_05_14_CHA_typo ---------------- folder name
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1845_05_14_CHA_typo/1845_05_14_CHA-0008.xml ---------- file name
...
/Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1857_02_05_JA1_bpt6k9677856h_typo already transformed
```



### 2. With the flag `-d` and the folder name we intend to transform:

* When we add new (non-transformed) files, we can transform only those files, and ignore those already transformed;
* Run the code, followed by the `-d` flag and the folder name containing the new files;

```bash
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_ALTO.sh -d 1845_05_14_CHA_typo
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1845_05_14_CHA_typo
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1845_05_14_CHA_typo/1845_05_14_CHA-0008.xml
...
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1845_05_14_CHA_typo/1845_05_14_CHA-0024.xml
```



### 3. With the flag `-a`:

* Transform all files in all catalogue folders, whether they have already been transformed or not;
  * Intended to handle the situations if somebody incorrectly modifies the transformed file, so we want to make sure that all the files are transformed in a regular way defined by the `.py` and `.sh` scripts:

```
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_ALTO.sh -a
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1845_05_14_CHA_typo ------------ the first folder
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1845_05_14_CHA_typo/1845_05_14_CHA-0008.xml
...
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Manuel_synonymie_typo -------------- the last folder
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Manuel_synonymie_typo/Manuel_de_Synonymie_Latine-0001.xml
```



### 4. With the flag `-h`:

* Get the `help`/flag description:

```
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_ALTO.sh -h
########## Help ##########
Flag description:
	-a 	Transform all files in all catalogue folders, whether they have already been transformed or not;
		Intended to handle the situations if somebody incorrectly modifies the transformed file, so we want to make sure that all the files are transformed in a regular way defined by the .py and .sh scripts:

	-d 	When we add new (non-transformed) files, we can transform only those files, and ignore those already transformed;
		Run the code, followed by the -d flag and the folder name containing those files;
		For the already transformed files, the script throws the error that these files have already been transformed.

	-h 	Get help/text description of the flags.

For the detailed explanation of the script, go to https://github.com/ljpetkovic/OCR-cat/tree/master/ALTO_XML_trans.
```



### Structure of the folder 

In order to run the script successfully, it is necessary to maintain the global structure of the files/folders:

* The script needs to be located in the `doc`'s neighbouring folder (`scripts`);
* The catalogues are located in the `doc` folder;
* The script will not work if the catalogues are located elsewhere, or even if they are located in some folder not called `doc`

```
|-ALTO_XML_trans
  |-env
  	...
  |-scripts
  	|-corr_ALTO.sh 
  	|-corr_XML_dpi.py
  |-test
  	...
  |-doc 				
  	|-1845_05_14_CHA_typo
  	|-1866_04_23_GAB_typo
  	|-...
  |-Brewfile.lock.json
  |-README.md
  |-Brewfile
  |-requirements.txt
```



### Define the relative path

* After specifying the relative path:

```bash
#################### WORKING PATH ##############################

path_ALTO_XML=$(dirname `pwd`)   # define the relative path, implies that the script is in it
```

*  it can be concatenated with the `doc` folder and the new folder name we wish to transform;

```bash
# transform only the specified folder with the flag -d
if [ "${option_name_single_directory}" == "d" ]; then
	g=$path_ALTO_XML/doc/$name_single_directory ------------- relative path + /doc folder + new folder name
	suppr_transformed $g # delete already transformed files
	dpi_and_transform $g # convert mm10 to pixels
	exit 0
fi
```

* When running the script with the flag `-d`, this functionality enables the user to specify only the folder name which needs to be transformed, without typing the absolute path;



### Simplifications 

Two functions for better code readability:

* mm10 to pixels conversion

```bash
# fetch the dpi info from one catalogue image
function dpi_and_transform {
	echo Processing $1
	liste_image=( $1/*.jpg ) # create the list of images located in the catalogue folder
	image=${liste_image[0]} # locate the image in the catalogue folder
	dpi=$(convert $image -format "%x" info:) # fetch the dpi 
	for f in $1/*.xml # find the ALTO-XML files
	do 
		python3 $path_ALTO_XML/scripts/corr_XML_dpi.py $f $dpi # transform those files with respect to their resolution
		echo "Processing $f" 
	done	
}
```



* deleting the already transformed files

```bash
# delete already transformed files 
function suppr_transformed {
	liste_trans=$(find $1  -type f -name "*trans.xml") # find all the files ending with 'trans.xml'
	for f in $liste_trans
	do
		rm $f # remove those files
	done
}
```

