# Transformation and evaluation of the ALTO-XML files 

The core idea of redesigning the ALTO-XML files in order to be injected into the GROBID-dictionaries is described [here](https://github.com/ljpetkovic/OCR-cat/blob/master/eval_ALTO/README.md).<br>

Here we present the updated version of the code, which includes:

* correcting the **"full" malformed tags** (containing either `b` or `i`);
* transformation of **all the files** in all the catalogue folders;
* automatic mm10 to pixels conversion with respect to **different image resolutions** for each catalogue.



### Preliminaries

You will need to have **Python 3** and **pip/pip3** installed. <br>

To create your Python virtual environment (optional):

1. Install the `virtualenv` PyPI library: <br>

   `pip3 install virtualenv` <br>

2. Move to the project directory:<br>

   `cd path/to/my/project/directory`

3. Set up your Python virtual environment in the project directory (this will create the `env` sub-directory):<br>

   `virtualenv -p python3 env`<br> (you can use any name instead of `env`)

4. Activate the environment:<br>

   `source env/bin/activate`<br>

5. Install libraries and dependencies:

   `pip3 install -r requirements.txt`<br>

   In order to install the `imagemagick` library on macOS/Linux, it is necessary to install [Homebrew](https://brew.sh) (The Missing Package Manager for macOS/Linux) beforehand .<br>
   
   After you installed `homebrew`, type:
   
   `brew bundle`
   
   This command installs the `imagemagick` library on macOS/Linux (indicated in the `Brewfile`), and it is mandatory for the mm10 to pixels conversion.<br>

*NB*:

* To deactivate the virtual environment:<br>

  `deactivate`

* Allow user to read and execute scripts:<br>

  `chmod 755 corr_trans_ALTO.sh`



#### File/folder structure

In order to run the script successfully, it is necessary to maintain the global structure of the files/folders:

* The script needs to be located in the `doc`'s neighbouring folder (`scripts`);
* The catalogues are located in the `doc` folder;
* The script will not work if the catalogues are located elsewhere, or even if they are located in some folder not called `doc`

```
|-ALTO_XML_trans
  |-env
  	...
  |-scripts
  	|-corr_trans_ALTO.sh 
  	|-corr_trans_ALTO.py
  |-test
  	...
  |-doc 				
  	|-1845_05_14_CHA_typo
  	|-Cat_Inde_1913
  	|-...
  |-Brewfile.lock.json
  |-README.md
  |-Brewfile
  |-requirements.txt
```



### New features

#### Correcting the "full" malformed tags (containing either `b` or `i`)

e.g. `&lt;b&gt;84&lt;/b&gt;` (`<b>84</b>`) instead of `84&lt;/b` (`84</b`)



#### Iterative transformation of all files in all the catalogues:

```bash
for f in $1/*.xml # find the ALTO-XML files
do 
		python3 $path_ALTO_XML/scripts/corr_trans_ALTO.py $f $dpi # transform those files with respect to their resolution
		echo "Processing $f" 
done
```

* The file variable `$f` represents the first command-line argument when running the `corr_trans_ALTO.py` script from the `corr_trans_ALTO.sh` script;



#### mm10 to pixels conversion 

* In order to convert correctly mm10 to pixels for each catalogue (since most of them differed in the image resolution, that is, in their dpi value), we placed one sample image of each catalogue in its corresponding folder with the .xml files, in order to fetch the dpi information;

* We converted mm10 to pixels with the following formula in the `corr_trans_ALTO.py` script: 

  ```python
  pixels = str(int(mm10) * dpi / 254)
  ```

* In the `corr_trans_ALTO.sh` script, the `imagemagick` library with the following command was used in order to access the dpi values:

  ```bash
  dpi=$(convert $image -format "%x" info:) # fetch the dpi 
  ```

   (the `"%x"` indicates the horizontal resolution);

* The dpi variable `$dpi` represents the second command-line argument when running the `corr_trans_ALTO.py` script from the `corr_trans_ALTO.sh` script;<br>

* The mm10 to pixels function enhances the code readability:

  ```bash
  # fetch the dpi info from one catalogue image
  function dpi_and_transform {
  	echo Processing $1
  	liste_image=( $1/*.jpg ) # create the list of images located in the catalogue folder
  	image=${liste_image[0]} # locate the image in the catalogue folder
  	dpi=$(convert $image -format "%x" info:) # fetch the dpi 
  	for f in $1/*.xml # find the ALTO-XML files
  	do 
  		python3 $path_ALTO_XML/scripts/corr_trans_ALTO.py $f $dpi # transform those files with respect to their resolution
  		echo "Processing $f" 
  	done	
  }
  ```

  

#### Defining the relative path

* After specifying the relative path:

```bash
#################### WORKING PATH ##############################

path_ALTO_XML=$(dirname `pwd`)   # define the relative path, implying that the script is in in the 'doc''s neighbouring folder ('scripts')
```

*  it can be concatenated with the `doc` folder and the new folder name we wish to transform;

```bash
# transform only the specified folder with the flag -d
if [ "${option_name_single_directory}" == "d" ]; then
	g=$path_ALTO_XML/doc/$name_single_directory ------------- relative path + /doc folder + new folder name
	suppr_transformed $g # delete already transformed files
	dpi_and_transform $g # transform files and convert mm10 to pixels
	exit 0
fi
```

* When running the script with the flag `-d`, this functionality enables the user to specify only the folder name which needs to be transformed, without typing the absolute path;

  

#### Deleting the already transformed files 

* When run with the `-d` or `-a` flag, the function `suppr_transformed` deletes the already transformed files, in order to be retransform the original files later:

```bash
# delete the already transformed files 
function suppr_transformed {
	liste_trans=$(find $1  -type f -name "*trans.xml") # find all the files ending with 'trans.xml'
	for f in $liste_trans
	do
		rm $f # remove those files
	done
}
```



#### Advantages of integrating the `lxml` library into the code

- no need to register the namespace (unlike with the previously used `etree` command `ET.register_namespace`);

- preserving the `xmlns:page="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"` namespace from the original ALTO-XML files;<br>

  

#### Extending the `<Styles>` tag content:

```xml
<Styles>
     <TextStyle ID="FONT0" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE=""/>
     <TextStyle ID="FONT1" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="bold"/>
     <TextStyle ID="FONT2" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="italics"/>
</Styles>
```



#### Correct placing of the tag `<Tags/>` after inserting the tag `<Styles>`

- The function `etree.XMLParser(remove_blank_text=True)` makes sure that the tag `</Styles>` is followed by a line feed and the tag `<Tags/>` (in the earlier version the tag `<Tags/>` followed immediately the tag `</Styles>` in the same line):

  ```xml
    <Styles>
         <TextStyle ID="FONT0" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE=""/>
         <TextStyle ID="FONT1" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="bold"/>
         <TextStyle ID="FONT2" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="italics"/>
    </Styles>
  <Tags/>
  ```
  



You can find the instruction for running the script [here](https://github.com/ljpetkovic/OCR-cat/tree/corr_trans_ALTO/ALTO_XML_trans/scripts).



 # TO DO
* Correct automatically the malformed tags of the type `<>foo</b>`in the ALTO-XML files.
