import lxml.etree as etree
import sys, argparse
import re


########### récupération du chemin du fichier #######################

fichier = sys.argv[1] #'ALTO_demo.xml' #'1885_12_RDA_N095-1.xml'  # '1871_08_RDA_N028-1.xml'
 
########### récupération du dpi #######################

# dpi = int(sys.argv[2]) # 254

########### récupération du nom du fichier #######################

pattern = r'[^/]+$'
p = re.compile(pattern)
result = p.search(fichier)
fileName = result.group().zfill(8)

##################################################################


parser_XML = etree.XMLParser(remove_blank_text=True) # </Styles> - la nouvelle ligne - <Tags/> - l'indentation  
tree = etree.parse(fichier,parser_XML)
root = tree.getroot()

############## ajout des namespaces et des méta-données dans l'en-tête ##############

 
sourceImageInformationText = """
      <sourceImageInformation>
         <fileName>{}</fileName>
      </sourceImageInformation>
""".format(fileName)

processingSoftwareText = """
            <processingSoftware>
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
<Styles>
     <TextStyle ID="FONT0" 
                FONTSTYLE=""/>
     <TextStyle ID="FONT1"
                FONTSTYLE="bold"/>
     <TextStyle ID="FONT2"
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

                    

####### Correction des balises pleines dans les fichiers ALTO-XML ##########
patt_b_open = r'([ <](([< ])*b([ >])*)+[>])|([<](([< ])*b([ >])*)+[ >])|(^(([< ])*b([ >])*)+[>])|[ <b>]*<[ <b>]*b([ <b>]*>[ <b>]*)*|(?<=[(b>)])b>'
patt_i_open = r'([ <](([< ])*i([ >])*)+[>])|([<](([< ])*i([ >])*)+[ >])|(^(([< ])*i([ >])*)+[>])|[ <i>]*<[ <i>]*i([ <i>]*>[ <i>]*)*|(?<=[(i>)])i>'
patt_b_closed = r'(([<]*[ ]*[\/][ ]*b([ >])*)+[ >.,;])|(([<]*[ ]*[\/][ ]*b([ >])*)+$)|[ <b>]*<[ <b>]*[\/]b([ <b>]*>[ <b>]*)*|(?<=[(b>)])\/b>'
patt_i_closed = r'(([<]*[ ]*[\/][ ]*i([ >])*)+[ >.,;])|(([<]*[ ]*[\/][ ]*i([ >])*)+$)|[ <i>]*<[ <i>]*[\/]i([ <i>]*>[ <i>]*)*|(?<=[(i>)])\/i>'
pattern_regex_gen = re.compile(r'([<]+([<]*[ ]*[/]*[bi]*[ ]*[>]*)*)|(([<]*[ ]*[/]*[bi]*[ ]*[>]*)*[>]+)')

###### Correction des balises vides #######                
def reco_balise(string_content,span):
    a,b = span
    if r'<b>' in string_content[a:b]:
        return 'open_b'
    elif r'<i>' in string_content[a:b]:
        return 'open_i'
    elif r'</b>' in string_content[a:b]:
        return 'close_b'
    elif r'</i>' in string_content[a:b]:
        return 'close_i'
    else:
        return 'other'
        

for page in root[3].iter('{http://www.loc.gov/standards/alto/ns-v2#}Page'):
    for printspace in page.findall('{http://www.loc.gov/standards/alto/ns-v2#}PrintSpace'):
        for textblock in printspace.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextBlock'):
            for textline in textblock.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextLine'):
                count = 0
                for string in textline.findall('{http://www.loc.gov/standards/alto/ns-v2#}String'):
                    count += 1
                    # Correction des balises pleines
                    if re.search(patt_b_open,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_b_open,'<b>',string.attrib['CONTENT'])
                        #print(string.attrib['CONTENT'])
                    if re.search(patt_i_open,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_i_open,'<i>',string.attrib['CONTENT'])
                        #print(string.attrib['CONTENT'])
                    if re.search(patt_b_closed,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_b_closed,'</b>',string.attrib['CONTENT'])
                       #print(string.attrib['CONTENT'])
                    if re.search(patt_i_closed,string.attrib['CONTENT']): 
                        string.attrib['CONTENT'] = re.sub(patt_i_closed,'</i>',string.attrib['CONTENT'])
                        #print(string.attrib['CONTENT'])

                ###### Correction des balises vides #######        
                count = 0
                liste_balises_ligne = []
                for string in textline.findall('{http://www.loc.gov/standards/alto/ns-v2#}String'):
                    string_content = string.attrib['CONTENT']
                    matches_balises = pattern_regex_gen.finditer(string_content) # itérateur
                    for match in matches_balises:
                        span = match.span()
                        res = [count, span, reco_balise(string_content,span)]
                        liste_balises_ligne.append(res)
                    count += 1
                long_string = len(liste_balises_ligne)
                #print(liste_balises_ligne)
                for i, l in enumerate(liste_balises_ligne):
                    if l[2] == "other":
                        if i >= 1 and liste_balises_ligne[i-1][2] == 'open_b':
                            k = l[0]
                            a,b = l[1]
                            string_content = textline[2*k].attrib['CONTENT']
                            string_content_cor = string_content
                            N = len(string_content)
                            string_content_cor = string_content_cor[:-(N-a)] + '</b>' + string_content[b:]
                            textline[2*k].attrib['CONTENT'] = string_content_cor
                        elif i >= 1 and liste_balises_ligne[i-1][2] == 'open_i':
                            k = l[0]
                            a,b = l[1]
                            string_content = textline[2*k].attrib['CONTENT']
                            string_content_cor = string_content
                            N = len(string_content)
                            string_content_cor = string_content_cor[:-(N-a)] + '</i>' + string_content[b:]
                            textline[2*k].attrib['CONTENT'] = string_content_cor                   
                        elif i < long_string - 1 and liste_balises_ligne[i+1][2] == 'close_b':
                            k = l[0]
                            a,b = l[1]
                            string_content = textline[2*k].attrib['CONTENT']
                            string_content_cor = string_content
                            N = len(string_content)
                            string_content_cor = string_content_cor[:-(N-a)] + '<b>' + string_content[b:]
                            textline[2*k].attrib['CONTENT'] = string_content_cor
                        elif i < long_string - 1 and liste_balises_ligne[i+1][2] == 'close_i':
                            k = l[0]
                            a,b = l[1]
                            string_content = textline[2*k].attrib['CONTENT']
                            string_content_cor = string_content
                            N = len(string_content)
                            string_content_cor = string_content_cor[:-(N-a)] + '<i>' + string_content[b:]
                            textline[2*k].attrib['CONTENT'] = string_content_cor
                        


#### Application des trois styles (FONT0, FONT1, FONT2) à tous les éléments <String>	######

for page in root[3].iter('{http://www.loc.gov/standards/alto/ns-v2#}Page'):
    for printspace in page.findall('{http://www.loc.gov/standards/alto/ns-v2#}PrintSpace'):
        for textblock in printspace.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextBlock'):
            for textline in textblock.findall('{http://www.loc.gov/standards/alto/ns-v2#}TextLine'):
                start_b = False
                start_i = False
                for string in textline.findall('{http://www.loc.gov/standards/alto/ns-v2#}String'):
                    string.set('STYLEREFS', 'FONT0')
                    if '<b>' in string.attrib['CONTENT']:
                        start_b = True
                        string.attrib['CONTENT'] = string.attrib['CONTENT'].replace('<b>', '')
                    elif '<i>' in string.attrib['CONTENT']:
                        start_i = True
                        string.attrib['CONTENT'] = string.attrib['CONTENT'].replace('<i>', '')
                    if start_b == True:
                        string.set('STYLEREFS', 'FONT1')
                    if start_i == True:
                        string.set('STYLEREFS', 'FONT2')
                    if '</b>' in string.attrib['CONTENT']:
                        start_b = False
                        string.attrib['CONTENT'] = string.attrib['CONTENT'].replace('</b>', '')
                    elif '</i>' in string.attrib['CONTENT']:
                        start_i = False
                        string.attrib['CONTENT'] = string.attrib['CONTENT'].replace('</i>', '')

###### Conversion mm10 en pixels #######

##liste_attribut = ["HPOS", "VPOS", "HEIGHT", "WIDTH"]
##for elt in root.iter():
##    dic = elt.attrib
##    for l in liste_attribut:
##        if l in dic.keys():
##            mm10 = dic[l]
##            pixels = str(int(mm10) * dpi / 254)
##            elt.set(l, pixels)

tree.write(fileName + '_trans.xml', encoding='utf8', pretty_print=True)
