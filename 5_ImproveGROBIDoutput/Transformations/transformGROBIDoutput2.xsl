<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:s="http://purl.oclc.org/dsdl/schematron" exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- This xsl stylesheet is derived from the work of Lucie Rondeau du Noyer, Simon Gabay and Matthias Gille Levenson -->
    
    <!-- add processing instructions (associate the ODD) -->
    <xsl:template match="/">
        <xsl:call-template name="schemas"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="TEI">
        <xsl:copy>
            <!-- Fill the name of the catalogue into <xsl:attribute name="xml:id"> tags -->
            <xsl:attribute name="xml:id">exhibCat_1923_Paris_SocieteArtistesIndependants</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- add teiHeader from another file -->
    <xsl:template match="teiHeader">
        <xsl:element name="teiHeader">
            <!-- complete the path of the header file : ../../Catalogues/NAME_OF_THE_FOLDER/TEI/NAME_OF_THE_CATALOGUE_header.xml -->
            <xsl:copy-of
                select="document('../../Catalogues/exhibCat_1923_Paris_SocieteArtistesIndependants/TEI/exhibCat_1923_Paris_SocieteArtistesIndependants_header.xml')/TEI/teiHeader/fileDesc"/>
            <xsl:copy-of
                select="document('../../Catalogues/exhibCat_1923_Paris_SocieteArtistesIndependants/TEI/exhibCat_1923_Paris_SocieteArtistesIndependants_header.xml')/TEI/teiHeader/profileDesc"/>
            <encodingDesc>
                <samplingDecl>
                    <p>This electronic version of the catalog only reproduces the entries that
                        correspond to exhibited works. All text preceding or succeeding the list
                        of documents is not reproduced below.</p>
                </samplingDecl>
                <appInfo>
                    <application version="1.11" ident="Transkribus" when="">
                        <label>Transkribus</label>
                        <ptr target="https://transkribus.eu/Transkribus/"/>
                    </application>
                    <application version="0.5.6" ident="GROBID" when="">
                        <label>GROBID_Dictionaries - A machine learning software for structuring
                            digitized dictionaries</label>
                        <ptr target="https://github.com/MedKhem/grobid-dictionaries"/>
                    </application>
                </appInfo>
            </encodingDesc>
            <!-- complete the path of the header file : ../../Catalogues/NAME_OF_THE_FOLDER/TEI/NAME_OF_THE_CATALOGUE_header.xml -->
            <xsl:copy-of
                select="document('../../Catalogues/exhibCat_1923_Paris_SocieteArtistesIndependants/TEI/exhibCat_1923_Paris_SocieteArtistesIndependants_header.xml')/TEI/teiHeader/revisionDesc"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="list">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="p">
        <xsl:element name="head">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:element name="entry">
            <xsl:attribute name="n">
                <xsl:number count="entry" level="any"/>
            </xsl:attribute>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="/TEI/@xml:id"/>
                <xsl:text>_e</xsl:text>
                <xsl:number count="entry" level="any"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="desc">
        <xsl:element name="desc">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="name">
        <xsl:element name="name">
            <xsl:if test="./@role = 'exhibitor'">
                <xsl:attribute name="role">
                    <xsl:text>exhibitor</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="trait">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="trait/p">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="item">
        <xsl:element name="item">
            <xsl:attribute name="n">
                <xsl:value-of select=".//num"/>
            </xsl:attribute>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="/TEI/@xml:id"/>
                <xsl:text>_e</xsl:text>
                <xsl:number count="entry" level="any"/>
                <xsl:text>_i</xsl:text>
                <xsl:value-of select="count(./preceding-sibling::item) + 1"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="num">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="title">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="item/desc">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- template to automatically associate the ODD -->
    <xsl:template name="schemas">
        <xsl:processing-instruction name="xml-model">
            <xsl:text>href="../../../5_ImproveGROBIDoutput/ODD/ODD_VisualContagions.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:text>
        </xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">
            <xsl:text>href="../../../5_ImproveGROBIDoutput/ODD/ODD_VisualContagions.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:text>
        </xsl:processing-instruction>
    </xsl:template>

</xsl:stylesheet>
