<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:ns8="http://www.vrt.be/mig/viaa" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:ebu="urn:ebu:metadata-schema:ebuCore_2012" exclude-result-prefixes="dc ns8 xs fn ebu">
    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"/>


    <!-- variables -->
    <xsl:variable name="status" select="//ebu:description[@typeDefinition='status']/dc:description"/>
    <xsl:variable name="hasBeenBroadcasted" as="xs:boolean" select="//ebu:description[@typeDefinition='hasBeenBroadcasted']/dc:description"/>
    <xsl:variable name="audioOrVideo">
        <xsl:choose>
            <xsl:when test="boolean(//ebu:videoFormat/node())">video</xsl:when>
            <xsl:when test="boolean(//ebu:audioFormat/node())">audio</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="productionMethod" select="//ebu:description[@typeDefinition='productionMethod']/dc:description"/>
    <xsl:variable name="ebuType" select="//ebu:type/ebu:objectType/@typeDefinition"/>
    <xsl:variable name="rightsType" select="//ebu:description[@typeDefinition='rightsType']/dc:description"/>
    <xsl:variable name="category" select="//ebu:description[@typeDefinition='category']/dc:description"/>
    <xsl:variable name="genre" select="//ebu:type/ebu:genre/@typeDefinition"/>
    <xsl:variable name="itemBehoortTotFootage" as="xs:boolean" select="boolean(//ebu:relation[$relation(normalize-space(@typeDefinition)) = 'FOOTAGE_HAS_ITEM'])" />

    <!-- templates -->
    <xsl:template name="aanbodfilter">
        <xsl:if test="$hasBeenBroadcasted and
                ($status = 'gearchiveerd') and
                ($productionMethod != 'aankoop') and
                ($ebuType = ('item', 'online_item', 'program')) and
                ($rightsType = ('', 'vrij gebruik')) and
                ($audioOrVideo = ('audio', 'video')) and
                not($itemBehoortTotFootage)">
            <xsl:choose>
                <xsl:when test="(($audioOrVideo = 'video') and
                                ($category != 'sport') and
                                ($genre != 'fictie'))
                                or
                                (($audioOrVideo = 'audio') and
                                ($category = 'nieuws en duiding'))">
                    <multiselect>VIAA-ONDERWIJS</multiselect>
                    <multiselect>VIAA-ONDERZOEK</multiselect>
                    <multiselect>VIAA-INTRA_CP-CONTENT</multiselect>
                    <multiselect>VIAA-INTRA_CP-METADATA-ALL</multiselect>
                    <multiselect>VIAA-PUBLIEK-METADATA-LTD</multiselect>
                </xsl:when>
                <xsl:when test="($audioOrVideo = 'video' and
                                (($category = 'sport' and $genre != 'fictie') or
                                ($category != 'sport' and $genre = 'fictie')))
                                or
                                ($audioOrVideo = 'audio' and
                                $category != 'nieuws en duiding')">
                    <multiselect>VIAA-INTRA_CP-METADATA-ALL</multiselect>
                    <multiselect>VIAA-PUBLIEK-METADATA-LTD</multiselect>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
