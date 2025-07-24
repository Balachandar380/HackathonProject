<?xml version="1.0"?>

<xsl:stylesheet version="2.0"	xmlns:xsl  = "http://www.w3.org/1999/XSL/Transform"
								xmlns:xs   = "http://www.w3.org/2001/XMLSchema"
								xmlns:t    = "http://www.vitesco-technologies/Powertrain/Engine-Systems/FARM/FRED/tableview"
								xmlns:xlink="http://www.w3.org/1999/xlink"
								xmlns="http://www.w3.org/2000/svg"
								exclude-result-prefixes="xs t xlink">
								
	
	<xsl:output		method="xml"
					indent="no"
					omit-xml-declaration="no"
					encoding="UTF-8"
					/> 
	
	<xsl:param name="background" select="'white'"/>
	
	<xsl:param name="gridWidth" select="0.01" as="xs:double"/>
	<xsl:param name="gridColor" select="'black'"/>
	
	<xsl:param name="infoFont"              select="'Verdana'"/>
	<xsl:param name="infoFontSize"          select="0.25" as="xs:double"/>
	
	<xsl:param name="cellFont"              select="'Verdana'"/>
	<xsl:param name="cellFontSize"          select="0.25" as="xs:double"/>
	<xsl:param name="cellBorderWidthFactor" select="8.0" as="xs:double"/>
	
	<xsl:variable name="cellBorderWidth" select="$cellBorderWidthFactor * $gridWidth" as="xs:double"/>
	
	<xsl:variable name="columnHeaderTable" select="/tableview/table[@id='columnHeaderTable']"/>
	<xsl:variable name="rowHeaderTable"    select="/tableview/table[@id='rowHeaderTable']"/>
	<xsl:variable name="bodyTable"         select="/tableview/table[@id='bodyTable']"/>
		
	<xsl:variable name="rowHeaderWidth"     select="t:table-width($rowHeaderTable)" as="xs:double"/>
	<xsl:variable name="columnHeaderWidth"  select="t:table-width($columnHeaderTable)" as="xs:double"/>
	
	<xsl:variable name="columnHeaderBodyHeight"   select="t:tableContent-height($columnHeaderTable/body)" as="xs:double"/>
	<xsl:variable name="columnHeaderHeaderHeight" select="t:tableContent-height($columnHeaderTable/columnHeader)" as="xs:double"/>
	<xsl:variable name="columnHeaderHeight"       select="$columnHeaderHeaderHeight + $columnHeaderBodyHeight"/>
														
	<xsl:variable name="bodyWidth"  select="$columnHeaderWidth" as="xs:double"/>
	<xsl:variable name="bodyHeight" select="t:tableContent-height($bodyTable/body)" as="xs:double"/>
	
	
	<!-- total width in user space units -->
	<xsl:variable name="layoutWidth" select="($rowHeaderWidth - 2) + $bodyWidth" as="xs:double"/>
	
	<!-- total height in user space units -->
	<xsl:variable name="layoutHeight" select="$columnHeaderHeight + $bodyHeight" as="xs:double"/>
	
		
	
	<xsl:template match="tableview">
		
		<!-- table top coordinates are scaled so that the total width = 1.0 -->
		<xsl:choose>
			<xsl:when test="@columns &gt; 0 and @rows &gt; 0">
				<svg viewBox="0.0 0.0 1.0 {$layoutHeight div $layoutWidth}"
					xmlns:xlink="http://www.w3.org/1999/xlink"
					xmlns:t="http://www.vitesco-technologies/Powertrain/Engine-Systems/FARM/FRED/tableview"
					t:layoutWidth="{$layoutWidth}" t:layoutHeight="{$layoutHeight}"
					t:columns="{@columns}" t:rows="{@rows}"
					t:empty="false">
					<defs id="Defs">
						<pattern id="hatching" patternUnits="userSpaceOnUse" x="0.0" y="0.0" width="1.0" height="1.0">
							
							<g fill="none" stroke="#7f7f7f" stroke-width="0.025">
								<path d="M 0.0 0.1 L 0.1 0.0"/>
								<path d="M 0.0 0.2 L 0.2 0.0"/>
								<path d="M 0.0 0.3 L 0.3 0.0"/>
								<path d="M 0.0 0.4 L 0.4 0.0"/>
								<path d="M 0.0 0.5 L 0.5 0.0"/>
								<path d="M 0.0 0.6 L 0.6 0.0"/>
								<path d="M 0.0 0.7 L 0.7 0.0"/>
								<path d="M 0.0 0.8 L 0.8 0.0"/>
								<path d="M 0.0 0.9 L 0.9 0.0"/>
								<path d="M 0.0 1.0 L 1.0 0.0"/>
								<path d="M 0.1 1.0 L 1.0 0.1"/>
								<path d="M 0.2 1.0 L 1.0 0.2"/>
								<path d="M 0.3 1.0 L 1.0 0.3"/>
								<path d="M 0.4 1.0 L 1.0 0.4"/>
								<path d="M 0.5 1.0 L 1.0 0.5"/>
								<path d="M 0.6 1.0 L 1.0 0.6"/>
								<path d="M 0.7 1.0 L 1.0 0.7"/>
								<path d="M 0.8 1.0 L 1.0 0.8"/>
								<path d="M 0.9 1.0 L 1.0 0.9"/>
							</g>
						</pattern>
						
						<xsl:for-each-group select="//cell[@gradient]" group-by="@gradient">
							<xsl:variable name="gradient-color" select="string(current-grouping-key())"/>
							 <linearGradient id="{t:gradient-id($gradient-color)}">
							 	<stop offset="0%" stop-color="{@border}"/>
								<stop offset="100%" stop-color="{$gradient-color}"/>
							 </linearGradient>
						</xsl:for-each-group>
						
					</defs>
					
					<g id="Table" transform="scale({1.0 div $layoutWidth})">
						
						<!-- info -->
						<xsl:call-template name="drawInfoAndCaption">
							<xsl:with-param name="info" select="info"/>
							<xsl:with-param name="caption" select="caption"/>
						</xsl:call-template>
						
						<!-- column colors -->
						<xsl:call-template name="drawColumns">
							<xsl:with-param name="tds"    select="$columnHeaderTable/columnHeader/tr[1]/td"/>
							<xsl:with-param name="x"      select="$rowHeaderWidth" />
							<xsl:with-param name="y"      select="xs:double('0.0')" as="xs:double"/>					
							<xsl:with-param name="width"  select="$bodyWidth"/>
							<xsl:with-param name="height" select="$layoutHeight"/>
						</xsl:call-template>
						
						<!-- enclosing rect -->
						<rect stroke="{$gridColor}" fill="none" stroke-width="{$gridWidth}" x="0" y="0" width="{$layoutWidth}" height="{$layoutHeight}"/>
						
						<!-- column header -->
						<xsl:call-template name="drawTableContent">
							<xsl:with-param name="tableContent" select="$columnHeaderTable/columnHeader"/>
							<xsl:with-param name="x"            select="$rowHeaderWidth - 2"/>
							<xsl:with-param name="y"            select="xs:double('0.0')" as="xs:double"/>		
							<xsl:with-param name="width"        select="$columnHeaderWidth"/>
							<xsl:with-param name="height"       select="$columnHeaderHeaderHeight"/>
						</xsl:call-template>
						
						<xsl:call-template name="drawTableContent">
							<xsl:with-param name="tableContent" select="$columnHeaderTable/body"/>
							<xsl:with-param name="x"            select="$rowHeaderWidth - 2"/>
							<xsl:with-param name="y"            select="$columnHeaderHeaderHeight"/>
							<xsl:with-param name="width"        select="$columnHeaderWidth"/>
							<xsl:with-param name="height"       select="$columnHeaderBodyHeight"/>
						</xsl:call-template>
						
						<!-- row header -->
						<xsl:call-template name="drawTableContent">
							<xsl:with-param name="tableContent" select="$rowHeaderTable/body"/>
							<xsl:with-param name="x"            select="xs:double('0.0')" as="xs:double"/>	
							<xsl:with-param name="y"            select="$columnHeaderHeight"/>
							<xsl:with-param name="width"        select="$rowHeaderWidth"/>
							<xsl:with-param name="height"       select="$bodyHeight"/>
						</xsl:call-template>
						 
						<!-- body -->
						<xsl:call-template name="drawTableContent">
							<xsl:with-param name="tableContent" select="$bodyTable/body"/>
							<xsl:with-param name="x" select="$rowHeaderWidth"/>
							<xsl:with-param name="y" select="$columnHeaderHeight"/>
							<xsl:with-param name="width"  select="$bodyWidth"/>
							<xsl:with-param name="height" select="$bodyHeight"/>
						</xsl:call-template>
					</g>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<svg 	viewBox="0.0 0.0 1.0 1.0"
						xmlns:xlink="http://www.w3.org/1999/xlink"
						xmlns:t="http://www.vitesco-technologies/Powertrain/Engine-Systems/FARM/FRED/tableview"
						t:empty="true">
				</svg>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="drawInfoAndCaption">
		<xsl:param name="info"/>
		<xsl:param name="caption"/>
		
		<xsl:variable name="y0" select="1.3 * $infoFontSize"/>
		<xsl:variable name="y1" select="$y0 + 1.3 * $infoFontSize * ((count($info/p) div 2.0) + 1.0)"/>
		
		<xsl:call-template name="drawPTabs">
			<xsl:with-param name="ps" select="$info"/>
			<xsl:with-param name="x" select="$infoFontSize"/>
			<xsl:with-param name="y" select="$y0"/>
		</xsl:call-template>
		
		<xsl:call-template name="drawPTabs">
			<xsl:with-param name="ps" select="$caption"/>
			<xsl:with-param name="x" select="$infoFontSize"/>
			<xsl:with-param name="y" select="$y1"/>
		</xsl:call-template>
		
	</xsl:template>
	
	
	<xsl:template name="drawPTabs">
		<xsl:param name="ps"/>
		<xsl:param name="x"/>
		<xsl:param name="y"/>
		
		<xsl:variable name="rows" select="(0.5 * count($ps/p) -1) cast as xs:integer" as="xs:integer"/>
		<xsl:variable name="colwidth" select="max($ps/p/@width)" as="xs:double"/>
		
		<xsl:for-each select="0 to $rows">
			<xsl:variable name="i" select="current()"/>
			<xsl:variable name="p0" select="$ps/p[position()=(2.0*$i+1)]"/>
			<xsl:variable name="p1" select="$ps/p[position()=(2.0*$i+2)]"/>
			
			<xsl:variable name="dx" select="$colwidth + 0.7*$infoFontSize"/>
			<xsl:variable name="dy" select="(1.3 * $infoFontSize * $i)"/>
			
			<xsl:call-template name="drawP">
				<xsl:with-param name="p" select="$p0"/> 
				<xsl:with-param name="x" select="$x"/>
				<xsl:with-param name="y" select="$y + $dy"/>
			</xsl:call-template>
			
			<xsl:call-template name="drawP">
				<xsl:with-param name="p" select="$p1"/> 
				<xsl:with-param name="x" select="$x + $dx"/>
				<xsl:with-param name="y" select="$y + $dy"/>
			</xsl:call-template>
		</xsl:for-each>
		
	</xsl:template>
	
	
	<xsl:template name="drawP">
		<xsl:param name="p"/>
		<xsl:param name="x"/>
		<xsl:param name="y"/>
		
		<xsl:variable name="foreground" select="if ($p/@foreground) then $p/@foreground else 'black'"/>
		<xsl:variable name="background" select="if ($p/@background) then $p/@background else 'none'"/>
		<xsl:variable name="border"     select="if ($p/@border) then $p/@border else 'none'"/>
		<xsl:variable name="width"      select="if ($p/@width) then $p/@width else '0'"/>
		
		<xsl:if test="$background!='none'">
			<rect 	x      = "{$x}"
					y      = "{$y - $infoFontSize}"
					width  = "{$width}"
					height = "{$infoFontSize}"
					stroke = "{$border}"
					stroke-width ="{$gridWidth}"
					fill   = "{$background}"/>
		</xsl:if>
		
		<xsl:variable name="s" select="string($p)"/>
		<xsl:if test="$s!=''">
			<text 	x="{$x}"
					y="{$y}"
					fill        = "{$foreground}"
					font-family = "{$infoFont}"
					font-size   = "{$infoFontSize}"><xsl:value-of select="$s"/></text>
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- draws the background colors of the columns (header + body) -->
	<xsl:template name="drawColumns">
		<xsl:param name="tds"/>
		<xsl:param name="x"      as="xs:double"/>
		<xsl:param name="y"      as="xs:double"/>
		<xsl:param name="width"  as="xs:double"/>
		<xsl:param name="height" as="xs:double"/>
		<xsl:variable name="td" select="$tds[1]"/>
		
		<xsl:if test="$td">
			<xsl:variable name="colWidth" select="t:td-width($td)"/>
			<xsl:variable name="fill"     select="$td/cell/@background"/>
			
			<xsl:if test="$fill">
				<rect x="{$x}" y="{$y}" width="{$colWidth}" height="{$height}" stroke="none" fill="{$fill}"/>
			</xsl:if>
			
			<xsl:call-template name="drawColumns">
				<xsl:with-param name="tds"    select="$tds[position() &gt; 1]"/>
				<xsl:with-param name="x"      select="$x + $colWidth"/>
				<xsl:with-param name="y"      select="$y"/>
				<xsl:with-param name="width"  select="$width"/>
				<xsl:with-param name="height" select="$height"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template name="drawTableContent">
		<xsl:param name="tableContent"/>
		<xsl:param name="x"      as="xs:double"/>
		<xsl:param name="y"      as="xs:double"/>
		<xsl:param name="width"  as="xs:double"/>
		<xsl:param name="height" as="xs:double"/>
		
		<xsl:call-template name="drawTableContentRows">
			<xsl:with-param name="trs"    select="$tableContent/tr"/>
			<xsl:with-param name="x"      select="$x"/>
			<xsl:with-param name="y"      select="$y"/>
			<xsl:with-param name="width"  select="$width"/>
			<xsl:with-param name="height" select="$height"/>
			<xsl:with-param name="row" select="xs:integer('1')"/>
		</xsl:call-template>
		
		<!-- here it is simply assumed that the width is the same for all rows -->
		<xsl:call-template name="drawTableVerticalGridLines">
			<xsl:with-param name="tds"    select="$tableContent/tr[1]/td"/>
			<xsl:with-param name="x"      select="$x"/>
			<xsl:with-param name="y"      select="$y"/>
			<xsl:with-param name="width"  select="$width"/>
			<xsl:with-param name="height" select="$height"/>
		</xsl:call-template>
	</xsl:template>
	
	
	
	<xsl:template name="drawTableVerticalGridLines">
		<xsl:param name="tds"/>
		<xsl:param name="x"      as="xs:double"/>
		<xsl:param name="y"      as="xs:double"/>
		<xsl:param name="width"  as="xs:double"/>
		<xsl:param name="height" as="xs:double"/>
		<xsl:variable name="td" select="$tds[1]"/>
		
		<xsl:if test="$td">
			<xsl:variable name="colWidth" select="t:td-width($td)"/>
			<line x1="{$x}" y1="{$y}" x2="{$x}" y2="{$y+$height}" stroke="{$gridColor}" stroke-width="{$gridWidth}"/>
			
			<xsl:call-template name="drawTableVerticalGridLines">
				<xsl:with-param name="tds"    select="$tds[position() &gt; 1]"/>
				<xsl:with-param name="x"      select="$x + $colWidth"/>
				<xsl:with-param name="y"      select="$y"/>
				<xsl:with-param name="width"  select="$width"/>
				<xsl:with-param name="height" select="$height"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template name="drawTableContentRows">
		<xsl:param name="trs"/>
		<xsl:param name="x"      as="xs:double"/>
		<xsl:param name="y"      as="xs:double"/>
		<xsl:param name="width"  as="xs:double"/>
		<xsl:param name="height" as="xs:double"/>
		<xsl:param name="row"    as="xs:integer"/>
		
		<xsl:variable name="tr" select="$trs[1]"/>
		
		<xsl:if test="$tr">
			<xsl:variable name="rowHeight" select="t:tr-height($tr)"/>
			
			<!-- horizontal grid line -->
			<line x1="{$x}" y1="{$y}" x2="{$x+$width}" y2="{$y}" stroke="{$gridColor}" stroke-width="{$gridWidth}"/>
			
			<xsl:call-template name="drawTableContentData">
				<xsl:with-param name="tds"       select="$tr/td"/>
				<xsl:with-param name="x"         select="$x"/>
				<xsl:with-param name="y"         select="$y"/>
				<xsl:with-param name="width"     select="$width"/>
				<xsl:with-param name="height"    select="$height"/>
				<xsl:with-param name="row"       select="$row"/>
				<xsl:with-param name="col"       select="xs:integer('1')"/>
				<xsl:with-param name="rowHeight" select="$rowHeight"/>
			</xsl:call-template>
			
			<xsl:call-template name="drawTableContentRows">
				<xsl:with-param name="trs"    select="$trs[position() &gt; 1]"/>
				<xsl:with-param name="x"      select="$x"/>
				<xsl:with-param name="y"      select="$y + $rowHeight"/>
				<xsl:with-param name="width"  select="$width"/>
				<xsl:with-param name="height" select="$height"/>
				<xsl:with-param name="row"    select="$row + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template name="drawTableContentData">
		<xsl:param name="tds"/>
		<xsl:param name="x"         as="xs:double"/>
		<xsl:param name="y"         as="xs:double"/>
		<xsl:param name="width"     as="xs:double"/>
		<xsl:param name="height"    as="xs:double"/>
		<xsl:param name="row"       as="xs:integer"/>
		<xsl:param name="col"       as="xs:integer"/>
		<xsl:param name="rowHeight" as="xs:double"/>
		<xsl:variable name="td" select="$tds[1]"/>
		
		<xsl:if test="$td">
			<xsl:variable name="colWidth" select="t:td-width($td)"/>
			
			<xsl:call-template name="drawCells">
				<xsl:with-param name="cells"     select="$td/cell"/>
				<xsl:with-param name="x"         select="$x"/>
				<xsl:with-param name="y"         select="$y"/>
				<xsl:with-param name="width"     select="$width"/>
				<xsl:with-param name="height"    select="$height"/>
				<xsl:with-param name="row"       select="$row"/>
				<xsl:with-param name="col"       select="$col"/>
				<xsl:with-param name="rowHeight" select="$rowHeight"/>
			</xsl:call-template>
					
			<xsl:call-template name="drawTableContentData">
				<xsl:with-param name="tds"       select="$tds[position() &gt; 1]"/>
				<xsl:with-param name="x"         select="$x + $colWidth"/>
				<xsl:with-param name="y"         select="$y"/>
				<xsl:with-param name="width"     select="$width"/>
				<xsl:with-param name="height"    select="$height"/>
				<xsl:with-param name="row"       select="$row"/>
				<xsl:with-param name="col"       select="$col + 1"/>
				<xsl:with-param name="rowHeight" select="$rowHeight"/>
			</xsl:call-template> 
			
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template name="drawCells">
		<xsl:param name="cells"/>
		<xsl:param name="x"         as="xs:double"/>
		<xsl:param name="y"         as="xs:double"/>
		<xsl:param name="width"     as="xs:double"/>
		<xsl:param name="height"    as="xs:double"/>
		<xsl:param name="row"       as="xs:integer"/>
		<xsl:param name="col"       as="xs:integer"/>
		<xsl:param name="rowHeight" as="xs:double"/>
		<xsl:variable name="cell" select="$cells[1]"/>
		
		<xsl:if test="$cell">
			<xsl:variable name="cellHeight" select="if ($cell/@height) then $cell/@height else $rowHeight" as="xs:double"/>
			
			<xsl:call-template name="drawCell">
				<xsl:with-param name="cell"      select="$cell"/>
				<xsl:with-param name="x"         select="$x"/>
				<xsl:with-param name="y"         select="$y"/>
				<xsl:with-param name="width"     select="$width+2"/>
				<xsl:with-param name="height"    select="$height"/>
				<xsl:with-param name="row"       select="$row"/>
				<xsl:with-param name="col"       select="$col"/>
				<xsl:with-param name="cellHeight" select="$cellHeight"/>
			</xsl:call-template>	
			
			<xsl:call-template name="drawCells">
				<xsl:with-param name="cells"     select="$cells[position() &gt; 1]"/>
				<xsl:with-param name="x"         select="$x"/>
				<xsl:with-param name="y"         select="$y + $cellHeight"/>
				<xsl:with-param name="width"     select="$width"/>
				<xsl:with-param name="height"    select="$height"/>
				<xsl:with-param name="row"       select="$row"/>
				<xsl:with-param name="col"       select="$col"/>
				<xsl:with-param name="rowHeight" select="$rowHeight"/>
			</xsl:call-template>			
		</xsl:if>
	</xsl:template>
	
	
	
	<xsl:template name="drawCell">
		<xsl:param name="cell"/>
		<xsl:param name="x"          as="xs:double"/>
		<xsl:param name="y"          as="xs:double"/>
		<xsl:param name="width"      as="xs:double"/>
		<xsl:param name="height"     as="xs:double"/>
		<xsl:param name="row"        as="xs:integer"/>
		<xsl:param name="col"        as="xs:integer"/>
		<xsl:param name="cellHeight" as="xs:double"/>
		
		<xsl:variable name="w"     select="$cell/@width"  as="xs:double"/>
		<xsl:variable name="h"     select="$cellHeight"/>
		<xsl:variable name="s"     select="normalize-space($cell)" as="xs:string"/>
		<xsl:variable name="image" select="$cell/@image"/>
		
		<xsl:variable name="border"     select="$cell/@border"/>
        <xsl:variable name="leftBorder" select="$cell/@border-left"/>
        <xsl:variable name="rightBorder" select="$cell/@border-right"/>
		<xsl:variable name="gradient"   select="$cell/@gradient"/>
		<xsl:variable name="hatching"   select="$cell/@hatching"/>
		<xsl:variable name="foreground" select="if ($cell/@foreground) then $cell/@foreground else 'black'"/>
		<xsl:variable name="background" select="if ($cell/@background) then $cell/@background else 'none'"/>
		
		<xsl:if test="$image">
			<xsl:variable name="d" select="$gridWidth * $cellBorderWidthFactor" as="xs:double"/>
			<image xlink:href="{$image}" x="{$x + $d}" y="{$y + $d}" width="{$w - 2.0 * $d}" height="{$h - 2.0 * $d}"/>
            <xsl:if test="$leftBorder">
                <rect	fill         ="{$background}"
                        stroke       ="{$gridColor}"
                        stroke-width ="{$gridWidth}"
                        x="{$x}" y="{$y}" width="{$w}" height="{$h}"/>

                <rect	fill         ="{$leftBorder}"
                        stroke       ="none"
                        x="{$x + 0.5 * $gridWidth}" y="{$y + 0.5 * $gridWidth}" width="{$gridWidth * $cellBorderWidthFactor}" height="{$h - $gridWidth}"/>
            </xsl:if>
	    </xsl:if>
		
		<xsl:if test="$s!=''">
			<!-- background: with/without border -->
			<xsl:choose>
				<xsl:when test="$border">
					<xsl:variable name="borderStroke">
						<xsl:choose>
							<xsl:when test="$gradient">
								<xsl:value-of select="concat('url(#', t:gradient-id(string($gradient)), ')')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$border"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<rect	fill         ="{$borderStroke}"
							stroke       ="{$gridColor}"
							stroke-width ="{$gridWidth}"
							x="{$x}" y="{$y}" width="{$w}" height="{$h}"/>
							
					<xsl:variable name="d" select="$gridWidth * (0.5 + $cellBorderWidthFactor)" as="xs:double"/>
					
					<rect	fill         ="{$background}"
							stroke       ="none"
							x            = "{$x + $d}"
							y            = "{$y + $d}"
							width        = "{$w - 2.0*$d}"
							height       = "{$h - 2.0*$d}"/>
				</xsl:when>
				
				<xsl:when test="$leftBorder">
					<rect	fill         ="{$background}"
							stroke       ="{$gridColor}"
							stroke-width ="{$gridWidth}"
							x="{$x}" y="{$y}" width="{$w}" height="{$h}"/>

					<rect	fill         ="{$leftBorder}"
							stroke       ="none"
							x="{$x + 0.5 * $gridWidth}" y="{$y + 0.5 * $gridWidth}" width="{$gridWidth * $cellBorderWidthFactor}" height="{$h - $gridWidth}"/>
				</xsl:when>

				<xsl:otherwise>
				<rect	fill         ="{$background}"
						stroke       ="{$gridColor}"
						stroke-width ="{$gridWidth}"
						x="{$x}" y="{$y}" width="{$w}" height="{$h}"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="$hatching">
				<rect	stroke = "none"
						fill   = "url(#hatching)"
						x="{$x}" y="{$y}" width="{$w}" height="{$h}"/>	
			</xsl:if>
			
			<!-- text: horizontal / vertial -->
			<xsl:choose>
				<xsl:when test="$cell/@text-orientation='vertical'">
					<xsl:variable name="tx" select="$x + 0.5*$w + 0.5*$cellFontSize"/>
					<xsl:variable name="ty" select="$y + $h - 0.5*$cellFontSize"/>
					<text 	transform="translate({$tx},{$ty}) rotate(-90.0)"
							x="0" y="0"
							fill        = "{$foreground}"
							font-family = "{$cellFont}"
							font-size   = "{$cellFontSize}"><xsl:value-of select="$s"/></text>
						
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="anchor" select="$cell/@text-anchor"/>
					<xsl:variable name="tx" select="$x + (if ($anchor='middle') then 0.5*$w else 0.5*$cellFontSize)"/>
					<xsl:variable name="ty" select="$y + 0.5*$h + 0.4*$cellFontSize"/>
					
					<text x="{$tx}" y="{$ty}"
						fill        = "{$foreground}"
						font-family = "{$cellFont}"
						font-size   = "{$cellFontSize}"
						text-anchor ="{$anchor}"><xsl:value-of select="$s"/></text>
					
				</xsl:otherwise>
			</xsl:choose>

            <xsl:if test="$rightBorder">
                <rect	fill         ="{$rightBorder}"
                        stroke       ="none"
                        x="{$x + $w - $gridWidth * $cellBorderWidthFactor}" y="{$y + $gridWidth}" width="{$gridWidth * $cellBorderWidthFactor}" height="{$h - $gridWidth}"/>
            </xsl:if>
		</xsl:if> <!-- end if non-empty text -->
	</xsl:template>
	
	
	
	<xsl:function name="t:gradient-id">
		<xsl:param name="color" as="xs:string"/>
		<xsl:value-of select="concat('gradient_', substring($color, 2))"/>
	</xsl:function>
	
	
	<!-- computes the total width of a table -->
	<xsl:function name="t:table-width" as="xs:double">
		<xsl:param name="table"/>
		<xsl:value-of select="sum($table/columnHeader/tr[1]/td/cell/@width)"/>
	</xsl:function>
	
	
	<!-- computes the total height of a table content -->
	<xsl:function name="t:tableContent-height" as="xs:double">
		<xsl:param name="tableContent"/>
		<xsl:value-of select="sum(for $i in $tableContent/tr return t:tr-height($i))"/>
	</xsl:function>
	
	
	<!-- computes the height of a tr element --> 
	<xsl:function name="t:tr-height" as="xs:double">
		<xsl:param name="tr"/>
		<xsl:value-of select="max(for $i in $tr/td return t:td-height($i))"/>
	</xsl:function>	
	
	
	<!-- computes the height of a td element --> 
	<xsl:function name="t:td-height" as="xs:double">
		<xsl:param name="td"/>
		<xsl:value-of select="sum($td/cell/@height)"/>
	</xsl:function>
	
	
	<!-- computes the width of a td element --> 
	<xsl:function name="t:td-width" as="xs:double">
		<xsl:param name="td"/>
		<xsl:value-of select="max($td/cell/@width)"/>
	</xsl:function>
	
	
	<!-- default -->
	<xsl:template match="node()">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>