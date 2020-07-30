# Running the `corr_trans_ALTO.sh` script

* Go to the `scripts` directory;
* In order to run the script on the command line without calling its path, you can add your path to the script to the `$PATH` variable with the command  `export PATH="$PATH:/path/to/my/script"`.
* Run `./corr_trans_ALTO.sh` (or just `corr_trans_ALTO.sh`, if you have already set your `$PATH` variable).



### 1. Without the additional flags:  

* if the files are not transformed, the script transforms those files;

* if the files have been transformed, the script throws the error that those files have already been transformed;

  Output of the terminal:

```
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_trans_ALTO.sh
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Cat_Inde_1913 -------- folder name
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Cat_Inde_1913/11.xml ------- file name
...
/Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/1857_02_05_JA1_bpt6k9677856h_typo already transformed
```



### 2. With the flag `-d` and the folder name we intend to transform:

* When we add new (non-transformed) files, we can transform only those files, and ignore those already transformed;
* Run the code, followed by the `-d` flag and the folder name containing those new files;

```bash
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_trans_ALTO.sh -d Cat_Inde_1913
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Cat_Inde_1913
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Cat_Inde_1913/11.xml
...
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Cat_Inde_1913/95.xml
```



### 3. With the flag `-a`:

* Transform all files in all catalogue folders, whether they have already been transformed or not;
  * Intended to handle the situations if somebody incorrectly modifies the transformed file(s), so we want to make sure that all the files are transformed in a regular way defined by the `.py` and `.sh` scripts:

```
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_trans_ALTO.sh -a
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Cat_Inde_1913 ---------- the first folder
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Cat_Inde_1913/11.xml
...
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Manuel_synonymie_typo -------------- the last folder
Processing /Users/ljudmilapetkovic/Desktop/Katabase/OCRcat/ALTO_XML_trans/doc/Manuel_synonymie_typo/Manuel_de_Synonymie_Latine-0001.xml
```



### 4. With the flag `-h`:

* Get the `help`/flag description:

```
(env) (base) Ljudmilas-MacBook-Air:scripts ljudmilapetkovic$ corr_trans_ALTO.sh -h
########## Help ##########
Flag description:
	-a 	Transform all files in all catalogue folders, whether they have already been transformed or not;
		Intended to handle the situations if somebody incorrectly modifies the transformed file, so we want to make sure that all the files are transformed in a regular way defined by the .py and .sh scripts:

	-d 	When we add new (non-transformed) files, we can transform only those files, and ignore those already transformed;
		Run the code, followed by the -d flag and the folder name containing those files;
		For the already transformed files, the script throws the error that these files have already been transformed.

	-h 	Get help/text description of the flags.

For the detailed explanation of the script, go to https://github.com/ljpetkovic/OCR-cat/tree/corr_trans_ALTO/ALTO_XML_trans.
```

### Output of the transformed file

From the `Cat_Inde_1913` catalogue (p. `21.xml_trans`):

