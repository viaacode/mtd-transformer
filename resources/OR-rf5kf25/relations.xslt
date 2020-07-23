<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:ns8="http://www.vrt.be/mig/viaa" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:ebu="urn:ebu:metadata-schema:ebuCore_2012" 
    xmlns:mh="https://zeticon.mediahaven.com/metadata/19.2/mh/" 
    xmlns:vrt="http://this.this.com" exclude-result-prefixes="dc ns8 xs fn ebu">
    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"/>

    <!-- variables -->
    <xsl:variable name="relation" as="map(xs:string, xs:string)">
        <xsl:map>
            <xsl:map-entry key="'Programma verwijst naar item'" select="'PROGRAM_REFERENCES_ITEM'"/>
            <xsl:map-entry key="'Item verwijst naar Programma'" select="'PROGRAM_REFERENCES_ITEM'"/>
            <xsl:map-entry key="'Programma gebruikt footage'" select="'PROGRAM_USES_FOOTAGE'"/>
            <xsl:map-entry key="'Footage wordt gebruikt in programma'" select="'PROGRAM_USES_FOOTAGE'"/>
            <xsl:map-entry key="'Programma verwijst naar programma'" select="'PROGRAM_HAS_PROGRAM'"/>
            <xsl:map-entry key="'Programma verwijst naar trailer'" select="'PROGRAM_HAS_TRAILER'"/>
            <xsl:map-entry key="'Trailer verwijst naar programma'" select="'PROGRAM_HAS_TRAILER'"/>
            <xsl:map-entry key="'Trailer verwijst naar trailer'" select="'TRAILER_HAS_TRAILER'"/>
            <xsl:map-entry key="'Footage verwijst naar footage'" select="'FOOTAGE_HAS_FOOTAGE'"/>
            <xsl:map-entry key="'Trailer gebruikt footage'" select="'TRAILER_USES_FOOTAGE'"/>
            <xsl:map-entry key="'Footage wordt gebruikt in trailer'" select="'TRAILER_USES_FOOTAGE'"/>
            <xsl:map-entry key="'Item gebruikt footage'" select="'ITEM_USES_FOOTAGE'"/>
            <xsl:map-entry key="'Footage wordt gebruikt in item'" select="'ITEM_USES_FOOTAGE'"/>
            <xsl:map-entry key="'Item verwijst naar item'" select="'ITEM_HAS_ITEM'"/>
            <xsl:map-entry key="'Seizoen heeft programma'" select="'SEASON_HAS_PROGRAM'"/>
            <xsl:map-entry key="'Programma behoort tot seizoen'" select="'SEASON_HAS_PROGRAM'"/>
            <xsl:map-entry key="'Footage heeft item'" select="'FOOTAGE_HAS_ITEM'"/>
            <xsl:map-entry key="'Item behoort tot footage'" select="'FOOTAGE_HAS_ITEM'"/>
            <xsl:map-entry key="'Programma heeft item'" select="'PROGRAM_HAS_ITEM'"/>
            <xsl:map-entry key="'Item behoort tot programma'" select="'PROGRAM_HAS_ITEM'"/>
            <!-- identity map for transition period when keys are being sent instead of labels-->
            <xsl:map-entry key="'PROGRAM_REFERENCES_ITEM'" select="'PROGRAM_REFERENCES_ITEM'"/>
            <xsl:map-entry key="'PROGRAM_USES_FOOTAGE'" select="'PROGRAM_USES_FOOTAGE'"/>
            <xsl:map-entry key="'PROGRAM_HAS_PROGRAM'" select="'PROGRAM_HAS_PROGRAM'"/>
            <xsl:map-entry key="'PROGRAM_HAS_TRAILER'" select="'PROGRAM_HAS_TRAILER'"/>
            <xsl:map-entry key="'TRAILER_HAS_TRAILER'" select="'TRAILER_HAS_TRAILER'"/>
            <xsl:map-entry key="'FOOTAGE_HAS_FOOTAGE'" select="'FOOTAGE_HAS_FOOTAGE'"/>
            <xsl:map-entry key="'TRAILER_USES_FOOTAGE'" select="'TRAILER_USES_FOOTAGE'"/>
            <xsl:map-entry key="'ITEM_USES_FOOTAGE'" select="'ITEM_USES_FOOTAGE'"/>
            <xsl:map-entry key="'ITEM_HAS_ITEM'" select="'ITEM_HAS_ITEM'"/>
            <xsl:map-entry key="'SEASON_HAS_PROGRAM'" select="'SEASON_HAS_PROGRAM'"/>
            <xsl:map-entry key="'FOOTAGE_HAS_ITEM'" select="'FOOTAGE_HAS_ITEM'"/>
            <xsl:map-entry key="'PROGRAM_HAS_ITEM'" select="'PROGRAM_HAS_ITEM'"/>
        </xsl:map>
    </xsl:variable>

    <!-- templates -->
    <xsl:template name="relations">
        <xsl:for-each select="//ebu:relation[ebu:relationIdentifier/dc:identifier]">
            <xsl:variable name="mapped_relation" select="$relation(current()/@typeDefinition)"/>
            <xsl:if test="$mapped_relation != ''">
                <xsl:element name="{$mapped_relation}">
                    <xsl:value-of select="current()/ebu:relationIdentifier/dc:identifier"/>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>