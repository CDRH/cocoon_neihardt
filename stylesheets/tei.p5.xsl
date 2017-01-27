<?xml version="1.0"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    version="2.0" >

  
  <xsl:output method="xhtml" indent="no" encoding="UTF-8"/>
  <xsl:param name="pagetype">unset</xsl:param>
  <xsl:param name="subpagetype">unset</xsl:param>
  <xsl:param name="q">unset</xsl:param>
  <xsl:param name="fq">unset</xsl:param>
  <xsl:param name="pageid">unset</xsl:param>
  <xsl:param name="start">0</xsl:param>
  <xsl:param name="rows">50</xsl:param>
  
  <xsl:param name="start_num"><xsl:value-of select="number($start)"/></xsl:param>
  <xsl:param name="rows_num"><xsl:value-of select="number($rows)"/></xsl:param>
  
  <xsl:param name="searchtype">all</xsl:param>
  <xsl:param name="sort">score</xsl:param>

  <xsl:include href="../config/config.xsl"/>

  <xsl:include href="common.xsl"/>
  <xsl:include href="page_templates.xsl"/>
  <xsl:include href="html_template.xsl"/>
  
  
  
  
  <!--<xsl:include href="html/tei.xsl"/>-->
  
  <!-- Things to hide -->

  <xsl:template match="teiHeader | revisionDesc | publicationStmt | sourceDesc | figDesc">
    <!-- hide --><xsl:text> </xsl:text>
  </xsl:template>

  <!-- Paragraphs and line breaks, add a rule check for nested paragraphs -->

  <xsl:template match="p">
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'p']">
        <div class="p">
          <xsl:apply-templates/>
        </div>
      </xsl:when>
      <xsl:when test="parent::body">
        <br />
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  
  <xsl:template match="p[@rend='italics']">
    <p>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <em><xsl:apply-templates/></em>
    </p>
  </xsl:template>
  
  <xsl:template match="lb">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>
  
  <!-- FW -->
  <xsl:template match="fw">  
    <xsl:if test="not(@type='sub')">
      <!-- Display page number, comment out below if you do not want page number displayed -->
    <!--<h6 class="pagenumber">
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </h6>-->
    </xsl:if>
  </xsl:template>
  
  <!-- Links -->
  
  <xsl:template match="xref[@n]">
    <a href="{@n}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- Elements to turn to DIV's -->
  
  <xsl:template match="text">
    <xsl:apply-templates/>
    
    <xsl:if test="//note[@place='foot']">
      <!-- <br/><h4>Footnotes</h4> -->
      <br /><hr />
    </xsl:if>
    <div class="footnotes"><xsl:text> </xsl:text>
      <xsl:for-each select="//note[@place='foot']">
      <p>
        <span class="notenumber"><xsl:value-of select="substring(@xml:id, 2)"/>.</span>
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
        <a>
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:text>body</xsl:text>
            <xsl:value-of select="@xml:id"/>

          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:text>foot</xsl:text>
            <xsl:value-of select="@xml:id"/>
          </xsl:attribute>
          <xsl:text>[back]</xsl:text>
        </a>
      </p>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="byline | docDate | sp | speaker | letter | 
    notesStmt | titlePart | docDate | ab | trailer | 
    front | lg | l | bibl | dateline | salute | trailer | titlePage | closer">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@type='handwritten'">
          <span><xsl:attribute name="class"><xsl:text>handwritten</xsl:text></xsl:attribute><xsl:apply-templates/></span>
        </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
      </xsl:choose>
    <xsl:text> </xsl:text>
    </div>
  </xsl:template>
  
  <!-- Special case, if encoding is fixed, can fold into rule above-->
  
  <xsl:template match="ab[@rend='italics']">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <em><xsl:apply-templates/></em>
    </div>
  </xsl:template>

  <!-- Elements to turn to SPAN's -->

  <xsl:template match="docAuthor | persName | placeName ">
    <span>
      <xsl:attribute name="class"><xsl:value-of select="name()"/></xsl:attribute><xsl:apply-templates/>
      <!-- <xsl:text> </xsl:text> -->
    </span>
  </xsl:template>

  <!-- HEADS -->

  <xsl:template match="head">
    <xsl:choose>
      <xsl:when test="ancestor::*[name() = 'p']">
        <span class="head">
          <xsl:apply-templates/>
          </span>
      </xsl:when>
      <xsl:when test="ancestor::*[name() = 'figure']">
        <span class="head">
          <xsl:apply-templates/>
        </span>
      </xsl:when>
      <xsl:when test=".[@type='sub']">
        <h4>
          <xsl:apply-templates/>
        </h4>
      </xsl:when>
      <xsl:when test="preceding::*[name() = 'head']">
        <h4>
          <xsl:apply-templates/>
        </h4>
      </xsl:when>
      <xsl:otherwise>
        <h3>
          <xsl:apply-templates/>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- Gaps, Additions, Deletes, Unclear -->
  
  <xsl:template match="damage">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:text>[?]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="gap">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@reason"/>
      </xsl:attribute>
      <xsl:apply-templates/>
      <xsl:text>[</xsl:text><xsl:value-of select="@reason" /><xsl:text>]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="unclear">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@reason"/>
      </xsl:attribute>
      <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>?]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="del">
    <xsl:choose>
      <xsl:when test="@type='overwrite'">
        <!-- Don't show overwritten text -->
      </xsl:when>
      <xsl:otherwise>
        <del>
          <xsl:attribute name="class">
            <xsl:value-of select="@reason"/>
            <xsl:apply-templates/></xsl:attribute>
          <xsl:value-of select="."/>
            <!-- <xsl:text>[?]</xsl:text> -->
          <xsl:text> </xsl:text>
          
        </del>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="add">
    <xsl:choose>
      <xsl:when test="@place='superlinear' or @place='supralinear'">
        <sup>
          <xsl:apply-templates/>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    
    
  </xsl:template>

