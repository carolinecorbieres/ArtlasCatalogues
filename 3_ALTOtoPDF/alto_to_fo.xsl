<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    version="2.0">
    <xsl:output method="xml" indent="yes" name="fo"/>

    <xsl:param name="paramLang">fr</xsl:param>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="single-doc" page-height="29.7cm"
                    page-width="21cm" margin-top="2cm" margin-bottom="2cm" margin-left="2cm"
                    margin-right="2cm">
                    <fo:region-body/>
                    <fo:region-after extent="12pt" padding-top="2cm"/>
                </fo:simple-page-master>

            </fo:layout-master-set>

            <fo:page-sequence master-reference="single-doc" initial-page-number="1">
                <fo:static-content flow-name="rest-region-before-recto"/>
                <!-- footer w/ page no. and output date -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="left" font-family="Times" font-size="8pt"
                        font-style="normal" margin-top="15pt">
                        <xsl:choose>
                            <xsl:when test="$paramLang = 'fr'">
                                <xsl:text>Mise en forme du PDF grâce à </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>PDF formatting courtesy of </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <fo:basic-link external-destination="http://www.renderx.com" color="blue"
                            >RenderX XEP Engine</fo:basic-link>
                    </fo:block>
                </fo:static-content>

                <!-- content flow -->
                <fo:flow flow-name="xsl-region-body" font-family="Times" font-weight="normal"
                    font-size="10pt" space-before="5pt" space-after="5pt" end-indent="120pt">
                    <xsl:apply-templates/>
                </fo:flow>

            </fo:page-sequence>

        </fo:root>
    </xsl:template>

    <!-- hide Transkribus metadata -->
    <xsl:template match="*[local-name() = 'Description']"/>

    <!-- each line is encoded in a fo:block (similar to a paragraph) -->
    <xsl:template match="*[local-name() = 'TextLine']">
        <fo:block font-family="Times" font-weight="normal" line-height="12pt"
            line-stacking-strategy="font-height" font-size="10pt" space-before="5pt"
            space-after="5pt" text-align="justify" end-indent="120pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- add each word of @CONTENT in fo:inline (similar to a line) -->
    <xsl:template match="*[local-name() = 'String']">
        <xsl:if test="@STYLEREFS = 'FONT0'">
            <fo:inline>
                <xsl:value-of select="@CONTENT"/>
            </fo:inline>
        </xsl:if>
        <!-- add bold or italic -->
        <xsl:if test="@STYLEREFS = 'FONT1'">
            <fo:inline font-weight="bold">
                <xsl:value-of select="@CONTENT"/>
            </fo:inline>
        </xsl:if>
        <xsl:if test="@STYLEREFS = 'FONT2'">
            <fo:inline font-style="italic">
                <xsl:value-of select="@CONTENT"/>
            </fo:inline>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
