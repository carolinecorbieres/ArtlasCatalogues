# Guide to create and train a model in GROBID-dictionaries

If you want to add training data to an existing model or train a new one, you can follow this guide. You can also refer to the official GROBID-dictionaries guidelines [here](https://github.com/MedKhem/grobid-dictionaries/wiki).

This guide allow you to train PDF files.

## Prepare training data

To train a model, you need to have training data for the training of the model and its evaluation. We usually use 80% data for training and 20% for evaluation. 

For this tutorial, you will need `cpdf` tool. To install it, you can refer to the [Step 3](https://github.com/carolinecorbieres/ArtlasCatalogues/tree/master/3_ALTOtoPDF). 

**1.** Choose 8 pages for the training and 2 pages for the evaluation.

**2.** Run in your terminal the following commands : 

- Activate the `cpdf` tool.
```
cd YOUR_PATH_TO_THE_FOLDER/cpdf-binaries-master/OSX-Intel/
```

- Split your pdf. 
```
./cpdf -split ~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/exhibCat_NAME_OF_THE_CATALOGUE-FO.pdf -o ~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/%%%%.pdf
```

- Rebuild a pdf with the pages you have selected. Don't forget to fill the `PAGE_NUMBER` of the command. To create a train document, you need to substitute `_test.pdf` for `_train.pdf` and add 6 more pages (`~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/PAGE_NUMBER.pdf`).
```
./cpdf -merge -i ~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/PAGE_NUMBER.pdf ~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/PDF/PAGE_NUMBER.pdf -o ~/YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/4_GROBID/exhibCat_NAME_OF_YOUR_CATALOGUE_test.pdf
```
The files are directly created in the `4_GROBID` folder. 

**3.** Move your files to the corresponding folder.

- If you want to add training data to an existing model, you can move the files `exhibCat_NAME_OF_YOUR_CATALOGUE_train.pdf` and `exhibCat_NAME_OF_YOUR_CATALOGUE_test.pdf` in the `TrainingTools/TestTrainingPDF/PDF_testFiles` folder and in the `toyData/dataset/dictionary-segmentation/corpus/pdf` folder.
- If you want to train a new model, create a new folder named `trainingData_MODEL_NAME_PDF` in `4_GROBID` folder. Then, move your files in the `TrainingTools/TestTrainingPDF/PDF_testFiles` folder and in the `toyData/dataset/dictionary-segmentation/corpus/pdf` folder.

**4.** If you are on Mac OS, you first need to remove the `.DS_Store` file of your `pdf` folder. Run in your terminal the following commands :
  
  - Go to your folder.
   ```
   cd YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/4_GROBID/toyData/dataset/dictionary-segmentation/corpus/pdf 
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

## Train a model with PDF files

### Level 1 : Dictionary segmentation

**1.** Synchronise the right train set.
``` 
docker run -v PATH_TO_YOUR_FOLDER/ArtlasCatalogues/4_GROBID/trainingData_NAME_OF_THE_DATASET/toyData:/grobid/grobid-dictionaries/resources -p 8080:8080 -it medkhem/grobid-dictionaries-stable bash
```

**2.** Create the training data.
```
java -jar /grobid/grobid-dictionaries/target/grobid-dictionaries-0.5.4-SNAPSHOT.one-jar.jar -dIn resources/dataset/dictionary-segmentation/corpus/pdf/  -dOut resources -exe createTrainingDictionarySegmentation
```

This command will create 5 different files (`.css`, `.rng`, `.xml`, `.rawtxt` and `.training.dictionarySegmentation`) in the `toyData` folder.

**3.** Annotate the XML-TEI file(s).

- Open the `.xml` file in Oxygen. 
- Click on the `Auteur` tab and select `Toutes les balises avec attributs` on the upper left-hand corner.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-4.png" width="60%"></p>

- Then annotate the file with the `<headnote>`, `<body>` and `<footnote>` tags. Select the text you want to annotate, type `cmd + E` and choose the corresponding tag.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-5.png" width="60%"></p>

**4.** Move the training files in the corresponding folder of the `dataset/dictionary-segmentation/corpus` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.
- Move the `.rawtxt` and `.training.dictionarySegmentation` files in the `raw` folder.

**5.** Move the evaluation files in the corresponding folder of the `dataset/dictionary-segmentation/evaluation` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.

**6.** Run the learning process
```
mvn generate-resources -P train_dictionary_segmentation -e
```

### Level 2 : Dictionary body segmentation

**1.** Create the training data.
```
java -jar /grobid/grobid-dictionaries/target/grobid-dictionaries-0.5.4-SNAPSHOT.one-jar.jar -dIn resources/dataset/dictionary-segmentation/corpus/pdf/  -dOut resources -exe createTrainingDictionaryBodySegmentation
```

This command will create 5 different files (`.css`, `.rng`, `.xml`, `.rawtxt` and `.dictionaryBodySegmentation`) in the `toyData` folder.

**2.** Annotate the XML-TEI file(s).

- Open the `.xml` file in Oxygen. 
- Click on the `Auteur` tab and select `Toutes les balises avec attributs` on the upper left-hand corner.
- Then annotate the file with the `<entry>` tag. Select the text you want to annotate, type `cmd + E` and choose the corresponding tag.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-6.png" width="60%"></p>

**3.** Move the training files in the corresponding folder of the `dataset/dictionary-body-segmentation/corpus` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.
- Move the `.rawtxt` and `.dictionaryBodySegmentation` files in the `raw` folder.

**4.** Move the evaluation files in the corresponding folder of the `dataset/dictionary-body-segmentation/evaluation` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.

**5.** Run the learning process
```
mvn generate-resources -P train_dictionary_body_segmentation -e
```

### Level 3 : Lexical entry

**1.** Create the training data.
```
java -jar /grobid/grobid-dictionaries/target/grobid-dictionaries-0.5.4-SNAPSHOT.one-jar.jar -dIn resources/dataset/dictionary-segmentation/corpus/pdf/  -dOut resources -exe createTrainingLexicalEntry
```

This command will create 5 different files (`.css`, `.rng`, `.xml`, `.rawtxt` and `.lexicalEntry`) in the `toyData` folder.

**2.** Annotate the XML-TEI file(s).

- Open the `.xml` file in Oxygen. 
- Click on the `Auteur` tab and select `Toutes les balises avec attributs` on the upper left-hand corner.
- Then annotate the file with the `<lemma>` and `<sense>` tags. Select the text you want to annotate, type `cmd + E` and choose the corresponding tag.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-7.png" width="60%"></p>

**3.** Move the training files in the corresponding folder of the `dataset/lexical-entry/corpus` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.
- Move the `.rawtxt` and `.lexicalEntry` files in the `raw` folder.

**4.** Move the evaluation files in the corresponding folder of the `dataset/lexical-entry/evaluation` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.

**5.** Run the learning process
```
mvn generate-resources -P train_lexicalEntries -e
```

### Level 4 : Form

**1.** Create the training data.
```
java -jar /grobid/grobid-dictionaries/target/grobid-dictionaries-0.5.4-SNAPSHOT.one-jar.jar -dIn resources/dataset/dictionary-segmentation/corpus/pdf/  -dOut resources -exe createTrainingForm
```

This command will create 5 different files (`.css`, `.rng`, `.xml`, `.rawtxt` and `.training.form`) in the `toyData` folder.

**2.** Annotate the XML-TEI file(s).

- Open the `.xml` file in Oxygen. 
- Click on the `Auteur` tab and select `Toutes les balises avec attributs` on the upper left-hand corner.
- Then annotate the file with the `<name>` and `<desc>` tags. Select the text you want to annotate, type `cmd + E` and choose the corresponding tag.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-8.png" width="60%"></p>

**3.** Move the training files in the corresponding folder of the `dataset/form/corpus` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.
- Move the `.rawtxt` and `.training.form` files in the `raw` folder.

**4.** Move the evaluation files in the corresponding folder of the `dataset/form/evaluation` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.

**5.** Run the learning process
```
mvn generate-resources -P train_form -e
```

### Level 5 : Sense

**1.** Create the training data.
```
java -jar /grobid/grobid-dictionaries/target/grobid-dictionaries-0.5.4-SNAPSHOT.one-jar.jar -dIn resources/dataset/dictionary-segmentation/corpus/pdf/  -dOut resources -exe createTrainingSense
```

This command will create 5 different files (`.css`, `.rng`, `.xml`, `.rawtxt` and `.training.sense`) in the `toyData` folder.

**2.** Annotate the XML-TEI file(s).

- Open the `.xml` file in Oxygen. 
- Click on the `Auteur` tab and select `Toutes les balises avec attributs` on the upper left-hand corner.
- Then annotate the file with the `<num>`, `<subSense>` and `<note>` tags. Select the text you want to annotate, type `cmd + E` and choose the corresponding tag.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-9.png" width="60%"></p>

**3.** Move the training files in the corresponding folder of the `dataset/sense/corpus` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.
- Move the `.rawtxt` and `.training.sense` files in the `raw` folder.

**4.** Move the evaluation files in the corresponding folder of the `dataset/sense/evaluation` folder.
- Move the `.xml` file in the `tei` folder.
- Move the `.css` and `.rng` files in the `css/rng` folder.

**5.** Run the learning process
```
mvn generate-resources -P train_sense -e
```