<!-- Sic's and corrections -->
  
  <xsl:template match="choice[child::corr]">
    <!-- Note, the above won't show page breaks which appear in a corr -->
    <xsl:apply-templates select="sic"></xsl:apply-templates>
    <!-- Not displaying regularization -->
    
    <!--<a>
      <xsl:attribute name="rel">
        <xsl:text>tooltip</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>sic</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="corr"/>​
      </xsl:attribute><xsl:apply-templates select="sic"/>
    </a>-->
    ​</xsl:template>
  
  <!-- orig and reg -->
  
  <xsl:template match="choice[child::orig]">
    <xsl:apply-templates select="orig"></xsl:apply-templates>
    <!--<a>
      <xsl:attribute name="rel">
        <xsl:text>tooltip</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>orig</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="reg"/>​
      </xsl:attribute><xsl:apply-templates select="orig"/></a>​--></xsl:template>
  
  <!-- abbr and expan -->
  
  <xsl:template match="choice[child::abbr]">
    <a>
      <xsl:attribute name="rel">
        <xsl:text>tooltip</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="class">
        <xsl:text>abbr</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="title">
        <xsl:apply-templates select="expan"/>​
      </xsl:attribute><xsl:apply-templates select="abbr"/></a>​</xsl:template>

<!-- Figures -->
  
  <xsl:template match="figure">
    
    <xsl:apply-templates/>
    
    <!--<xsl:choose>
      <xsl:when test="@n">
        <div class="illustration">
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$externalfileroot"/>
              <xsl:text>template/</xsl:text>
              <xsl:value-of select="@facs"/>
            </xsl:attribute>
          </img>
          <p>
            <xsl:for-each select="p">
              <span class="caption">
                <xsl:value-of select="."></xsl:value-of>
              </span>
            </xsl:for-each>
          </p>
          
        </div>
      </xsl:when>
    </xsl:choose>-->
    
    <!--<xsl:if test="@n">
      <span>
        <xsl:attribute name="class">
          <xsl:text>figure </xsl:text>
        </xsl:attribute>
        
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$externalfileroot"/>
            <xsl:text>figures/</xsl:text>
            <xsl:text>/fullsize/</xsl:text>
            <xsl:value-of select="graphic/@url"/>
          </xsl:attribute>
          <xsl:attribute name="rel">
            <xsl:text>prettyPhoto[pp_gal]</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:text>&lt;a href="</xsl:text>
            <xsl:value-of select="$externalfileroot"/>
            <xsl:text>figures/</xsl:text>
            <xsl:text>/fullsize/</xsl:text>
            <xsl:value-of select="graphic/@url"/>
            <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
          </xsl:attribute>
          
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$externalfileroot"></xsl:value-of>
              <xsl:text>figures/</xsl:text>
              <xsl:text>thumbnails/</xsl:text>
              <xsl:value-of select="graphic/@url"/>
             
            </xsl:attribute>
            <xsl:attribute name="class">
              <xsl:text>display</xsl:text>
            </xsl:attribute>
          </img> 
        </a>          
        <xsl:if test="$subpagetype = 'newspapers'">
          <br/>
          <xsl:value-of select="tokenize(@facs, '\.')[last()-1]"/>
        </xsl:if>
        
        
        
      </span>  
    </xsl:if>-->
    
  </xsl:template>
  
  
  
  <!-- Page Images -->

  <xsl:template match="pb"> 
    <!-- No page images for now -->
   <!-- <xsl:if test="@facs">
      
      <hr class="page_hr" />
      
      
      <xsl:if test="./@n">
        <span class="fw">
        <h6>
        <xsl:value-of select="./@n"/>
        </h6>
        </span>
      </xsl:if>
      
      <span>
          <xsl:attribute name="class">
            <xsl:text>pageimage </xsl:text>
          </xsl:attribute>
          
          <a>
            <xsl:attribute name="href">
              <xsl:value-of select="$externalfileroot"/>
              <xsl:text>figures/</xsl:text>
              <xsl:text>/fullsize/</xsl:text>
              <xsl:value-of select="@facs"/>
              <xsl:text>.jpg</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="rel">
              <xsl:text>prettyPhoto[pp_gal_2]</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:text>&lt;a href="</xsl:text>
              <xsl:value-of select="$externalfileroot"/>
              <xsl:text>figures/</xsl:text>
              <xsl:text>/fullsize/</xsl:text>
              <xsl:value-of select="@facs"/>
              <xsl:text>.jpg</xsl:text>
              <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
            </xsl:attribute>
            
            <img>
              <xsl:attribute name="src">
                <xsl:value-of select="$externalfileroot"></xsl:value-of>
                <xsl:text>figures/</xsl:text>
                <xsl:text>thumbnails/</xsl:text>
                <xsl:value-of select="@facs"></xsl:value-of>
                <xsl:text>.jpg</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="class">
                <xsl:text>display</xsl:text>
                </xsl:attribute>
             </img> 
            <xsl:value-of select="@facs"/>
          </a>  
        </span>  
    </xsl:if>
    -->
    
    
    <!-- Setting variables that will be used to grab each <figure> tag before the next pb. 
        Getting figures here instead of with a match on figure because we want to group all the figures 
        together for display purposes.   -->
    
    <!--<xsl:variable name="following"><xsl:value-of select="count(following::figure/graphic)"/></xsl:variable>
    <xsl:variable name="preceding"><xsl:value-of select="count(preceding::figure/graphic)"/></xsl:variable>
    <xsl:variable name="following-next"><xsl:value-of select="count((following::pb)[1]/following::figure/graphic)"/></xsl:variable>
    
    <xsl:variable name="count"><xsl:value-of select="$following - $following-next"/></xsl:variable>
    
    <xsl:variable name="position_start"><xsl:value-of select="$preceding + 1"/></xsl:variable>
    <xsl:variable name="position_end"><xsl:value-of select="$count + $position_start - 1"/></xsl:variable>
    
    <xsl:if test="(/descendant::figure)[position() >= $position_start and position() &lt;= $position_end]/graphic/@url">
      <span class="figure_holder">
        <xsl:for-each select="(/descendant::figure)[position() >= $position_start and position() &lt;= $position_end]/graphic/@url">
          
          <span>
            <xsl:attribute name="class">
              <xsl:text>figure</xsl:text>
            </xsl:attribute>
            <a>
              <xsl:attribute name="href">
                <xsl:value-of select="$externalfileroot"/>
                <xsl:text>figures/</xsl:text>
                <xsl:text>/fullsize/</xsl:text>
                <xsl:value-of select="."/>
              </xsl:attribute>
              <xsl:attribute name="rel">
                <xsl:text>prettyPhoto[pp_gal]</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="title">
                <xsl:text>&lt;a href="</xsl:text>
                <xsl:value-of select="$externalfileroot"/>
                <xsl:text>figures/</xsl:text>
                <xsl:text>/fullsize/</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
              </xsl:attribute>
              
              <img>
                <xsl:attribute name="src">
                  <xsl:value-of select="$externalfileroot"></xsl:value-of>
                  <xsl:text>figures/</xsl:text>
                  <xsl:text>thumbnails/</xsl:text>
                  <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:attribute name="class">
                  <xsl:text>display</xsl:text>
                </xsl:attribute>
              </img> 
              <xsl:value-of select="."/>
              
            </a>
            
            <span class="figure_description"><xsl:value-of select="ancestor::figure"/></span>
          </span> 
        </xsl:for-each>
      </span>
    </xsl:if>-->
    <!-- End figure display -->
    
  </xsl:template>
  
  
  
  
  <!-- Div types for styling -->
  
  <xsl:template match="div1 | div2">
    <xsl:choose>
      <xsl:when test="@type='html'">
        <xsl:copy-of select="."/>
      </xsl:when>
      <xsl:otherwise>
         <div>
           <xsl:if test="@type">
           <xsl:attribute name="class">
             <xsl:value-of select="@type"/>
           </xsl:attribute>
           </xsl:if>
           
           <xsl:apply-templates />
           
         </div>
      </xsl:otherwise>
    </xsl:choose>
    
   
  </xsl:template>
  
  <!-- Handwritten -->
  <xsl:template match="seg[@type='handwritten']">    
    <span><xsl:attribute name="class"><xsl:text>handwritten</xsl:text></xsl:attribute><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="div2[@subtype='handwritten']">    
    <div><xsl:attribute name="class"><xsl:text>handwritten</xsl:text></xsl:attribute><xsl:apply-templates/></div>
  </xsl:template>
  

  <!-- Milestone / horizontal rule -->

  <xsl:template match="milestone">
    <div>
      <xsl:attribute name="class">
        <xsl:text>milestone </xsl:text>
        <xsl:value-of select="@unit"/>
      </xsl:attribute>
      <xsl:text> </xsl:text>
    </div>
  </xsl:template>

  <!-- Notes / Footnotes / references -->

  
  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="@place='foot'">
        <span>
          <xsl:attribute name="class">
            <xsl:text>foot</xsl:text>
          </xsl:attribute>
          <a>
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:text>foot</xsl:text>
            <xsl:value-of select="@xml:id"/>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:text>body</xsl:text>
            <xsl:value-of select="@xml:id"/>
          </xsl:attribute>
          
          <xsl:text>(</xsl:text>
          <xsl:value-of select="substring(@xml:id, 2)"/>
          <xsl:text>)</xsl:text>
        </a>
          </span>
      </xsl:when>
      <xsl:when test="@xml:id">
        <p id="{@xml:id}"><xsl:apply-templates/></p>
      </xsl:when>
      <xsl:when test="@type='editorial'"/>
      <xsl:when test="@type='curatorial'"/>
      <xsl:otherwise>
        <div>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>
  

  
  
  
  <xsl:template match="ref">
    <xsl:choose>
      <!--<xsl:when test="starts-with(@target, 'n')">
        <xsl:variable name="n" select="@target"/>
        <a>
          <xsl:attribute name="id">
            <xsl:text>ref</xsl:text>
            <xsl:value-of select="@target"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="class">
            <xsl:text>inlinenote</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>#note</xsl:text>
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:text> [note </xsl:text>
          <xsl:apply-templates></xsl:apply-templates>
          <xsl:text>] </xsl:text>
        </a>
      </xsl:when>-->
      <xsl:when test="ends-with(@target, '.xml')">
        <a href="{$siteroot}{substring-before(@target, 'xml')}html">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <!--<xsl:when test="ends-with(@facs, '.xml')">
        <a href="{$siteroot}{substring-before(@facs, 'xml')}html">
          <xsl:apply-templates/>
        </a>
      </xsl:when>-->
      <xsl:when test="ends-with(@target, '.html')">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="starts-with(@target, 'n')">
        <a href="#{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@type='link'">
        <a href="{@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
        <a href="{@target}" id="{@target}.ref" class="footnote">
         
            <xsl:choose>
              <xsl:when test="descendant::text()">
                <xsl:apply-templates/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@n"/>
              </xsl:otherwise>
            </xsl:choose>
          
        </a>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <!-- Rules for em tag -->
  
  <xsl:template
    match="term | foreign | emph | title[not(@level='a')] | biblScope[@type='volume'] | 
    hi[@rend='italic'] | hi[@rend='italics']">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  
  <xsl:template
    match="hi[@rend='underlined']">
    <u>
      <xsl:apply-templates/>
    </u>
  </xsl:template>
  
  <!-- Things that should be strong -->
  
  <xsl:template match="item/label">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  
  <xsl:template match="hi[@rend='bold']">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <!-- Rules to account for hi tags other than em and strong-->

  <xsl:template match="hi[@rend='underline']">
    <u>
      <xsl:apply-templates/>
    </u>
  </xsl:template>

  <xsl:template match="hi[@rend='quoted']">
    <xsl:text>"</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="hi[@rend='super']">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>

  <xsl:template match="hi[@rend='subscript']">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>

  <xsl:template match="hi[@rend='smallcaps'] | hi[@rend='roman']">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="@rend"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="hi[@rend='right'] | hi[@rend='center']">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="@rend"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  
  
  <!-- Signed -->
  <xsl:template match="//signed">
    <br /><xsl:apply-templates />
  </xsl:template>
  
  <!-- Table Rules -->
  
  <xsl:template match="table">
    <xsl:choose>
      <xsl:when test="@rend='handwritten'">
        <table>
          <xsl:attribute name="class">
            <xsl:text>handwritten</xsl:text>
          </xsl:attribute><xsl:apply-templates/>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <table>
          <xsl:apply-templates/>
        </table>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <xsl:template match="row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  <xsl:template match="cell">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  
  <!-- Lists -->
  
  <xsl:template match="list">
    <xsl:choose>
      <xsl:when test="@type='handwritten'">
        <ul>
          <xsl:attribute name="class">
            <xsl:text>handwritten</xsl:text>
          </xsl:attribute><xsl:apply-templates/>
        </ul>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template match="space">
    <span class="teispace"><xsl:text>[no handwritten text supplied here]</xsl:text></span>
  </xsl:template>
  
  <xsl:template match="q | quote">
    <blockquote><p><xsl:apply-templates/></p></blockquote>
  </xsl:template>

</xsl:stylesheet>
