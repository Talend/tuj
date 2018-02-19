<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="column_title" />
<xsl:param name="column_artist" /> 

<xsl:template match="/">
  <html>
	  <body>
		 
		<table border="1">
			  <tr bgcolor="#9acd32">
				  <th><xsl:value-of select="$column_title"></xsl:value-of></th> 
				  <th><xsl:value-of select="$column_artist"></xsl:value-of></th> 
			  </tr>
					  
			  <xsl:for-each select="catalog/cd">
				  <xsl:call-template name="show_title">
					<xsl:with-param name="title" select="title"/>
					<xsl:with-param name="artist" select="artist"/>
				  </xsl:call-template>
			  </xsl:for-each>
		</table>
		  
	  </body>
  </html>
</xsl:template>

<xsl:template name="show_title" match="title">
    <xsl:param name="title" />
    <xsl:param name="artist" />
	<tr>	
		<td><xsl:value-of select="$title" /></td>
		<td><xsl:value-of select="$artist" /></td>
        </tr>
    
</xsl:template>

</xsl:stylesheet>