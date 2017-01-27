<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/">
    
    <xsl:output method="xhtml" indent="yes" encoding="UTF-8"/>
    
    <xsl:param name="pagetype">unset</xsl:param>
    
    <xsl:template match="/">
        
        <xsl:if test="$pagetype = 'rends'">
            <xsl:call-template name="rends"/>
        </xsl:if>
        
        <xsl:if test="$pagetype = 'unset'">
            <xsl:call-template name="rend_fields" />
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="div1[@type='html']">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="str[@name='id']">
        <li><!--xsl:value-of select="." /--></li>
    </xsl:template>
    
    <xsl:template name="rends">
        <xsl:apply-templates select="//text"/>
    </xsl:template>

    <xsl:template name="rend_fields" xpath-default-namespace="">
        <xsl:variable name="field"
            select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/@name"/>
        
        <p>Rends for: <strong>
            <xsl:value-of select="$field"/>
        </strong></p>
        
        
        <ul>
            
            <xsl:for-each
                select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/int">
                <xsl:variable name="fieldName" select="@name"/>
                <xsl:choose>
                    <xsl:when test="$fieldName = ''">
                        <li><strong>Blank ('')</strong>: <xsl:value-of select="."/></li>
                    </xsl:when>
                    <xsl:when test="not($fieldName)">
                        <li><strong>Missing</strong>: <xsl:value-of select="."/></li>
                    </xsl:when>
                    <xsl:otherwise>
                        <li><strong>
                            <xsl:value-of select="@name"/>
                        </strong>: <xsl:value-of select="."/></li>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </ul>
        
        <p>Annotated List</p>
        
        <ul>
            
            <xsl:for-each
                select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst/int">
                <xsl:variable name="fieldName" select="@name"/>
                <xsl:choose>
                    <xsl:when test="$fieldName = ''">
                        <li><strong>Blank ('')</strong>: <xsl:value-of select="."/></li>
                    </xsl:when>
                    <xsl:otherwise>
                        <li><strong>
                            <xsl:value-of select="@name"/>
                        </strong>: <xsl:value-of select="."/></li>
                    </xsl:otherwise>
                </xsl:choose>
                
                <ul>
                    <xsl:for-each select="/response/result[@name='response']/doc">
                        <xsl:choose>
                            <xsl:when test="./str[@name=$field]">
                                <xsl:choose>
                                    <xsl:when test="$fieldName = ''">
                                        <xsl:if test="str[@name=$field] = ''">
                                            <li><xsl:value-of select="str[@name='id']" /></li>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="str[@name=$field] = $fieldName">
                                            <li><xsl:value-of select="str[@name='id']" /></li>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$fieldName = ''">
                                        <xsl:if test="arr[@name=$field]/str[1] = ''">
                                            <li><xsl:value-of select="str[@name='id']" /></li>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="arr[@name=$field]/str">
                                            <xsl:if test=". = $fieldName">
                                                <li><xsl:value-of select="parent::node()/parent::node()/str[@name='id']" /></li>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                            
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
                
            </xsl:for-each>
            
        </ul>
        
    </xsl:template>
    
</xsl:stylesheet>
