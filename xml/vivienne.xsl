<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="tei">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- Root template -->
  <xsl:template match="/tei:TEI">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>
      </head>
      <body>
        <h1><xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h1>
        <h2>
          by <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
        </h2>

        <!-- Front matter (e.g. preface) -->
        <div class="front">
          <xsl:apply-templates select="tei:text/tei:front"/>
        </div>

        <!-- Main text -->
        <div class="main-text">
          <xsl:apply-templates select="tei:text/tei:text"/>
        </div>

        <!-- Back matter -->
        <div class="back">
          <xsl:apply-templates select="tei:text/tei:back"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- Default paragraph -->
  <xsl:template match="tei:p">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <!-- Paragraph inside a <sp> (no <p> wrapper) -->
  <xsl:template match="tei:sp/tei:p">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Line break -->
  <xsl:template match="tei:lb">
    <br/>
  </xsl:template>

  <!-- Speaker + paragraph inline rendering -->
  <xsl:template match="tei:sp">
    <p>
      <xsl:apply-templates select="tei:speaker"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="tei:p"/>
    </p>
  </xsl:template>

  <!-- Speaker rendered inline and bold -->
  <xsl:template match="tei:speaker">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <!-- Italics -->
  <xsl:template match="tei:hi[@rend='italic']">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <!-- Bold -->
  <xsl:template match="tei:hi[@rend='bold']">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <!-- Underlined -->
  <xsl:template match="tei:hi[@rend='underlined']">
    <u><xsl:apply-templates/></u>
  </xsl:template>

  <!-- Headings -->
  <xsl:template match="tei:head">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>

  <!-- Scene description -->
  <xsl:template match="tei:scene">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <!-- Stage direction -->
  <xsl:template match="tei:stage">
    <div class="stage-direction"><em><xsl:apply-templates/></em></div>
  </xsl:template>

  <!-- Handle <quote> -->
  <xsl:template match="tei:quote | tei:q">
    <blockquote><xsl:apply-templates/></blockquote>
  </xsl:template>

  <!-- Default catch-all rule -->
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
