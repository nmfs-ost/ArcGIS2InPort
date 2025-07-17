<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="esri res t msxsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="http://www.esri.com/xslt/translator" xmlns:esri="http://www.esri.com/metadata/" xmlns:res="http://www.esri.com/metadata/res/" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
	<xsl:template match="/">
		<!-- Last Update: InPort Release 4.6.0.0 -->
		<!--Note: only the dates from the time period section are included.  Times are not.-->
		<!--Make sure the encoding is UTF-8!!! -->
		<!-- added/modified TJH -->
		<!-- some variables to use ... -->
		<!-- When creating a new record, just specify parentCatalogItemId, when updating, only specify catalogItemId -->
		<!--<xsl:variable name="parentCatalogItemId" select="'99999'" />	-->
		<!--<xsl:variable name="catalogItemId" select="''" /> -->
		<!-- the effective date for contacts is not provided in metadata so must be provided here -->
		<!--<xsl:variable name="defaultEffectiveDate" select="'2015-5-11'"/>		-->
		<!-- these variables only need to be filled in if you don't have the various contact roles defined in your metadata -->
		<xsl:variable name="defaultPointOfContactEmail" select="'nopointofcontact@noaa.gov'" />
		<xsl:variable name="defaultDataStewardEmail" select="'nodatasteward@noaa.gov'" />
		<xsl:variable name="defaultMetadataContactEmail" select="'nometadatacontact@noaa.gov'" />
		<xsl:variable name="defaultPointOfContactName" select="'No Point of Contact'" />
		<xsl:variable name="defaultDataStewardName" select="'No Data Steward'" />
		<xsl:variable name="defaultMetadataContactName" select="'No Metadata Contact'" />		
		<xsl:variable name="defaultOrganizationName" select="'No Organization'" />
		<xsl:variable name="esriCreaDate" select="metadata/Esri/CreaDate" />
		<xsl:variable name="defaultEffectiveDate" select="concat(concat(concat(concat(concat(substring($esriCreaDate,1,4),'-'),substring($esriCreaDate,5,2)),'-'),substring($esriCreaDate,7,2)),'T')" />		

		<!-- other global changes made -->
		<!--    - replaced <person-email> with <contact-email> -->
		<!--    - used variables for Effective date and email for Distributor, Point Of Contact, Data Steward, Metadata Contact -->
		<!-- added/modified TJH end -->
		<!-- <inport-metadata version="1.6"> modified JFK end -->
		<inport-metadata xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.11" source="https://www.fisheries.noaa.gov">
			<item-identification>
				<catalog-item-type>Data Set</catalog-item-type>
				<title><xsl:value-of select="metadata/dataIdInfo/idCitation/resTitle"/></title>
				<!-- added/modified TJH -->
				<!-- use parent-catalog-item-id for a new item -->
				<!--<parent-catalog-item-id><xsl:value-of select="$parentCatalogItemId"/></parent-catalog-item-id>-->
				<!--<catalog-item-id><xsl:value-of select="$catalogItemId"/></catalog-item-id>-->
				<!-- use catalog-item-id for an updated item -->
				<!--
				<xsl:variable name="myFileID" select="metadata/mdFileID" />
				<xsl:choose>
					<xsl:when test="contains($myFileID,'inport:')">
						<catalog-item-id><xsl:value-of select="substring-after($myFileID,'inport:')"/></catalog-item-id>	
					</xsl:when>
					<xsl:otherwise>
						<catalog-item-id><xsl:value-of select="metadata/mdFileID"/></catalog-item-id>
					</xsl:otherwise>
				</xsl:choose>
				-->
				<!-- end added/modified TJH -->
				<!-- added/modified JFK 5/29/2025 -->								
				<xsl:variable name="mdFileID" select="metadata/mdFileID" />
				<xsl:choose>
					<xsl:when test="contains($mdFileID,'inport:')">
						<catalog-item-id><xsl:value-of select="substring-after($mdFileID,'inport:')"/></catalog-item-id>	
					</xsl:when>
					<xsl:otherwise>
						<catalog-item-id><xsl:value-of select="metadata/mdFileID"/></catalog-item-id>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:variable name="mdParentID" select="metadata/mdParentID" />
				<xsl:choose>
					<xsl:when test="contains($mdParentID,'inport:')">
						<parent-catalog-item-id><xsl:value-of select="substring-after($mdParentID,'inport:')"/></parent-catalog-item-id>	
					</xsl:when>
					<xsl:otherwise>
						<parent-catalog-item-id><xsl:value-of select="metadata/mdParentID"/></parent-catalog-item-id>
					</xsl:otherwise>
				</xsl:choose>				
				<!-- end added/modified JFK 5/28/2025 -->				
				<status>
					<xsl:for-each select="(/metadata/dataIdInfo[1]/idStatus/ProgCd/@value)[1]">
						<xsl:choose>
							<xsl:when test=". = '001'"><xsl:text>Complete</xsl:text></xsl:when>
							<xsl:when test=". = '002'"><xsl:text>Complete</xsl:text></xsl:when>
							<xsl:when test=". = '003'"><xsl:text>Complete</xsl:text></xsl:when>
							<xsl:when test=". = '004'"><xsl:text>In Work</xsl:text></xsl:when>
							<xsl:when test=". = '005'"><xsl:text>Planned</xsl:text></xsl:when>
							<xsl:when test=". = '006'"><xsl:text>Planned</xsl:text></xsl:when>
							<xsl:when test=". = '007'"><xsl:text>In Work</xsl:text></xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</status>
				<abstract>
					<xsl:call-template name="strip-tags">
						<xsl:with-param name="text" select="metadata/dataIdInfo/idAbs"/>
					</xsl:call-template>
				</abstract>
				<purpose>
					<xsl:value-of select="metadata/dataIdInfo/idPurp"/>
				</purpose>
				<xsl:variable name="mypubdate" select="metadata/dataIdInfo/idCitation/date/pubDate" />
				<publication-date><xsl:value-of select="substring-before($mypubdate,'T')"/></publication-date>
			</item-identification>
			<keywords>
				<xsl:for-each select="/metadata/dataIdInfo/themeKeys"> 
					<xsl:choose>
						<xsl:when test="contains(keyword,', ')">
							<keyword>
							<keyword-type>Theme</keyword-type>
							<xsl:call-template name="tokenize">
								<xsl:with-param name="text" select="keyword"/>
								<xsl:with-param name="elemName" select="'keyword'"/>
							</xsl:call-template>
							</keyword>
						</xsl:when>
						<xsl:otherwise>
							<keyword>
								<keyword-type>Theme</keyword-type>
								<xsl:if test="thesaName">
									<thesaurus><xsl:value-of select="thesaName/resTitle"/></thesaurus>
								</xsl:if>
								<xsl:for-each select="keyword">
									<keyword><xsl:value-of select="."/></keyword>
								</xsl:for-each>
							</keyword>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:for-each>
				<xsl:for-each select="/metadata/dataIdInfo/placeKeys"> 
					<xsl:choose>
						<xsl:when test="contains(keyword,', ')">
							<keyword>
							<keyword-type>Spatial</keyword-type>
							<xsl:call-template name="tokenize">
								<xsl:with-param name="text" select="keyword"/>
								<xsl:with-param name="elemName" select="'keyword'"/>
							</xsl:call-template>
							</keyword>
						</xsl:when>
						<xsl:otherwise>
							<keyword>
								<keyword-type>Spatial</keyword-type>
								<xsl:if test="thesaName">
									<thesaurus><xsl:value-of select="thesaName/resTitle"/></thesaurus>
								</xsl:if>
								<xsl:for-each select="keyword">
									<keyword><xsl:value-of select="."/></keyword>
								</xsl:for-each>
							</keyword>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:for-each>
				<!--
				<xsl:for-each select="/metadata/dataIdInfo/placeKeys">
				<keyword>
					<keyword-type>Spatial</keyword-type>
					<xsl:if test="thesaName">
						<thesaurus><xsl:value-of select="thesaName/resTitle"/></thesaurus>
					</xsl:if>
					<xsl:for-each select="keyword">
						<keyword><xsl:value-of select="."/></keyword>
					</xsl:for-each>
				</keyword>
				</xsl:for-each>-->
				<xsl:if test="/metadata/dataIdInfo/tpCat">
				<keyword>
					<keyword-type>Theme</keyword-type>
					<thesaurus>ISO 19115 Topic Category</thesaurus>
					<xsl:for-each select="/metadata/dataIdInfo/tpCat">
						<xsl:choose>
							<xsl:when test="TopicCatCd/@value = '001'"><keyword>farming</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '002'"><keyword>biota</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '003'"><keyword>boundaries</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '004'"><keyword>climatologyMeteorologyAtmosphere</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '005'"><keyword>economy</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '006'"><keyword>elevation</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '007'"><keyword>environment</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '008'"><keyword>geoscientificInformation</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '009'"><keyword>health</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '010'"><keyword>imageryBaseMapsEarthCover</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '011'"><keyword>intelligenceMilitary</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '012'"><keyword>inlandWaters</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '013'"><keyword>location</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '014'"><keyword>oceans</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '015'"><keyword>planningCadastre</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '016'"><keyword>society</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '017'"><keyword>structure</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '018'"><keyword>transportation</keyword></xsl:when>
							<xsl:when test="TopicCatCd/@value = '019'"><keyword>utilitiesCommunication</keyword></xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</keyword>
				</xsl:if>
			</keywords>
			<!-- added/modified TJH -->
			<!-- this wasn't matching anything, because it was referencing a specific role code ('006') ... removed the role to just look for the single contact regardless of role -->
			<physical-location>
				<city><xsl:value-of select="/metadata/dataIdInfo/idPoC/rpCntInfo/cntAddress/city"/></city>
				<state-province><xsl:value-of select="/metadata/dataIdInfo/idPoC/rpCntInfo/cntAddress/adminArea"/></state-province>
			</physical-location>
			<!-- added/modified TJH end -->
			<data-set-information>
				<data-set-scope-code>Data Set</data-set-scope-code>
				<maintenance-frequency>
				<xsl:for-each select="(/metadata/dataIdInfo[1]/resMaint/maintFreq/MaintFreqCd/@value)[1]">
					<xsl:choose>
						<xsl:when test=". = '001'"><xsl:text>Continually</xsl:text></xsl:when>
						<xsl:when test=". = '002'"><xsl:text>Daily</xsl:text></xsl:when>
						<xsl:when test=". = '003'"><xsl:text>Weekly</xsl:text></xsl:when>
						<xsl:when test=". = '004'"><xsl:text>Every Other Week</xsl:text></xsl:when>
						<xsl:when test=". = '005'"><xsl:text>Monthly</xsl:text></xsl:when>
						<xsl:when test=". = '006'"><xsl:text>Quarterly</xsl:text></xsl:when>
						<xsl:when test=". = '007'"><xsl:text>Twice a Year</xsl:text></xsl:when>
						<xsl:when test=". = '008'"><xsl:text>Annually</xsl:text></xsl:when>
						<xsl:when test=". = '009'"><xsl:text>As Needed</xsl:text></xsl:when>
						<xsl:when test=". = '010'"><xsl:text>Irregular</xsl:text></xsl:when>
						<xsl:when test=". = '011'"><xsl:text>None Planned</xsl:text></xsl:when>
						<xsl:when test=". = '012'"><xsl:text>Unknown</xsl:text></xsl:when>
					</xsl:choose>
				</xsl:for-each>
				</maintenance-frequency>
				<!-- added/modified TJH 20201214 moving publication status and date to item-identification section -->
				<!-- <data-set-publication-status>Published</data-set-publication-status> -->
				<!-- end TJH 20201214 -->
				<!-- added/modified TJH 20201214 moving publication status and date to item-identification section -->
				<!--    need to remove the time from the time stamp ... InPort is expecting only a date -->
				<!--    <xsl:variable name="mypubdate" select="metadata/dataIdInfo/idCitation/date/pubDate" /> -->
				<!--    <publish-date><xsl:value-of select="substring-before($mypubdate,'T')"/></publish-date> -->
				<!--    end added/modified TJH -->
				<!-- end TJH 20201214 -->
				<data-presentation-form>
				<xsl:for-each select="(metadata/dataIdInfo/idCitation/presForm/PresFormCd/@value)[1]">
					<xsl:choose>
						<xsl:when test=". = '001'"><xsl:text>Document (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '002'"><xsl:text>Document (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '003'"><xsl:text>Image (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '004'"><xsl:text>Image (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '005'"><xsl:text>Map (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '006'"><xsl:text>Map (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '007'"><xsl:text>Model (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '008'"><xsl:text>Model (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '009'"><xsl:text>Profile (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '010'"><xsl:text>Profile (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '011'"><xsl:text>Table (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '012'"><xsl:text>Table (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '013'"><xsl:text>Video (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '014'"><xsl:text>Video (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '015'"><xsl:text>Audio (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '016'"><xsl:text>Audio (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '017'"><xsl:text>Multimedia (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '018'"><xsl:text>Multimedia (hardcopy)</xsl:text></xsl:when>
						<xsl:when test=". = '019'"><xsl:text>Diagram (digital)</xsl:text></xsl:when>
						<xsl:when test=". = '020'"><xsl:text>Diagram (hardcopy)</xsl:text></xsl:when>
					</xsl:choose>
				</xsl:for-each>
				</data-presentation-form>
				<xsl:choose>
					<xsl:when test="metadata/dataIdInfo/idCredit">
						<xsl:choose>
							<xsl:when test="count (metadata/dataIdInfo/idCitation/citRespParty[role/RoleCd/@value = 006]) = 0">
								<data-set-credit><xsl:value-of select="metadata/dataIdInfo/idCredit"/></data-set-credit>
							</xsl:when>
							<xsl:otherwise>
								<data-set-credit>
									<xsl:text>CREDIT: </xsl:text>
									<xsl:value-of select="metadata/dataIdInfo/idCredit"/>
									<xsl:text>   ORIGINATORS: </xsl:text>
									<xsl:for-each select="metadata/dataIdInfo/idCitation/citRespParty/rpOrgName">
										<xsl:value-of select="."/>
										<xsl:text>; </xsl:text>
									</xsl:for-each>
								</data-set-credit>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="metadata/dataIdInfo/idCitation/citRespParty[role/RoleCd/@value = 006]">
							<data-set-credit>
							<xsl:text>ORIGINATORS: </xsl:text>
							<xsl:for-each select="metadata/dataIdInfo/idCitation/citRespParty/rpOrgName">
								<xsl:value-of select="."/>
								<xsl:text>; </xsl:text>
							</xsl:for-each>
							</data-set-credit>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</data-set-information>
			<support-roles>
				<!-- Data Steward is required -->
				<xsl:for-each select="/metadata/dataIdInfo/idCitation/citRespParty">
					<support-role>
						<support-role-type>Data Steward</support-role-type>
						<from-date><xsl:value-of select="substring-before($defaultEffectiveDate,'T')"/></from-date>	
						<xsl:choose>
							<xsl:when test="not(rpIndName) and not(rpCntInfo/cntAddress/eMailAdd) and rpOrgName">
								<contact-type>Organization</contact-type>
								<contact-name><xsl:value-of select="rpOrgName"/></contact-name>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="rpIndName">
										<contact-type>Person</contact-type>
										<contact-name><xsl:value-of select="rpIndName"/></contact-name>
										<xsl:choose>
											<xsl:when test="rpCntInfo/cntAddress/eMailAdd">
												<contact-email><xsl:value-of select="rpCntInfo/cntAddress/eMailAdd"/></contact-email>
											</xsl:when>
											<xsl:otherwise>
												<contact-email><xsl:value-of select="$defaultDataStewardEmail"/></contact-email>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="rpCntInfo/cntAddress/eMailAdd">
												<contact-type>Person</contact-type>
												<xsl:variable name="tmpEmail" select="rpCntInfo/cntAddress/eMailAdd"/>
												<contact-name><xsl:value-of select="translate(substring-before($tmpEmail,'@noaa.gov'),'\.','\ ')"/></contact-name>
												<contact-email><xsl:value-of select="rpCntInfo/cntAddress/eMailAdd"/></contact-email>
											</xsl:when>
											<xsl:otherwise>
												<contact-type>Person</contact-type>
												<contact-name><xsl:value-of select="$defaultDataStewardName"/></contact-name>
												<contact-email><xsl:value-of select="$defaultDataStewardEmail"/></contact-email>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>								
							</xsl:otherwise>
						</xsl:choose>
					</support-role>	
				</xsl:for-each>					
				<!-- Distributor organization is required -->
				<xsl:for-each select="/metadata/distInfo/distributor/distorCont">
					<support-role>
						<support-role-type>Distributor</support-role-type>
						<contact-type>Organization</contact-type>
						<from-date><xsl:value-of select="substring-before($defaultEffectiveDate,'T')"/></from-date>	
						<xsl:choose>
							<xsl:when test="rpOrgName">
								<contact-name><xsl:value-of select="rpOrgName"/></contact-name>
							</xsl:when>
							<xsl:otherwise>
								<contact-name><xsl:value-of select="$defaultOrganizationName"/></contact-name>
							</xsl:otherwise>
						</xsl:choose>
					</support-role>	
				</xsl:for-each>					
			
				<!-- Point of Contact is required. -->
				<xsl:for-each select="/metadata/dataIdInfo/idPoC">
					<support-role>
						<support-role-type>Point of Contact</support-role-type>
						<from-date><xsl:value-of select="substring-before($defaultEffectiveDate,'T')"/></from-date>	
						<xsl:choose>
							<xsl:when test="not(rpIndName) and not(rpCntInfo/cntAddress/eMailAdd) and rpOrgName">
								<contact-type>Organization</contact-type>
								<contact-name><xsl:value-of select="rpOrgName"/></contact-name>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="rpIndName">
										<contact-type>Person</contact-type>
										<contact-name><xsl:value-of select="rpIndName"/></contact-name>
										<xsl:choose>
											<xsl:when test="rpCntInfo/cntAddress/eMailAdd">
												<contact-email><xsl:value-of select="rpCntInfo/cntAddress/eMailAdd"/></contact-email>
											</xsl:when>
											<xsl:otherwise>
												<contact-email><xsl:value-of select="$defaultPointOfContactEmail"/></contact-email>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="rpCntInfo/cntAddress/eMailAdd">
												<contact-type>Person</contact-type>
												<xsl:variable name="tmpEmail" select="rpCntInfo/cntAddress/eMailAdd"/>
												<contact-name><xsl:value-of select="translate(substring-before($tmpEmail,'@noaa.gov'),'\.','\ ')"/></contact-name>
												<contact-email><xsl:value-of select="rpCntInfo/cntAddress/eMailAdd"/></contact-email>
											</xsl:when>
											<xsl:otherwise>
												<contact-type>Person</contact-type>
												<contact-name><xsl:value-of select="$defaultPointOfContactName"/></contact-name>
												<contact-email><xsl:value-of select="$defaultPointOfContactEmail"/></contact-email>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>								
							</xsl:otherwise>
						</xsl:choose>
					</support-role>	
				</xsl:for-each>					
				<!-- Metadata Point of Contact is required -->
				<xsl:for-each select="/metadata/mdContact">
					<support-role>
						<support-role-type>Metadata Contact</support-role-type>
						<from-date><xsl:value-of select="substring-before($defaultEffectiveDate,'T')"/></from-date>	
						<xsl:choose>
							<xsl:when test="not(rpIndName) and not(rpCntInfo/cntAddress/eMailAdd) and rpOrgName">
								<contact-type>Organization</contact-type>
								<contact-name><xsl:value-of select="rpOrgName"/></contact-name>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="rpIndName">
										<contact-type>Person</contact-type>
										<contact-name><xsl:value-of select="rpIndName"/></contact-name>
										<xsl:choose>
											<xsl:when test="rpCntInfo/cntAddress/eMailAdd">
												<contact-email><xsl:value-of select="rpCntInfo/cntAddress/eMailAdd"/></contact-email>
											</xsl:when>
											<xsl:otherwise>
												<contact-email><xsl:value-of select="$defaultMetadataContactEmail"/></contact-email>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="rpCntInfo/cntAddress/eMailAdd">
												<contact-type>Person</contact-type>
												<xsl:variable name="tmpEmail" select="rpCntInfo/cntAddress/eMailAdd"/>
												<contact-name><xsl:value-of select="translate(substring-before($tmpEmail,'@noaa.gov'),'\.','\ ')"/></contact-name>
												<contact-email><xsl:value-of select="rpCntInfo/cntAddress/eMailAdd"/></contact-email>
											</xsl:when>
											<xsl:otherwise>
												<contact-type>Person</contact-type>
												<contact-name><xsl:value-of select="$defaultMetadataContactName"/></contact-name>
												<contact-email><xsl:value-of select="$defaultMetadataContactEmail"/></contact-email>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>								
							</xsl:otherwise>
						</xsl:choose>
					</support-role>	
				</xsl:for-each>					
			</support-roles>
			<extents>
				<currentness-reference>Publication Date</currentness-reference>
				<!-- added/modified JFK 20220607-->
				<xsl:for-each select="/metadata/dataIdInfo/dataExt">
					<extent>
						<!-- added/modified TJH -->
						<!-- moved description out of time-frames -->
						<!-- added choose/when to support TM_Period time frame -->
						<!-- added/modified JFK 20220607-->
						<description>
							<!-- <xsl:value-of select="dataExt/exDesc"/> -->
							<!-- <xsl:value-of select="/metadata/dataIdInfo/dataExt/exDesc"/> -->
							<xsl:value-of select="exDesc"/>
						</description>
						<time-frames>
							<!-- <xsl:for-each select="/metadata/dataIdInfo/dataExt/tempEle"> -->
							<!-- <xsl:for-each select="dataExt/tempEle"> -->
							<!-- added/modified JFK 20220607-->
							<xsl:for-each select="tempEle">
								<time-frame>
									<xsl:choose>
										<xsl:when test="TempExtent/exTemp/TM_Instant">
											<time-frame-type>Discrete</time-frame-type>
											<start-date-time><xsl:value-of select="TempExtent/exTemp/TM_Instant/tmPosition"/></start-date-time>
											<!-- added/modified JFK 20220607-->
											<!-- <description><xsl:value-of select="../exDesc"/></description> -->
										</xsl:when>
										<xsl:when test="TempExtent/exTemp/TM_Period">
											<time-frame-type>Range</time-frame-type>
											<start-date-time><xsl:value-of select="TempExtent/exTemp/TM_Period/tmBegin"/></start-date-time>
											<end-date-time><xsl:value-of select="TempExtent/exTemp/TM_Period/tmEnd"/></end-date-time>
										</xsl:when>
									</xsl:choose>		
								<!-- end added/modified TJH -->
								</time-frame>
							</xsl:for-each>
						</time-frames>
						<geographic-areas>
							<!-- <xsl:for-each select="/metadata/dataIdInfo/dataExt/geoEle/GeoBndBox"> -->
							<!-- added/modified JFK 20220607-->
							<!-- <xsl:for-each select="dataExt/geoEle/GeoBndBox"> -->
							<xsl:for-each select="geoEle">
								<geographic-area>
									<!-- added/modified JFK 20220607-->
									<!-- <west-bound><xsl:value-of select="westBL"/></west-bound> -->
									<!-- <east-bound><xsl:value-of select="eastBL"/></east-bound> -->
									<!-- <north-bound><xsl:value-of select="northBL"/></north-bound> -->
									<!-- <south-bound><xsl:value-of select="southBL"/></south-bound> -->
									<west-bound><xsl:value-of select="GeoBndBox/westBL"/></west-bound>
									<east-bound><xsl:value-of select="GeoBndBox/eastBL"/></east-bound>
									<north-bound><xsl:value-of select="GeoBndBox/northBL"/></north-bound>
									<south-bound><xsl:value-of select="GeoBndBox/southBL"/></south-bound>
								</geographic-area>
							</xsl:for-each>
						</geographic-areas>
					</extent>
				</xsl:for-each>
			</extents>
			<xsl:if test="/metadata/refSysInfo/RefSystem/refSysID/idCodeSpace = 'EPSG'">
				<spatial-information>
					<reference-systems>
						<reference-system>
							<coordinate-reference-system>
								<epsg-code><xsl:value-of select="/metadata/refSysInfo/RefSystem/refSysID/identCode/@code"/></epsg-code>
							</coordinate-reference-system>
						</reference-system>
					</reference-systems>
				</spatial-information>
			</xsl:if>
			<!--<spatial-information>
				<spatial-representation>
					<representations-used>
						<grid>No</grid>
						<vector>Yes</vector>
						<text-table>No</text-table>
						<tin>No</tin>
						<stereo-model>No</stereo-model>
						<video>No</video>
					</representations-used>					
					<vector-representations>
						<vector-representation>
							<topology-level>Enter the topology level from the following list of possible values:  Geometry Only, Topology 1D, Planar Graph, Full Planar Graph, Surface Graph, Full Surface Graph, Topology 3D, Full Topology 3D, Abstract.</topology-level>
							<complex-object>
								<present>Enter Yes or No, in regards to whether or not complex objects are present.</present>
								<count>Enter the count of complex objects (must be a positive integer). Only provide this node if complex objects are present.</count>
							</complex-object>
							<composite-object>
								<present>Enter Yes or No, in regards to whether or not composite objects are present.</present>
								<count>Enter the count of composite objects (must be a positive integer). Only provide this node if composite objects are present.</count>
							</composite-object>
							<curve-object>
								<present>Enter Yes or No, in regards to whether or not curve objects are present.</present>
								<count>Enter the count of curve objects (must be a positive integer). Only provide this node if curve objects are present.</count>
							</curve-object>
							<point-object>
								<present>Enter Yes or No, in regards to whether or not point objects are present.</present>
								<count>Enter the count of point objects (must be a positive integer). Only provide this node if point objects are present.</count>
							</point-object>
							<solid-object>
								<present>Enter Yes or No, in regards to whether or not solid objects are present.</present>
								<count>Enter the count of solid objects (must be a positive integer). Only provide this node if solid objects are present.</count>
							</solid-object>
							<surface-object>
								<present>Enter Yes or No, in regards to whether or not surface objects are present.</present>
								<count>Enter the count of surface objects (must be a positive integer). Only provide this node if surface objects are present.</count>
							</surface-object>
						</vector-representation>
					</vector-representations>
				</spatial-representation>
			</spatial-information>-->
			<access-information>
				<security-class>Unclassified</security-class>
				<xsl:choose>
					<xsl:when test="/metadata/dataIdInfo/resConst/LegConsts/useLimit">
						<data-use-constraints>
							<!-- added/modified TJH 20201214 Removing html from ArcGIS metadata element -->
							<xsl:call-template name="strip-tags">
								<xsl:with-param name="text" select="/metadata/dataIdInfo/resConst/LegConsts/useLimit"/>
							</xsl:call-template>						
							<!--<xsl:value-of select="/metadata/dataIdInfo/resConst/LegConsts/useLimit"/>-->
						</data-use-constraints>
					</xsl:when>
					<xsl:when test="/metadata/dataIdInfo/resConst/Consts/useLimit">
						<data-use-constraints>
							<!-- added/modified TJH 20201214 Removing html from ArcGIS metadata element -->
							<xsl:call-template name="strip-tags">
								<xsl:with-param name="text" select="/metadata/dataIdInfo/resConst/Consts/useLimit"/>
							</xsl:call-template>						
							<!--<xsl:value-of select="/metadata/dataIdInfo/resConst/Consts/useLimit"/>-->
						</data-use-constraints>
					</xsl:when>
				</xsl:choose>
			</access-information>
			<distribution-information>
			<!-- added/modified TJH -->
				<xsl:for-each select="metadata/distInfo/distTranOps/onLineSrc">			
					<distribution>
						<download-url><xsl:value-of select="linkage"/></download-url>
						<description>Data access URL</description>
						<!-- added file-type and compression ... InPort wants this -->
						<!-- An issue is, that the onLineSrc does not have a file type and compression, so it has to be pulled from the higher-level distFormat section -->
						<!-- TODO: if there are multiple online resources with different formats/compressions, then a different approach will be needed; specifically, multiple distributors would -->
						<!-- need to be set up in the metadata, each with its own format section, and online resource(s) -->
						<!-- for now this script assumes that all online resources have the same file format/compression -->
						<!-- modified JFK Nov. 9, 2023 --> 
						<!-- Deprecated Sept. 2023 <file-type><xsl:value-of select="/metadata/distInfo/distFormat/formatName"/></file-type> -->
						<distribution-format><xsl:value-of select="/metadata/distInfo/distFormat/formatName"/></distribution-format>
						<compression><xsl:value-of select="/metadata/distInfo/distFormat/fileDecmTech"/></compression>
						<!-- added distributor ... InPort wants this -->
						<!-- example from actual InPort xml
						<distributor cc-id="822167">
						<from-date><xsl:value-of select="$defaultEffectiveDate"/></from-date>
						<contact-type>Organization</contact-type>
						<contact-name>NMFS Office of Science and Technology</contact-name>
						</distributor>
						-->
						<distributor>
							<!-- unfortunately there's no where to pull a from and to date from ArcGIS metadata so must be hard coded-->
							<from-date><xsl:value-of select="substring-before($defaultEffectiveDate,'T')"/></from-date>
							<!-- Type is also hard-coded to Organization; should probably change so an individual could be used -->
							<contact-type>Organization</contact-type>
							<xsl:choose>
								<xsl:when test="/metadata/distInfo/distributor/distorCont/role/RoleCd[@value='005']">
									<contact-name><xsl:value-of select="/metadata/distInfo/distributor/distorCont[role/RoleCd/@value='005']/rpOrgName"/></contact-name>
								</xsl:when>
								<xsl:otherwise>
									<contact-name><xsl:value-of select="$defaultOrganizationName"/></contact-name>
								</xsl:otherwise>
							</xsl:choose>
						</distributor>
					</distribution>	
				</xsl:for-each>
				<!-- end added/modified TJH -->
			</distribution-information>
			<!-- added/modified TJH -->
			<!-- pulling these data from the citation under citRespParty, as this is where InPort stores it via ISO 19115 -->
			<!-- grabbing all URLs for all citRespParty ... so if a person has a URL in this section it will show up -->

			<urls>
				<xsl:for-each select="metadata/dataIdInfo/idCitation/citRespParty">
					<xsl:choose>
						<xsl:when test="rpCntInfo/cntOnlineRes">
							<url>
								<url><xsl:value-of select="rpCntInfo/cntOnlineRes/linkage"/></url>
								<name><xsl:value-of select="rpCntInfo/cntOnlineRes/orName"/></name>
								<url-type>Online Resource</url-type>
								<file-resource-format>
									<xsl:choose>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '001'"><xsl:text>Download</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '002'"><xsl:text>Information</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '003'"><xsl:text>Offline Access</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '004'"><xsl:text>Order</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '005'"><xsl:text>Search</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '006'"><xsl:text>Upload</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '007'"><xsl:text>Web Service</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '008'"><xsl:text>Email Service</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '009'"><xsl:text>Browser</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '010'"><xsl:text>File Access</xsl:text></xsl:when>
										<xsl:when test="rpCntInfo/cntOnlineRes/orFunct/OnFunctCd/@value = '011'"><xsl:text>Web Map Service</xsl:text></xsl:when>
									</xsl:choose>
								</file-resource-format>
								<description><xsl:value-of select="rpCntInfo/cntOnlineRes/orDesc"/></description>
							</url>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</urls>
			<!-- end added/modified TJH -->			
			<technical-environment>
				<description><xsl:value-of select="metadata/dataIdInfo/envirDesc"/></description>
			</technical-environment>
			<!-- added/modified TJH -->
			<!-- The data-quality section does not match well with the ArcGIS Quality section -->
			<!-- The best we can do is dump any values into specified in ArcGIS into the proper data-quality section -->
			<data-quality>
				<accuracy><xsl:value-of select="metadata/dqInfo/report[@type='DQQuanAttAcc']"/></accuracy>
				<horizontal-positional-accuracy><xsl:value-of select="metadata/dqInfo/report[@type='DQAbsExtPosAcc']"/></horizontal-positional-accuracy>
				<completeness-report><xsl:value-of select="metadata/dqInfo/report[@type='DQCompOm']"/><xsl:copy-of select="metadata/dqInfo/report[@type='DQCompComm']"/></completeness-report>
				<conceptual-consistency><xsl:value-of select="metadata/dqInfo/report[@type='DQConcConsis']"/></conceptual-consistency>
			</data-quality>
			<lineage>
				<!-- added/modified by JFK 20220607 -->
				<!-- Adding code to capture the Lineage Statement -->
				<lineage-statement>
					<xsl:value-of select="metadata/dqInfo/dataLineage/statement"/>
				</lineage-statement>
				<lineage-sources>
					<xsl:for-each select="metadata/dqInfo/dataLineage/dataSource">
					<lineage-source>
						<citation-title><xsl:value-of select="srcCitatn/resTitle"/></citation-title>
						<!--<originator-publisher-type>Non-InPort Person/Organization</originator-publisher-type>
						<originator-publisher><xsl:value-of select="srcCitatn/citRespParty/rpOrgName"/></originator-publisher>
						-->
						<!-- added/modified TJH -->
						<xsl:if test="srcCitatn/citRespParty/rpOrgName">
							<!-- TODO: this should be defined for the citRespParty in the role ... do this through a function? -->
							<contact-role-type>Originator</contact-role-type>
							<!-- TODO: not sure how to define contact-type dynamically -->
							<contact-type>Organization</contact-type>
							<contact-name><xsl:value-of select="srcCitatn/citRespParty/rpOrgName"/></contact-name>
						</xsl:if>
						<!-- added/modified TJH end -->						
						<xsl:if test="srcExt/tempEle/TempExtent/exTemp/TM_Instant">
							<extent-type>Discrete</extent-type>
							<extent-start-date-time><xsl:value-of select="srcExt/tempEle/TempExtent/exTemp/TM_Instant/tmPosition"/></extent-start-date-time>
						</xsl:if>
						<!-- added/modified TJH -->
						<xsl:if test="srcCitatn/citOnlineRes/linkage">
							<citation-url><xsl:value-of select="srcCitatn/citOnlineRes/linkage"/></citation-url>
							<citation-url-name>Source Online Linkage</citation-url-name>
							<citation-url-description>URL where the source data were originally accessed.</citation-url-description>
						</xsl:if>					
						<!-- added/modified TJH end -->						
						<source-contribution><xsl:value-of select="srcDesc"/></source-contribution>
					</lineage-source>
					</xsl:for-each>
				</lineage-sources>
				<lineage-process-steps>
					<xsl:for-each select="metadata/dqInfo/dataLineage/prcStep">
					<lineage-process-step>
						<sequence-number><xsl:value-of select="position()"/></sequence-number>
						<description><xsl:value-of select="stepDesc"/></description>
						<process-date-time><xsl:value-of select="stepDateTm"/></process-date-time>
						<!-- added/modified TJH 
						<process-contact-type>Non-InPort Person/Organization</process-contact-type>
						<process-contact><xsl:value-of select="stepProc/rpOrgName"/>, <xsl:value-of select="stepProc/rpPosName"/></process-contact>
						<process-contact-phone><xsl:value-of select="stepProc/rpCntInfo/cntPhone/voiceNum"/></process-contact-phone>
						<process-contact-email-address><xsl:value-of select="stepProc/rpCntInfo/cntAddress/eMailAdd"/></process-contact-email-address> -->
						<!--
						<process-contact>
							<contact-type>REQUIRED if process-contact is specified. Enter the type of Contact from the following list of possible values: Person, Organization, Position.</contact-type>
							<contact-email>EITHER contact-email or contact-name is REQUIRED if process-contact is specified. Enter the email address of the Contact, as it appears in InPort.</contact-email>
							<contact-name>EITHER contact-email or contact-name is REQUIRED if process-contact is specified. Enter the name of the Contact, as it appears in InPort. For persons, use the format "[First Name] [Last Name]" or "[First Name] [Middle Name] [Last Name]".</contact-name>
						</process-contact>
						NOTE when specifying the organization don't add any acronym ... for example Southwest Fisheries Science Center ... don't add SWFSC
						-->
						<process-contact>
							<contact-type>Organization</contact-type>
							<contact-name><xsl:value-of select="stepProc/rpOrgName"/></contact-name>
						</process-contact>
						<!-- end added/modified TJH -->
					</lineage-process-step>
					</xsl:for-each>
				</lineage-process-steps>
			</lineage>
			<entity-attribute-information>
				<entity>
					<item-identification>
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
						<!--<parent-catalog-item-id><xsl:value-of select="$parentCatalogItemId"/></parent-catalog-item-id>-->
						<!--<catalog-item-id><xsl:value-of select="$catalogItemId"/></catalog-item-id>-->
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
				</entity>
			</entity-attribute-information>
		</inport-metadata>
	</xsl:template>
	<xsl:template name="strip-tags">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '&lt;')">
				<xsl:value-of select="substring-before($text, '&lt;')"/>
				<xsl:call-template name="strip-tags">
					<xsl:with-param name="text" select="substring-after($text, '&gt;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="elemName"/>
		<xsl:param name="sep" select="', '"/>
		<xsl:choose>
			<xsl:when test="contains($text, $sep)">
				<xsl:element name="{$elemName}">
					<xsl:value-of select="substring-before($text, $sep)"/>
				</xsl:element>
				<!-- recursive call -->
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $sep)" />
					<xsl:with-param name="elemName" select="$elemName" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$elemName}">
					<xsl:value-of select="$text"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
