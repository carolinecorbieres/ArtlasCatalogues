# ArtlasCatalogues/2_OCR

---

# Step 2 : OCR process on catalogues and export of the ALTO files

Now we need to process catalogues in a OCR software to get the text of the document. The transcription of each catalogue is augmented by typographical information : bold and italic words are tagged with HTML tags (`<b>`, `</b>`, `<i>` and `</i>`). Then we will used two scripts written by Ljudmila Petkovic, a first one ([1_eval_txt](https://github.com/carolinecorbieres/ArtlasCatalogues/tree/master/2_OCR/1_eval_txt)) to verify the well formation of the tag and another one ([2_ALTO_XML_trans](https://github.com/carolinecorbieres/ArtlasCatalogues/tree/master/2_OCR/2_ALTO_XML_trans)) to correct automatically the malformed tags and to transform the ALTO-XML files come from the OCR software. You can find her work [here](https://github.com/ljpetkovic/OCR-cat)

## OCR process

### Prerequisites

The following tutorial is using the Transkribus software. You can download it [here](https://transkribus.eu/Transkribus/) and have access to differents guides. 

### Run the OCR

First you need to run the Transkribus app and to log in. If you don't have a Transkribus account, you can register on the website.   

In Transkribus :

**1.** Select the `ArtlasCatalogues` collection. If you don't have access to it, you can contact Caroline Corbières at caroline.corbieres(at)chartes.psl.eu, she will give you an access to it. 

**IMAGE**

**2.** Import your catalogue in the collection. Go to `Document...` and click on `Import document to the server`.

**IMAGE**

- If you have JPEG images of your catalogue, choose `Upload single document` and add the path to your `exhibCat_NAME_OF_THE_CATALOGUE/JPG` folder you created before.

**IMAGE**

- If you have a PDF version of your catalogue, choose `Extract and upload images from pdf` and add the path to your `exhibCat_NAME_OF_THE_CATALOGUE/PDF` folder you created before.

**IMAGE**


## Tag verification and correction

## Transformation of the ALTO-XML files

## Thanks

Thanks to Ljudmila Petkovic for her work on the python scripts and for her explanations.
