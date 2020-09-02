import re
import lxml.etree as etree

###### créer l'objet XML

fichier = '1855_72_CHA_N53_0001.xml'
tree = etree.parse(fichier)
root = tree.getroot()


###### extraire les valeurs de l'attribut 'CONTENT'
with open(fichier[:-4]+'.txt', 'w') as o:
    for page in root[2].iter('{http://www.loc.gov/standards/alto/ns-v2#}Page'):
        for printspace in page.findall('{http://www.loc.gov/standards/alto/ns-v2#}PrintSpace'):
            for textblock in printspace.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextBlock'):
                for textline in textblock.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextLine'):

    ###### listes qui concatènent les mots de chaque ligne
                    l = []
                    for string in textline.findall('{http://www.loc.gov/standards/alto/ns-v2#}String'):
                        s = string.attrib['CONTENT']
                        l.append(s)
                    #print(l)


    ###### convertir la liste des mots en lignes de chaîne de caractères
                    #print(' '.join(l))
                    li = ' '.join(l)
                    #print(li)
                    
###### écrire dans un fichier
                
                    o.write(str(li) + '\n')
                    print(li)



########### récupération du nom du fichier #######################

pattern = r'[^/]+$'
p = re.compile(pattern)
result = p.search(fichier)
fileName = result.group()  

##################################################################


parser_XML = etree.XMLParser(remove_blank_text=True) # </Styles> - la nouvelle ligne - <Tags/> - l'indentation  
tree = etree.parse(fichier,parser_XML)
root = tree.getroot()

############## ajout des namespaces et des méta-données dans l'en-tête ##############

 
sourceImageInformationText = """
      <sourceImageInformation xmlns="http://www.loc.gov/standards/alto/ns-v2#">
         <fileName>{}</fileName>
      </sourceImageInformation>
""".format(fileName)

processingSoftwareText = """
            <processingSoftware xmlns="http://www.loc.gov/standards/alto/ns-v2#">
               <softwareCreator>CONTRIBUTORS</softwareCreator>
               <softwareName>pdfalto</softwareName>
               <softwareVersion>0.1</softwareVersion>
            </processingSoftware>
"""
sourceImageInformation = etree.fromstring(sourceImageInformationText)
processingSoftware = etree.fromstring(processingSoftwareText)
for processing_software in root[0][1]:
    for p in processing_software.findall('{http://www.loc.gov/standards/alto/ns-v2#}processingSoftware'):
        processing_software.remove(p)

    
root[0].insert(1, sourceImageInformation)
root[0][2][0].insert(1, processingSoftware)

#############   nettoyage du ficher des balises inutiles     ################

tag_a_supprimer = ['{http://www.loc.gov/standards/alto/ns-v2#}TopMargin',
                   '{http://www.loc.gov/standards/alto/ns-v2#}LeftMargin',
                   '{http://www.loc.gov/standards/alto/ns-v2#}RightMargin',
                   '{http://www.loc.gov/standards/alto/ns-v2#}BottomMargin']

for page in root[2].iter('{http://www.loc.gov/standards/alto/ns-v2#}Page'):
    for tag in tag_a_supprimer:
        for elem in page.findall(tag):
            page.remove(elem)
    for printspace in page.findall('{http://www.loc.gov/standards/alto/ns-v2#}PrintSpace'):
        for textblock in printspace.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextBlock'):
            for shape in textblock.findall('{http://www.loc.gov/standards/alto/ns-v2#}Shape'):
                textblock.remove(shape)

############    ajout d'une balise <Styles> avec les polices dans l'en-tête     ##########

