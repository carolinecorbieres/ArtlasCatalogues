# ArtlasCatalogues/6_TEItoCSV

---

# Step 6 : Transformation of the XML-TEI encoded catalogue to a CSV file

To put the data in BasArt database, we need to have them in a CSV file. To do that, we have to transform the XML-TEI version of the catalogue to a CSV file thanks to the `XMLtoCSV` xsl stylesheet. It puts the encoded data in the corresponding column of the CSV document.  

## Transformation

Open the `ExhibitionCatalogues.xpr` project in Oxygen. 

**1.** Go to `Catalogues > exhibCat_NAME_OF_THE_CATALOGUE > TEI` and click on `Transformation > Configurer le/les scénario(s) de transformation...`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/CSV-1.png" width="70%"></p>

**2.** Then select the `TEItoCSV` scenario and click on `Appliquer le/les scénario(s) associé(s)`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/CSV-2.png" width="70%"></p>

**3.** Move the CSV file created to `CSV` folder.

Now you can complete the empty columns by moving the data in the corresponding columns. At this step, check for errors and correct them.