```xml
<alto xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/standards/alto/ns-v2#" xmlns:page="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15" xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# http://www.loc.gov/standards/alto/alto.xsd">
  <Description>
    <MeasurementUnit>pixel</MeasurementUnit>
    <sourceImageInformation>
         <fileName>21.xml</fileName>
      </sourceImageInformation>
    <OCRProcessing ID="IdOcr">
      <ocrProcessingStep>
        <processingDateTime>2020-06-23T14:34:15.646+02:00</processingDateTime>
        <processingSoftware>
               <softwareCreator>CONTRIBUTORS</softwareCreator>
               <softwareName>pdfalto</softwareName>
               <softwareVersion>0.1</softwareVersion>
            </processingSoftware>
      </ocrProcessingStep>
    </OCRProcessing>
  </Description>
  <Styles>
     <TextStyle ID="FONT0" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE=""/>
     <TextStyle ID="FONT1" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="bold"/>
     <TextStyle ID="FONT2" FONTFAMILY="unknown" FONTSIZE="unknown" FONTTYPE="unknown" FONTWIDTH="unknown" FONTCOLOR="unknown" FONTSTYLE="italics"/>
</Styles>
  <Tags/>
  <Layout>
    <Page ID="Page1" PHYSICAL_IMG_NR="1" HEIGHT="4710.236220472441" WIDTH="3036.220472440945">
      <PrintSpace HEIGHT="4710.236220472441" WIDTH="3036.220472440945" VPOS="0.0" HPOS="0.0">
        <TextBlock ID="r_1_1" HEIGHT="53.54330708661417" WIDTH="166.9291338582677" VPOS="648.8188976377953" HPOS="1144.8818897637796">
          <TextLine ID="tl_1" BASELINE="462" HEIGHT="103.93700787401575" WIDTH="201.5748031496063" VPOS="623.6220472440945" HPOS="1132.283464566929">
            <String HEIGHT="103.93700787401575" WIDTH="251.96850393700788" VPOS="623.6220472440945" HPOS="1081.8897637795276" CONTENT="—" ID="tl_1_1" STYLEREFS="FONT0"/>
            <SP HEIGHT="103.93700787401575" WIDTH="50.39370078740158" VPOS="623.6220472440945" HPOS="1333.8582677165355"/>
            <String HEIGHT="103.93700787401575" WIDTH="201.5748031496063" VPOS="623.6220472440945" HPOS="1132.283464566929" CONTENT="19" ID="tl_1_2" STYLEREFS="FONT0"/>
          </TextLine>
        </TextBlock>
        <TextBlock ID="r_2_1" HEIGHT="187.4015748031496" WIDTH="1757.4803149606298" VPOS="836.2204724409448" HPOS="322.8346456692913">
          <TextLine ID="tl_2" BASELINE="590" HEIGHT="141.73228346456693" WIDTH="1779.5275590551182" VPOS="787.4015748031496" HPOS="311.81102362204723">
            <String HEIGHT="141.73228346456693" WIDTH="381.1023622047244" VPOS="787.4015748031496" HPOS="269.29133858267716" CONTENT="ANREP" ID="tl_2_1" STYLEREFS="FONT0"/>
            <SP HEIGHT="141.73228346456693" WIDTH="42.51968503937008" VPOS="787.4015748031496" HPOS="650.3937007874016"/>
            <String HEIGHT="141.73228346456693" WIDTH="423.62204724409446" VPOS="787.4015748031496" HPOS="524.4094488188977" CONTENT="(Boris" ID="tl_2_2" STYLEREFS="FONT0"/>
            <SP HEIGHT="141.73228346456693" WIDTH="42.51968503937008" VPOS="787.4015748031496" HPOS="948.0314960629921"/>
            <String HEIGHT="141.73228346456693" WIDTH="381.1023622047244" VPOS="787.4015748031496" HPOS="820.4724409448819" CONTENT="von)," ID="tl_2_3" STYLEREFS="FONT0"/>
            <SP HEIGHT="141.73228346456693" WIDTH="42.51968503937008" VPOS="787.4015748031496" HPOS="1201.5748031496064"/>
            <String HEIGHT="141.73228346456693" WIDTH="253.54330708661416" VPOS="787.4015748031496" HPOS="1074.015748031496" CONTENT="né" ID="tl_2_4" STYLEREFS="FONT0"/>
            <SP HEIGHT="141.73228346456693" WIDTH="42.51968503937008" VPOS="787.4015748031496" HPOS="1329.1338582677165"/>
            <String HEIGHT="141.73228346456693" WIDTH="212.5984251968504" VPOS="787.4015748031496" HPOS="1201.5748031496064" CONTENT="à" ID="tl_2_5" STYLEREFS="FONT0"/>
            <SP HEIGHT="141.73228346456693" WIDTH="42.51968503937008" VPOS="787.4015748031496" HPOS="1414.1732283464567"/>
            <String HEIGHT="141.73228346456693" WIDTH="847.2440944881889" VPOS="787.4015748031496" HPOS="1244.0944881889764" CONTENT="Saint" ID="tl_2_6" STYLEREFS="FONT0"/>
          </TextLine>
          <TextLine ID="tl_3" BASELINE="684" HEIGHT="185.82677165354332" WIDTH="957.4803149606299" VPOS="891.3385826771654" HPOS="392.12598425196853">
            <String HEIGHT="185.82677165354332" WIDTH="267.7165354330709" VPOS="891.3385826771654" HPOS="354.3307086614173" CONTENT="65," ID="tl_3_1" STYLEREFS="FONT0"/>
            <SP HEIGHT="185.82677165354332" WIDTH="37.79527559055118" VPOS="891.3385826771654" HPOS="622.0472440944882"/>
            <String HEIGHT="185.82677165354332" WIDTH="497.6377952755906" VPOS="891.3385826771654" HPOS="507.0866141732283" CONTENT="boulevard" ID="tl_3_2" STYLEREFS="FONT0"/>
            <SP HEIGHT="185.82677165354332" WIDTH="37.79527559055118" VPOS="891.3385826771654" HPOS="1004.7244094488188"/>
            <String HEIGHT="185.82677165354332" WIDTH="382.6771653543307" VPOS="891.3385826771654" HPOS="889.7637795275591" CONTENT="Arago," ID="tl_3_3" STYLEREFS="FONT0"/>
            <SP HEIGHT="185.82677165354332" WIDTH="37.79527559055118" VPOS="891.3385826771654" HPOS="1272.4409448818897"/>
            <String HEIGHT="185.82677165354332" WIDTH="229.92125984251967" VPOS="891.3385826771654" HPOS="1119.6850393700788" CONTENT="13e." ID="tl_3_4" STYLEREFS="FONT0"/>
          </TextLine>
        </TextBlock>
        <TextBlock ID="r_2_2" HEIGHT="80.31496062992126" WIDTH="930.7086614173228" VPOS="1140.1574803149606" HPOS="325.98425196850394">
          <TextLine ID="tl_4" BASELINE="791" HEIGHT="148.03149606299212" WIDTH="952.7559055118111" VPOS="1097.6377952755906" HPOS="313.38582677165357">
            <String HEIGHT="148.03149606299212" WIDTH="456.6929133858268" VPOS="1097.6377952755906" HPOS="275.59055118110234" CONTENT="84" ID="tl_4_1" STYLEREFS="FONT1"/>
            <SP HEIGHT="148.03149606299212" WIDTH="37.79527559055118" VPOS="1097.6377952755906" HPOS="732.2834645669292"/>
            <String HEIGHT="148.03149606299212" WIDTH="456.6929133858268" VPOS="1097.6377952755906" HPOS="618.8976377952756" CONTENT="L’enfant" ID="tl_4_2" STYLEREFS="FONT0"/>
            <SP HEIGHT="148.03149606299212" WIDTH="37.79527559055118" VPOS="1097.6377952755906" HPOS="1075.5905511811025"/>
            <String HEIGHT="148.03149606299212" WIDTH="343.3070866141732" VPOS="1097.6377952755906" HPOS="922.8346456692914" CONTENT="pleure." ID="tl_4_3" STYLEREFS="FONT0"/>
          </TextLine>
        </TextBlock>
```