stylesText = """
<Styles xmlns="http://www.loc.gov/standards/alto/ns-v2#">
     <TextStyle ID="FONT0"
                FONTFAMILY="unknown"
                FONTSIZE="unknown"
                FONTTYPE="unknown"
                FONTWIDTH="unknown"
                FONTCOLOR="unknown"
                FONTSTYLE=""/>
     <TextStyle ID="FONT1"
                FONTFAMILY="unknown"
                FONTSIZE="unknown"
                FONTTYPE="unknown"
                FONTWIDTH="unknown"
                FONTCOLOR="unknown"
                FONTSTYLE="bold"/>
     <TextStyle ID="FONT2"
                FONTFAMILY="unknown"
                FONTSIZE="unknown"
                FONTTYPE="unknown"
                FONTWIDTH="unknown"
                FONTCOLOR="unknown"
                FONTSTYLE="italics"/>
</Styles>
"""

styles = etree.fromstring(stylesText)
root.insert(1, styles)


#######  Récupération et création incrémentale des ID des éléments <String> à partir de l'ID des éléments <TextLine> #########

for page in root[3].iter('{http://www.loc.gov/standards/alto/ns-v2#}Page'):
    for printspace in page.findall('{http://www.loc.gov/standards/alto/ns-v2#}PrintSpace'):
        for textblock in printspace.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextBlock'):
            id_tex_block = textblock.attrib['ID']
            for textline in textblock.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextLine'):
                id_textline = textline.attrib['ID']
                for i, string in enumerate(textline.findall('{http://www.loc.gov/standards/alto/ns-v2#}String'),
                                           start=1):
                    string.set('ID', id_textline + "_{}".format(str(i)))


######### Fonctions ##############################

 

def regexbaliseouv(x):
    return r'([ <](([< ])*{0}([ >])*)+[>])|([<](([< ])*{0}([ >])*)+[ >])|(^(([< ])*{0}([ >])*)+[>])'.format(x) # x = 'b' ou 'i'

def regexbalisefer(x):
    return r'(([<]*[ ]*[/][ ]*{0}([ >])*)+[ >.,;])|(([<]*[ ]*[/][ ]*{0}([ >])*)+$)'.format(x)  # x = 'b' ou 'i'


def bonneBalises(ligne):
    L_bo_b = [] # liste des span des balises ouvrantes b ex : [(0,4),(19,22)]
    L_bf_b = [] # liste des span des balises fermantes b ex : [(6,10),(36,40)]
    L_bo_i = [] # liste des span des balises ouvrantes i ex : [(41,45),(70,74)]
    L_bf_i = [] # liste des span des balises fermantes i ex : [(60,64),(80,84)]
    pattern_bo_b = re.compile(r'<b>')   # pattern balise ouvrante correcte
    matches_bo_b = pattern_bo_b.finditer(ligne) # itérateur
    pattern_bf_b = re.compile(r'</b>')   # pattern balise fermante correcte
    matches_bf_b = pattern_bf_b.finditer(ligne)
    pattern_bo_i = re.compile(r'<i>')   # pattern balise ouvrante correcte
    matches_bo_i = pattern_bo_i.finditer(ligne) # itérateur
    pattern_bf_i = re.compile(r'</i>')   # pattern balise fermante correcte
    matches_bf_i = pattern_bf_i.finditer(ligne)
    for match in matches_bo_b:
        u = match.span()
        L_bo_b.append(u)
    for match in matches_bf_b:
        u = match.span()
        L_bf_b.append(u)
    for match in matches_bo_i:
        u = match.span()
        L_bo_i.append(u)
    for match in matches_bf_i:
        u = match.span()
        L_bf_i.append(u)
    ### On enlève toute les bonnes balises :
    ligne_test = re.sub(r'<b>', '', ligne)
    ligne_test = re.sub(r'</b>', '', ligne_test)
    ligne_test = re.sub(r'<i>', '', ligne_test)
    ligne_test = re.sub(r'</i>', '', ligne_test)
    ### Et on teste ce qui reste (ici présence de <, >) remarque : on ne cherche pas les / tous seuls, car présence de fractions éventuelles
    if re.search(r'[<>]',ligne_test):    
        return False,[]
    elif (len(L_bo_b) == len(L_bf_b)) and (len(L_bo_i) == len(L_bf_i)) and len(L_bo_b) == 0 and len(L_bo_i) == 0:  # cas où il s'agit d'une ligne a priori sans balise
        return True,[True]
    elif (len(L_bo_b) == len(L_bf_b)) and (len(L_bo_i) == len(L_bf_i)):
        return True, [L_bo_b,L_bf_b,L_bo_i,L_bf_i]  # bonnes balises et même nombre ouvrantes/fermantes
    else:
        return True, [False]   # bonnes balises mais pas le même nombre ouvrantes/fermantes

