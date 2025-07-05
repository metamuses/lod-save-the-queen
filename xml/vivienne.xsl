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
        <link href="https://fonts.googleapis.com/css2?family=Roboto+Condensed:wght@400&amp;display=swap" rel="stylesheet"/>

        <style>
        .section-square {
          height: 95vh;
          width: 95vh;
          justify-content: center;
          align-items: center;
          text-align: justify;
          max-height: 90vw;
          max-width: 90vw;
          border: 2px solid black;
          background-color: #FFFFFF;
          margin: 1.5rem auto;
          box-sizing: border-box;
          overflow: auto;
          padding: 1rem;
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

        .section-square:nth-of-type(3){
          padding: 3rem;
        }
        .section-square:nth-of-type(4),
        .section-square:nth-of-type(5),
        .section-square:nth-of-type(6),
        .section-square:nth-of-type(7),
        .section-square:nth-of-type(8),
        .section-square:nth-of-type(9),
        .section-square:nth-of-type(10),
        .section-square:nth-of-type(11),
        .section-square:nth-of-type(12),
        .section-square:nth-of-type(13),
        .section-square:nth-of-type(14),
        .section-square:nth-of-type(15),
        .section-square:nth-of-type(16),
        .section-square:nth-of-type(17) {

          padding: 3rem;
          text-align: justify;
          font-family: 'Didot', serif;
          font-size: 0.75rem;
        }

        .section-square:nth-of-type(2),
        .section-square:nth-of-type(3){
          padding: 3rem;
          font-family: 'Didot', serif;
          font-size: 1rem;

        }

        .stage-direction {
          font-style: italic;
          color: #555;
          font-size: 0.9em;
        }

        /*preface page*/

        .preface-head {
        text-align: center;
        font-family: 'Anton', sans-serif;
        font-size: 2.5rem;
        margin: 1rem;
        margin-bottom: 3rem;
        }

        .preface-head-of {
          font-family: 'Roboto Condensed', sans-serif;
          font-weight: normal;
          font-size: 3rem;
          display: inline;
        }

        /*signature vivienne*/
        .epilogue-img {
          max-width: 40%;
          height: auto;
          display: block;
          margin: 1rem auto;
        }

        /*style motto page  img and text*/
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
        .section-motto {
          padding: 4rem;
        }

        /*for the photograph page*/

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
          margin: 2rem 0 4rem 0;
          font-size: 0.75rem;
          padding-top: 15rem;
        }

        .photo-photographer {
          text-align: right;
          color: black;
          font-size: 0.8rem;
          margin-top: 1rem;
          font-family: 'Anton', sans-serif;
          font-weight: bold;
          padding-top: 8rem;
        }

        .photo-img {
          max-width: 100%;
          height: auto;
          margin: 0 rem;
          display: inline;
          vertical-align: middle;
          border: 2px solid black;
        }
        /*speaker group style handler*/
        .dialogue-tight {
          line-height: 1.1;
        }

        .dialogue-tight p,
        .dialogue-tight .sp-line {
          margin: 0.2rem 0;
          line-height: 1.1;
        }
        /*prologue styling*/

        .prologue-head {
          font-family: 'Anton', sans-serif;
          text-align: center;
          line-height: 1;
          margin-bottom: 2rem;
        }

        .prologue-abbrev {
          font-size: 25vh;
          letter-spacing: -2rem; /* negative kerning to make A and R touch */
          display: inline-block;
        }

        .prologue-subhead {
          font-size: 7vh;
          display: inline-block;
          margin-top: 1rem;
          line-height: 1.1;
        }
        /*dropcap styling*/
        .dropcap-speaker {
          float: left;
          font-family: 'Anton', sans-serif;
          font-size: 8vh;
          letter-spacing: -0.5rem;
          line-height: 1;
          margin-right: 0.1rem;
          margin-top: 0.1em;
          width: 1em;
          height: 8vh;
          display: block;
        }
        /*photographers list page*/
        .photographer-inline {
          font-family: 'Anton', sans-serif;
          margin-bottom: 1rem;
          text-align: left;
          white-space: nowrap;
        }

        .photographer-inline .day {
          color: #856A00;
          font-size: 1.5rem;
          font-weight: bold;
          margin-right: 0.5rem;
        }

        .photographer-inline .persname {
          font-size: 1.5rem;
          color: black;
        }


        </style>
      </head>
      <body>
        <xsl:call-template name="render-section">
          <xsl:with-param name="content" select="tei:text"/>
        </xsl:call-template>
      </body>
    </html>
  </xsl:template>

