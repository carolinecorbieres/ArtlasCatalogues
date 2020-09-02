# Automatic tag verification and correction

### Introduction

The current OCR model is tested on the _in-domain_ file from the RDA catalogue (`1871_08_RDA_N028-1.png`).

The imperfect OCR results (including the typographical information represented by the `<b>`, `</b>`, `<i>`, and `</i>` tags) is in the `Pour_les_tests.txt` file (sample output below):

```
5
6
7


<b>Août 1874..
<b>N° 28</b>
REVUE
DES
JUAUS
<b>LAHS</b>
<b>DES CURIOSITÉS DE L'HISTOIRE & DE LA BIOGRAPHE</b>
PARAISSANT CHAQUE MOIS, SOUS LA DIRECTION DE
<b>GABRIEL CHARAVAY</b>
<b>ABONNEMENTS</>:
< <b>BUREAUX:</
France, un an (12 Numéros) 3 fr.
GO, rue Saint-Andre-des Arts
Etranger...... 4
<b>UN NUMÉRO: 25 CENTIMES</b>
<b>LETTRES AUTOGRAPHES/b>
A PRIX MARQUÉS
En vente chez Gabriel CHARAVAY,</b> expert,
rue Saint-André-des-Arts, 60.
1
<b>Abington</b> (Miss Frances), l’une des plus célèbres comédiennes
du Théâtre anglais. — L. a. sig., (à la 3e pers.), au dessinateur
Cosway, 2 p. in-8, avec son portrait dessiné par Cosway. 3 »
2 <b>Achard</b> (P.-Fréd.), spirituel acteur comique, né à Lyon. — L.
D</i
a. s., 1845, 1 p. in-8.
...
```

### Tasks

##### Tag verification

1. Check automatically the well-formedness of the  `<b>`, `</b>`, `<i>`, `</i>` tags, whether any open tag is closed, and if the order of the tags is correct. 

   The Python quality control script for the output tags `score_and_correct.py` is written for that purpose.

2. Indicate the problems that cannot be solved automatically, *i.e.* the examples requiring manual correction:
   *e.g.*: `<>foo</>`

3. Calculate the score which evaluates the overall OCR performance.

##### Corrections