def verifEntrelacement(L_bo_b,L_bf_b,L_bo_i,L_bf_i):
    verif_b = [ u[1]<v[0] for u,v in zip(L_bo_b,L_bf_b)]
    verif_i = [ u[1]<v[0] for u,v in zip(L_bo_i,L_bf_i)]
    def not_between(Liste,Liste_o,Liste_f):
        return [ not ( u[1]<x[0] and x[1]<v[0]) for x in Liste for u,v in zip(Liste_o,Liste_f)]
    verif_bo_i = not_between(L_bo_b,L_bo_i,L_bf_i) # <b> ne doit pas etre entre <i> et </i>
    verif_bf_i = not_between(L_bf_b,L_bo_i,L_bf_i) # </b> ne doit pas etre entre <i> et </i>
    verif_io_b = not_between(L_bo_i,L_bo_b,L_bf_b) # <i> ne doit pas etre entre <b> et </b>
    verif_if_b = not_between(L_bf_i,L_bo_b,L_bf_b) # </i> ne doit pas etre entre <b> et </b>
    return all([all(verif_b), all(verif_i), all(verif_bo_i),all(verif_bf_i),all(verif_io_b),all(verif_if_b)])  # all(list) = True si et seulement tous les éléments de list sont True


def correctionBalisesPleines(ligne):
    ligne_corr = re.sub(regexbaliseouv('b'), r' <b>', ligne)
    ligne_corr = re.sub(regexbalisefer('b'), r'</b> ', ligne_corr)
    ligne_corr = re.sub(regexbaliseouv('i'), r' <i>', ligne_corr)
    ligne_corr = re.sub(regexbalisefer('i'), r'</i> ', ligne_corr)
    return ligne_corr


def correctionBalisesVides(ligne):
    corr_all = True
    ligne_corr = ligne
    N = len(ligne)
    L_balises = [] # liste des span de toutes les balises  
    pattern_regex_gen = re.compile(r'([<]+([<]*[ ]*[/]*[bi]*[ ]*[>]*)*)|(([<]*[ ]*[/]*[bi]*[ ]*[>]*)*[>]+)')
    matches_balises = pattern_regex_gen.finditer(ligne) # itérateur
    for match in matches_balises:
        u = match.span()
        L_balises.append(u)
    for i,u in enumerate(L_balises):
        a,b = u
        if not (r'<b>' in ligne[a:b] or r'</b>' in ligne[a:b] or r'<i>' in ligne[a:b] or r'</i>' in ligne[a:b]):
            if r'/' in ligne[a:b]: # cas d'une balise a priori fermante vide
                if i == 0: # cas ou la première des balises serait vide mais fermante
                    corr_all = False
                else:
                    prev_a,prev_b = L_balises[i-1]
                    if r'<b>' in ligne[prev_a:prev_b]:
                        ligne_corr = ligne_corr[:-(N-a)] + '</b> ' + ligne[b:]
                    elif r'<i>' in ligne[prev_a:prev_b]:
                        ligne_corr = ligne_corr[:-(N-a)] + '</i> ' + ligne[b:]
                    else:
                        corr_all = False
            else:  # cas d'une balise a priori ouvrante vide
                if i == len(L_balises)-1: # cas ou la dernière des balises serait vide mais ouvrante
                    corr_all = False
                else:
                    suiv_a,suiv_b = L_balises[i+1]
                    if r'</b>' in ligne[suiv_a:suiv_b]:
                        ligne_corr = ligne_corr[:-(N-a)] + ' <b>' + ligne[b:]
                    elif r'</i>' in ligne[suiv_a:suiv_b]:
                        ligne_corr = ligne_corr[:-(N-a)] + ' <i>' + ligne[b:]                    
                    else:
                        corr_all = False                   
    return corr_all, ligne_corr

