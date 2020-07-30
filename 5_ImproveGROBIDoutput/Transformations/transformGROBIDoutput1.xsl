<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:s="http://purl.oclc.org/dsdl/schematron" exclude-result-prefixes="xs"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
   
    <!-- This xsl stylesheet is derived from the work of Lucie Rondeau du Noyer, Simon Gabay and Matthias Gille Levenson -->

    <!-- VOIR POUR ASSOCIER ODD DIRECTEMENT AVEC XSL -->
    
    <xsl:template match="TEI">
        <xsl:copy>
            <!-- Fill the name of the catalogue into <xsl:attribute name="xml:id"> tags -->
            <xsl:attribute name="xml:id">exhibCat_1892_Paris_SocieteArtistesIndependants</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="teiHeader">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="text">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="body">
        <xsl:copy>
            <xsl:element name="list">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="dictScrap">
        <xsl:comment>If the text encoded in p tag is not the name of a list, you can deleted it</xsl:comment>
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:element name="entry">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="form">
        <xsl:element name="desc">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="sense">
        <xsl:element name="item">
            <xsl:attribute name="n">
                <xsl:value-of select=".//num"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="pc"/>

    <xsl:template match="num">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="name">
        <xsl:element name="name">
            <xsl:attribute name="role">
                <xsl:text>exhibitor</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="desc">
        <xsl:element name="trait">
            <xsl:element name="p">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="sense/sense">
        <xsl:element name="title">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="note">
        <xsl:element name="desc">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
