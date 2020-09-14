<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Création d'une variable permettant de stocker le chemin jusqu'au dossier devant contenir les fichiers TEI générés automatiquement -->
    <xsl:variable name="dir">
        <xsl:text>./3-1_TEI-results_withoutManifests</xsl:text>
    </xsl:variable>

    <xsl:template match="root">
        <xsl:apply-templates select="row"/>
    </xsl:template>
    
    <!-- Template qui permet de générer un fichier TEI par "row" et de le nommer selon l'information indiquée dans "Nommage_fichier" -->
    <xsl:template match="row">
        <!-- Pour chaque "row" création d'une variable récupérant l'information contenue dans "Nommage_fichier"... -->
        <xsl:variable name="nameFolder">
            <xsl:value-of select="./Nommage_fichier"/>
        </xsl:variable>
        <!-- ...puis récupération en sortie du chemin stocké dans la variable $dir et du nom du fichier stocké dans la variable $nameFolder -->
        <xsl:result-document method="xml" href="{$dir}/{$nameFolder}_header.xml" indent="yes">
            <!-- Appel de la règle contenant le modèle de header -->
            <xsl:call-template name="header"/>
        </xsl:result-document>
    </xsl:template>

    <!-- Template du modèle de header (au sein duquel sont injectées les informations du CSV) -->
    <xsl:template name="header">
        <!-- Instruction de traitement XML qui permet d'associer chaque document à l'ODD -->
        <xsl:processing-instruction name="xml-model">
            <xsl:text>href="../../5_ImproveGROBIDoutput/ODD/ODD_VisualContagions.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
        </xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">
            <xsl:text>href="../../5_ImproveGROBIDoutput/ODD/ODD_VisualContagions.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
        </xsl:processing-instruction>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="file_name">
            <!-- Appel de la règle concernant l'attribut "xml:id" (même procédé réalisé pour les autres attributs) -->
            <xsl:call-template name="TEI_attribute"/>
            <!-- Création d'un commentaire devant apparaître dans le fichier TEI en sortie -->
            <xsl:comment> Le nom de chaque fichier est indiqué à l'emplacement "xml:id="file_name"" </xsl:comment>
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>
                            <!-- Chaque information du fichier source est ensuite copiée dans les balises correspondantes -->
                            <xsl:value-of select="Titre"/>
                        </title>
                        <editor role="metadata">
                            <persName>
                                <xsl:value-of select="Contributeur"/>
                            </persName>
                        </editor>
                        <editor role="data">
                            <persName>
                                <xsl:comment> Prénom et nom de la personne ayant encodé le corps du texte </xsl:comment>
                            </persName>
                        </editor>
                    </titleStmt>
                    <publicationStmt>
                        <publisher>
                            <name>VISUAL CONTAGIONS</name>
                            <persName type="director">Béatrice Joyeux-Prunel</persName>
                            <orgName>UNIGE</orgName>
                            <address>
                                <addrLine>Rue des Battoirs 7</addrLine>
                                <postCode>1205</postCode>
                                <settlement>Genève</settlement>
                            </address>
                        </publisher>
                        <date when="2020"/>
                        <availability>
                            <xsl:comment> Licence texte </xsl:comment>
                            <licence target="https://creativecommons.org/licenses/by/4.0/"
                                >CC-BY</licence>
                            <xsl:comment> Licence images </xsl:comment>
                            <licence>
                                <!-- Ajout d'une condition afin que l'attribut ne soit ajouté à la balise que s'il n'est pas vide
                                    (les autres conditions ci-dessous fonctionnent de la même manière) -->
                                <xsl:if test="descendant::Licence[text() != '']">
                                    <xsl:call-template name="licence_attribute"/>
                                </xsl:if>                                
                            </licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <bibl type="source_type">
                            <!-- Cet attribut contiendra toujours une valeur donc la mise en place d'une condition n'était pas requise -->
                            <xsl:call-template name="bibl_attribute"/>
                            <title>
                                <xsl:value-of select="Titre"/>
                            </title>
                            <author>
                                <xsl:value-of select="Auteur"/>
                            </author>
                            <editor>
                                <xsl:value-of select="Editeur_scientifique"/>
                            </editor>
                            <editor role="director">
                                <xsl:value-of select="Directeur"/>
                            </editor>
                            <publisher>
                                <xsl:value-of select="Editeur"/>
                            </publisher>
                            <pubPlace>
                                <xsl:value-of select="Lieu_publication_en"/>
                            </pubPlace>
                            <date>
                                <xsl:if test="descendant::Date_publication[text() != '']">
                                    <xsl:call-template name="pub_date_attribute"/>
                                </xsl:if>
                                <xsl:value-of select="Date_publication"/>
                            </date>
                            <date type="first_publication_number">
                                <xsl:if test="descendant::Annee_1er_numero[text() != '']">
                                    <xsl:call-template name="first_pub_attribute"/>
                                </xsl:if>
                                <xsl:value-of select="Annee_1er_numero"/>
                            </date>
                            <date type="last_publication_number">
                                <xsl:if test="descendant::Annee_dernier_numero[text() != '']">
                                    <xsl:call-template name="last_pub_attribute"/>
                                </xsl:if>
                                <xsl:value-of select="Annee_dernier_numero"/>
                            </date>
                            <relatedItem>
                                <xsl:comment> Localisation de l'original </xsl:comment>
                                <msDesc>
                                    <msIdentifier>
                                        <repository>
                                            <xsl:value-of select="Depot"/>
                                        </repository>
                                    </msIdentifier>
                                    <additional>
                                        <surrogates>
                                            <xsl:comment> Lien vers sa version numérisée </xsl:comment>
                                            <ref>
                                                <xsl:if test="descendant::Source_diffuseur[text() != '']">
                                                    <xsl:call-template name="digitised_version"/>
                                                </xsl:if>
                                            </ref>
                                            <name role="digitisation">
                                                <xsl:if test="descendant::Date_numerisation[text() != '']">
                                                    <xsl:call-template name="digitisation_date"/>
                                                </xsl:if>
                                                <xsl:value-of select="Numerise_par"/>
                                            </name>
                                        </surrogates>
                                    </additional>
                                </msDesc>
                            </relatedItem>
                            <extent>
                                <xsl:value-of select="Format"/>
                            </extent>
                            <note>
                                <xsl:value-of select="Notes_catalogue_expo"/>
                            </note>
                        </bibl>
                        <listEvent>
                            <xsl:comment> Concernant l'attribut "subtype" de la balise "event", indiquer "travelling" si l'exposition est itinérante, ou "fixed" si elle ne l'est pas </xsl:comment>
                            <event>
                                <xsl:if test="descendant::Type_evenement[text() != '']">
                                    <xsl:call-template name="event_type"/>
                                </xsl:if>
                                <xsl:if test="descendant::Exposition_itinerante[text() != '']">
                                    <xsl:call-template name="event_subtype"/>
                                </xsl:if>
                                <xsl:if test="descendant::Date_debut_exposition[text() != '']">
                                    <xsl:call-template name="event_from"/>
                                </xsl:if>
                                <xsl:if test="descendant::Date_fin_exposition[text() != '']">
                                    <xsl:call-template name="event_to"/>
                                </xsl:if>
                                <head>
                                    <xsl:value-of select="Titre_exposition"/>
                                </head>
                                <head>
                                    <xsl:if test="descendant::Type_groupe_expositions[text() != '']">
                                        <xsl:call-template name="exhib_group_type"/>
                                    </xsl:if>
                                    <xsl:value-of select="Titre_groupe_expositions"/>
                                </head>
                                <desc>
                                    <xsl:comment> Liste des lieux </xsl:comment>
                                    <listPlace>
                                        <xsl:comment> Enchaînement de balises répétable (dans le cas où il y aurait plusieurs sections (= adresses) pour un même catalogue d'exposition) </xsl:comment>
                                        <place>
                                            <head>
                                                <xsl:value-of select="Titre_section"/>
                                            </head>
                                            <placeName>
                                                <orgName>
                                                    <xsl:if test="descendant::Type_lieu[text() != '']">
                                                        <xsl:call-template name="place_type"/>
                                                    </xsl:if>
                                                    <xsl:value-of
                                                  select="Lieu_exposition_section_unique"/>
                                                </orgName>
                                                <xsl:comment> Deux adresses sont encodées : celle indiquée dans l'imprimé et sa version normalisée </xsl:comment>
                                                <choice>
                                                  <orig>
                                                    <address n="address_from_source">
                                                        <addrLine>
                                                            <xsl:value-of select="Adresse_section_decrite_dans_catalogue"/>
                                                        </addrLine>
                                                    </address>
                                                  </orig>
                                                  <reg>
                                                    <address n="section_address">
                                                        <street>
                                                            <xsl:value-of select="Numero_et_nom_rue_section"/>
                                                        </street>
                                                        <addrLine n="floor">
                                                            <xsl:value-of select="Etage_section"/>
                                                        </addrLine>
                                                        <addrLine n="additional_address">
                                                            <xsl:value-of select="Complement_adresse_section"/>
                                                        </addrLine>
                                                        <addrLine n="locality">
                                                            <xsl:value-of select="Lieu-dit_section"/>
                                                        </addrLine>
                                                        <settlement>
                                                            <xsl:value-of select="Ville_exposition_en"/>
                                                        </settlement>
                                                        <country>
                                                            <xsl:value-of select="Pays_en"/>
                                                        </country>
                                                        <region>
                                                            <xsl:value-of select="Etat_en"/>
                                                        </region>
                                                    </address>
                                                  </reg>
                                                </choice>
                                            </placeName>
                                            <note>
                                                <xsl:value-of select="Notes_section"/>
                                            </note>
                                        </place>
                                        <place>
                                            <xsl:comment> Répétition des balises possible comme indiqué ci-dessus </xsl:comment>
                                        </place>
                                    </listPlace>
                                </desc>
                            </event>
                        </listEvent>
                    </sourceDesc>
                </fileDesc>
                <profileDesc>
                    <langUsage>
                        <language>
                            <xsl:if test="descendant::Langue_source[text() != '']">
                                <xsl:call-template name="language"/>
                            </xsl:if>
                        </language>
                    </langUsage>
                </profileDesc>
                <encodingDesc><xsl:comment> Concerne uniquement les catalogues encodés avec GROBID.
                    Caroline Corbières est chargée de compléter cette partie. </xsl:comment>
                    <p/>
                </encodingDesc>
                <revisionDesc>
                    <xsl:comment> Descriptif des révisions du fichier </xsl:comment>
                    <change who="name"
                        ><xsl:comment> Indiquer la modification ou la correction apportée au fichier </xsl:comment></change>
                </revisionDesc>
            </teiHeader>
            <text>
                <body>
                    <list>
                        <head/>
                    </list>
                </body>
            </text>
        </TEI>
    </xsl:template>
    
    <!-- Règles concernant les attributs -->
    <xsl:template name="TEI_attribute">
        <xsl:attribute name="xml:id">
            <xsl:value-of select="Nommage_fichier"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="licence_attribute">
        <xsl:attribute name="target">
            <xsl:value-of select="Licence"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="bibl_attribute">
        <xsl:attribute name="type">
            <xsl:value-of select="Type_source"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="pub_date_attribute">
        <xsl:attribute name="when">
            <xsl:value-of select="Date_publication"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="first_pub_attribute">
        <xsl:attribute name="when">
            <xsl:value-of select="Annee_1er_numero"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="last_pub_attribute">
        <xsl:attribute name="when">
            <xsl:value-of select="Annee_dernier_numero"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="digitised_version">
        <xsl:attribute name="facs">
            <xsl:value-of select="Source_diffuseur"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="digitisation_date">
        <xsl:attribute name="when">
            <xsl:value-of select="Date_numerisation"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="event_type">
        <xsl:attribute name="type">
            <xsl:value-of select="Type_evenement"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="event_subtype">
        <xsl:attribute name="subtype">
            <xsl:value-of select="Exposition_itinerante"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="event_from">
        <xsl:attribute name="from">
            <xsl:value-of select="Date_debut_exposition"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="event_to">
        <xsl:attribute name="to">
            <xsl:value-of select="Date_fin_exposition"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="exhib_group_type">
        <xsl:attribute name="type">
            <xsl:value-of select="Type_groupe_expositions"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="place_type">
        <xsl:attribute name="type">
            <xsl:value-of select="Type_lieu"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="language">
        <xsl:attribute name="ident">
            <xsl:value-of select="Langue_source"/>
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>
