<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml" 
    version="2.0">
  
  <!-- XML -->
  
  <xsl:variable name="filename" select="tokenize(base-uri(.), '/')[last()]"/>
  
  <!-- Split the filename using '\.' -->
  <xsl:variable name="filenamepart" select="substring-before($filename, '.xml')"/>

    <xsl:template name="mainContent">
        
        <!-- TESTING CODE ==================================================================== -->
        
        <!--<p>For testing, variable list:</p>
<ul>
    <li>pagetype: <xsl:value-of select="$pagetype"/></li>
    <li>subpagetype: <xsl:value-of select="$subpagetype"/></li>
    <li>q: <xsl:value-of select="$q"/></li>
    <li>fq: <xsl:value-of select="$fq"/></li>
    <li>pageid: <xsl:value-of select="$pageid"/></li>
    <li>searchtype: <xsl:value-of select="$searchtype"/></li>
    <li>sort: <xsl:value-of select="$sort"/></li>
    <li>start: <xsl:value-of select="$start"/></li>
    <li>rows: <xsl:value-of select="$rows"/></li>
    <li>start_num: <xsl:value-of select="$start_num"/></li>
    <li>rows_num: <xsl:value-of select="$rows_num"/></li>
</ul>-->

<xsl:choose>
    
        
        <!-- =====================================================================================
        Main Page
        ===================================================================================== -->

        <xsl:when test="$pagetype = 'main'">

            <xsl:copy-of select="//body" xpath-default-namespace=""/>

        </xsl:when>
        
        
        <!-- =====================================================================================
        Personography
        ===================================================================================== -->
        
        <xsl:when test="$subpagetype = 'nei.person'">
            
            <xsl:apply-templates select="//div1[@type='introduction']"></xsl:apply-templates>
            
            <ul class="life_item">
                <xsl:for-each select="//person">
                    <xsl:sort select="@xml:id"/>
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>#</xsl:text>
                                <xsl:value-of select="@xml:id"/>
                            </xsl:attribute>
                            <xsl:attribute name="title">
                                <xsl:value-of select="persName[@type='display']"/>
                            </xsl:attribute>
                            <xsl:value-of select="persName[@type='display']"/>
                        </a>
                    </li>
                    
                </xsl:for-each>
            </ul>
            
            
            
            <xsl:for-each select="//person">
                <xsl:sort select="@xml:id"/>
                <div>
                    <xsl:attribute name="class">
                        <xsl:text>life_item</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <h3>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$siteroot"/>
                        <xsl:text>search/all/?q=recipient:&quot;</xsl:text>
                        <xsl:value-of select="encode-for-uri(persName[@type='display'])"/>
                        <xsl:text>&quot;</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="persName[@type='display']"/>
                        </a>
                    </h3>
                    <p><xsl:apply-templates select="note"/></p>
                </div>
            </xsl:for-each>
            
        </xsl:when>
        
        
        
        
        <!-- =====================================================================================
        Search Page
        ===================================================================================== -->
        
        <xsl:when test="$pagetype = 'search'">
            
            <h2>Search the Archive</h2>
            
            <!-- May be integrated with browse eventually -->
            
            <p>Type a search term in the box below to search all the items in the archive. </p>

            <form action="{$siteroot}search/all/" method="get" enctype="application/x-www-form-urlencoded">
                <input id="basic-q" type="text" name="q" value="" class="textField"/>
                <input type="submit" value="Search" class="submit"/>
            </form>
            
            <p>Advanced searching: you can exclude with a "-", use boolean operators like AND &amp; OR, group items with (parentheses), and search for a phrase with "quotation marks."</p>
            
        </xsl:when>
        <!-- /search -->
        
        
        
        <!-- =====================================================================================
        Content/Document Display
        ===================================================================================== -->
        
        <xsl:when test="$pagetype = 'content'">
            
            <div class="metadata">
                <ul>
                <!--Title: <title level="a" type="main"/>-->
                
                <xsl:if test="/TEI/teiHeader/fileDesc/titleStmt/title[@type='main'][normalize-space()]">
                    <li><strong><xsl:text>Title: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/title[@type='main']"/></li>
                </xsl:if>
                
                <!-- Periodical (or publication): <title level="j"/> -->
                
                <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j'][normalize-space()]">
                    <li><strong><xsl:text>Publication: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/title[@level='j']"/></li>
                </xsl:if>
                
                <!-- Book: <title level="m"/> -->
                <!-- None, shows as page title -->
                
                <!-- Date: <date when="1898-01-01"/> -->
                
                <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date[normalize-space()]">
                    <li><strong><xsl:text>Date: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/date"/></li>
                </xsl:if>
                
                <!-- Author(s): <author/> -->
                
                    <xsl:if test="/TEI/teiHeader/fileDesc/titleStmt/author[normalize-space()]">
                        <li><strong><xsl:text>Author(s): </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/author"/></li>
                </xsl:if>
                
                <!--Publisher: <publisher/>, <pubPlace/>-->
                
                <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher[normalize-space()]">
                    <li><strong><xsl:text>Publisher: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/publisher"/></li>
                </xsl:if>
                
                <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/pubPlace[normalize-space()]">
                    <li><strong><xsl:text>Publication Place: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/pubPlace"/></li>
                </xsl:if>
                
                <!--Document: <note type="doc"/>-->
                
                <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/bibl/note[@type='doc'][normalize-space()]">
                    <li><strong><xsl:text>Document: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/note[@type='doc']"/></li>
                </xsl:if>
                    
                  <!-- Recipient -->  
                    
                    <xsl:if test="/TEI/teiHeader/profileDesc/particDesc/person[@role='recipient']/persName[1][normalize-space()]">
                        <li><strong><xsl:text>Recipient: </xsl:text></strong> <xsl:value-of select="/TEI/teiHeader/profileDesc/particDesc/person[@role='recipient']/persName[1]"/></li>
                    </xsl:if>
                    
                   
                    
                        <li>
                            <strong><xsl:text>TEI XML: </xsl:text></strong> 
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$siteroot"/>
                                    <xsl:text>content/</xsl:text>
                                    <xsl:value-of select="$pageid"/>
                                    <!--<xsl:value-of select="$filenamepart"/>-->
                                    <xsl:text>.xml</xsl:text>
                                </xsl:attribute>
                                <xsl:value-of select="$pageid"/>
                                <!--<xsl:value-of select="$filenamepart"/>-->
                              <xsl:text>.xml</xsl:text><xsl:value-of select="$filenamepart"/>
                            </a>
                            <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl/note[@type='doc']"/>
                        </li>
                </ul>
            </div>
            <xsl:apply-templates/>
        </xsl:when>

        
        <!-- =====================================================================================
        Essays and Letters
        ===================================================================================== -->
        
        <xsl:when test="$pagetype = 'essays' or
                      $pagetype = 'letters'">

            <div class="body_text">
                <xsl:copy-of select="//body" xpath-default-namespace=""/>
            </div>
            <div class="search_results">
                <xsl:call-template name="search-generated-page"/>
            </div>
            
            
        </xsl:when>
        <!-- /content -->

        <!-- =====================================================================================
        Browse Page
        ===================================================================================== -->

        <xsl:when test="$pagetype = 'browse'">

            <xsl:copy-of select="//body" xpath-default-namespace=""/>
            
            <xsl:variable name="solrsearchurl">
                <xsl:call-template name="solrURL">
                    <!-- Any blank params will be left as default in the solr search -->
                        <xsl:with-param name="rowstart">0</xsl:with-param>
                        <xsl:with-param name="rowend">1</xsl:with-param>
                    <!-- add fields to display (not search) in a commented delimited list, i.e. 'id,title'
                         fields can be found in the /search/foo2solr.xsl -->
                        <xsl:with-param name="searchfields">id,title,titleAlt,category,subcategory,topic,dateDisplay,dateSort,dateNormalized</xsl:with-param>
                    <!-- 'true' if faceting, blank if not -->
                        <xsl:with-param name="facet">true</xsl:with-param>
                    <!-- will only show up if faceting true. e.g. "{!ex=dt}subtype" -->
                        <xsl:with-param name="facetfield"></xsl:with-param>
                    <!-- Any other solr url builders, i.e. "&amp;facet.limit=10" -->
                    <xsl:with-param name="other">
                        <xsl:text>&amp;facet.limit=-1</xsl:text>
                        <xsl:text>&amp;facet.field=recipient</xsl:text>
                        <xsl:text>&amp;facet.field=works</xsl:text>
                        <xsl:text>&amp;facet.field=repository</xsl:text>
                        <xsl:text>&amp;facet.field=places</xsl:text>
                    </xsl:with-param>
                    <!-- defaults to "*:*" (show all in all fields) -->
                        <xsl:with-param name="q"></xsl:with-param>
                    <!-- First and secondary sort, defaults to score -->
                    <xsl:with-param name="sort">dateNormalized</xsl:with-param>
                        <xsl:with-param name="sortSecondary"></xsl:with-param>
                    
                    <!-- Remember to set xpath-default-namespace="" on document() calls!-->
                </xsl:call-template>
                
            </xsl:variable>
   
   <!-- Test Search URL -->
 <!--<p><strong><xsl:text>Solr search URL (for troubleshooting): </xsl:text> <a> <xsl:attribute name="href"><xsl:value-of select="$solrsearchurl"/></xsl:attribute> 
                <xsl:attribute name="target">_blank</xsl:attribute> Open in new window </a></strong></p>-->

            <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">

                <xsl:for-each select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst" xpath-default-namespace="">