#compte_0 = 0
#compte_1 = 0
#compte_2 = 0
#compte_3 = 0
compte_cor_1 = 0
compte_cor_2 = 0
compte_cor_3 = 0
#compte_cor_4 = 0

def affichage(ligne,parametres,max_taille):
    #global compte_0
    #global compte_1
    #global compte_2
    #global compte_3
    global compte_cor_1
    global compte_cor_2
    global compte_cor_3
    #global compte_cor_4
    bonneBalise,sans_balise,bon_nombre_balise,corr,corr_all,entrelacement = parametres
    l = ligne.strip()
    #if sans_balise:
       
        #if ligne.strip():
            #print(l+' '*(max_taille-len(l))+' | '+'0'+' | ')
            #compte_0 += 1
        #else:
            #print(l+' '*(max_taille-len(l))+' | '+' '+' | ')
    #else:
        #if not corr[0]:
            #if bonneBalise and entrelacement:
                #print(l+' '*(max_taille-len(l))+' | '+'1'+' | ')
                #compte_1 += 1
            #elif bonneBalise and bon_nombre_balise:
                #print(l+' '*(max_taille-len(l))+' | '+'2'+' | '+' PROBLEME ORDRE DES BALISES')
                #compte_2 += 1
            #elif bonneBalise:
                #print(l+' '*(max_taille-len(l))+' | '+'3'+' | '+' BALISES MANQUANTES')
                #compte_3 += 1
    if corr[1]:
        ligne_corr = corr[1]
        if bonneBalise and entrelacement:
            print(ligne_corr)
            compte_cor_1 += 1
        elif bonneBalise and bon_nombre_balise:
            print(ligne_corr)
            compte_cor_2 += 1
        else:
            print(ligne_corr)
            compte_cor_3 += 1
        #else:
            #print(l+' '*(max_taille-len(l))+' | '+'4'+' | '+ligne_corr)
            #compte_cor_4 += 1
                



######### Texte de description des sorties #######


with open("score_and_correct_description.txt") as myfile:
    f = myfile.read()
    print(f)


########## Importation des données ################

print('')
print('AVERTISSEMENT : Agrandir le shell au maximum!')

texte = input("Donner le nom du fichier à traiter : ") #Pour_les_tests.txt

total = input("Nombre de lignes à traiter (taper all pour tout le texte) : ")


print('')
print('########################################################################################################################################################################')
print('')

##if texte == 'fichier_demo.txt':
##    total = 16
##elif texte == 'Pour_les_tests.txt':
##    total = 300
##elif texte == "1855_72_CHA_N53_0001.txt":
##    total = 50


with open(texte) as myfile:
    if total != "all":
        total = int(total)
        head = [next(myfile) for x in range(total)]  # pour extraire seulement les 'total' premières lignes
    else:
        head = myfile.readlines()
        total = len(head)
    taille = [len(ligne) for ligne in head] # liste des longueurs des lignes
    max_taille = max(taille) - 1 # longueur de la ligne la plus longue
    #print(max_taille)

    


######### Corps du programme #####################