* Correct automatically the malformed ALTO-XML files exported from Transkribus (word-level), before transforming them into the ALTO-XML files which could be accepted by the GROBID dictionaries (for the latter procedure, cf. [here](https://github.com/ljpetkovic/OCR-cat/tree/master/ALTO_XML_trans) and [here](https://github.com/ljpetkovic/OCR-cat/tree/master/ALTO_XML_trans/scripts)).

### Method 

Create regex in a fairly flexible format allowing to find *a priori* all the tags' anomalies with the following rule:

We consider that we are dealing with such a tag if we have a character string containing at most only the characters: `SPACE`, `<`, `{bi}`, `/`, `>`,
and containing at least either 

*  `<{bi}`
* `{bi}>`
* `</{bi}` 
*  `/{bi}>`

in order to correct errors such as: 

* `< b>`, `< <b>`, `<b<b>`, `<<b>`, `<< b >>>`, `<b`, `<   b `, `<b `, `b>`, ` b>`, ` b >` (opening tags) etc., into `<b>` and
* `</b>`, `<</b>`, `< / b>`, `/b>`, `/ b>>>`, `/ b >`, `/ b>`, `</b`, `/b>`, `/ b` (closing tags) etc., into `</b>`;

The same applies to the malformed `<i>` `</i>` tags.

### Workflow

1. define regex patterns for the opening and closing tags;
2. find the correct tags;
3. find the incorrect tags by ignoring the correct tags;
4. find the lines not containing any tag;
5. check the number of opening/closing tags;
6. check the opening/closing tags' order;
7. correct the tags if needed;
8. indicate the cases in which manual intervention is needed;
9. output the results.


### Output description

When you run the script, you need to specify the file and the number of lines you wish to evaluate (if you want to process the whole file, type `all`):

```
Donner le nom du fichier à traiter : Pour_les_tests.txt
Nombre de lignes à traiter (taper all pour tout le texte) : 105
```

 The programme output is in the format of three columns:

* the 1<sup>st</sup> column is the original text line;
* the 2<sup>nd</sup> is the number indicating the possible tag scenarios (cf. below);
* the 3<sup>rd</sup> could be either the error signalisation or the suggestion of the correction. 

The possible code's outputs (corresponding to the situation after the possible correction) for the initially well-formed tags:<br><br>
**0**: line with no tags, no error message;<br>
**1**: well-formed tags, respecting the order of opening and closing tags (including the original tag well-formedness and the well-formedness resulting from the corrections by the programme), no error message;<br>
**2**: well-formed tags, there are as many opening as closing tags, but the tag order is not respected, message error `WRONG TAG ORDER`;<br>
**3**: well-formed tags, but the number of opening and closing tags is not the same, message error `MISSING TAGS`;<br>
<br>
In the case of the initially malformed tags, the output of the corrected line is generated instead of the message errors :<br><br>
**1**: well-corrected tags, no message error, output of the corrected line;<br>
**2**: well-formed tags, no message error, output of the corrected line;<br>
**3**: no message error, output of the corrected line;<br>
**4**: there is at least potentially one erroneous tag which could not be corrected, no message error, output of the corrected line.<br>

Output for the first 105 lines:

```
5                                                                             | 0 | 
6                                                                             | 0 | 
7                                                                             | 0 | 
                                                                              |   | 
                                                                              |   | 
<b>Août 1874..                                                                | 3 |  BALISES MANQUANTES
<b>N° 28</b>                                                                  | 1 | 
REVUE                                                                         | 0 | 
DES                                                                           | 0 | 
JUAUS                                                                         | 0 | 
<b>LAHS</b>                                                                   | 1 | 
<b>DES CURIOSITÉS DE L'HISTOIRE & DE LA BIOGRAPHE</b>                         | 1 | 
PARAISSANT CHAQUE MOIS, SOUS LA DIRECTION DE                                  | 0 | 
<b>GABRIEL CHARAVAY</b>                                                       | 1 | 
<b>ABONNEMENTS</>:                                                            | 1 |  <b>ABONNEMENTS</b> :

< <b>BUREAUX:</                                                               | 1 |  <b>BUREAUX:</b> 

France, un an (12 Numéros) 3 fr.                                              | 0 | 
GO, rue Saint-Andre-des Arts                                                  | 0 | 
Etranger...... 4                                                              | 0 | 
<b>UN NUMÉRO: 25 CENTIMES</b>                                                 | 1 | 
<b>LETTRES AUTOGRAPHES/b>                                                     | 1 |  <b>LETTRES AUTOGRAPHES</b> 

A PRIX MARQUÉS                                                                | 0 | 
En vente chez Gabriel CHARAVAY,</b> expert,                                   | 3 |  BALISES MANQUANTES
rue Saint-André-des-Arts, 60.                                                 | 0 | 
1                                                                             | 0 | 
<b>Abington</b> (Miss Frances), l’une des plus célèbres comédiennes           | 1 | 
du Théâtre anglais. — L. a. sig., (à la 3e pers.), au dessinateur             | 0 | 
Cosway, 2 p. in-8, avec son portrait dessiné par Cosway. 3 »                  | 0 | 
2 <b>Achard</b> (P.-Fréd.), spirituel acteur comique, né à Lyon. — L.         | 1 | 
D</i                                                                          | 3 | D</i> 

a. s., 1845, 1 p. in-8.                                                       | 0 | 
3                                                                             | 0 | 
<Achard</b> (Léon), célèbre ténor de l’Opéra-Comique, né à Lyon,              | 1 |  <b>Achard</b> (Léon), célèbre ténor de l’Opéra-Comique, né à Lyon,

fils du précédent. — L. a. s., 1 p. in-8.                                     | 0 | 
2                                                                             | 0 | 
4 <b>Adélaïde</b> (Louise-Thér.-Car.-Amélie), princesse de Saxe-Mei¬          | 1 | 
ningen, reine d’Angleterre, femme de Georges IV. — L. a, s.,                  | 0 | 
en anglais, à Alex. Vattemare, 7 juin 1838, 1 p. in-4, cach.                  | 0 | 
4                                                                             | 0 | 
»                                                                             | 0 | 
Gracteux remerciments à Vattemare, qui lui a communiqué sa collection d'auto¬ | 0 | 
grapbes et de dessins.                                                        | 0 | 
<b<b>Adelon</b> (N.-Philib.), savant médecin et physiologiste, né à           | 1 |  <b>Adelon</b> (N.-Philib.), savant médecin et physiologiste, né à

2                                                                             | 0 | 
»                                                                             | 0 | 
Dijon. — L. a. s., 1834, 1 p. 1/2 in-4.                                       | 0 | 
<b<b>Affo</b> (Ireneo), historien de Guastalla et de Parme. — L. a. s.        | 1 |  <b>Affo</b> (Ireneo), historien de Guastalla et de Parme. — L. a. s.

2 50                                                                          | 0 | 
au graveur Rosaspina; Parme, 1793, 1 p. in-4.                                 | 0 | 
<b>Agar</> (Mme), célèbre tragédienne. —                                      | 1 |  <b>Agar</b> (Mme), célèbre tragédienne. —

L. a. s., 1 p. in-8, relative                                                 | 0 | 
à une soiree de bienfaisance chez la princesse Mathilde. 3 »                  | 0 | 
                                                                              |   | 
                                                                              |   | 
8 <b>Ainsworth</b> (W. Harrison), célèbre romancier angl., imitateur          | 1 | 
                                                                              |   | 
                                                                              |   | 
heureux du genre d’Anne Radcliffe. — L. a. s., 1865, 4 p.                     | 0 | 
in-8. 2 50                                                                    | 0 | 
                                                                              |   | 
                                                                              |   | 
9 <b>Akakia</b> (Jean), médecin de Louis XIII, régent-doyen de la             | 1 | 
                                                                              |   | 
                                                                              |   | 
Faculté de Paris. — Quittance sig. sur vélin, 1619. 1 50                      | 0 | 
                                                                              |   | 
                                                                              |   | 
10 <b>Albani</b> (le card. Joseph), soupçonné de complicité dans l’assas¬     | 1 | 
                                                                              |   | 
                                                                              |   | 
sinat de Basseville, ministre de Pie VIII, musicien. — L. a. s.,              | 0 | 
en français; Rome, 1816, 1 p. 1/2 in-4. 3 »                                   | 0 | 
                                                                              |   | 
                                                                              |   | 
Relative à des marbres antiques que son fière voulait vendre à Paris.         | 0 | 
                                                                              |   | 
                                                                              |   | 
11 <b>Aleotti</b> (J.-B.), illustre architecte du XVIe siècle, constructeur   | 1 | 
                                                                              |   | 
                                                                              |   | 
du théâtre Farnèse, à Parme. — Fin d’un compte, sig., relatif                 | 0 | 
à la construction de la citadelle de Ferrare, 1 p. in-4,                      | 0 | 
oblong. 2 »                                                                   | 0 | 
                                                                              |   | 
                                                                              |   | 
12 <b>Alghisi</b> (Tommaso), chirurgien florentin, célèbre par ses            | 1 | 
travaux sur la lithotomie. — L. a. s., 1698, 1 p. in-f. 3 »                   | 0 | 
                                                                              |   | 
                                                                              |   | 
13 <b>Alizard</b> (Adolphe), célèbre chanteur du grand Opéra. — L. a. s.;     | 1 | 
                                                                              |   | 
                                                                              |   | 
Bruxelles, 1843, 2 p. in-8. 2 »                                               | 0 | 
                                                                              |   | 
                                                                              |   | 
14 <b>Allan</b> (Louise), une des plus célèbres comédiennes du Théâtre        | 1 | 
                                                                              |   | 
                                                                              |   | 
français. — L. a. s., 1848, 1 p. in-8. 2 50                                   | 0 | 
                                                                              |   | 
                                                                              |   | 
15 <b>Allan</b> (A.), acteur comique du Gymnase, mari de la précédente.       | 1 | 
                                                                              |   | 
                                                                              |   | 
— L. a. s., 1/2 p. in-4. 5 4. 1 50                                            | 0 | 

```

### Statistics

| Code                           | Nº of occurrences | %     |
| ------------------------------ | ----------------- | ----- |
| 0 (lines with no tags)         | 45                | 42.86 |
| 1 (initially without problems) | 16                | 15.24 |

##### Initially well-formed tags, not correctable automatically (requiring manual correction)

| Code             | Nº of occurrences | %    |
| ---------------- | ----------------- | ---- |
| 2 (wrong order)  | 0                 | 0    |
| 3 (missing tags) | 2                 | 1.90 |

##### Initially malformed tags, correctable automatically

| Code                                                | Nº of occurrences | %    |
| :-------------------------------------------------- | ----------------- | ---- |
| 1 (well-corrected tags)                             | 7                 | 6.67 |
| 2 (well-formed tags, bad order)                     | 0                 | 0    |
| 3 (well-formed tags, missing tags)                  | 1                 | 0.95 |
| 4 (malformed tags, at least one is not correctable) | 0                 | 0    |

### Remarks

In order to avoid matching real words starting with `b` or `i` with an accidental `<` before (for example: `<boat`, 
`<in`), the regexes `[ <b>]*<[ <b>]*b([ <b>]*>[ <b>]*)*`, that is, `[ <i>]*<[ <i>]*i([ <i>]*>[ <i>]*)*)` should be tested beforehand. <br><br>
The same logic applies to the cases like `</bDES` or `</iDES`, in which the `[ <b>]*[]<[ <b>]*[\/]b([ <b>]*>[ <b>]*)*` and `[ <i>]*[]<[ <i>]*[\/]i([ <i>]*>[ <i>]*)*` should be tested. <br><br>
The script includes these regexes.<br>

We are not looking for the `/` in isolation, because of the presence of possible fractions (`1/2`).

This programme is supposed to generalise well in the cases of the individual tags `<b>text</b>` and `<i>text</i>`. <br>However, it does not take into account:

* the tags which could not be restored, because there are no indication whether they contain the `b` or `i` component: `<>unknown</>tag`;
* the nested tags (e.g. `<b><i>text</i></b>`, where the sequences `<b><i>` and `</i></b>` are treated as error).

Also:   

* `<b> </> < > </b>`  -------------> `<b> </b> <b> </b>` : can be corrected, no nested tags;
* `<b> < > < > </b>` --------------> `<b> < > <b> </b>` : corrected, but the original example is ambiguous (could be either `<b> </b> <b> </b>` or `<b> <i> </i> </b>`);
* `<b> < > </ > </b>` -------------> `<b> <> </> </b>`.  

### TO DO

* Correct automatically the malformed tags in the ALTO-XML files, and run the `corr_ALTO.sh` script (cf. [here](https://github.com/ljpetkovic/OCR-cat/tree/master/ALTO_XML_trans/scripts));
* Correct manually the text and the tags not recognised properly by the OCR model;
* Add more test data to check the generalisability of the code;