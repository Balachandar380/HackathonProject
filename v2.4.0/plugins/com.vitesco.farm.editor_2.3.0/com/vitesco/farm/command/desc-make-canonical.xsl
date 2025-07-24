<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- we create a text file which is NOT a XML -->
	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	
	<!-- omit comments and PIs -->
	<xsl:template match="comment() | processing-instruction()">
		<!-- NOP -->
	</xsl:template>
	
	
	<!-- normalize text and remove emtpy text -->
	<xsl:template match="text()">
		<xsl:variable name="normalized" select="normalize-space(.)"/>
		<xsl:if test="$normalized!=''">
			<xsl:value-of select="$normalized"/>
		</xsl:if>
	</xsl:template>
	
	
	<!-- elements -->
	<xsl:template match="*">
		<xsl:text>&lt;</xsl:text>
		<xsl:call-template name="nodename"/>
		<xsl:text>&gt;</xsl:text>
			
		<!-- attrbutes in alphabetical order -->
		<xsl:apply-templates select="@*">
			<xsl:sort select="namespace-uri()"/>
			<xsl:sort select="local-name()"/>
		</xsl:apply-templates>
		
		<!-- children -->
		<xsl:apply-templates />
			
		<xsl:text>&lt;/</xsl:text>
		<xsl:call-template name="nodename"/>
		<xsl:text>&gt;</xsl:text>
		
		<!-- <xsl:text>&#xA;</xsl:text> -->
	</xsl:template>
	
	
	<!-- write out node name -->
	<!-- if the node name is bound to a namespace, the namespace URI is prepended in curly brackets -->
	<xsl:template name="nodename">
		<xsl:choose>
			<xsl:when test="namespace-uri()!=''">
				<xsl:value-of select="concat('{', namespace-uri(), '}', local-name())"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="local-name()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- attributes -->
	<xsl:template match="@*">
		<xsl:call-template name="nodename"/><xsl:text>=&quot;</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>&quot;</xsl:text>
	</xsl:template>
	
	
	<!-- omit doc-checksum element -->
	<xsl:template match="descCheckSum">
		<!-- NOP -->
	</xsl:template>
	
	
	<!-- omit editor-info elements -->
	<xsl:template match="editor-info">
		<!-- NOP  -->
	</xsl:template>
	
	
</xsl:stylesheet>
