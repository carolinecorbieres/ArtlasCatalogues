# ArtlasCatalogues/5_ImproveGROBIDoutput

---

# Step 5 : Transformation of the `.xml` file automatically encoded by GROBID-dictionaries

GROBID-dictionaries offers an encoding for dictionaries. To have an encoding suitable for exhibition catalogues, we have to change some tags and add informations, like the header of the document. To do that, we use two xsl stylesheets. 

## Transformation 1 

The `transformGROBIDoutput1` xsl stylesheet change the tags and allow us to correct the first mistakes of the encoding.

**1.** Open the catalogue encoded by GROBID-dictionaries and the `ExhibitionCatalogues.xpr` project in Oxygen. 

**2.** Open the `transformGROBIDoutput1` xsl stylesheet and fill the catalogue's name.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/output-1.png" width="70%"></p>

**3.** Click on the red monkey wrench and select in `Projet (4)` : `XML with XSLT transformGROBIDoutput1`. Then click on `Appliquer le/les scénario(s) associé(s)`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/output-2.png" width="60%"></p>,

it will open a new `.xml` document in Oxygen called `exhibCat_NAME_OF_THE_CATALOGUE.pdf.tei_body.xml`.

**4.** Correct the document until it is green.

- First, you have to correct the `<application>` tag like the following picture. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/output-3.png" width="70%"></p>

- Then you have to correct all the mistakes in the catalogue entries.

## Transformation 2

The `transformGROBIDoutput2` xsl stylesheet add the header and the `xml:id` in the file and allow us to correct the last mistakes of the encoding.

**1.** Open the `transformGROBIDoutput2` xsl stylesheet.
- Fill the catalogue's name.
- Fill the catalogue's header path thrice.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/output-4.png" width="70%"></p>

**2.** Click on the red monkey wrench and select in `Projet (4)` : `XML with XSLT transformGROBIDoutput2`. Then click on `Appliquer le/les scénario(s) associé(s)`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/output-5.png" width="60%"></p>

It will open a new `.xml` document in Oxygen called `exhibCat_NAME_OF_THE_CATALOGUE.pdf.tei_body_step2.xml`.

**3.** Fill the header : enter your name in the `<editor role="data">` tag.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/output-6.png" width="70%"></p>

**4.** Correct the document until it is green.

- First, you have to enter the date of use in the `<application>` tags. You can just fill the year.  

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/output-7.png" width="70%"></p>

- Then you have to correct all the mistakes in the catalogue entries.

- Finally, look over the encoding carrefully to correct the last mistakes. 

**5.** Rename the document `exhibCat_NAME_OF_THE_CATALOGUE.xml` in the `TEI` folder of the corresponding catalogue and delete all the other `.xml` files.
