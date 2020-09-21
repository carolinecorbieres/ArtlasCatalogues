# ArtlasCatalogues/1_ImportCatalogues

---

# Step 1 : Import catalogue pages or PDF

To process catalogues into the workflow, we need to import catalogue pages. For the use of the OCR software, it is better to have high resolution images but it also works with PDF documents. 

## Digitised Catalogues

### Catalogue Images using IIIF

If the digitised catalogue have images using IIIF, you can get image pages thanks to the script `import_iiif.py`. Its arguments are based on the URI Manifest model : `{scheme}://{host}/{prefix}/{identifier}/manifest`. The default arguments are set on the Gallica IIIF API, however you can change that to adapt them to any IIIF API. 

**1.** If you want to download a catalogue from Gallica, run in the terminal the following commands : 

- Go to your folder.
```
cd YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/1_ImportCatalogues
```
- Copy the ark identifier of the catalogue in Gallica. 

<p align="center"><img src="https://github.com/carolinecorbieres/ArtlasCatalogues/blob/master/images/ImportCatalogues-1.png" width="70%"></p>

- Run the script with the ark identifier argument. If you need some help, you can run the script with `-h` argument. 
```
python import_iiif.py ark:/ARK_INDENTIFIER
```

- The script will download pages in JPEG in a `download/IDENTIFIER_NAME` folder. 

**2.** If you want to download a catalogue from another IIIF API, run in the terminal the following commands :

- Go to your folder.
```
cd YOUR_PATH_TO_THE_FOLDER/ArtlasCatalogues/1_ImportCatalogues
```
- Find the IIIF manifest of the catalogue, for example : https://bibliotheque-numerique.inha.fr/iiif/21124/manifest.

- Run the script by substitute Gallica arguments for the corresponding arguments of the URI. If you need some help, you can run the script with `-h` argument. 
```
python import_iiif.py -s SCHEME -d DOMAIN -p PREFIX IDENTIFIER -m MANIFEST
```

You can call any argument with the following prefix : 
  - `-s` to substitute the scheme of the URI, by default it is `https`
  - `-d` to substitute the domain (hostname) of the URI, by default it is `gallica.bnf.fr`
  - `-p` to substitute the prefix of the URI, by default it is `iiif`
  - `-m` to substitute the manifest name of the URI, by default it is `manifest.json`
  - You always must indicate the identifier argument. 
  

For example, for the following URI (https://bibliotheque-numerique.inha.fr/iiif/21124/manifest), you should run : 
```
python import_iiif.py -d bibliotheque-numerique.inha.fr 21124 -m manifest
```

- The script will download pages in JPEG in a `download/IDENTIFIER_NAME` folder.

**3.** Create a folder for the catalogue named `exhibCat_NAME_OF_THE_CATALOGUE` in `Catalogues` folder. The name of the catalogue takes 3 arguments : the date, the location and the name of the exhibition. Here are some examples : `exhibCat_1892_Paris_SocieteArtistesIndependants`, `exhibCat_1921_TheHague_ExpositionHollandaise` and `exhibCat_1965_Paris_Biennale`.

**4.** When you have all your pages in JPEG, you can move them in a `JPG` folder that you create in the corresponding `exhibCat_NAME_OF_THE_CATALOGUE` folder.

### PDF Catalogue

If the digitised catalogue only exists in PDF : 

**1.** Import the PDF. 

**2.** Create a folder for the catalogue named `exhibCat_NAME_OF_THE_CATALOGUE` in `Catalogues` folder. The name of the catalogue takes 3 arguments : the date, the location and the name of the exhibition. Here are some examples : `exhibCat_1892_Paris_SocieteArtistesIndependants`, `exhibCat_1921_TheHague_ExpositionHollandaise` and `exhibCat_1965_Paris_Biennale`.

**3.** Move the file in a `PDF` folder that you create in the corresponding `exhibCat_NAME_OF_THE_CATALOGUE` folder. 

## Non digitised Catalogues

If you need to process a non digitised catalogue :  

**1.** Check with the institution if they have JPEG images of the pages or a PDF version of the catalogue and if they could give you a copy. 

**2.** If they don't, you must scan or take photos of the pages. It is important to handle page by page and to pay attention to the quality of the photo (it should not be curve).

**3.** Create a folder for the catalogue named `exhibCat_NAME_OF_THE_CATALOGUE` in `Catalogues` folder. The name of the catalogue takes 3 arguments : the date, the location and the name of the exhibition. Here are some examples : `exhibCat_1892_Paris_SocieteArtistesIndependants`, `exhibCat_1921_TheHague_ExpositionHollandaise` and `exhibCat_1965_Paris_Biennale`.

**4.** When you have all your pages in JPEG or PDF, you can move them in a `JPG` or `PDF` folder that you create in the corresponding `exhibCat_NAME_OF_THE_CATALOGUE` folder. 