<!--transform <pb/> tag into sectioned div-->
  <xsl:template name="render-section">
    <xsl:param name="content"/>
    <div class="section-square">
      <xsl:apply-templates select="$content" mode="split"/>
    </div>
  </xsl:template>

  <xsl:template match="tei:pb" mode="split">
    <xsl:text disable-output-escaping="yes"><![CDATA[</div><div class="section-square">]]></xsl:text>
  </xsl:template>

  <xsl:template match="*" mode="split">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()" mode="split"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()" mode="split">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="tei:lb" mode="split">
    <br/>
  </xsl:template>
<!--speakers sections-->
  <xsl:template match="tei:sp" mode="split">
    <p>
      <xsl:apply-templates select="tei:speaker" mode="split"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="tei:p" mode="split"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:div2[@type='body of perfomance text']/tei:div3/tei:sp[1]/tei:speaker[text()='AR']" mode="split">
    <span class="dropcap-speaker">AR</span>
  </xsl:template>

  <xsl:template match="tei:speaker" mode="split">
    <strong><xsl:apply-templates mode="split"/></strong>
  </xsl:template>

  <xsl:template match="tei:sp/tei:p" mode="split">
    <xsl:apply-templates mode="split"/>
  </xsl:template>

  <xsl:template match="tei:hi" mode="split">
    <xsl:choose>
      <xsl:when test="contains(@rend, 'italic') and contains(@rend, 'bold')">
        <b><i><xsl:apply-templates mode="split"/></i></b>
      </xsl:when>
      <xsl:when test="contains(@rend, 'italic')">
        <i><xsl:apply-templates mode="split"/></i>
      </xsl:when>
      <xsl:when test="contains(@rend, 'bold')">
        <b><xsl:apply-templates mode="split"/></b>
      </xsl:when>
      <xsl:when test="contains(@rend, 'underlined')">
        <u><xsl:apply-templates mode="split"/></u>
      </xsl:when>
      <xsl:otherwise>
        <span><xsl:apply-templates mode="split"/></span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--stage inside sp line-->
  <xsl:template match="tei:stage[ancestor::tei:sp]" mode="split">
    <span class="stage-direction">
      <em><xsl:apply-templates mode="split"/></em>
    </span>
  </xsl:template>

<!-- Stage outside <sp>: block -->
  <xsl:template match="tei:stage[not(ancestor::tei:sp)]" mode="split">
    <div class="stage-direction">
      <em><xsl:apply-templates mode="split"/></em>
    </div>
  </xsl:template>


  <xsl:template match="tei:quote" mode="split">
    <xsl:apply-templates mode="split"/>
  </xsl:template>

  <xsl:template match="tei:q" mode="split">
    <i><xsl:apply-templates mode="split"/></i>
  </xsl:template>
<!--speakers group handler-->
  <xsl:template match="tei:spGrp" mode="split">
    <div class="dialogue-tight">
      <xsl:apply-templates mode="split"/>
    </div>
  </xsl:template>

<!--first page-->
  <xsl:template match="tei:head[@rend='gold-right']" mode="split">
    <h3 class="right-gold-title">
      <xsl:apply-templates mode="split"/>
    </h3>
  </xsl:template>
