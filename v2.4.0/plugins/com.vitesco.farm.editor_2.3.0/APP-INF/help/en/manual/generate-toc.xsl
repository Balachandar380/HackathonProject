<?xml version="1.0"?>
<xsl:stylesheet version="1.0"	xmlns:xsl   = "http://www.w3.org/1999/XSL/Transform"
								xmlns:xs    = "http://www.w3.org/2001/XMLSchema"
								xmlns:xhtml = "http://www.w3.org/1999/xhtml"
								xmlns       = "http://www.w3.org/1999/xhtml"
								xmlns:t="http://www.vitesco-technologies/Powertrain/Engine-Systems/FARM/FRED/manual"
								exclude-result-prefixes="xhtml">
								
	<xsl:output	 method="html" indent="yes" encoding="UTF-8"/>
	
	<xsl:param name="manual" select="'manual.html'"/>
	<xsl:param name="indent" select="'&#160;&#160;&#160;&#160;'"/>
	
	<xsl:template match="t:generate-toc">
		<xsl:apply-templates select="document($manual)"/>
	</xsl:template>
	
	
	<xsl:template match="xhtml:html">
		<html>
			<head>
				<meta content="text/html; charset=UTF-8" http-equiv="Content-Type"/>
				<title>FARM Manual Table of Contents</title>
				<link rel="stylesheet" type="text/css" href="styles.css"/>
			</head>
			<body>
				<h1>Contents</h1>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	
	<xsl:template match="xhtml:h1 | xhtml:h2"> <!--   | xhtml:h3 | xhtml:h4 | xhtml:h5 | xhtml:h6 -->
		<xsl:variable name="anchor" select=".//xhtml:a[@name][1]/@name"/>
		
		<xsl:variable name="t" select="normalize-space( translate(., '&#160;','') )"/>
			
			<!--
			<xsl:for-each select="0 to (xs:integer(substring(name(), 2)) - 1)">
				<xsl:text>&#160;&#160;</xsl:text>
			</xsl:for-each>
			-->
		<p class="MsoNormal">
			<nobr>
			<xsl:apply-templates select="." mode="indent"/>
			<a name="{$anchor}"/>
				<a href="{$manual}#{$anchor}" target="frame_content"><xsl:value-of select="$t"/>
			</a>
			</nobr>
		</p>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="xhtml:h1" mode="indent">
	</xsl:template>
	
	<xsl:template match="xhtml:h2" mode="indent">
		<xsl:copy-of select="$indent"/>
	</xsl:template>
	
	<xsl:template match="xhtml:h3" mode="indent">
		<xsl:copy-of select="$indent"/>
		<xsl:copy-of select="$indent"/>
	</xsl:template>
	
	<xsl:template match="xhtml:h4" mode="indent">
		<xsl:copy-of select="$indent"/>
		<xsl:copy-of select="$indent"/>
		<xsl:copy-of select="$indent"/>
	</xsl:template>
	
	
	<xsl:template match="node()">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>
