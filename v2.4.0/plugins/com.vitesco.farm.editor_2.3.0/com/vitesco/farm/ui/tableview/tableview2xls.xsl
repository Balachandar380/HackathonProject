<?xml version="1.0"?>

<xsl:stylesheet version="2.0"	xmlns:xsl  = "http://www.w3.org/1999/XSL/Transform"
								xmlns:xs   = "http://www.w3.org/2001/XMLSchema"
								xmlns:html = "http://www.w3.org/TR/REC-html40"
								
								xmlns:ss   = "urn:schemas-microsoft-com:office:spreadsheet"
								xmlns:o    = "urn:schemas-microsoft-com:office:office"
								xmlns:x    = "urn:schemas-microsoft-com:office:excel"
								>
	
	<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
	
	<xsl:param name="author"     select="'Anonymous'"/>
	<xsl:param name="lastAuthor" select="'Anonymous'"/>
	<xsl:param name="created"    select="current-dateTime()" as="xs:dateTime"/>
	<xsl:param name="company"    select="'N.N.'"/>
	<xsl:param name="version"    select="'11.9999'"/>
	
	<xsl:template match="tableview">
		<xsl:processing-instruction name="mso-application">
			<xsl:text>progid="Excel.Sheet"</xsl:text>
		</xsl:processing-instruction>
		
		<ss:Workbook>
			<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
				<Author><xsl:value-of select="$author"/></Author>
				<LastAuthor><xsl:value-of select="$lastAuthor"/></LastAuthor>
				<Created><xsl:value-of select="$created"/></Created>
				<Company><xsl:value-of select="$company"/></Company>
				<Version><xsl:value-of select="$version"/></Version>
			</DocumentProperties>
			
			<ss:Styles>
				<ss:Style ss:ID="Default" ss:Name="Normal">
					<ss:Alignment ss:Vertical="Bottom"/>
					<ss:Borders/>
					<ss:Font ss:Size="11"/>
					<ss:Interior/>
					<ss:NumberFormat/>
					<ss:Protection/>
				</ss:Style>
			</ss:Styles>
			
			
			<ss:Worksheet ss:Name="{head/title}">		
				<xsl:apply-templates select="body/table"/>
			</ss:Worksheet>	
		</ss:Workbook>
	</xsl:template>
	
	
	<xsl:template match="table">
		<ss:Table>
			<ss:Row>
				<!-- corner -->
				<ss:Cell>
					<ss:Data ss:Type="String">FARM</ss:Data>
				</ss:Cell>
				
				<xsl:for-each select="1 to head/cols/@count">
					<ss:Cell>
						<ss:Data ss:Type="Number"><xsl:value-of select="position()"/></ss:Data>
					</ss:Cell>
				</xsl:for-each>
			</ss:Row>
			<xsl:apply-templates select="body/tr"/>
		</ss:Table>
		
		
		<!--
		<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
			<PageSetup>
				<Header x:Margin="0.4921259845"/>
				<Footer x:Margin="0.4921259845"/>
				<PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996" x:Right="0.78740157499999996" x:Top="0.984251969"/>
			</PageSetup>
			<Selected/>
			<Panes>
				<Pane>
					<Number>1</Number>
					<ActiveRow>0</ActiveRow>
					<ActiveCol>0</ActiveCol>
				</Pane>
			</Panes>
			<ProtectObjects>False</ProtectObjects>
			<ProtectScenarios>False</ProtectScenarios>
		</WorksheetOptions> 
		-->
	</xsl:template>
	
	<xsl:template match="tr">
		<ss:Row>
			<ss:Cell>
				<ss:Data ss:Type="Number"><xsl:value-of select="position()"/></ss:Data>
			</ss:Cell>
			<xsl:apply-templates select="td"/>
		</ss:Row>	
	</xsl:template>
	
	<xsl:template match="td">
		<ss:Cell>
			<ss:Data ss:Type="String">
				<xsl:value-of select="string-join(link, ',')"/>
			</ss:Data>
		</ss:Cell>
	</xsl:template>
	
	<xsl:template match="node()">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>