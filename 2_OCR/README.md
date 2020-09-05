# ArtlasCatalogues/2_OCR

---

# Step 2 : OCR process on catalogues and export of the ALTO files

Now we need to process catalogues in a OCR software to get the text of the document. The transcription of each catalogue is augmented by typographical information : bold and italic words are tagged with HTML tags (`<b>`, `</b>`, `<i>` and `</i>`). Then we will use two scripts written by Ljudmila Petkovic, a first one ([1_eval_txt](https://github.com/carolinecorbieres/ArtlasCatalogues/tree/master/2_OCR/1_eval_txt)) to verify the good formation of the tag and another one ([2_ALTO_XML_trans](https://github.com/carolinecorbieres/ArtlasCatalogues/tree/master/2_OCR/2_ALTO_XML_trans)) to correct automatically the malformed tags and to transform the ALTO-XML files come from the OCR software.

## OCR process

### Prerequisites

The following tutorial is using the Transkribus software. You can download it [here](https://transkribus.eu/Transkribus/) and have access to differents guides. 

### Run the OCR

First you need to run the Transkribus app and to log in. If you don't have a Transkribus account, you can register on the website.   

In Transkribus :

**1.** Select the `ArtlasCatalogues` collection (n° 70757). If you don't have access to it, you can contact Caroline Corbières at caroline.corbieres(at)chartes.psl.eu, she will give you an access to it. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-1.png" width="40%"></p>

**2.** Import your catalogue in the collection. Go to `Document...` and click on `Import document to the server`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-2.png" width="50%"></p>

- If you have JPEG images of your catalogue, choose `Upload single document` and add the path to the `exhibCat_NAME_OF_THE_CATALOGUE/JPG` folder you created before. You can add the name of the catalogue in the `Title on server` section. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-3.png" width="60%"></p>

- If you have a PDF version of your catalogue, choose `Extract and upload images from pdf` and add the path to your `exhibCat_NAME_OF_THE_CATALOGUE/PDF` folder you created before. You can add the name of the catalogue in the `Title on server` section. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-4.png" width="60%"></p>

**3.** Run the OCR. Select your catalogue and go to the `Tools` tab. 
- In `Text Recognition` select `OCR (Abbyy FineReader)` method and click on `Run...`.
- Then select `Pages` in the new window and the language(s) of the catalogue and click on `OK`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-5.png" width="60%"></p>

**4.** Run the `TYPO_2020_06_15` HTR model. Go to the `Tools` tab. 
- In `Text Recognition` select `HTR (CITLab)` method and click on `Run...`.
- Then select `Pages` in the new window. If the `TYPO_2020_06_15` HTR model is already stored, click on `OK`. If not, verify if you have access to it in the `Select HTR model...` tab, select it and click on `Ok`. If you don't find the model, you can contact Simon Gabay to have access to it at simon.gabay(at)unine.ch.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-6.png" width="60%"></p>

**5.** Verify the transcription of the OCR page by page. Go to the `Layout` tab.
- If you notice character srtings which don't make sense and which aren't a transcription of the text, you can delete the line by selecting the `TextRegion` and click on the no-entry sign. You can also delete some wrong characters of a line directly in the transcription area of Transkribus, under the image of the catalogue page. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-7.png" width="60%"></p>

- If you notice the following mistakes, you must correct them :
  - A line isn't highlighted in blue and/or green : in the page image aera, add a baseline (select the `BL` green button) under the line to create a `TextRegion` and write the corresponding transcription in the transcription area.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-8.png" width="40%"></p>
  
  - A bold or italic word isn't between tags (you don't need to correct every tag, a script will do it) : encode the word with the corresponding tags in the transcription area.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-9.png" width="40%"></p>
  
  - Lines aren't in the good order : replace them in the `Layout` area.
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-10.png" width="60%"></p>
  
  - A `Table` region in the `Layout` area : delete it and re-create baselines. We notice that the transcrition of a `TableCell` isn't recorded in the ALTO files, so you must correct it. 
  
  <p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-11.png" width="70%"></p>
 
Don't forget to save the transcription after each correction. 

## Tag verification and correction

**1.** In Transkribus, export the transcription in `.txt`. Go to the folder logo with a green right arrow.
- In `Client export` tab, file the path to your folder : `YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/2_OCR/1_eval_txt/doc` and the file name : `exhibCat_NAME_OF_THE_CATALOGUE`.
- In `Choose export formats`, deselect `Transkribus Document` and select `Simple TXT`.
- Click on `OK`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-12.png" width="60%"></p>

- Go to the folder you just created and move the `exhibCat_NAME_OF_THE_CATALOGUE.txt` in the `doc` folder. You can delete the `exhibCat_NAME_OF_THE_CATALOGUE` folder created by Transkribus.  

**2.** Go to your `ArtlasCatalogues/2_OCR/1_eval_txt/script` folder and open the `score_corr.py` script in a text editor program. 
- Complete the path to your document in the line 9 : `../doc/exhibCat_NAME_OF_THE_CATALOGUE.txt`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-13.png" width="60%"></p>

**3.** Run in the terminal the following commands :
- Go to the `script` folder.
```
cd YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/2_OCR/1_eval_txt/script
```
- Run the python script.
```
python3 score_corr.py
```

The script output is a the table of 3 columns : 
- The first one corresponds to the original text.
- The second one indicates a number corresponding to the possible tag scenarios. You can find more informations about it [here](https://github.com/ljpetkovic/OCR-cat/tree/GROBID_eval/eval_txt).
- The third one could be either the error signalisation or the suggestion of the correction.

**4.** In the second column of the scipt output, find the 2, 3 and 4 numbers to correct the OCR. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-14.png" width="60%"></p>

- Return in Transkribus and correct the malformed tags (visible thanks to the numbers 2, 3 or 4) in the transcription area. When you have corrected a page, you can update the `In Progress` status (above the page image) to `Done` status. At the end, all your pages must be `Done` (you can check it in the `Overview` tab). 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-15.png" width="50%"></p>

## Transformation of the ALTO-XML files

**1.** In Transkribus, export the transcription in `ALTO`. Go to the folder logo with a green right arrow.
- In `Client export` tab, file the path to your folder : `YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/2_OCR/2_ALTO_XML_trans/doc`.
- In `Export options`, deselect `Export Page` and `Export Image` and select `Export ALTO (Split Lines Into Words)`.
- Click on `OK`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/OCR-16.png" width="60%"></p>

- Go to the folder you just created and move the ALTO files (which are in the `alto` folder) in the `doc/exhibCat_NAME_OF_THE_CATALOGUE` folder. You can delete the `alo` folder and the `.xml` files created by Transkribus.

**2.** To transform the ALTO files and correct the OCR, run in the terminal the following commands :
- Go to the `script` folder.
```
cd YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/2_OCR/2_ALTO_XML_/scripts
```
- Run the `.sh` script.
```
bash corr_trans_ALTO.sh -d exhibCat_NAME_OF_THE_CATALOGUE
```

**3.** Move the `_trans.xml` files created in the `scripts` folder to the `Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/ALTO` folder. In order to use GROBID, you can delete all ALTO pages that don't record catalogue entries.

## Credits

The python scripts are written by Ljudmila Petkovic, with the help of Simon Gabay, you can find more informations about them on her [GitHub](https://github.com/ljpetkovic/OCR-cat).
