# Transformation and evaluation of the ALTO-XML files 

The core idea of redesigning the ALTO-XML files in order to be injected into the GROBID-dictionaries is available [here](https://github.com/ljpetkovic/OCR-cat/blob/master/eval_ALTO/README.md).<br>

Here we present the updated version of the code, which includes the transformation of **all the files** in all the catalogue folders.<br>

Another major new feature includes the automatic mm10 to pixels conversion with respect to **different image resolutions** for each catalogue.

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

   In order to install the `imagemagick` library on macOS/Linux, it is necessary to install [Homebrew](https://brew.sh) (The Missing Package Manager for macOS/Linux).<br>
   
   After you installed `homebrew`, type:
   
   `brew bundle`
   
   This command installs the `imagemagick` library on macOS/Linux (indicated in the `Brewfile`), and it is mandatory for the mm10 to pixels conversion.<br>

*NB*:

* To deactivate the virtual environment:<br>

  `deactivate`

* Allow user to read and execute scripts:<br>

  `chmod 755 myScript.sh`

### New features

##### Iterative transformation of all files in all the catalogues:<br>

cf. `corr_XML_dpi.sh`:

* One `for` loop enables access to all the catalogue folders (`$g`), as well as to the corresponding image samples providing the information about the dpi:

  ```bash
  for g in /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/* ---------- locate all the catalogue folders
  do
  	echo Processing $g
  	liste_image=( $g/*.jpg ) ---------- open all the folders and find images in those folders
  	image=${liste_image[0]}  
  	u=$(convert $image -format "%x" info:) ---- mm10 to pixels conversion, cf. the next subsection
  	...
  	done
  ```

* The other loop opens and transforms all the .xml files (`$f`) located in their corresponding folders:

  ```bash
  	for f in $g/*.xml
  	do 
  		python3 /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/scripts/corr_XML_dpi.py $f $u 
  		echo "Processing $f" 
  	done
  ```

  

##### Different image resolutions:<br>

* In order to convert correctly mm10 to pixels for each catalogue (since most of them differed in the image resolution, that is, in their dpi value), we placed one sample image of each catalogue in its corresponding folder with the .xml files, in order to fetch the dpi information;

* We converted mm10 to pixels with the following formula in the `corr_XML_dpi.py` script: 

  ```python
  pixels = str(int(mm10) * dpi / 254)
  ```

* In the `corr_XML_dpi.sh` script, the `imagemagick` library with the following command was used in order to access the dpi values:

  ```bash
  u=$(convert $image -format "%x" info:)
  ```

   (the `"%x"` indicates the horizontal resolution);

* The dpi variable `$u` represents the second command-line argument when running the `corr_XML_dpi.py` script from the `corrXML_dpi.sh` script;

##### Remove escape sequences from the attribute values<br>

e.g. `BELLE` instead of `&lt;b&gt;BELLE`

##### Advantages of integrating the `lxml` library into the code<br>

- no need to register the namespace (unlike with the previously used `etree` command `ET.register_namespace`);
- preserving the `xmlns:page="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"` namespace from the original ALTO-XML files;

##### Extending the `<Styles>` tag content:<br>

```xml
<Styles>
     <TextStyle ID="FONT0" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE=""/>
     <TextStyle ID="FONT1" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="bold"/>
     <TextStyle ID="FONT2" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="italics"/>
</Styles>
```

##### Correct placing of the tag `<Tags/>` after inserting the tag `<Styles>`<br>

- The function `XMLParser(remove_blank_text=True)` makes sure that the tag `</Styles>` is followed by a line feed and the tag `<Tags/>` (in the earlier version the tag `<Tags/>` followed immediately the tag `</Styles>` in the same line):

  ```xml
    <Styles>
         <TextStyle ID="FONT0" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE=""/>
         <TextStyle ID="FONT1" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="bold"/>
         <TextStyle ID="FONT2" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="italics"/>
    </Styles>
  <Tags/>
  ```
  
##### Dispay `--help`/description text of the Python scripts

* `python3 corr_XML_dpi.py -h`

  ```
              This programme is executable on the command line.
              To transform all files in all the catalogue folders,
              move to the 'scripts' folder and then run:
              
              ./corr_XML_dpi.sh    
  
              For the detailed explanation of the code, cf. https://github.com/ljpetkovic/OCR-cat/tree/master/ALTO_XML_trans',
  ```

* `python3 corr_XML_dpi_test.py -h`

  ```xml
              To run this programme on a single file do
              
              python3 corr_XML_dpi_test.py path_name_of_the_file dpi
  
              where dpi is an integer and           
              where path_name_of_the_file is the complete path of the file name to process.
  
              For the detailed explanation of the code, cf. https://github.com/ljpetkovic/OCR-cat/tree/master/ALTO_XML_trans',
  ```

  

### Running the scripts

#### Demo

When in `scripts` folder, to transform only one file (for testing purposes), run:<br>

```bash
python3 corr_XML_dpi_test.py ../test/1871_08_RDA_N028-1.xml $(convert ../test/1871_08_RDA_N028-1.jpg -format "%x" info:)
```

The above command runs the Python transforming script `corr_XML_dpi_test.py` on the input file `../test/1871_08_RDA_N028-1.xml`, while performing the mm10 to pixels conversion using the `imagemagick` library with the command `$(convert ../test/1871_08_RDA_N028-1.jpg -format "%x" info:)` (the `"%x"` indicates the horizontal resolution).

Output of the terminal:<br>

```bash
Processing 1871_08_RDA_N028-1.xml...
Done
```

Output of the transformed file `1871_08_RDA_N028-1.xml_trans`:<br>

```xml
<alto xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xmlns="http://www.loc.gov/standards/alto/ns-v2#"
      xmlns:page="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
      xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# http://www.loc.gov/standards/alto/alto.xsd">
  <Description>
    <MeasurementUnit>pixel</MeasurementUnit>
    <sourceImageInformation>
         <fileName>1871_08_RDA_N028-1.xml</fileName>
      </sourceImageInformation>
    <OCRProcessing ID="IdOcr">
      <ocrProcessingStep>
        <processingDateTime>2020-05-17T21:22:02.419+02:00</processingDateTime>
        <processingSoftware>
               <softwareCreator>CONTRIBUTORS</softwareCreator>
               <softwareName>pdfalto</softwareName>
               <softwareVersion>0.1</softwareVersion>
            </processingSoftware>
      </ocrProcessingStep>
    </OCRProcessing>
  </Description>
  <Styles>
     <TextStyle ID="FONT0" 
                FONTFAMILY="unknown" 
                FONTSIZE="unknown" 
                FONTTYPE="unknown" 
                FONTWIDTH="unknown" 
                FONTCOLOR="unknown" 
                FONTSTYLE=""/>
     <TextStyle ID="FONT1" 
                FONTFAMILY="unknown" 
                FONTSIZE="unknown" 
                FONTTYPE="unknown" 
                FONTWIDTH="unknown" 
                FONTCOLOR="unknown" 
                FONTSTYLE="bold"/>
     <TextStyle ID="FONT2" 
                FONTFAMILY="unknown" 
                FONTSIZE="unknown" 
                FONTTYPE="unknown" 
                FONTWIDTH="unknown" 
                FONTCOLOR="unknown" 
                FONTSTYLE="italics"/>
</Styles>
  <Tags/>
  <Layout>
    <Page ID="Page1" 
          PHYSICAL_IMG_NR="1" 
          HEIGHT="817.7952755905512" 
          WIDTH="526.6771653543307">
      <PrintSpace HEIGHT="740.9763779527559" 
                  WIDTH="475.93700787401576" 
                  VPOS="1.4173228346456692" 
                  HPOS="0.0">
...
        <TextBlock ID="r3" 
                   HEIGHT="702.992125984252" 
                   WIDTH="411.3070866141732" 
                   VPOS="36.28346456692913" 
                   HPOS="62.92913385826772">
          <TextLine ID="r3l1" 
                    BASELINE="175" 
                    HEIGHT="18.4251968503937" 
                    WIDTH="85.03937007874016" 
                    VPOS="31.181102362204726" 
                    HPOS="373.8897637795276">
            <String HEIGHT="18.4251968503937" 
                    WIDTH="66.89763779527559" 
                    VPOS="31.181102362204726" 
                    HPOS="367.93700787401576" 
                    CONTENT="Août" 
                    ID="r3l1_1" 
                    STYLEREFS="FONT1"/>
...
            <String HEIGHT="18.4251968503937" 
                    WIDTH="48.47244094488189" 
                    VPOS="31.181102362204726" 
                    HPOS="410.45669291338584" 
                    CONTENT="1874.." 
                    ID="r3l1_2" 
                    STYLEREFS="FONT1"/>
          </TextLine>
```

#### Full version

From the same folder, run `./corrXML_dpi.sh`.

Output of the terminal:<br>

```bash
Processing /Users/ljudmilapetkovic/Desktop/Katabase/ALTO_XML_trans/doc/1845_05_14_CHA_typo
Processing /Users/ljudmilapetkovic/Desktop/Katabase/ALTO_XML_trans/doc/1845_05_14_CHA_typo/1845_05_14_CHA-0008.xml
...
Processing /Users/ljudmilapetkovic/Desktop/Katabase/ALTO_XML_trans/doc/1856_10_LAV_N03_gt_typo
Processing /Users/ljudmilapetkovic/Desktop/Katabase/ALTO_XML_trans/doc/1856_10_LAV_N03_gt_typo/1856_10_LAV_N03-1.xml
...
```

Output of the transformed file `1845_05_14_CHA-0008.xml_trans.xml`:<br>

```xml
<alto xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
      xmlns="http://www.loc.gov/standards/alto/ns-v2#"
      xmlns:page="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
      xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# http://www.loc.gov/standards/alto/alto.xsd">
  <Description>
    <MeasurementUnit>pixel</MeasurementUnit>
    <sourceImageInformation>
         <fileName>1845_05_14_CHA-0008.xml</fileName>
      </sourceImageInformation>
    <OCRProcessing ID="IdOcr">
      <ocrProcessingStep>
        <processingDateTime>2020-05-13T10:41:44.561+02:00</processingDateTime>
        <processingSoftware>
               <softwareCreator>CONTRIBUTORS</softwareCreator>
               <softwareName>pdfalto</softwareName>
               <softwareVersion>0.1</softwareVersion>
            </processingSoftware>
      </ocrProcessingStep>
    </OCRProcessing>
  </Description>
  <Styles>
     <TextStyle ID="FONT0" 
                FONTFAMILY="unknown" 
                FONTSIZE="unknown" 
                FONTTYPE="unknown" 
                FONTWIDTH="unknown" 
                FONTCOLOR="unknown" 
                FONTSTYLE=""/>
     <TextStyle ID="FONT1" 
                FONTFAMILY="unknown" 
                FONTSIZE="unknown" 
                FONTTYPE="unknown" 
                FONTWIDTH="unknown" 
                FONTCOLOR="unknown" 
                FONTSTYLE="bold"/>
     <TextStyle ID="FONT2" 
                FONTFAMILY="unknown" 
                FONTSIZE="unknown" 
                FONTTYPE="unknown" 
                FONTWIDTH="unknown" 
                FONTCOLOR="unknown" 
                FONTSTYLE="italics"/>
</Styles>
  <Tags/>
  <Layout>
    ...
          <TextLine ID="tl_1" 
                    BASELINE="1036" 
                    HEIGHT="87.59055118110236" 
                    WIDTH="651.6850393700787" 
                    VPOS="206.07874015748033" 
                    HPOS="524.4094488188977">
            <String HEIGHT="87.59055118110236" 
                    WIDTH="796.5354330708661" 
                    VPOS="206.07874015748033" 
                    HPOS="379.5590551181102" 
                    CONTENT="CATALOGUE" 
                    ID="tl_1_1" STYLEREFS="FONT0"/>
          </TextLine>
...
          <TextLine ID="tl_2" 
                    BASELINE="1306" 
                    HEIGHT="36.0" 
                    WIDTH="105.16535433070867" 
                    VPOS="334.20472440944883" 
                    HPOS="801.3543307086615">
            <String HEIGHT="36.0" 
                    WIDTH="147.11811023622047" 
                    VPOS="334.20472440944883" 
                    HPOS="759.4015748031496" 
                    CONTENT="D'UNE" 
                    ID="tl_2_1" 
                    STYLEREFS="FONT0"/>
          </TextLine>
...
          <TextLine ID="tl_3" 
                    BASELINE="1667" 
                    HEIGHT="42.803149606299215" 
                    WIDTH="458.3622047244094" 
                    VPOS="429.73228346456693" 
                    HPOS="626.7401574803149">
            <String HEIGHT="42.803149606299215" 
                    WIDTH="239.24409448818898" 
                    VPOS="429.73228346456693" 
                    HPOS="606.8976377952756" 
                    CONTENT="BELLE" 
                    ID="tl_3_1" 
                    STYLEREFS="FONT1"/>
...
            <String HEIGHT="42.803149606299215" 
                    WIDTH="318.8976377952756" 
                    VPOS="429.73228346456693" 
                    HPOS="766.2047244094488" 
                    CONTENT="COLLECTION" 
                    ID="tl_3_2" 
                    STYLEREFS="FONT1"/>
          </TextLine>
```
 # TO DO
* Correct automatically the malformed tags in the ALTO-XML files.
