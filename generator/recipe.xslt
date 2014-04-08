<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="ingredient quantity"/>

	<xsl:template match="recipe">
		<html>
			<head>
				<title><xsl:value-of select="title"/> - Michael Cooper</title>
				<link rel="stylesheet" type="text/css" href="/recipes/recipes" />
			</head>
			<body><xsl:apply-templates/></body>
		</html>
	</xsl:template>
	
	<xsl:template match="title"><h1><xsl:value-of select="."/></h1></xsl:template>
	
	<xsl:template match="meta"><xsl:apply-templates select="comment | processnote"/></xsl:template>
	
	<xsl:template match="meta/comment"><p class="comment"><xsl:apply-templates/></p></xsl:template>
	
	<xsl:template match="processnote"><p class="processnote"><xsl:apply-templates/></p></xsl:template>

	<xsl:template match="ingredients">
		<xsl:apply-templates select="yield"/>
		<ul class="ingredients">
			<xsl:apply-templates select="ingredient | ingredient_group | ingredient_choice"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="yield">
		For <xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template name="ingredient">
		<xsl:apply-templates/>
		<!--<xsl:if test="not(quantity)"><xsl:text> to taste</xsl:text></xsl:if>-->
		<xsl:if test="@optional = 'true'"><xsl:text> (optional)</xsl:text></xsl:if>
	</xsl:template>

	<xsl:template match="ingredient">
		<li>
			<xsl:call-template name="ingredient"/>
		</li>
	</xsl:template>
	
	<xsl:template match="ingredient_choice"><xsl:apply-templates select="ingredient | ingredient_group | ingredient_choice"/></xsl:template>
	
	<xsl:template match="ingredient_choice/ingredient">
		<li>
			<xsl:call-template name="ingredient"/>
			<xsl:if test="not(position() = last())"><xsl:text>, </xsl:text><strong>OR</strong></xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="ingredient_group">
		<li><xsl:apply-templates select="ingredient | ingredient_group | ingredient_choice"/></li>
	</xsl:template>
	
	<xsl:template match="ingredient_group/ingredient">
		<xsl:call-template name="ingredient"/>
		<xsl:if test="not(position() = last())"><xsl:text> </xsl:text><strong>AND</strong><xsl:text> </xsl:text></xsl:if>
	</xsl:template>

	<xsl:template match="quantity">
		<xsl:apply-templates/>
		<xsl:if test="@approximate = 'true'"><xsl:text>(approximately) </xsl:text></xsl:if>
		<xsl:if test="following-sibling::quantity"><xsl:text> + </xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="altmeasure"><xsl:text> </xsl:text>(<xsl:apply-templates/>)</xsl:template>
	
	<xsl:template match="value"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="unit"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="variant"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="item"><xsl:text> </xsl:text><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="preprep"><xsl:text>, </xsl:text><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="note"/>
	
	<!--<xsl:template match="ingredient_choice"><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="ingredient_group"><xsl:apply-templates/></xsl:template>-->
	
	<xsl:template match="group"><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="activity"><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="label">
		<xsl:element name="h{count(ancestor::group | ancestor::activity) + 1}"><xsl:apply-templates/></xsl:element>
	</xsl:template>
	
	<xsl:template match="steps">
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>
	
	<xsl:template match="step">
		<li><xsl:apply-templates/></li>
	</xsl:template>
	
	<xsl:template match="step/ingredient"><xsl:call-template name="ingredient"/></xsl:template>
	
	<xsl:template match="temperature">
		<xsl:value-of select="."/> °<xsl:choose>
			<xsl:when test="@scale = 'Fahrenheit'"><abbr title="Fahrenheit">F</abbr></xsl:when>
			<xsl:when test="@scale = 'Celsius'"><abbr title="Celsius">C</abbr></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="reciperef">
		<a>
			<xsl:attribute name="href">aihal:recipe_<xsl:value-of select="@ref"/></xsl:attribute>
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	<xsl:template match="variation"><div class="variation"><xsl:apply-templates/></div></xsl:template>
	
	<xsl:template match="variation/label">
		<h2>Variation: <xsl:apply-templates/></h2>
	</xsl:template>
	
	<xsl:template match="storage">
		<h2>Storage Instructions</h2>
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