<!--motto page-->
  <xsl:template match="tei:figure" mode="split">
    <xsl:variable name="url" select="tei:graphic/@url"/>
    <xsl:variable name="alt" select="normalize-space(tei:figDesc)"/>
    <xsl:variable name="inMotto" select="ancestor::tei:div1[@type='motto']"/>
    <xsl:variable name="inEpilogue" select="ancestor::tei:div3[@type='epilogue']"/>
    <xsl:variable name="inPhoto" select="ancestor::tei:div3[@type='photo']"/>
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

      <xsl:when test="$inEpilogue">
        <img src="{$url}" alt="{$alt}" class="epilogue-img"/>
      </xsl:when>

      <xsl:when test="$inPhoto">
        <img src="{$url}" alt="{$alt}" class="photo-img"/>
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


  <xsl:template match="tei:div1[@type='motto']/tei:hi[2]" mode="split">
    <p class="motto-life">
      <xsl:apply-templates mode="split"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:div1[@type='motto']/tei:hi[1]" mode="split">
    <p class="motto-lead">
      <xsl:apply-templates mode="split"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:div1[@type='motto']/tei:hi[3]" mode="split">
    <p class="motto-artloversunite">
      <xsl:apply-templates mode="split"/>
    </p>
  </xsl:template>

  <xsl:template match="tei:div1[@type='motto']" mode="split">
    <div class="section-motto">
      <xsl:apply-templates mode="split"/>
    </div>
  </xsl:template>

<!--preface page-->
  <xsl:template match="tei:div1[@type='preface']/tei:head" mode="split">
    <div class="preface-head">
      <xsl:apply-templates mode="split"/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div1[@type='preface']/tei:head/tei:hi[normalize-space(.)='100']" mode="split">
    <span style="color: red;">
      <xsl:apply-templates mode="split"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:div1[@type='preface']/tei:head/tei:hi[normalize-space(.)='OF']" mode="split">
    <span class="preface-head-of">
      <u><xsl:apply-templates mode="split"/></u>
    </span>
  </xsl:template>
  <!--prologue div handling-->
  <xsl:template match="tei:div2[@type='prologue']/tei:head" mode="split">
    <div class="prologue-head">
      <span class="prologue-abbrev">
        <xsl:apply-templates select="tei:hi" mode="split"/>
      </span>
      <br/>
      <span class="prologue-subhead">
        <xsl:apply-templates select="text()[normalize-space() != '']" mode="split"/>
      </span>
    </div>
  </xsl:template>
  <xsl:template match="tei:div2[@type='prologue']/tei:head/tei:hi" mode="split">
    <xsl:value-of select="."/>
  </xsl:template>

<!--matching xml/html pagina photo1-->
  <!-- Match the head inside div3 in div1[@type='photographs'] -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:head" mode="split">
    <div class="photo-head">
      <!-- The Day 1 text is inside the text node before <lb/> -->
      <span class="day">
        <xsl:value-of select="normalize-space(text()[1])"/>
      </span>
      <br/>
      <!-- Then apply the date styling -->
      <span class="date">
        <xsl:apply-templates select="tei:date" mode="split"/>
      </span>
    </div>
  </xsl:template>

  <!-- Match the date element inside that head -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:head/tei:date" mode="split">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- Match the quote inside the p -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:p/tei:quote" mode="split">
    <p class="photo-quote">
      <xsl:apply-templates mode="split"/>
    </p>
  </xsl:template>

  <!-- Match the last p (photographer info) inside that div3 -->
  <xsl:template match="tei:div1[@type='photographs']//tei:div3[@type='photo information']/tei:p[@type='photographer']" mode="split">
    <p class="photo-photographer">
      <xsl:apply-templates mode="split"/>
    </p>
  </xsl:template>
  <!--photographer list page-->
  <xsl:template match="tei:back/tei:div1[@type='photographers list']/tei:div2[@type='photographers name']/tei:p" mode="split">
    <p class="photographer-inline">
      <span class="day">
        <xsl:value-of select="normalize-space(text()[1])"/>
      </span>
            &#160;
      <span class="persname">
        <xsl:apply-templates select="tei:persName" mode="split"/>
      </span>
    </p>
  </xsl:template>

  <!-- Match persName inside the photographer entry -->
  <xsl:template match="tei:persName" mode="split">
    <xsl:apply-templates mode="split"/>
  </xsl:template>

  <!--link page-->


</xsl:stylesheet>
