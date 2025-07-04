<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="tei">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  <xsl:template match="/tei:TEI">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>

        <link href="https://fonts.googleapis.com/css2?family=Anton&amp;display=swap" rel="stylesheet"/>

        <style>
        .section-square {
          height: 95vh;
          width: 95vh;
          justify-content: center;
          align-items: center;
          max-height: 90vw;
          max-width: 90vw;
          border: 2px solid black;
          background-color: #FFFFFF;
          margin: 2rem auto; /* Adds vertical spacing (top + bottom) */
          box-sizing: border-box;
          overflow: auto;
          padding: 1rem;
        }

        br {
          margin: 0;
          padding: 0;
          line-height: 0;
        }
        <!--style motto page  img and text-->
        div[type="motto"] hi {
          display: block;
          margin: 0;
          padding: 0;
          line-height: 1;
        }
        .motto-life,
        .motto-artloversunite {
          margin-bottom: 0;
          margin-top: 0;
          padding: 0;
          line-height: 0.9; /* fine-tune if needed */
        }

        .motto-lead {
          font-family: 'Brush Script MT', cursive, sans-serif;
          font-size: 15vh;
          line-height: 1;
          margin: 0 0 2rem 2rem;
          padding-bottom: 2rem;
          text-align: left;
          display: inline;
        }

        .motto-img {
          max-width: 15%;
          height: auto;
          margin: 0 1rem;
          display: inline;
          vertical-align: middle;
        }

        .motto-life {
          font-size: 50vh;
          color: red;
          line-height: 1;
          text-align: center;
          font-family: 'Anton', sans-serif;
          margin: 0 0 0 0;
        }

        .motto-artloversunite {
          font-family: 'Brush Script MT', cursive, sans-serif;
          font-size: 7.5vh;
          color: red;
          line-height: 1;
          text-align: center;

        }
        <!--for the motto page-->
        .section-motto {
          padding: 4rem;
        }

        <!--for the preface page-->
        .front .section-square:nth-of-type(2) {
          padding: 3rem;
          text-align: justify;
          font-family: 'Didot', serif;
        }

        .right-gold-title {
          color: #856A00;
          text-align: right;
          margin: 0;
          font-size: 2.5vw;
          font-family: 'Anton', sans-serif;
          line-height: 1.2;
          font-weight: bold;
        }

        .preface-head {
        text-align: center;
        /* Optional styling */
        font-family: 'Anton', sans-serif;
        font-size: 2.5rem;
        margin: 1rem;
        margin-bottom: 3rem;
        }
        <!--for the photograph page-->

        .photo-head {
          text-align: left;
          font-family: 'Anton', sans-serif;
        }

        .photo-head .day {
          color: #856A00;
          font-size: 4vw;
          font-family: 'Anton', sans-serif;
          font-weight: bold;
        }

        .photo-head .date {
          color: black;
          font-family: 'Anton', sans-serif;
          font-size: 1.5rem;
        }

        .photo-quote {
          font-family: "Courier New", Courier, monospace;
          text-align: center;
          margin: 2rem 0;
          font-size: 1rem;
        }

        .photo-photographer {
          text-align: right;
          color: black;
          font-size: 0.8rem;
          margin-top: 1rem;
          font-family: 'Anton', sans-serif;
          font-weight: bold;
        }

        </style>
      </head>
      <body>
        <div class="front">
          <xsl:call-template name="process-sections">
            <xsl:with-param name="nodes" select="tei:text/tei:front/node()"/>
          </xsl:call-template>
        </div>

        <div class="body">
          <xsl:call-template name="process-sections">
            <xsl:with-param name="nodes" select="tei:text/tei:body/node()"/>
          </xsl:call-template>
        </div>

        <div class="back">
          <xsl:call-template name="process-sections">
            <xsl:with-param name="nodes" select="tei:text/tei:back/node()"/>
          </xsl:call-template>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="process-sections">
    <xsl:param name="nodes"/>
    <xsl:choose>
      <xsl:when test="not($nodes)"/>
      <xsl:otherwise>
        <xsl:variable name="pos">
          <xsl:call-template name="find-pb-position">
            <xsl:with-param name="nodes" select="$nodes"/>
            <xsl:with-param name="pos" select="1"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
          <!-- No pb: output everything in one section-square -->
          <xsl:when test="$pos = 0">
            <xsl:variable name="nonEmpty" select="$nodes[not(self::text()[normalize-space(.) = '']) and not(self::comment())]" />
            <xsl:if test="$nonEmpty">
              <div class="section-square">
                <xsl:apply-templates select="$nonEmpty"/>
              </div>
            </xsl:if>
          </xsl:when>

        <!-- Found a pb: split and insert square, then recurse -->
          <xsl:otherwise>
            <xsl:variable name="beforePb" select="$nodes[position() &lt; $pos]" />
            <xsl:variable name="pbNode" select="$nodes[position() = $pos][self::tei:pb]" />
            <xsl:variable name="afterPb" select="$nodes[position() &gt; $pos]" />

            <!-- Content before pb -->
            <xsl:variable name="nonEmptyBeforePb" select="$beforePb[not(self::text()[normalize-space(.) = '']) and not(self::comment())]" />
            <xsl:if test="$nonEmptyBeforePb">
              <div class="section-square">
                <xsl:apply-templates select="$nonEmptyBeforePb"/>
              </div>
            </xsl:if>

            <!-- pb triggers a new empty section-square -->
            <xsl:if test="$pbNode">
            </xsl:if>

            <!-- Recurse with remaining nodes -->
            <xsl:call-template name="process-sections">
            <xsl:with-param name="nodes" select="$afterPb"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="find-pb-position">
    <xsl:param name="nodes"/>
    <xsl:param name="pos"/>
    <xsl:choose>
      <xsl:when test="not($nodes)">
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:when test="$nodes[1][self::tei:pb]">
        <xsl:value-of select="$pos"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="find-pb-position">
          <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
          <xsl:with-param name="pos" select="$pos + 1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--basic matching strategy-->
  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template match="tei:sp/tei:p">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:lb">
    <br/>
  </xsl:template>

  <xsl:template match="tei:sp">
    <p>
      <xsl:apply-templates select="tei:speaker"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="tei:p"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:speaker">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="tei:hi[@rend='italic']">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="tei:hi[@rend='bold']">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <xsl:template match="tei:hi[@rend='underlined']">
    <u><xsl:apply-templates/></u>
  </xsl:template>

  <xsl:template match="tei:head">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>

  <xsl:template match="tei:head[@rend='gold-right']">
    <h3 class="right-gold-title">
      <xsl:apply-templates/>
    </h3>
  </xsl:template>

  <xsl:template match="tei:div1[@type='preface']/tei:head">
    <div class="preface-head">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div1[@type='preface']/tei:head/tei:hi[normalize-space(.)='100']">
    <span style="color: red;">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:div1[@type='preface']/tei:head/tei:hi[normalize-space(.)='OF']">
    <u>
      <xsl:apply-templates/>
    </u>
  </xsl:template>

  <xsl:template match="tei:scene">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="tei:stage">
    <div class="stage-direction"><em><xsl:apply-templates/></em></div>
  </xsl:template>

  <xsl:template match="tei:quote">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:q">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

