<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0">



    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml" class="{$pagetype} {$subpagetype}">

            <head>
                <meta name="viewport" content="width=device-width" />
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                
                <title>Across the Spectrum: The Interdisciplinary Life and Letters of John G. Neihardt (‘Flaming Rainbow’)</title>
                
                <link href="{$siteroot}assets/css/reset.css" rel="stylesheet" type="text/css"/> 
                <link href="{$siteroot}assets/css/style.css" rel="stylesheet" type="text/css"/>

                <!-- JQuery -->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"> &#160; </script>

                <!-- Pretty Photo -->
                <link rel="stylesheet" href="{$siteroot}assets/js/prettyPhoto_compressed_3.1.3/css/prettyPhoto.css" type="text/css" media="screen" charset="utf-8" />
                <script src="{$siteroot}assets/js/prettyPhoto_compressed_3.1.3/js/jquery.prettyPhoto.js"> &#160; </script>


                <script src="{$siteroot}assets/js/script.js"> &#160; </script>
                <link href="http://fonts.googleapis.com/css?family=Josefin+Slab:400,700"
                    rel="stylesheet" type="text/css"/>

                <script type="text/javascript"> 
              <![CDATA[
                    Google analytics tracking code goes here//]]>  </script>
            </head>


            <body>

                <div id="header" class="header">
                    <h1>
                        <a href="{$siteroot}">
                            <span class="header_main">
                                <span class="head_col_1">Ac</span>
                                <span class="head_col_2">ro</span>
                                <span class="head_col_3">ss </span>
                                <span class="head_col_4">the </span>
                                <span class="head_col_5">Spe</span>
                                <span class="head_col_6">ctr</span>
                                <span class="head_col_7">um:</span>
                            </span>
                            <span class="header_sub">The Interdisciplinary Life and Letters of John
                                G. Neihardt (‘Flaming Rainbow’)</span>
                        </a>
                    </h1>

                    <div id="nav" class="nav">
                        <ul>
                            <li>
                                <a href="{$siteroot}" class="home">Home</a>
                            </li>
                            <li>
                                <a href="{$siteroot}essays/" class="essays">Essays &amp; Reviews</a>
                            </li>
                            <li>
                                <a href="{$siteroot}letters/" class="letters">Letters &amp;
                                    Correspondence</a>
                            </li>
                            <li>
                                <a href="{$siteroot}browse/" class="browse">Browse</a>
                            </li>
                            <li>
                                <a href="{$siteroot}search/" class="search">Search</a>
                            </li>
                            <li>
                                <a href="{$siteroot}about/" class="about">About</a>
                            </li>
                        </ul>
                    </div>
                    <!-- /nav -->

                </div>
                <!-- /header -->
                <div class="pagewrap">
                    <div id="main_div" class="main_div">
                        <xsl:call-template name="mainContent"/>
                    </div>

                    <div id="footer" class="footer">
                        <!--<div class="nav">
                            <ul>
                                <li><a href="{$siteroot}" class="home">Home</a></li>
                                <li><a href="{$siteroot}about/" class="about">About</a></li>
                                <li><a href="{$siteroot}browse/" class="browse">Browse</a></li>
                                <li><a href="{$siteroot}topics/" class="topics">Topics</a></li>
                                <li><a href="{$siteroot}essays/" class="essays">Essays and Introductions</a></li>
                                <li><a href="{$siteroot}timeline/" class="timeline">Timeline of Life and Works</a></li>
                            </ul>
                        </div> <!-\- /nav -\->-->

                        <div class="footerinfo">
                            <p>Created by the <a href="http://cdrh.unl.edu">Center for Digital
                                    Research in the Humanities</a>. <br/>Funding provided by the <a
                                    href="http://www.unl.edu/plains/pha/pha.shtml">Plains Humanities
                                    Alliance</a> and the <a href="http://www.unl.edu/plains/welcome"
                                    >Center for Great Plains Studies</a>.</p>
                        </div>
                        <!-- /footerinfo -->

                        <div class="icons">
                            <a href="http://www.unl.edu/"><img src="{$siteroot}assets/template/unl_black.png"  class="right"/></a>
                        </div><!-- /icons -->
                        
                    </div> <!-- /footer -->
                </div><!-- /pagewrap -->
            </body>
        </html>



    </xsl:template>

    <!--  ABOUT -->

    <xsl:template name="about">
        <xsl:apply-templates/>
    </xsl:template>



</xsl:stylesheet>
