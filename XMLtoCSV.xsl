<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0">
    <xsl:output method="text"/>

    <xsl:variable name="delimiter" select="','"/>

    <xsl:variable name="fieldArray">
        <field>name</field>
        <field>surname</field>
        <field>forename</field>
        <field>trait</field>
        <field>biographical description</field>
        <field>birth</field>
        <field>birth adress</field>
        <field>death</field>
        <field>death adress</field>
        <field>sex</field>
        <field>group</field>
        <field>master</field>
        <field>nationality</field>
        <field>biography</field>
        <field>adress</field>
        <field>notes</field>
        <field>num</field>
        <field>title</field>
        <field>subtitle</field>
        <field>desc</field>
        <field>medium</field>
        <field>category</field>
        <field>dimensions</field>
        <field>room</field>
        <field>catalogue chapter</field>
        <field>price</field>
        <field>owner</field>
        <field>owner adress</field>
        <field>date</field>
        <field>design adress</field>
        <field>reproduction in the catalogue ?</field>
        <field>notes</field>
    </xsl:variable>
    <xsl:param name="fields" select="document('')/*/xsl:variable[@name = 'fieldArray']/*"/>

    <xsl:template match="/">

        <!-- output the header row -->
        <xsl:for-each select="$fields">
            <xsl:if test="position() != 1">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:for-each>

        <!-- output newline -->
        <xsl:text>&#xa;</xsl:text>

        <xsl:apply-templates select="//entry"/>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:apply-templates select="desc"/>
        <xsl:apply-templates select="item"/>
        
        <!-- output newline -->
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="item">
        <xsl:variable name="currNode" select="."/>

        <!--   output the data row -->
        <!-- loop over the field names and find the value of each one in the xml -->
        <xsl:for-each select="$fields">
            <xsl:if test="position() != 1">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
            <xsl:text>'</xsl:text>
            <xsl:variable name="child" select="$currNode/*[name() = current()]/*[1]"/>
            <xsl:choose>
                <xsl:when test="count($child) > 0">
                    <xsl:value-of select="$child"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$currNode/*[name() = current()]"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>'</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="desc">
        <xsl:variable name="currNode" select="."/>

        <!-- output the data row -->
        <!-- loop over the field names and find the value of each one in the xml -->
        <xsl:for-each select="$fields">
            <xsl:if test="position() != 1">
                <xsl:value-of select="$delimiter"/>
            </xsl:if>
            <xsl:text>'</xsl:text>
            <xsl:variable name="child" select="$currNode/*[name() = current()]/*[1]"/>
            <xsl:choose>
                <xsl:when test="count($child) > 0">
                    <xsl:value-of select="$child"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$currNode/*[name() = current()]"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>'</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
