#!/bin/bash
echo ""
echo ""
echo "#################### Vérification et correction automatiques de balises #####################"
echo ""


echo "La sortie du programme est en trois colonnes : 
• la première colonne est la ligne originale, 
• la deuxième est un code de sortie
• la troisième est soit le signalement d'un problème soit la suggestion d'une correction
Codes de sorties possibles (correspondant à la situation après correction éventuelle):
0 : ligne sans balise
1 : les balises sont bien formées, et respectent la succession balises ouvrantes/balises
    fermantes
2 : les balises sont bien formées et il y a autant de balises ouvrantes que fermantes,
    mais l'alternance 'ouvrante/fermante' n'est pas respectée
3 : les balises sont bien formées mais il n'y a pas le même nombre de balises ouvrantes 
    et fermantes
4 : il y a au moins potentiellement une balise erronée qui n'a pas pu être corrigée."

echo "##########################################################################################"
echo ""
for f in /Users/carolinecorbieres/Desktop/OCR-cat/eval_txt/doc/Cat_Paris_1969.txt
do
	python3 /Users/carolinecorbieres/Desktop/OCR-cat/eval_txt/scripts/score_corr.py $f

done
