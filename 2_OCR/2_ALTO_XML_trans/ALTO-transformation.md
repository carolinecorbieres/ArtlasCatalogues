This README is written by Ljudmila Petkovic, you can find all her work [here](https://github.com/ljpetkovic/OCR-cat/tree/GROBID_eval). 

--------

# Transformation and evaluation of the ALTO-XML files

### Introduction

In this phase, the OCR output (text + typographical information) is exported from Transkribus into the ALTO-XML format (at the word level), in order to be further processed and injected into the GROBID-dictionaries. However, we have noticed two problems that prevent this injection: <br>

* the ALTO-XML structure of the exported files did not correspond to the structure which could be accepted by the GROBID-dictionaries;<br>
* the markup is stored in attribute values, and such a design is fundamentally flawed (e.g.`<String CONTENT="&lt;b&gt;Août"`, where `&lt;b&gt;` is equivalent to the tag `<b>` indicating the word in bold).<br>



### Redesigning the ALTO-XML files

After the initial experimenting with the XSLT transformations, we have managed to mitigate the problem with the structure, but the attribute values indicating the font were not always correctly assigned (e.g. the `<String CONTENT="Août" STYLEREFS="FONT2"` part does not correspond to the `&lt;b&gt;Août` &mdash; in this case the value `FONT1` should be assigned to the attribute `STYLEREFS` instead of `FONT2`):

The original (flawed) structure of the ALTO-XML file (`1871_08_RDA_N028-1.xml`):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<alto xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns="http://www.loc.gov/standards/alto/ns-v2#"
      xmlns:page="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
      xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# http://www.loc.gov/standards/alto/alto.xsd">
   <Description>
      <MeasurementUnit>pixel</MeasurementUnit>
      <OCRProcessing ID="IdOcr">
         <ocrProcessingStep>
            <processingDateTime>2020-05-17T21:22:02.419+02:00</processingDateTime>
            <processingSoftware>
               <softwareCreator>READ COOP</softwareCreator>
               <softwareName>Transkribus</softwareName>
            </processingSoftware>
         </ocrProcessingStep>
      </OCRProcessing>
   </Description> ------------------ below goes Styles with its fonts
   <Tags/>
   <Layout>
      <Page ID="Page1" PHYSICAL_IMG_NR="1" HEIGHT="2885" WIDTH="1858">    
         <TopMargin HEIGHT="5" WIDTH="1858" VPOS="0" HPOS="0"/>  ----- unnecessary, convert into pixels
         <LeftMargin HEIGHT="2614" WIDTH="0" VPOS="5" HPOS="0"/> ----- unnecessary, convert into pixels
         <RightMargin HEIGHT="2614" WIDTH="179" VPOS="5" HPOS="1679"/> 	----- unnecessary, convert into pixels
         <BottomMargin HEIGHT="266" WIDTH="1858" VPOS="2619" HPOS="0"/> ----- unnecessary, convert into pixels
         <PrintSpace HEIGHT="2614" WIDTH="1679" VPOS="5" HPOS="0">
            <TextBlock ID="r2" HEIGHT="241" WIDTH="34" VPOS="2334" HPOS="249">
               <Shape> 	------------------------------------------------------ unnecessary
                  <Polygon POINTS="249,2334 249,2575 283,2575 283,2334"/> --- unnecessary
               </Shape>     
               <TextLine ID="r2l1"
                         BASELINE="2391"
                         HEIGHT="58"
                         WIDTH="44"
                         VPOS="2333"
                         HPOS="241">
                 <String HEIGHT="58" --- String needs the incremental ID and STYLEREFS with FONT{0,1,2}
                         WIDTH="132" 
                         VPOS="2333" 
                         HPOS="153" 
                         CONTENT="5"/>
               </TextLine>
               <TextLine ID="r2l2"
                         BASELINE="2486"
                         HEIGHT="71"
                         WIDTH="56"
                         VPOS="2415"
                         HPOS="239">
                 <String HEIGHT="71" 
                  	 WIDTH="168" 
                  	 VPOS="2415" 
                  	 HPOS="127" 
                  	 CONTENT="6"/>
               </TextLine>
               <TextLine ID="r2l3"
                         BASELINE="2569"
                         HEIGHT="58"
                         WIDTH="44"
                         VPOS="2511"
                         HPOS="243">
                 <String HEIGHT="58" 
                  	 WIDTH="132" 
                  	 VPOS="2511" 
                  	 HPOS="155" 
                  	 CONTENT="7"/>
               </TextLine>
            </TextBlock>
            <TextBlock ID="r3" 
            	       HEIGHT="2480" 
            	       WIDTH="1451" 
            	       VPOS="128" 
            	       HPOS="222">
               <Shape>
                  <Polygon POINTS="222,128 222,2608 1673,2608 1673,128"/>
               </Shape>
               <TextLine ID="r3l1"
                         BASELINE="175"
                         HEIGHT="65"
                         WIDTH="300"
                         VPOS="110"
                         HPOS="1319">
                  <String HEIGHT="65"
                          WIDTH="236"
                          VPOS="110"
                          HPOS="1298"
                          CONTENT="&lt;b&gt;Août"/>
                  <SP HEIGHT="65" WIDTH="21" VPOS="110" HPOS="1533"/>
                  <String HEIGHT="65"
                          WIDTH="171"
                          VPOS="110"
                          HPOS="1448"
                          CONTENT="1874.."/>
               </TextLine>
               <TextLine ID="r3l2"
                         BASELINE="175"
                         HEIGHT="65"
                         WIDTH="187"
                         VPOS="110"
                         HPOS="243">
                  <String HEIGHT="65"
                          WIDTH="140"
                          VPOS="110"
                          HPOS="227"
                          CONTENT="&lt;b&gt;N°"/>
                  <SP HEIGHT="65" WIDTH="16" VPOS="110" HPOS="368"/>
                  <String HEIGHT="65"
                          WIDTH="125"
                          VPOS="110"
                          HPOS="305"
                          CONTENT="28&lt;/b&gt;"/>
               </TextLine>
...
```



The desired structure demanded the following structural modifications:<br>

1. Removing the unnecessary tags `<TopMargin>`, `<LeftMargin>`, `<RightMargin>`, `<BottomMargin>`,`<Shape>`,`<Polygon>`;

2. Adding the `<Styles>` tag in the header with the following content: 
```xml
   <Styles>
      <TextStyle ID="FONT0" STYLEREFS=""/>
      <TextStyle ID="FONT1" STYLEREFS="bold"/>
      <TextStyle ID="FONT2" STYLEREFS="italic"/>
   </Styles>
```

3. Adding the `ID` attribute for each element `<String>`; the value of its `ID` is the incremented value generated by the `ID` of its parent element `TextLine`; 										
   
   ```xml
   <TextBlock ID="r_2_1" HEIGHT="205" WIDTH="2840" VPOS="833" HPOS="793">
          <TextLine ID="tl_2" -------- used to generate incrementally the value of the String ID attribute
                    BASELINE="943"
                    HEIGHT="109"
                    WIDTH="2836"
                    VPOS="834"
                    HPOS="794">
             <String ID="tl_2_1" ------- The ID with the incremented value
                     HEIGHT="109"
                     WIDTH="324"
                     VPOS="834"
                     HPOS="753"
                     CONTENT="154."/>
   ```
   
4. The crucial aspect of this code is to consider the **different possible tagging scenarios** for applying the `STYLEREFS="FONT{0,1,2}"` to the elements `<String>`, taking into account the word context in order to determine whether to assign one font value or not. More precisely, this code goes beyond the basic font assignment where:

    - the default value is `STYLEREFS="FONT0"` (normal text, e.g. the word `5`);

    - if the attribute `CONTENT` contains the tags `<b>   ` or `</b>` then `STYLEREFS="FONT1"` (bold, e.g. `&lt;b&gt;Amari&lt;/b&gt;`);

    - if the attribute `CONTENT` contains the tags `<i> ` or `</i>` then `STYLEREFS="FONT2"` (italic, e.g. `&lt;i&gt;des`),

    

    to the more complex cases where:

    - the whole line is marked typographically, but the exported ALTO-XML files contain the markup stored only at the beginning and at the end of the marked-up segment, that is, only before the first and after the last word in the marked-up sequence (e.g.`&lt;b&gt;DES CURIOSITÉS DE L'HISTOIRE & DE LA BIOGRAPHE&lt;/b&gt;`);
    - only some line segments are marked typographically (`&lt;i&gt;des Vépres siciliennes&lt;/i&gt;. ministre des Finances en 1848.`).

    

    In other words, the programme assigns correct font values to all the individual words encompassed in the marked-up line (`DES`, `CURIOSITÉS`, `DE`, `L'HISTOIRE`, `&`, `DE`, `LA`, `BIOGRAPHE`) or to the words being part of the marked-up segment (`des`, `Vépres`, `siciliennes`, excluding the `ministre des Finances en 1848` part). Thus, this code extension is intended to emulate the intelligent human reasoning when deciding which parts of text are marked up in which font;

    

    Handling different tagging scenarios (taken from `1871_08_RDA_N028-1.xml` and `1871_08_RDA_N028-2.xml`):

    ```xml
    <String CONTENT="&lt;b&gt;N°"  ------ opening bold tag
            HEIGHT="18.4251968503937" 
            HPOS="64.34645669291339" 
            ID="r3l2_1" 
            STYLEREFS="FONT1"    ------ bold
            VPOS="31.181102362204726" 
            WIDTH="39.68503937007874" />
    <SP HEIGHT="18.4251968503937" HPOS="104.31496062992126" VPOS="31.181102362204726" WIDTH="4.535433070866142" />
    <String CONTENT="28&lt;/b&gt;" ------ closing bold tag
            HEIGHT="18.4251968503937" 
            HPOS="86.45669291338582" 
            ID="r3l2_2" 
            STYLEREFS="FONT1"    ------- bold
            VPOS="31.181102362204726" 
            WIDTH="35.43307086614173" />
    <String CONTENT="&lt;b&gt;Amari&lt;/b&gt;" --- opening and closing bold tags
            HEIGHT="18.4251968503937" 
            HPOS="102.61417322834646" 
            ID="tl_22_2" 
            STYLEREFS="FONT1"     ----- bold
            VPOS="315.7795275590551" 
            WIDTH="81.63779527559055" />
    <String CONTENT="&lt;i&gt;des" -------- opening italic tag in the beginning of the line
            HEIGHT="15.023622047244094" 
            HPOS="104.31496062992126" 
            ID="tl_23_1" 
            STYLEREFS="FONT2"    ----------- italic
            VPOS="330.23622047244095" 
            WIDTH="54.14173228346457" />
    <SP HEIGHT="15.023622047244094" HPOS="158.45669291338584" VPOS="330.23622047244095" WIDTH="5.3858267716535435" />
    <String CONTENT="Vépres" ----------- no explicit tag, the second word in the italic part &lt;i&gt;des Vépres siciliennes&lt;/i&gt;
            HEIGHT="15.023622047244094" 
            HPOS="142.01574803149606" 
            ID="tl_23_2" 
            STYLEREFS="FONT2"    ----------- italic
            VPOS="330.23622047244095" 
            WIDTH="54.14173228346457" />
    <SP HEIGHT="15.023622047244094" HPOS="196.15748031496062" VPOS="330.23622047244095" WIDTH="5.3858267716535435" />
    <String CONTENT="siciliennes&lt;/i&gt;." -------- closing italic tag in the middle of the line
            HEIGHT="15.023622047244094" 
            HPOS="180.0" 
            ID="tl_23_3" 
            STYLEREFS="FONT2"    ----------- italic
            VPOS="330.23622047244095" 
            WIDTH="108.28346456692914" />
    <SP HEIGHT="15.023622047244094" HPOS="288.2834645669291" VPOS="330.23622047244095" WIDTH="5.3858267716535435" />
    <String CONTENT="ministre"            ----------- no tag
            HEIGHT="15.023622047244094" 
            HPOS="271.84251968503935" 
            ID="tl_23_4" 
            STYLEREFS="FONT0"   ----------- normal text
            VPOS="330.23622047244095" 
            WIDTH="64.91338582677166" />
    ```

    

The extended desired structure (cf. `1871_08_RDA_N028-1.xml_trans` and `1871_08_RDA_N028-2.xml_trans`):

```xml
<?xml version='1.0' encoding='utf8'?>
<alto xmlns="http://www.loc.gov/standards/alto/ns-v2#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/standards/alto/ns-v2# http://www.loc.gov/standards/alto/alto.xsd">
   <Description>
      <MeasurementUnit>pixel</MeasurementUnit>
      <sourceImageInformation>
         <fileName>1871_08_RDA_N028-1.xml</fileName>
      </sourceImageInformation><OCRProcessing ID="IdOcr">
         <ocrProcessingStep>
            <processingDateTime>2020-05-17T21:22:02.419+02:00</processingDateTime>
            <processingSoftware>
               <softwareCreator>CONTRIBUTORS</softwareCreator>
               <softwareName>pdfalto</softwareName>
               <softwareVersion>0.1</softwareVersion>
            </processingSoftware></ocrProcessingStep>
      </OCRProcessing>
   </Description>
   <Styles>
      <TextStyle FONTSTYLE="" ID="FONT0" />
      <TextStyle FONTSTYLE="bold" ID="FONT1" />
      <TextStyle FONTSTYLE="italics" ID="FONT2" />
   </Styles><Tags />
   <Layout>
      <Page HEIGHT="817.7952755905512" ID="Page1" PHYSICAL_IMG_NR="1" WIDTH="526.6771653543307">
         <PrintSpace HEIGHT="740.9763779527559" HPOS="0.0" VPOS="1.4173228346456692" WIDTH="475.93700787401576">
            <TextBlock HEIGHT="68.31496062992126" HPOS="70.58267716535433" ID="r2" VPOS="661.6062992125984" WIDTH="9.637795275590552">
               <TextLine BASELINE="2391" HEIGHT="16.440944881889763" HPOS="68.31496062992126" ID="r2l1" VPOS="661.3228346456693" WIDTH="12.472440944881889">
                  <String CONTENT="5" 
                          HEIGHT="16.440944881889763" 
                          HPOS="43.37007874015748" 
                          ID="r2l1_1" 
                          STYLEREFS="FONT0" 
                          VPOS="661.3228346456693" 
                          WIDTH="37.41732283464567" />
               </TextLine>
               <TextLine BASELINE="2486" HEIGHT="20.125984251968504" HPOS="67.74803149606299" ID="r2l2" VPOS="684.5669291338583" WIDTH="15.874015748031496">
                  <String CONTENT="6" 
                          HEIGHT="20.125984251968504" 
                          HPOS="36.0" ID="r2l2_1" 
                          STYLEREFS="FONT0" 
                          VPOS="684.5669291338583" 
                          WIDTH="47.62204724409449" />
               </TextLine>
               <TextLine BASELINE="2569" HEIGHT="16.440944881889763" HPOS="68.88188976377953" ID="r2l3" VPOS="711.7795275590552" WIDTH="12.472440944881889">
                  <String CONTENT="7" 
                          HEIGHT="16.440944881889763" 
                          HPOS="43.93700787401575" 
                          ID="r2l3_1" 
                          STYLEREFS="FONT0" 
                          VPOS="711.7795275590552" 
                          WIDTH="37.41732283464567" />
               </TextLine>
            </TextBlock>
            <TextBlock HEIGHT="702.992125984252" HPOS="62.92913385826772" ID="r3" VPOS="36.28346456692913" WIDTH="411.3070866141732">
               <TextLine BASELINE="175" HEIGHT="18.4251968503937" HPOS="373.8897637795276" ID="r3l1" VPOS="31.181102362204726" WIDTH="85.03937007874016">
                  <String CONTENT="&lt;b&gt;Août" 
                          HEIGHT="18.4251968503937" 
                          HPOS="367.93700787401576" 
                          ID="r3l1_1" 
                          STYLEREFS="FONT1" 
                          VPOS="31.181102362204726" 
                          WIDTH="66.89763779527559" />
                  <SP HEIGHT="18.4251968503937" HPOS="434.5511811023622" VPOS="31.181102362204726" WIDTH="5.952755905511811" />
                  <String CONTENT="1874.." 
                          HEIGHT="18.4251968503937" 
                          HPOS="410.45669291338584" 
                          ID="r3l1_2" 
                          STYLEREFS="FONT1" 
                          VPOS="31.181102362204726" 
                          WIDTH="48.47244094488189" />
               </TextLine>
               <TextLine BASELINE="175" HEIGHT="18.4251968503937" HPOS="68.88188976377953" ID="r3l2" VPOS="31.181102362204726" WIDTH="53.00787401574803">
                  <String CONTENT="&lt;b&gt;N°" 
                          HEIGHT="18.4251968503937" 
                          HPOS="64.34645669291339" 
                          ID="r3l2_1" STYLEREFS="FONT1" 
                          VPOS="31.181102362204726" 
                          WIDTH="39.68503937007874" />
                  <SP HEIGHT="18.4251968503937" HPOS="104.31496062992126" VPOS="31.181102362204726" WIDTH="4.535433070866142" />
                  <String CONTENT="28&lt;/b&gt;" 
                          HEIGHT="18.4251968503937" 
                          HPOS="86.45669291338582" 
                          ID="r3l2_2" 
                          STYLEREFS="FONT1" 
                          VPOS="31.181102362204726" 
                          WIDTH="35.43307086614173" />
               </TextLine>
...
```

5. Conversion of the `HPOS`, `VPOS`, `HEIGHT` and `WIDTH` attribute values from mm10 (the measurement unit used in the ALTO file) to pixels, using the formula `mm10 * dpi / 254`.

### Remarks

* For the transformation of the ALTO-XML files we opted for the `ElementTree` built-in Python library, instead of the non-native Python library `lxml`;
* With this library it was possible to reproduce the results made during the experimental phase, and as well to improve the key aspect of the transformation, that is, the correct assignment of the attribute values `FONT{0,1,2}`;
* There were some initial problems in the displaying of the ALTO-XML header (e.g. the insertion of `<ns0:` in `<ns0:Description>` ). Those issues were resolved by adding the explicit statements of the namespaces and the metadata in the header, which facilitated the creation of the valid ALTO-XML structure and the access to the XML nodes (e.g. `{http://www.loc.gov/standards/alto/ns-v2#}Page` );



### TO DO

* Transform all the annotated training data using this procedure.
