# ArtlasCatalogues/4_GROBID

---

# Step 4 : Using GROBID-dictionaries to automatically encode exhibition catalogues

GROBID-dictionaries is a machine learning software for structuring in XML-TEI digitised documents like lexical ressources, dictionaries and bibliographies. We also use it to encode in XML-TEI [sale catalogues](https://github.com/katabase/GROBID_Dictionaries) and exhibition catalogues. 

## Choose the right train set

To encode a catalogue, you need to choose the train set that matches your catalogue. For now, we only have few train sets but you can train some more and add them here.

### When to choose the trainingData_INDEPENDANTS train set ? 

If the entries of your exhibition catalogue are the same as the _Catalogue de la société des artistes indépendants_ , you can choose this train set for using GROBID-dictionaries. You need to pay attention to following typographical details :
- the exhibitor name is in capital;
- his adress is separated from the rest of the biographical informations by an underscore;
- the number of each exhibited work is in bold. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-1.png" width="50%"></p>

The train set contains extracted data from several catalogues of the _Société des artistes indépendants_ (1890, 1892, 1913, 1923). 

### When to choose the trainingData_BIENNALE train set ? 

If the entries of your exhibition catalogue are the same as the _Catalogue de la Biennale de Paris_ , you can choose this train set for using GROBID-dictionaries. You need to pay attention to following typographical details :
- the exhibitor name is in bold;
- the number of each exhibited work is in bold;
- some informations about the work are in parentheses. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-2.png" width="50%"></p>

The train set contains extracted data from several catalogues of the _Biennale de Paris_ (1961, 1965). 

## Encode a catalogue

### Prerequisites

To use GROBID-dictionaries, you need to install Docker. You can download it [here](https://www.docker.com/). 

Then you need to download GROBID-dictionaries. Run in your terminal the following command : 
``` 
docker pull medkhem/grobid-dictionaries-stable
```

### Run the train set 

To run the trainings, you need to run in your terminal the following commands :

**1.** Synchronise the right train set.
``` 
docker run -v PATH_TO_YOUR_FOLDER/ArtlasCatalogues/4_GROBID/trainingData_NAME_OF_THE_DATASET/toyData:/grobid/grobid-dictionaries/resources -p 8080:8080 -it medkhem/grobid-dictionaries-stable bash
```

Now, your terminal must start with something like that `root@ef0ec5b02e82:/grobid/grobid-dictionaries#`. 

**2.** Run the learning process, one after another.

- Dictionary segmentation : 
```
mvn generate-resources -P train_dictionary_segmentation -e
```
- Dictionary body segmentation :
```
mvn generate-resources -P train_dictionary_body_segmentation -e
```
- Lexical entry : 
```
mvn generate-resources -P train_lexicalEntries -e
```
- Sense : 
```
mvn generate-resources -P train_form -e
```
- Form :
```
mvn generate-resources -P train_sense -e
```

Now you trained all the levels of the model, you can run the web app to encode your catalogue. 

### Run the web app

**1.** Run in the terminal the following command : 
```
mvn -Dmaven.test.skip=true jetty:run-war
```

**2.** When you read `[INFO] Started Jetty Server` in your terminal, go to the localhost : [http://localhost:8080/](http://localhost:8080/)

**3.** Upload your catalogue. 

- In the `Dictionary services` tab, select `Parse full dictionary`.
- Upload your catalogue (in PDF).
- Click on `Envoyer`.
- Click on `Download TEI Result`.

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/GROBID-3.png" width="60%"></p>

**4.** You can leave the localhost by typing in the terminal `ctrl + C`

**5.** Move the new TEI file in the `Catalogues/exhibCat_NAME_OF_THE_CATALOGUE/TEI`folder.

## Create and train a new model 

You can find [here](https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/4_GROBID/How_to_train_a_model.md) a guide to create new models and train existing ones in GROBID-dictionaries. 

## Credits and licence

GROBID-dictionaries is developed by Mohamed Khemakhem, you can find more informations about his work in his [GitHub](https://github.com/MedKhem/grobid-dictionaries). You also could find more informations on GROBID technologies [here](https://grobid.readthedocs.io/en/latest/).

You can find more informations about the licence of GROBID-dictionaries [here](https://github.com/MedKhem/grobid-dictionaries).