<!--matching xml/html pagina motto-->
  <xsl:template match="tei:figure">
    <xsl:variable name="url" select="tei:graphic/@url"/>
    <xsl:variable name="alt" select="normalize-space(tei:figDesc)"/>
    <xsl:variable name="inMotto" select="ancestor::tei:div1[@type='motto']"/>
    <xsl:choose>
      <xsl:when test="$inMotto">
        <img>
          <xsl:attribute name="src">
            <xsl:value-of select="$url"/>
          </xsl:attribute>
          <xsl:attribute name="alt">
            <xsl:value-of select="$alt"/>
          </xsl:attribute>
          <xsl:attribute name="class">motto-img</xsl:attribute>
        </img>
      </xsl:when>
      <xsl:otherwise>
        <figure>
          <img>
            <xsl:attribute name="src">
              <xsl:value-of select="$url"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:value-of select="$alt"/>
            </xsl:attribute>
          </img>
        </figure>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="tei:div1[@type='motto']/tei:hi[2]">
    <p class="motto-life">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:div1[@type='motto']/tei:hi[1]">
    <p class="motto-lead">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:div1[@type='motto']/tei:hi[3]">
    <p class="motto-artloversunite">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:div1[@type='motto']">
    <div class="section-motto">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

<!--matching xml/html pagina photo1-->
  <!-- Match the head inside div3 in div1[@type='photographs'] -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:head">
    <div class="photo-head">
      <!-- The Day 1 text is inside the text node before <lb/> -->
      <span class="day">
        <xsl:value-of select="normalize-space(text()[1])"/>
      </span>
      <br/>
      <!-- Then apply the date styling -->
      <span class="date">
        <xsl:apply-templates select="tei:date"/>
      </span>
    </div>
  </xsl:template>

  <!-- Match the date element inside that head -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:head/tei:date">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- Match the quote inside the p -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:p/tei:quote">
    <p class="photo-quote">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- Match the last p (photographer info) inside that div3 -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:p[@type='photographer']">
    <p class="photo-photographer">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

</xsl:stylesheet>
