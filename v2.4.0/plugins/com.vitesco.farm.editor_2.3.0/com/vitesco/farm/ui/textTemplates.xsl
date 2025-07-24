<?xml version="1.0"?>

<xsl:stylesheet version="2.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:o="urn:schemas-microsoft-com:office:office"
								xmlns:x="urn:schemas-microsoft-com:office:excel"
								xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
								xmlns:html="http://www.w3.org/TR/REC-html40">

	<xsl:output		method="xml"
					indent="no"
					omit-xml-declaration="no"
					encoding="UTF-8"/>
					
	<xsl:template match="/">
		<text-templates-root>
			<xsl:for-each-group select="ss:Workbook/ss:Worksheet[1]/ss:Table[1]/ss:Row[position()!=1]"
									group-by="normalize-space(ss:Cell[1]/ss:Data)">
				<xsl:sort select="current-grouping-key()"/>
				
				<text-templates component="{current-grouping-key()}">
					<xsl:for-each-group select="current-group()"
							group-by="normalize-space(ss:Cell[3]/ss:Data)">
						<xsl:sort select="current-grouping-key()"/>
						
						<xsl:if test="string(current-grouping-key())!=''">
							<text-template><xsl:value-of select="current-grouping-key()"/></text-template>
						</xsl:if>
						
					</xsl:for-each-group>
				</text-templates>
			</xsl:for-each-group>
		</text-templates-root>
	</xsl:template>
</xsl:stylesheet>