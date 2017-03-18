<?xml version="1.0" encoding="UTF-8"?>
<!-- This XSLT has been optimized for the Drupal XSL formatter, and is stuck with XSLT 1.0 and without DTD-derived defaults in the XML -->
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="recipe">
		<!--
		<html>
			<head>
				<title><xsl:value-of select="title"/> - Michael Cooper</title>
				<link rel="stylesheet" type="text/css" href="/recipes/recipes" />
			</head>
			<body><xsl:apply-templates/></body>
		</html>
		-->
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="title">
		<!--
		<h1><xsl:value-of select="."/></h1>
		-->
	</xsl:template>
	
	<xsl:template match="meta">
		<xsl:apply-templates select="comment | processnote"/>
	</xsl:template>
	
	<xsl:template match="comment">
		<p class="comment"><xsl:apply-templates/></p>
	</xsl:template>
	
	<xsl:template match="processnote">
		<p class="processnote"><xsl:apply-templates/></p>
	</xsl:template>

	<xsl:template match="ingredients">
		<xsl:variable name="heading-level">
			<xsl:call-template name="heading-level"/>
		</xsl:variable>
		<section class="ingredients">
			<xsl:attribute name="id">
				<xsl:call-template name="section-id"/>
			</xsl:attribute>
			<xsl:element name="h{$heading-level}">
				<xsl:text>Ingredients</xsl:text>
			</xsl:element>
			<xsl:apply-templates select="yield"/>
			<ul class="ingredients">
				<xsl:apply-templates select="ingredient | ingredient_group | ingredient_choice"/>
			</ul>
		</section>
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
	
	<xsl:template match="ingredient_choice">
		<li>
			<xsl:apply-templates select="ingredient | ingredient_group | ingredient_choice"/>
		</li>
	</xsl:template>
	
	<xsl:template match="ingredient_choice/ingredient">
		<xsl:call-template name="ingredient"/>
		<xsl:if test="not(position() = last())"><xsl:text>, </xsl:text><strong>OR</strong><xsl:text> </xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="ingredient_choice/ingredient_group">
		<li>
			<xsl:apply-templates select="ingredient | ingredient_group | ingredient_choice"/>
			<xsl:if test="not(position() = last())"><xsl:text>, </xsl:text><strong>OR</strong><xsl:text> </xsl:text></xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="ingredient_group">
		<li>
			<xsl:apply-templates select="ingredient | ingredient_group | ingredient_choice"/>
		</li>
	</xsl:template>
	
	<xsl:template match="ingredient_group/ingredient">
		<xsl:call-template name="ingredient"/>
		<xsl:if test="not(position() = last())"><xsl:text> </xsl:text><strong>AND</strong><xsl:text> </xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="quantity">
		<xsl:apply-templates/>
		<xsl:if test="@approximate = 'true'"><xsl:text> (approximately) </xsl:text></xsl:if>
		<xsl:if test="following-sibling::quantity"><xsl:text> - </xsl:text></xsl:if>
	</xsl:template>
	
	<xsl:template match="altmeasure | quantity/quantity">
		<xsl:text> (</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>)</xsl:text>
	</xsl:template>
	
	<xsl:template match="value">
		<!--<xsl:text> </xsl:text>-->
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="unit">
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="variant">
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="item">
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="../@mainingredient = 'true'">
				<strong class="mainingredient"><xsl:apply-templates/></strong>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="preprep">
		<xsl:text>, </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="note"/>
	
	<!--<xsl:template match="ingredient_choice"><xsl:apply-templates/></xsl:template>
	
	<xsl:template match="ingredient_group"><xsl:apply-templates/></xsl:template>-->
	
	<xsl:template match="group">
		<section class="group">
			<xsl:attribute name="id">
				<xsl:call-template name="section-id"/>
			</xsl:attribute>
			<xsl:if test="not(label)">
				<xsl:variable name="heading-level">
					<xsl:call-template name="heading-level"/>
				</xsl:variable>
				<xsl:element name="h{$heading-level}">
					<xsl:text>Group</xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates/>
		</section>
	</xsl:template>
	
	<xsl:template match="activity">
		<section class="activity">
			<xsl:attribute name="id">
				<xsl:call-template name="section-id"/>
			</xsl:attribute>
			<xsl:if test="not(label)">
				<xsl:variable name="heading-level">
					<xsl:call-template name="heading-level"/>
				</xsl:variable>
				<xsl:element name="h{$heading-level}">
					<xsl:text>Activity</xsl:text>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates/>
		</section>
	</xsl:template>
	
	<xsl:template match="label">
		<xsl:variable name="heading-level">
			<xsl:call-template name="heading-level"/>
		</xsl:variable>
		<xsl:element name="h{$heading-level}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="steps">
		<xsl:variable name="heading-level">
			<xsl:call-template name="heading-level"/>
		</xsl:variable>
		<section class="steps">
			<xsl:attribute name="id">
				<xsl:call-template name="section-id"/>
			</xsl:attribute>
			<xsl:element name="h{$heading-level}">
				<xsl:text>Steps</xsl:text>
			</xsl:element>
			<ol>
				<xsl:apply-templates/>
			</ol>
		</section>
	</xsl:template>
	
	<xsl:template match="step">
		<li>
			<xsl:if test="@optional = 'true'">
				<em>Optional: </em>
			</xsl:if>
			<xsl:apply-templates/>
		</li>
	</xsl:template>
	
	<xsl:template match="step/ingredient"><xsl:call-template name="ingredient"/></xsl:template>
	
	<xsl:template match="temperature">
		<xsl:value-of select="."/> °<xsl:choose>
			<xsl:when test="@scale = 'Fahrenheit' or not(@scale)"><abbr title="Fahrenheit">F</abbr></xsl:when>
			<xsl:when test="@scale = 'Celsius'"><abbr title="Celsius">C</abbr></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="reciperef">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="@ref"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	<xsl:template match="expanded">
		<span class="expanded">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="explanation">
		<span class="explanation">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	
	<xsl:template match="variation">
		<section class="variation">
			<xsl:attribute name="id">
				<xsl:call-template name="section-id"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</section>
	</xsl:template>
	
	<xsl:template match="variation/label">
		<h2>Variation: <xsl:apply-templates/></h2>
	</xsl:template>
	
	<xsl:template match="storage">
		<section class="storage">
			<xsl:attribute name="id">
				<xsl:call-template name="section-id"/>
			</xsl:attribute>
			<h2>Storage Instructions</h2>
			<xsl:apply-templates/>
		</section>
	</xsl:template>
	
	<xsl:template name="section-id">
		<xsl:param name="section" select="."/>
		<xsl:apply-templates select="$section/ancestor::recipe | $section/ancestor::group | $section/ancestor::activity | $section/ancestor::ingredients | $section/ancestor::steps | $section" mode="section-id"/>
	</xsl:template>
	
	<xsl:template match="recipe" mode="section-id">
		<xsl:value-of select="translate(title, ' ', '-')"/>
		<xsl:if test="position() != last()">_</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="section-id">
		<xsl:choose>
			<xsl:when test="label">
				<xsl:value-of select="translate(label, ' ', '-')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(name(), ' ', '-')"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="count(preceding-sibling::*)"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="position() != last()">_</xsl:if>
	</xsl:template>
	
	<xsl:template name="heading-level">
		<xsl:param name="section" select="."/>
		<xsl:value-of select="count($section/ancestor-or-self::recipe | $section/ancestor-or-self::group | $section/ancestor-or-self::activity | $section/ancestor-or-self::ingredients | $section/ancestor-or-self::steps)"/>
	</xsl:template>
</xsl:stylesheet>
