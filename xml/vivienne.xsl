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
        max-height: 90vw;
        max-width: 90vw;
        border: 2px solid black;
        background-color: white;
        margin: 2rem auto; /* Adds vertical spacing (top + bottom) */
        box-sizing: border-box;
        overflow: auto;
        padding: 1rem;
        }
        .front .section-square:nth-of-type(2) {
        padding: 3rem;
        text-align: justify;
        font-family: 'Didot', serif;
        }
        .right-gold-title {
          color: #856A00;
          text-align: right;
          margin: 0;
          font-size: 2.5vw; /* Adjusted size: ~21px on a 600px box */
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
          <xsl:apply-templates select="tei:text/tei:back"/>
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

</xsl:stylesheet>
