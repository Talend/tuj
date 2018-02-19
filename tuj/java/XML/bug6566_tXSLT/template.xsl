<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">
<xsl:template match="/">
<xsl:element name="world">
<xsl:for-each-group select="//country" group-by="@continent">
<xsl:sort select="@continent" data-type="text" order="ascending"/>
<xsl:variable name="continent" select="@continent"/>
<xsl:apply-templates select="//country[@continent = $continent]" mode="group">
<xsl:sort select="@name" data-type="text" order="ascending"/>
</xsl:apply-templates>
</xsl:for-each-group>
</xsl:element>
</xsl:template>
<xsl:template match="*" mode="group">
<xsl:copy-of select="."/>
</xsl:template>
</xsl:stylesheet>