if __name__ == '__main__':
    for i,ligne in enumerate(head[:total]):
        corr = [False,[]]
        corr_all = None
        verif = bonneBalises(ligne)
        if verif[0] == False:
            corr[0] = True
            ligne_corr = correctionBalisesPleines(ligne)
            corr[1] = ligne_corr
            verif = bonneBalises(ligne_corr)
            if verif[0] == False:
                corr_all,ligne_corr = correctionBalisesVides(ligne_corr)
                corr[1] = ligne_corr
                verif = bonneBalises(ligne_corr)
        if verif[0] == False:
            bonneBalise = False
            sans_balise = False
            bon_nombre_balise = False
            entrelacement = False
        else:
            bonneBalise = True
            if len(verif[1]) == 1:
                if verif[1][0] == True:
                    sans_balise = True
                    bon_nombre_balise = True
                    entrelacement = True
                else:
                    sans_balise = False
                    bon_nombre_balise = False
                    entrelacement = False
            else:
                L_bo_b,L_bf_b,L_bo_i,L_bf_i = verif[1]
                entrelacement = verifEntrelacement(L_bo_b,L_bf_b,L_bo_i,L_bf_i)
                sans_balise = False
                bon_nombre_balise = True
        parametres = (bonneBalise,sans_balise,bon_nombre_balise,corr,corr_all,entrelacement)
        affichage(ligne,parametres,max_taille)
     
    total = compte_cor_1 + compte_cor_2 + compte_cor_3



    ################  Stat ######################

    print('\nSTATISTIQUE:\n____________\n',
          '### Initially malformed:\n',
          compte_cor_1,'Well-corrected tags, ', (compte_cor_1 / total) * 100,' %\n',
          compte_cor_2,'Well-formed tags, bad order, ', (compte_cor_2 / total) * 100,' %\n',
          compte_cor_3,'Well-formed tags, missing tags, ', (compte_cor_3 / total) * 100,' %\n')





####### Correction des balises pleines dans les fichiers ALTO-XML ##########
patt_b_open = r'([ <](([< ])*b([ >])*)+[>])|([<](([< ])*b([ >])*)+[ >])|(^(([< ])*b([ >])*)+[>])|[ <b>]*<[ <b>]*b([ <b>]*>[ <b>]*)*'
patt_i_open = r'([ <](([< ])*i([ >])*)+[>])|([<](([< ])*i([ >])*)+[ >])|(^(([< ])*i([ >])*)+[>])|[ <i>]*<[ <i>]*i([ <i>]*>[ <i>]*)*'
patt_b_closed = r'(([<]*[ ]*[\/][ ]*b([ >])*)+[ >.,;])|(([<]*[ ]*[\/][ ]*b([ >])*)+$)|[ <b>]*<[ \/<b>]*b([ <b>]*>[ <b>]*)*'
patt_i_closed = r'(([<]*[ ]*[\/][ ]*i([ >])*)+[ >.,;])|(([<]*[ ]*[\/][ ]*i([ >])*)+$)|[ <i>]*<[ \/<i>]*i([ <i>]*>[ <i>]*)*'

for page in root[3].iter('{http://www.loc.gov/standards/alto/ns-v2#}Page'):
    for printspace in page.findall('{http://www.loc.gov/standards/alto/ns-v2#}PrintSpace'):
        for textblock in printspace.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextBlock'):
            for textline in textblock.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextLine'):
                for string in textline.findall('{http://www.loc.gov/standards/alto/ns-v2#}String'):
                    if re.search(patt_b_open,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_b_open,'<b>',string.attrib['CONTENT'])
                        print(string.attrib['CONTENT'])
                    elif re.search(patt_i_open,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_i_open,'<i>',string.attrib['CONTENT'])
                        print(string.attrib['CONTENT'])
                    elif re.search(patt_b_closed,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_b_closed,'</b>',string.attrib['CONTENT'])
                        print(string.attrib['CONTENT'])
                    elif re.search(patt_i_closed,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_i_closed,'</i>',string.attrib['CONTENT'])
                        print(string.attrib['CONTENT'])
                        
              
                        
tree.write(fichier + '_trans.xml', encoding='utf8', pretty_print=True)

