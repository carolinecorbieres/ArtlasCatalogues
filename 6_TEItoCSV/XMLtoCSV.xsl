<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0">
    <xsl:output method="text"/>

    <xsl:variable name="delimiter" select="';'"/>

    <!-- column's names -->
    <xsl:variable name="fieldArray">
        <field>Last name of the artist</field>
        <field>First name of the artist</field>
        <field>Sex of the artist (F/M/FM/empty)</field>
        <field>Membership in movement, if applicable</field>
        <field>Biographical elements</field>
        <field>Detailed address of the artist, as it appears in the catalogue</field>
        <field>Country of the artist</field>
        <field>State of the artist</field>
        <field>City of the artist</field>
        <field>Street number of the artist's address</field>
        <field>Street name of the artist's address</field>
        <field>Floor level of the artist's address</field>
        <field>Local address of the artist</field>
        <field>Additional information on the artist's address</field>
        <field>Address as it appears in the catalogue</field>
        <field>Country of the artist 2</field>
        <field>State of the artist 2</field>
        <field>City of the artist 2</field>
        <field>Street number of the artist's address 2</field>
        <field>Street name of the artist's address 2</field>
        <field>Floor level of the artist's address 2</field>
        <field>Local address of the artist 2</field>
        <field>Additional information on the artist's address 2</field>
        <field>Artist's nationality</field>
        <field>Student of</field>
        <field>Birth year</field>
        <field>Month of birth</field>
        <field>Day of birth</field>
        <field>Detailed birth address of the artist, as it appears in the catalogue</field>
        <field>Country of birth</field>
        <field>State of birth</field>
        <field>City of birth</field>
        <field>Street number of the birth address</field>
        <field>Street name of the birth address</field>
        <field>Floor level of the birth address</field>
        <field>Local address of birth</field>
        <field>Additional information on the birth address</field>
        <field>Year of death</field>
        <field>Month of death</field>
        <field>Day of death</field>
        <field>Detailed death address of the artist, as it appears in the catalogue</field>
        <field>Country of death</field>
        <field>State of death</field>
        <field>City of death</field>
        <field>Street number of the death address</field>
        <field>Street name of the death address</field>
        <field>Floor level of the death address</field>
        <field>Local address of death</field>
        <field>Additional information on the death address</field>
        <field>Notes</field>
        <!-- Artwork -->
        <field>Number</field>
        <field>Title of artwork</field>
        <field>Subtitle</field>
        <field>Translated title</field>
        <field>Start year of creation</field>
        <field>Start month of creation</field>
        <field>Start day of creation</field>
        <field>End year of creation</field>
        <field>End month of creation</field>
        <field>End day of creation</field>
        <field>Country of creation</field>
        <field>State of creation</field>
        <field>City of creation</field>
        <field>Dimensions</field>
        <field>Categories</field>
        <field>Medium</field>
        <field>Room</field>
        <field>Chapter of the catalogue ?</field>
        <field>Price</field>
        <field>Location/Owner</field>
        <field>Owner's country</field>
        <field>Owner's state</field>
        <field>Owner's city</field>
        <field>Notes</field>
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

        <xsl:apply-templates select="//item"/>
    </xsl:template>

    <xsl:template match="item">
        <xsl:value-of select="preceding-sibling::desc/name/text()"/>
        <xsl:text>; ; ; ; </xsl:text>
        <xsl:value-of select="preceding-sibling::desc/trait/p/text()"/>
        <xsl:text>; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;</xsl:text>
        <xsl:value-of select="num/text()"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="title/text()"/>
        <xsl:value-of select="$delimiter"/>
        <xsl:value-of select="desc/text()"/>
        <xsl:text>; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;</xsl:text>
        <!-- output newline -->
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