<xsl:if test="@name != ''">
                    <h3><xsl:value-of select="concat(upper-case(substring(@name, 1, 1)), substring(@name, 2))"/></h3>
                    
                    <!--<xsl:value-of select="@name"></xsl:value-of>-->
                    <xsl:if test="@name = 'recipient'"><p><a href="{$siteroot}content/nei.person.html">Recipient biographies</a></p></xsl:if>
                    <ul class="browselist">
                        <xsl:for-each select="int">
                            <xsl:sort select="lower-case(@name)" data-type="text" order="ascending"></xsl:sort>
                          <xsl:if test=". > 0">
                            <li>
                                <xsl:attribute name="class">
                                    <xsl:text>qty</xsl:text>
                                    <xsl:value-of select="."></xsl:value-of>
                                </xsl:attribute>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$siteroot"/>
                                        <xsl:text>search/all/?q=</xsl:text>
                                        <xsl:value-of select="../@name"></xsl:value-of>
                                        <xsl:text>:</xsl:text>
                                        <xsl:value-of select="encode-for-uri('&quot;')"></xsl:value-of>
                                        <xsl:value-of select="encode-for-uri(@name)"></xsl:value-of>
                                        <xsl:value-of select="encode-for-uri('&quot;')"></xsl:value-of>
                                    </xsl:attribute>
                                    <span class="browsename"><xsl:value-of select="@name"/></span><xsl:text> </xsl:text>
                                    <span class="browsenumber"><xsl:value-of select="."/></span>
                                </a>
                             
                            </li>
                          </xsl:if>
                            
                        </xsl:for-each>
                    </ul>
</xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:when>
        <!-- /browse -->
        
        
        <!-- =====================================================================================
        Browse 2 Page (For testing)
        ===================================================================================== -->
        
        <xsl:when test="$pagetype = 'browse2'">
            
            <xsl:copy-of select="//body" xpath-default-namespace=""/>
            
            <xsl:variable name="solrsearchurl">
                <xsl:call-template name="solrURL">
                    <!-- Any blank params will be left as default in the solr search -->
                    <xsl:with-param name="rowstart">0</xsl:with-param>
                    <xsl:with-param name="rowend">1</xsl:with-param>
                    <!-- add fields to display (not search) in a commented delimited list, i.e. 'id,title'
                         fields can be found in the /search/foo2solr.xsl -->
                    <xsl:with-param name="searchfields">id,title,titleAlt,category,subcategory,topic,dateDisplay,dateSort,dateNormalized</xsl:with-param>
                    <!-- 'true' if faceting, blank if not -->
                    <xsl:with-param name="facet">true</xsl:with-param>
                    <!-- will only show up if faceting true. e.g. "{!ex=dt}subtype" -->
                    <xsl:with-param name="facetfield"></xsl:with-param>
                    <!-- Any other solr url builders, i.e. "&amp;facet.limit=10" -->
                    <xsl:with-param name="other">
                        <xsl:text>&amp;facet.limit=-1</xsl:text>
                        <xsl:text>&amp;facet.field=recipient</xsl:text>
                        <xsl:text>&amp;facet.field=places</xsl:text>
                        <xsl:text>&amp;facet.field=works</xsl:text>
                        <xsl:text>&amp;facet.field=author</xsl:text>
                        <xsl:text>&amp;facet.field=dateSort</xsl:text>
                        <xsl:text>&amp;facet.field=keywords</xsl:text>
                        <xsl:text>&amp;facet.field=people</xsl:text>
                    </xsl:with-param>
                    <!-- defaults to "*:*" (show all in all fields) -->
                    <xsl:with-param name="q"></xsl:with-param>
                    <!-- First and secondary sort, defaults to score -->
                    <xsl:with-param name="sort">dateNormalized</xsl:with-param>
                    <xsl:with-param name="sortSecondary"></xsl:with-param>
                    
                    <!-- Remember to set xpath-default-namespace="" on document() calls!-->
                </xsl:call-template>
                
            </xsl:variable>
            
            <!-- Test Search URL -->
            <!-- <p><strong><xsl:text>Solr search URL (for troubleshooting): </xsl:text> <a> <xsl:attribute name="href"><xsl:value-of select="$solrsearchurl"/></xsl:attribute> 
                <xsl:attribute name="target">_blank</xsl:attribute> Open in new window </a></strong></p>-->
            
            <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">
                <ul>
                <xsl:for-each select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst" xpath-default-namespace="">
                    <xsl:sort order="descending"/>
                    
                    <xsl:if test="normalize-space(@name) != ''">
                        
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:text>#</xsl:text>
                                    <xsl:value-of select="concat(upper-case(substring(@name, 1, 1)), substring(@name, 2))"/>
                                </xsl:attribute>
                            </a>
                            <xsl:value-of select="concat(upper-case(substring(@name, 1, 1)), substring(@name, 2))"/>
                        </li>
                        
                    </xsl:if>
                </xsl:for-each>
                </ul>
                
                
                <xsl:for-each select="/response/lst[@name='facet_counts']/lst[@name='facet_fields']/lst" xpath-default-namespace="">
                    <xsl:sort order="descending"/>
                    
                    <xsl:if test="normalize-space(@name) != ''">
                        
                        <h3>
                            <xsl:attribute name="id"><xsl:value-of select="concat(upper-case(substring(@name, 1, 1)), substring(@name, 2))"/></xsl:attribute>
                            <xsl:value-of select="concat(upper-case(substring(@name, 1, 1)), substring(@name, 2))"/>
                        </h3>
                        <!--<h3><xsl:value-of select="concat(upper-case(substring(@name, 1, 1)), substring(@name, 2))"/></h3>-->
                        <ul class="browselist2">
                            <xsl:for-each select="int">
                                <xsl:sort select="lower-case(@name)" data-type="text" order="ascending"></xsl:sort>
                                <li>
                                    <xsl:attribute name="class">
                                        <xsl:text>qty</xsl:text>
                                        <xsl:value-of select="."></xsl:value-of>
                                    </xsl:attribute>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$siteroot"/>
                                            <xsl:text>search/all/?q=</xsl:text>
                                            <xsl:value-of select="../@name"></xsl:value-of>
                                            <xsl:text>:</xsl:text>
                                            <xsl:value-of select="encode-for-uri('&quot;')"></xsl:value-of>
                                            <xsl:value-of select="encode-for-uri(@name)"></xsl:value-of>
                                            <xsl:value-of select="encode-for-uri('&quot;')"></xsl:value-of>
                                        </xsl:attribute>
                                        <span class="browsename"><xsl:value-of select="@name"/></span><xsl:text> </xsl:text>
                                        <span class="browsenumber"><xsl:value-of select="."/></span>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:when>
        <!-- /browse2 -->

        <!-- =====================================================================================
        About Page
        ===================================================================================== -->

        <xsl:when test="$pagetype = 'about'">

            <xsl:copy-of select="//body" xpath-default-namespace=""/>

        </xsl:when>
        <!-- /about -->

        <!-- =====================================================================================
        Search Results
        ===================================================================================== -->

        <xsl:when test="$pagetype = 'searchresults'">

           <xsl:call-template name="search-generated-page"/>

        </xsl:when>
        <!-- /searchresults -->
    
