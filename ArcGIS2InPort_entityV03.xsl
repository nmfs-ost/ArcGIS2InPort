<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="esri res t msxsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.esri.com/xslt/translator" xmlns:esri="http://www.esri.com/metadata/" xmlns:res="http://www.esri.com/metadata/res/" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
	<xsl:template match="/">
		<xsl:variable name="parentCatalogItemId" select="'[parentCatalogItemId]'" />	
		<xsl:variable name="catalogItemId" select="'[catalogItemId]'" />	
		<!-- Last Update: InPort Release 3.9.4.0 -->
		<!--Note: only the dates from the time period section are included.  Times are not.-->
		<!--Make sure the encoding is UTF-8!!! -->
		<inport-metadata version="1.6">
			<item-identification>
				<catalog-item-type>Entity</catalog-item-type>
				<title><xsl:value-of select="metadata/eainfo/detailed/@Name"/></title>
				<!--
				<xsl:variable name="myFileID" select="metadata/mdFileID" />
				<xsl:choose>
					<xsl:when test="contains($myFileID,'inport:')">
						<parent-catalog-item-id><xsl:value-of select="substring-after($myFileID,'inport:')"/></parent-catalog-item-id>	
					</xsl:when>
					<xsl:otherwise>
						<parent-catalog-item-id><xsl:value-of select="metadata/mdFileID"/></parent-catalog-item-id>
					</xsl:otherwise>
				</xsl:choose>
				-->
				<parent-catalog-item-id><xsl:value-of select="$parentCatalogItemId"/></parent-catalog-item-id>
				<catalog-item-id><xsl:value-of select="$catalogItemId"/></catalog-item-id>
			</item-identification>			
			<entity-information>
				<!-- added/modified by JFK 20220609 -->
				<!-- <entity-type>GIS File</entity-type> -->
				<entity-type>Data Table</entity-type>
				<active-version>Yes</active-version>
				<description><xsl:value-of select="metadata/eainfo/detailed/enttyp/enttypd"/>; Source: <xsl:value-of select="metadata/eainfo/detailed/enttyp/enttypds"/></description>
			</entity-information>
			<data-attributes>
				<xsl:for-each select="metadata/eainfo/detailed/attr">
				<data-attribute>
					<seq-order><xsl:value-of select="position()"/></seq-order>
					<name><xsl:value-of select="attrlabl"/></name>
					<data-storage-type>n/a</data-storage-type>
					<status>Active</status>
					<description><xsl:value-of select="attrdef"/>; Source: <xsl:value-of select="attrdefs"/></description>
					<xsl:choose>
						<xsl:when test="attrdomv/codesetd">
							<allowed-values>Code Set: <xsl:value-of select="attrdomv/codesetd/codesetn"/>; Source: <xsl:value-of select="attrdomv/codesetd/codesets"/></allowed-values>
						</xsl:when>
						<xsl:when test="attrdomv/edom">
							<allowed-values>
							<xsl:for-each select="attrdomv/edom">
								<xsl:sort select="edomv"/>
								<xsl:value-of select="edomv"/>: <xsl:value-of select="edomvd"/>;<xsl:text> </xsl:text>
							</xsl:for-each>
							</allowed-values>
						</xsl:when>
						<xsl:when test="attrdomv/rdom">
							<allowed-values><xsl:value-of select="attrdomv/rdom/rdommin"/> to <xsl:value-of select="attrdomv/rdom/rdommax"/></allowed-values>
						</xsl:when>
						<xsl:when test="attrdomv/udom">
							<allowed-values><xsl:value-of select="attrdomv/udom"/></allowed-values>
						</xsl:when>
					</xsl:choose>
				</data-attribute>
				</xsl:for-each>
			</data-attributes>
		</inport-metadata>
	</xsl:template>	
</xsl:stylesheet>
