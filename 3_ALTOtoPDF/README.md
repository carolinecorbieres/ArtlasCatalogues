# ArtlasCatalogues/3_ALTOtoPDF

---

# Step 3 : Transformation of the ALTO files to PDF files

While we are waiting for GROBID to process ALTO files, we add to the workflow this intermediate step to transform ALTO files to PDF files. The `alto_to_fo.xsl` xsl stylesheet transforms the ALTO files to XML-FO files by keeping bold and italic informations. Then a FO processor (like XEP) transforms the XML-FO files to PDF files. 

## Prerequisites

The following tutorial is using [Oxygen XML Editor](https://www.oxygenxml.com/) and [RenderX XEP Engine](http://www.renderx.com/tools/xep.html). 

### Oxygen

You can download Oxygen XML Editor [here](https://www.oxygenxml.com/xml_editor/download_oxygenxml_editor.html).

### RenderX 

You can have a RenderX free personal (or academic) licence [here](http://www.renderx.com/download/personal.html). 

After you have installed RenderX on your computer, you need to add the XEP processor to Oxygen. In Oxygen, go to : 

` Options > Préférences... > XML > Sortie PDF > Processeurs FO ` (arrow 1) and click on `Parcourir` (arrow 2) next to "Ajouter un processeur FO 'XEP' (un fichier exécutable est nécessaire)". 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-1.png" width="70%"></p>

Then add the path to your `xep` script, in the `XEP` folder you have downloaded.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-2.png" width="60%"></p>

## Transformation

First, you need to open `ExhibitionCatalogues.xpr` project in Oxygen.

### ALTO to FO
 
  **1.** Go to `Catalogues > exhibCat_NAME_OF_THE_CATALOGUE > ALTO` and click on `Transformation > Configurer le/les scénario(s) de transformation...`.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-3.png" width="70%"></p>
  
  **2.** Select the `ALTO_to_FO` scenario and click on `Éditer`.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-4.png" width="70%"></p>
  
  **3.** Check the ` XSL URL `, it should match with your path on the `alto_to_fo.xsl` xsl stylesheet.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-5.png" width="50%"></p>
  
  **4.** Click on ` OK `.
  
  **5.** Then select the `ALTO_to_FO` scenario and click on `Appliquer le/les scénario(s) associé(s)`.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-6.png" width="70%"></p>
  
  **6.** Move the FO files created to `FO` folder.

### FO to PDF

Now, you need to create a transformation scenario using XEP processor (you just have to do this step once) : 

  **1.** Go to `Catalogues > exhibCat_NAME_OF_THE_CATALOGUE > FO` and click on `Transformation > Configurer le/les scénario(s) de transformation...`.
  
  **2.** Duplicate the `FO PDF` scenario.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-7.png" width="70%"></p>
  
  **3.** Rename it `XEP_PDF` for example, choose `Stockage: Options de projet` and `Transformateur: Saxon-PE 9.8.0.12`.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-8.png" width="50%"></p>
  
  **4.** In `Processeur FO` tab, click on `exécuter le traitement FO` and select `Méthode: pdf` and `Processeur: XEP`.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-9.png" width="50%"></p>
  
  **5.** In `Sortie` tab, select `Enregistrer sous` and write : `${cfn}.pdf`.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ALTOtoFO-10.png" width="50%"></p>
  
  **6.** Click on `OK`.
  
  **7.** Then select the `XEP_PDF` scenario and click on `Appliquer le/les scénario(s) associé(s)`.
  
  **8.** Move the PDF files created to `PDF` folder.
  
 Once you have created the `XEP_PDF` scenario, you can skip steps 2 to 6.
  
### Put PDF files together with `cpdf`

Finally you need to put all your PDF pages together by using `cpdf` (Coherent PDF Command Line Tools) tool. In order to use GROBID, you can delete all PDF pages that don't record catalogue entries.

  **1.** Download `cpdf` tool [here](https://community.coherentpdf.com/).
  
  **2.** If you are on Mac OS, you first need to remove the `.DS_Store` file of your `PDF` folder. Run in your terminal the following commands :
  
  - Go to your folder.
   ```
   cd YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/ 
   ```
   
  - Look for hidden files. 
   ```
   ls -a 
   ```
   
  - If there is a `.DS_Store` file, remove it. 
   ```
   rm .DS_Store 
   ```
   
  - Check if you deleted the `.DS_Store` file. 
   ```
   ls -a 
   ```
   
  **3.** Use `cpdf` tool to create a new PDF. Run in your terminal the following commands :
  
  - Activate the `cpdf` tool. 
   ```
   cd YOUR_PATH_TO_THE_FOLDER/cpdf-binaries-master/OSX-Intel/
   ```
   
  - Put all your PDF pages together. 
   ```
   ./cpdf -merge -idir ~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/ -o ~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/exhibCat_NAME_OF_THE_CATALOGUE-FO.pdf
   ```


## Thanks

Thanks to Jean-Paul Rehr who explained us how to use XML-FO and XEP processor.
