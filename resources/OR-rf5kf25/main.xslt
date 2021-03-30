<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:ns8="http://www.vrt.be/mig/viaa" 
    xmlns:ns9="http://www.vrt.be/mig/viaa/api" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:ebu="urn:ebu:metadata-schema:ebuCore_2012" 
    xmlns:vrt="http://this.this.com" exclude-result-prefixes="dc ns8 xs fn ebu">
    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"/>

    <!-- includes -->
    <xsl:include href="aanbodfilter.xslt" />
    <xsl:include href="structural.xslt" />
    <xsl:include href="relations.xslt" />
    <xsl:include href="strata.xslt" />

    <!-- variables -->


    <!-- functions -->
    <xsl:function name="vrt:englishToDutch">
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$word='season'">
                seizoen
            </xsl:when>
            <xsl:when test="$word='series'">
                serie
            </xsl:when>
            <xsl:when test="$word='program'">
                programma
            </xsl:when>
            <xsl:otherwise>
                alternatief
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- templates -->

    <xsl:template match="ns8:metadataUpdatedEvent | ns8:MakeMetadataAvailableResponse | ns9:metadata | ns9:metadataUpdatedEvent | ns9:getMetadataResponse">
        <mhs:Sidecar xmlns:mhs="https://zeticon.mediahaven.com/metadata/19.2/mhs/" 
            xmlns:mh="https://zeticon.mediahaven.com/metadata/19.2/mh/" version="19.2">
            <mhs:Descriptive>
                <mh:Title>
                    <xsl:value-of select="//ebu:title/dc:title"/>
                </mh:Title>
                <mh:Description>
                    <xsl:value-of select="//ebu:description[@typeDefinition='long']/dc:description"/>
                </mh:Description>
            </mhs:Descriptive>
            <mhs:Structural>
                <xsl:call-template name="structural"/>
            </mhs:Structural>
            <mhs:Dynamic>
                <CP>VRT</CP>
                <CP_id>OR-rf5kf25</CP_id>
                <dc_identifier_localid>
                    <xsl:value-of select="//ebu:identifier[@typeDefinition='MEDIA_ID']/dc:identifier"/>
                </dc_identifier_localid>
                <dc_identifier_localids type="list" strategy="OVERWRITE">
                    <xsl:for-each select="//ebu:identifier">
                        <xsl:if test="normalize-space(current()/dc:identifier)">
                            <xsl:element name="{current()/@typeDefinition}">
                                <xsl:value-of select="current()/dc:identifier"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </dc_identifier_localids>
                <dc_relations>
                    <xsl:call-template name="relations"/>
                </dc_relations>
                <title>
                    <xsl:value-of select="//ebu:title/dc:title"/>
                </title>
                <dc_titles type="list" strategy="OVERWRITE">
                    <xsl:for-each select="//ebu:alternativeTitle">
                        <xsl:if test="normalize-space(current()/dc:title)">
                            <xsl:element name="{vrt:englishToDutch(current()/@typeDefinition)}">
                                <xsl:value-of select="current()/dc:title"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </dc_titles>
                <dcterms_created>
                    <xsl:value-of select="//ebu:date/*[@typeDefinition='mainDate']/@startDate"/>
                </dcterms_created>
                <dcterms_issued>
                    <xsl:value-of select="//ebu:date/*[@typeDefinition='mainDate']/@startDate"/>
                </dcterms_issued>
                <dc_creators type="list" strategy="OVERWRITE">
                    <xsl:for-each select="//ebu:creator">
                        <xsl:if test="normalize-space(current()/ebu:organisationDetails/ebu:organisationName)">
                            <xsl:element name="{normalize-space(current()/ebu:role/@typeDefinition)}">
                                <xsl:value-of select="normalize-space(current()/ebu:organisationDetails/ebu:organisationName)"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>

                    <xsl:for-each select="//ebu:contributor">
                        <xsl:if test="current()/ebu:role/@typeDefinition = ('journalist', 'presentator', 'scenarist')">
                            <xsl:element name="{normalize-space(current()/ebu:role/@typeDefinition)}">
                                <xsl:value-of select="normalize-space(current()/ebu:contactDetails/ebu:name)"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </dc_creators>
                <dc_contributors type="list" strategy="OVERWRITE">
                    <xsl:for-each select="//ebu:contributor">
                        <xsl:if test="current()/ebu:role/@typeDefinition = ('onbepaald', 'producer', 'regisseur', 'assistent', 'archivaris', 'commentator')">
                            <xsl:element name="{normalize-space(current()/ebu:role/@typeDefinition)}">
                                <xsl:value-of select="normalize-space(current()/ebu:contactDetails/ebu:name)"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </dc_contributors>
                <dc_publishers type="list" strategy="OVERWRITE">
                    <xsl:for-each select="//ebu:publisher">
                        <xsl:if test="current()/ebu:role/@typeDefinition = 'publisher' and normalize-space(current()/ebu:organisationDetails/ebu:organisationName)">
                            <Distributeur>
                                <xsl:value-of select="normalize-space(current()/ebu:organisationDetails/ebu:organisationName)"/>
                            </Distributeur>
                        </xsl:if>
                    </xsl:for-each>
                </dc_publishers>
                <ebu_objectType>
                    <xsl:value-of select="//ebu:type/ebu:objectType/@typeDefinition"/>
                </ebu_objectType>
                <description>
                    <xsl:value-of select="//ebu:description[@typeDefinition='long']/dc:description"/>
                </description>
                <dc_description_lang>
                    <xsl:call-template name="strata"/>
                </dc_description_lang>
                <dc_description_ondertitels><!-- empty --></dc_description_ondertitels>
                <dc_description_programma>
                    <xsl:value-of select="//ebu:description[@typeDefinition='short']/dc:description"/>
                </dc_description_programma>
                <dc_description_cast>
                    <xsl:value-of select="//ebu:description[@typeDefinition='cast']/dc:description"/>
                </dc_description_cast>
                <dc_description_transcriptie><!-- empty--></dc_description_transcriptie>
                <dc_description_categorie>
                    <xsl:value-of select="//ebu:description[@typeDefinition='category']/dc:description"/>
                </dc_description_categorie>
                <dc_types type="list" strategy="OVERWRITE">
                    <xsl:for-each select="//ebu:type/ebu:genre">
                        <multiselect>
                            <xsl:value-of select="current()/@typeDefinition"/>
                        </multiselect>
                    </xsl:for-each>
                </dc_types>
                <dc_coverages><!-- empty --></dc_coverages>
                <dc_subjects type="list" strategy="OVERWRITE">
                    <xsl:for-each select="tokenize(//ebu:subject/@note,',')">
                        <Trefwoord>
                            <xsl:value-of select="normalize-space(current())"/>
                        </Trefwoord>
                    </xsl:for-each>
                </dc_subjects>
                <dc_languages><!-- empty--></dc_languages>
                <dc_rights_licenses type="list" strategy="OVERWRITE">
                    <xsl:call-template name="aanbodfilter"/>
                </dc_rights_licenses>
                <dc_rights_rightsOwners><!-- empty --></dc_rights_rightsOwners>
                <dc_rights_rightsHolders type="list" strategy="OVERWRITE">
                    <xsl:if test="normalize-space(//ebu:rights/ebu:rightsHolder/ebu:organisationDetails/ebu:organisationName)">
                        <Licentiehouder>
                            <xsl:value-of select="//ebu:rights/ebu:rightsHolder/ebu:organisationDetails/ebu:organisationName"/>
                        </Licentiehouder>
                    </xsl:if>
                </dc_rights_rightsHolders>
                <dc_rights_credit><!-- empty --></dc_rights_credit>
                <dc_rights_comment>
                    <xsl:value-of select="//ebu:description[@typeDefinition='rights']/dc:description, //ebu:description[@typeDefinition='rightsType']/dc:description"/>
                </dc_rights_comment>

                <!-- following variables come from the aanbodfilter -->
                <vrt_status>
                    <xsl:value-of select="$status"/>
                </vrt_status>
                <vrt_has_been_broadcasted>
                    <xsl:value-of select="$hasBeenBroadcasted"/>
                </vrt_has_been_broadcasted>
                <type_viaa>
                    <xsl:value-of select="$audioOrVideo"/>
                </type_viaa>
                <vrt_production_method>
                    <xsl:value-of select="$productionMethod"/>
                </vrt_production_method>
                <dc_rights>
                    <xsl:value-of select="$rightsType"/>
                </dc_rights>
            </mhs:Dynamic>
        </mhs:Sidecar>
    </xsl:template>
</xsl:stylesheet>
