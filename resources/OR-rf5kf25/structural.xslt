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
    <xsl:variable name="framerate" select="xs:integer((//ebu:format[@formatDefinition='current'])[1]/ebu:videoFormat/ebu:frameRate)"/>
    <xsl:variable name="StartOfMedia" select="vrt:timecodeToFrames((//ebu:format[@formatDefinition='current'])[1]/ebu:technicalAttributeString[@typeDefinition='SOM'])"/>
    <xsl:variable name="StartOfContent">
        <xsl:choose>
            <xsl:when test="(//ebu:format[@formatDefinition='current'])[1]/ebu:start/ebu:timecode">
                <xsl:value-of select="vrt:timecodeToFrames((//ebu:format[@formatDefinition='current'])[1]/ebu:start/ebu:timecode) - $StartOfMedia"/>
            </xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="EndOfContent">
        <xsl:choose>
            <xsl:when test="(//ebu:format[@formatDefinition='current'])[1]/ebu:end/ebu:timecode">
                <xsl:value-of select="vrt:timecodeToFrames((//ebu:format[@formatDefinition='current'])[1]/ebu:end/ebu:timecode) - $StartOfMedia"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="vrt:timecodeToFrames(//ebu:description[@typeDefinition='duration']/dc:description)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- functions -->

    <xsl:function name="vrt:timecodeToFrames">
        <xsl:param name="time"/>

        <xsl:variable name="hours" select="xs:integer(substring($time, 1, 2))"/>
        <xsl:variable name="minutes" select="xs:integer(substring($time, 4, 2))"/>
        <xsl:variable name="seconds" select="xs:integer(substring($time, 7, 2))"/>
        <xsl:variable name="frames" select="xs:integer(substring($time, 10, 2))"/>

        <xsl:variable name="timeInSeconds" select="($hours * 3600 + $minutes * 60 + $seconds)"/>


        <!-- Fragment start and end get set using a fictious 25 fps instead of the real fps.
             The object could be higher fps and thus the frames from the timecode (hh:mm:ss:frames) have to be converted to 25fps.
             We use floor() instead of round() to ensure we always stay inside the duration of the fragment. -->
        <xsl:value-of select="$timeInSeconds * 25 + floor($frames * (25 div $framerate))"/>
    </xsl:function>


    <!-- templates -->
    <xsl:template name="structural">
        <mh:FragmentStartFrames>
            <xsl:value-of select="$StartOfContent"/>
        </mh:FragmentStartFrames>
        <mh:FragmentEndFrames>
            <xsl:value-of select="$EndOfContent"/>
        </mh:FragmentEndFrames>
    </xsl:template>
</xsl:stylesheet>