</xsl:choose>

    </xsl:template>


    <!-- =====================================================================================
        Templates
        ===================================================================================== -->
    

    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        search-generated-page - For Search results, essays and letters
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
    <xsl:template name="search-generated-page"> 
        
        <xsl:variable name="solrsearchurl">
            <xsl:call-template name="solrURL">
                <!-- Any blank params will be left as default in the solr search -->
                <xsl:with-param name="rowstart">
                    <xsl:value-of select="number($start_num)"/>
                </xsl:with-param>
                <xsl:with-param name="rowend"><xsl:value-of select="$rows_num"/></xsl:with-param>
                <!-- add fields to display (not search) in a commented delimited list, i.e. 'id,title'
                         fields can be found in the /search/foo2solr.xsl -->
                <xsl:with-param name="searchfields">id,title,titleAlt,category,subcategory,topic,dateDisplay,dateSort,dateNormalized,recipient,publication</xsl:with-param>
                <!-- 'true' if faceting, blank if not -->
                <xsl:with-param name="facet"></xsl:with-param>
                <!-- will only show up if faceting true. e.g. "{!ex=dt}subtype" -->
                <xsl:with-param name="facetfield"></xsl:with-param>
                <!-- Any other solr url builders, i.e. "&amp;facet.limit=10" -->
                <xsl:with-param name="other">
                    <xsl:choose>
                        <xsl:when test="$pagetype = 'letters'">&amp;fq=category:Correspondence</xsl:when>
                        <xsl:when test="$pagetype = 'essays'">&amp;fq=category:<xsl:value-of select="encode-for-uri('&quot;Essays and Reviews&quot;')"></xsl:value-of></xsl:when>
                    </xsl:choose>
                </xsl:with-param>
                <!-- defaults to "*:*" (show all in all fields) -->
                <xsl:with-param name="q">
                    <xsl:choose>
                        <xsl:when test="$pagetype = 'searchresults'">
                            <xsl:value-of select="$q"/>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <!-- First and secondary sort, defaults to score -->
                <xsl:with-param name="sort">
                    <xsl:choose>
                        <xsl:when test="$pagetype != 'searchresults' or $q = '*:*'">
                            <xsl:choose>
                                <xsl:when test="$sort='score'">
                                    <!-- Sort on titleAlt for libary sort -->
                                    <xsl:text>titleAlt</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$sort"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise><xsl:value-of select="$sort"/></xsl:otherwise>
                    </xsl:choose>
                    </xsl:with-param>
                <xsl:with-param name="sortSecondary"></xsl:with-param>
            </xsl:call-template>
            
        </xsl:variable>
        
        <!-- Test Search URL -->
       <!-- <p><strong><xsl:text>Solr search URL (for troubleshooting): </xsl:text> <a> <xsl:attribute name="href">
            <xsl:value-of select="$solrsearchurl"/></xsl:attribute> <xsl:attribute name="target">_blank</xsl:attribute> Open in new window </a></strong></p>-->
        
        <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">
        <xsl:variable name="numFound" select="//result/@numFound"/>
        
            <xsl:choose>
                <xsl:when test="$numFound &lt; 1"><h4>Your search returned no results.</h4></xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        
                <xsl:when test="$pagetype = 'searchresults' and $q = '*:*'"><h4>
                    <xsl:text>Displaying all </xsl:text>
                    <xsl:value-of select="$numFound"/>
                    <xsl:text> results.</xsl:text></h4>
                </xsl:when>
                <xsl:when test="$pagetype = 'searchresults'">
                    <h4><xsl:text>Your search for </xsl:text>
                    <span class="searchterm"><xsl:value-of select="$q"/></span>
                    <xsl:text> returned </xsl:text>
                    <xsl:value-of select="$numFound"></xsl:value-of>
                    <xsl:text> result</xsl:text>
                    <xsl:if test="$numFound > 1">s</xsl:if>
                    <xsl:text>. Showing result</xsl:text>
                    <xsl:if test="$numFound > 1">s</xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="/response/result/@start + 1"></xsl:value-of>
                    <xsl:text> to </xsl:text>
                    <xsl:choose>
                        <xsl:when test="(/response/result/@start + ($rows_num - 1)) + 1 > $numFound">
                            <xsl:value-of select="$numFound"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="(/response/result/@start + ($rows_num - 1)) + 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>.</xsl:text></h4>
                </xsl:when>
                <xsl:otherwise>
                    <p class="search_descriptor">
                    <xsl:value-of select="$numFound"/>
                    <xsl:text> documents</xsl:text>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        
        <div class="callout">
            <p class="sort_choices"> 
                <xsl:text>Sort: </xsl:text> 
                <!-- Relevance displays only for searches, not essays, letters or display all -->
                <xsl:if test="$pagetype = 'searchresults' and $q != '*:*'">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="sort">score</xsl:with-param>
                                <xsl:with-param name="start">0</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$sort = 'score'">
                            <xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>relevance</xsl:text>
                    </a>
                    
                    <xsl:text> | </xsl:text>
                </xsl:if>
                <a>
                    <xsl:attribute name="href">
                        <xsl:call-template name="urlbuilder">
                            <xsl:with-param name="sort">titleAlt</xsl:with-param>
                            <xsl:with-param name="start">0</xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:if test="$sort = 'titleAlt' or 
                                 ($pagetype != 'searchresults' and $sort = 'score') or 
                                 ($q = '*:*' and $sort = 'score')">
                        <xsl:attribute name="class">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>title</xsl:text>
                </a>
                
                <xsl:text> | </xsl:text>
                <a>
                    <xsl:attribute name="href">
                        <xsl:call-template name="urlbuilder">
                            <xsl:with-param name="sort">dateSort</xsl:with-param>
                            <xsl:with-param name="start">0</xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:if test="$sort = 'dateSort'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                    <xsl:text>date</xsl:text>
                </a>
                <xsl:if test="$pagetype = 'letters'">
                    <xsl:text> | </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="sort">recipient</xsl:with-param>
                                <xsl:with-param name="start">0</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$sort = 'recipient'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>recipient</xsl:text>
                    </a>
                </xsl:if>
                <!-- Sort by ID, useful for testing -->
                <!--<xsl:text> | </xsl:text>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="sort">id</xsl:with-param>
                                <xsl:with-param name="start">0</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:if test="$sort = 'id'"><xsl:attribute name="class">selected</xsl:attribute></xsl:if>
                        <xsl:text>id</xsl:text>
                    </a>-->
            </p>
            
        </div>
             <xsl:call-template name="paginationLinks">
            <xsl:with-param name="numFound" select="$numFound"/>
            <xsl:with-param name="start" select="/response/result/@start"/>
            <xsl:with-param name="rows" select="$rows_num"/>
        </xsl:call-template>

            <ul class="searchResults">
            
                <xsl:for-each select="//doc">
                    <!--<xsl:sort select="str[@name='title']"/>-->

                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$siteroot"/>
                                    <xsl:text>content/</xsl:text>
                                    <xsl:value-of select="str[@name='id']"/>
                                    <xsl:text>.html</xsl:text>
                                </xsl:attribute>
                                
                                <strong><xsl:value-of select="str[@name='title']"/></strong>
                                <span class="listingMeta">
                                    <span class="listingDate"><xsl:value-of select="str[@name='dateNormalized']"/></span>

                                    <xsl:if test="str[@name='publication']">
                                        <span class="listingPublication"><xsl:value-of select="str[@name='publication']"/></span>
                                    </xsl:if>
                                    <xsl:if test="str[@name='recipient']">
                                        <span class="listingRecipient"><xsl:value-of select="str[@name='recipient']"/></span>
                                    </xsl:if>
                                </span>
                            </a>
                            
                        </li>
                </xsl:for-each>  
        </ul>
        
            <xsl:call-template name="paginationLinks">
                <xsl:with-param name="numFound" select="$numFound"/>
                <xsl:with-param name="start" select="$start_num"/>
                <xsl:with-param name="rows" select="$rows_num"/>
            </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:for-each>

    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        urlbuilder ||| Builds sitewide URL's
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

    <xsl:template name="urlbuilder">
        <xsl:param name="sort"><xsl:value-of select="$sort"/></xsl:param>
        <xsl:param name="searchtype"><xsl:value-of select="$searchtype"/></xsl:param>
        <xsl:param name="start"><xsl:value-of select="$start_num"/></xsl:param>
        <xsl:param name="pagetype"><xsl:value-of select="$pagetype"/></xsl:param>
        <xsl:param name="subpagetype"><xsl:value-of select="$subpagetype"/></xsl:param>
        <xsl:param name="pageid"><xsl:value-of select="$pageid"/></xsl:param>
        <xsl:param name="fq"><xsl:value-of select="$fq"/></xsl:param>
        <xsl:param name="q"><xsl:value-of select="$q"/></xsl:param>
        
        <xsl:value-of select="$siteroot"/>
        <!--<xsl:value-of select="$pagetype"/>-->
        
        <xsl:choose>
            <!-- For top level pages, as long as texts has no subpages -->
            <!--<xsl:when test="$subpagetype = '' and $fq = '' and $q = '' and $pagetype != 'texts'">
                <xsl:text>.html</xsl:text>
            </xsl:when>-->
            <!-- Search URL -->
            <xsl:when test="$pagetype = 'searchresults'">
                <xsl:text>search/all</xsl:text>
                <!--<xsl:value-of select="$subpagetype"/>-->
                <xsl:text>/</xsl:text>
            </xsl:when>
            <xsl:when test="$pagetype = 'essays'">
                <xsl:text>essays</xsl:text>
                <!--<xsl:value-of select="$subpagetype"/>-->
                <xsl:text>/</xsl:text>
            </xsl:when>
            <xsl:when test="$pagetype = 'letters'">
                <xsl:text>letters</xsl:text>
                <!--<xsl:value-of select="$subpagetype"/>-->
                <xsl:text>/</xsl:text>
            </xsl:when>
            <!-- Photographs, Memorabilia -->
            <xsl:when test="$pageid != '' and $subpagetype != 'item'">
                <xsl:text>/view/</xsl:text>
                <xsl:value-of select="$pageid"/>
                <xsl:text>.html</xsl:text>
            </xsl:when>
            <!-- Texts -->
            <xsl:when test="$pagetype != 'search' and $subpagetype != 'item'">
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$subpagetype"/>
                <xsl:text>.html</xsl:text>
            </xsl:when>
            <!-- Individual items -->
            <xsl:when test="$subpagetype = 'item'">
                <xsl:text>.html</xsl:text>
            </xsl:when>
        </xsl:choose> 
        
        <!-- variables, show a ? if any search/display variables present -->
        
            <xsl:text>?</xsl:text>
            <!--<xsl:if test="$searchtype != ''">
                <xsl:text>&amp;searchtype=</xsl:text>
                <xsl:value-of select="$searchtype"/>
            </xsl:if>-->
            <xsl:if test="$sort != ''">
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sort"/>
            </xsl:if>
            <xsl:if test="$start != 0">
                <xsl:text>&amp;start=</xsl:text>
                <xsl:value-of select="$start"/>
            </xsl:if>
            <!--<xsl:if test="$fq != ''">
                <xsl:text>&amp;fq=</xsl:text>
                <xsl:value-of select="$fq"/>
            </xsl:if>-->
            <xsl:if test="$q != ''">
                <xsl:text>&amp;q=</xsl:text>
                <xsl:value-of select="$q"/>
            </xsl:if>
        
        
    </xsl:template>
    
    
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        solrURL || Builds Solr Link
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

    <xsl:template name="solrURL">
        <!-- Any site wide defaults should be set here. Any blanks will go to solr defaults -->
        <xsl:param name="rowstart">0</xsl:param>
        <xsl:param name="rowend">20</xsl:param>
        <xsl:param name="searchfields">id,title</xsl:param>
        <xsl:param name="facet"></xsl:param>
        <xsl:param name="facetfield"></xsl:param>
        <xsl:param name="other"></xsl:param>
        <xsl:param name="q"></xsl:param>
        <xsl:param name="sort"></xsl:param>
        <xsl:param name="sortSecondary"></xsl:param>

        <xsl:value-of select="$searchroot"/>

   <!-- Add sort if not set to default -->
        <xsl:choose>
            <xsl:when test="$sort = ''">
                <!-- do nothing to leave as default sort -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sort"/>
                <xsl:text>+asc</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
   <!-- Add secondary sort if necessary -->
        <xsl:choose>
            <xsl:when test="$sortSecondary = ''">
                <!-- do nothing to leave as default sort -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;sort=</xsl:text>
                <xsl:value-of select="$sortSecondary"/>
                <xsl:text>+asc</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
   <!-- tag filters that directly constrain doctype http://wiki.apache.org/solr/SimpleFacetParameters 
             This variable is set globally, and passed through a URL
             need to research this more, not sure what project I used it for or what I was accomplishing
             Oh, might have used it for CWW keywords -Karin -->
        <xsl:choose>
            <xsl:when test="$searchtype = 'all' or $searchtype = '' or $searchtype = 'keyword'">
                <!-- do nothing to leave as default display -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;fq={!tag=dt}subtype:</xsl:text>
                <xsl:value-of select="$searchtype"/>
            </xsl:otherwise>
        </xsl:choose>

   <!-- Start and rows -->
        <xsl:if test="$rowstart != ''">
            <xsl:text>&amp;start=</xsl:text>
            <xsl:value-of select="$rowstart"/>
        </xsl:if>
        <xsl:if test="$rowend != ''">
            <xsl:text>&amp;rows=</xsl:text>
            <xsl:value-of select="$rowend"/>
        </xsl:if>
        
   <!-- Which fields to return -->
        <xsl:if test="$searchfields != ''">
            <xsl:text>&amp;fl=</xsl:text>
            <xsl:value-of select="$searchfields"/>
        </xsl:if>
        
        <!-- faceting options -->
        <xsl:if test="$facet = 'true'">
            <xsl:text>&amp;facet=</xsl:text>
            <xsl:value-of select="$facet"/>
            <xsl:if test="$facetfield != ''">
                <xsl:text>&amp;facet.field=</xsl:text>
                <xsl:value-of select="$facetfield"/>
            </xsl:if>
            
        </xsl:if>
        
        <!-- anything else, passed through the "other" variable -->
        <xsl:if test="$other != ''">
            <xsl:value-of select="$other"/>
        </xsl:if>
        
        <!-- query -->
        <xsl:choose>
            <xsl:when test="$q = ''">
                <xsl:text>&amp;q=%28*:*%29</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&amp;q=%28</xsl:text>
                <xsl:value-of select="encode-for-uri($q)"/>
                <xsl:text>%29</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="topnav">
       
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        paginationLinks ||| Constructs links for pagination
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    
    <xsl:template name="paginationLinks">
        <xsl:param name="searchTerm"/>
        <xsl:param name="numFound"/>
        <xsl:param name="start"></xsl:param> <!-- defaults to 0, unless changed in cocoon sitemap -->
        <xsl:param name="rows"/> <!-- defaults to 10, unless changed in cocoon sitemap -->
        <xsl:param name="sort"><xsl:value-of select="$sort"/></xsl:param>
        
        <xsl:variable name="prev-link">
            
            <xsl:choose>
                <xsl:when test="$start_num &lt;= 0">
                    <xsl:text>Previous</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="start">
                                    <xsl:value-of select="$start_num - $rows_num"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:if test="$searchTerm">
                                <xsl:text>q=</xsl:text>
                                <xsl:value-of select="$searchTerm"/>
                                <xsl:text>&#38;</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:text>Previous</xsl:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="next-link">
            <xsl:choose>
                <xsl:when test="$start_num + $rows_num &gt;= $numFound">
                    <xsl:text>Next</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:call-template name="urlbuilder">
                                <xsl:with-param name="start"><xsl:value-of select="$start_num + $rows_num"/></xsl:with-param>
                            </xsl:call-template>
                            <xsl:if test="$searchTerm">
                                <xsl:text>q=</xsl:text>
                                <xsl:value-of select="$searchTerm"/>
                                <xsl:text>&#38;</xsl:text>
                            </xsl:if>
                        </xsl:attribute>
                        <xsl:text>Next</xsl:text>
                    </a>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Pagination HTML (do not show if less than 2 pages) -->
        <xsl:choose>
            <xsl:when test="ceiling($numFound div $rows_num) != 1">
                <div class="pagination"><xsl:copy-of select="$prev-link"/> | Go to <!--page -->
                    <form>
                        <xsl:attribute name="class">jumpForm</xsl:attribute>
                        <xsl:attribute name="action"></xsl:attribute>
                        <xsl:if test="$q != 'unset' or $q != '*:*'">
                            <input type='hidden' name='q' value='{$q}' />
                        </xsl:if>
                        
                        <xsl:if test="$sort != 'score'">
                            <input type='hidden' name='sort' value='{$sort}' />
                        </xsl:if>
                        
                        <span class="paginationJump_div">
                        <select name="start" class="paginationJump">
                        <xsl:call-template name="recurse_till_x">
                            <xsl:with-param name="num">1</xsl:with-param>
                            <xsl:with-param name="times" as="xs:integer"><xsl:value-of select="ceiling($numFound div $rows_num)"/></xsl:with-param>
                        </xsl:call-template>
                        </select>
                        </span>
                        
                        <input type="submit" value="Go" class="paginationJumpBtn submit"/>
                    </form>
                    
                     of <xsl:value-of select="ceiling($numFound div $rows_num)"/> | <xsl:copy-of
                    select="$next-link"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="pagination">
                    <xsl:text>Showing all results (Page 1 of 1)</xsl:text>
                </div>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- /end Pagination HTML -->
        
    </xsl:template>
    
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Recursive template to construct jump down menu
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->   
    
    <!-- Recursive template from transmiss -KMD -->
    <xsl:template name="recurse_till_x" xpath-default-namespace="">
        <xsl:param name="num">1</xsl:param>
        <xsl:param name="times"/>
        
        
        <option>
            <xsl:attribute name="value"><xsl:value-of select="($num - 1) * $rows_num"/></xsl:attribute>
            <xsl:if test="($num - 1) * $rows_num = $num or ($start_num div $rows_num) + 1 = $num">
                <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="$num"/>
        </option>

        <!-- The recursion part -->
        
        <xsl:if test="$num != $times">
            <xsl:call-template name="recurse_till_x">
                <xsl:with-param name="num"><xsl:value-of select="$num + 1"/></xsl:with-param>
                <xsl:with-param name="times" as="xs:integer"><xsl:value-of select="$times"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        pagelistsolr (unneeded?)
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->


    <xsl:template name="pagelistsolr">
        <xsl:param name="solrsearchurl"/>
        <xsl:for-each select="document($solrsearchurl)" xpath-default-namespace="">

            <xsl:for-each-group select="/response/result/doc" group-by="str[@name='subtype']">

                <ul>
                    <xsl:for-each select="current-group()">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$siteroot"/>
                                    <xsl:value-of select="str[@name='subtype']"/>
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="str[@name='id']"/>
                                    <xsl:text>.html</xsl:text>
                                </xsl:attribute>

                                <xsl:value-of select="str[@name='title']"/>
                                <!--<xsl:text> - </xsl:text>
                        <xsl:value-of select="str[@name='id']"/>-->
                                <!--<xsl:text> - </xsl:text>
                        <xsl:value-of select="str[@name='dateNormalized']"/>-->
                            </a>
                        </li>

                    </xsl:for-each>
                </ul>
            </xsl:for-each-group>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>
