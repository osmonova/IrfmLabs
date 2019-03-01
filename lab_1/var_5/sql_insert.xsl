<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:key name="unique"
        match="object"
        use="concat(profile-code, study-form, speciality-id, profile)"
    />
    <xsl:template match="/objects">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>Вставка данных в таблицу plans</title>
            </head>
            <body>
                <xsl:text>insert all</xsl:text>
                    <xsl:apply-templates select="object[count(. | key('unique', concat(profile-code, study-form, speciality-id, profile))[1]) = 1]"/>
                <xsl:text>from dual;</xsl:text>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="object">
        <dl>
            <xsl:text>into plans (</xsl:text>
            <xsl:for-each select="*">
                <xsl:text>"</xsl:text>
                <xsl:call-template name="replace">
                    <xsl:with-param name="string" select="name()"/>
                    <xsl:with-param name="search" select="'-'"/>
                    <xsl:with-param name="replacement" select="'_'"/>
                </xsl:call-template>
                <xsl:text>"</xsl:text>
                <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
            <xsl:text>) values (</xsl:text>
            <xsl:for-each select="*">
                <xsl:choose>
                    <xsl:when test="@nil = 'true' or not(text())">
                        <xsl:text>null</xsl:text>
                    </xsl:when>
                    <xsl:when test="name() = 'id'">
                        <xsl:value-of select=". + 10000"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="@type = 'string' or not(@type)"><xsl:text>'</xsl:text></xsl:if>
                        <xsl:call-template name="replace">
                            <xsl:with-param name="string" select="."/>
                            <xsl:with-param name="search" select="'&#xA;'"/>
                            <xsl:with-param name="replacement" select="' '"/>
                        </xsl:call-template>
                        <xsl:if test="@type = 'string' or not(@type)"><xsl:text>'</xsl:text></xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
            <xsl:text>)</xsl:text>
        </dl>
    </xsl:template>
    <xsl:template name="replace">
        <xsl:param name="string"/>
        <xsl:param name="search"/>
        <xsl:param name="replacement"/>
        <xsl:choose>
            <xsl:when test="contains($string, $search)">
                <xsl:value-of select="substring-before($string, $search)"/>
                <xsl:value-of select="$replacement"/>
                <xsl:call-template name="replace">
                    <xsl:with-param name="string" select="substring-after($string, $search)"/>
                    <xsl:with-param name="search" select="$search"/>
                    <xsl:with-param name="replacement" select="$replacement"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
