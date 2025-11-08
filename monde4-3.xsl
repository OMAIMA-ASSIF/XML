<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:variable name="barHeight" select="30"/>
    <xsl:variable name="barSpacing" select="15"/>
    <xsl:variable name="margin" select="50"/>
    <xsl:variable name="maxBarWidth" select="600"/>
    <xsl:variable name="legendWidth" select="150"/>
    
    <xsl:template match="/">
        <svg width="1000" height="{count(monde/pays) * ($barHeight * 4 + $barSpacing * 3) + $margin * 3}" 
             xmlns="http://www.w3.org/2000/svg">
            
            <!-- Style -->
            <style>
                <![CDATA[
                .title { font-family: Arial; font-size: 24px; font-weight: bold; fill: #2c3e50; }
                .country-name { font-family: Arial; font-size: 14px; font-weight: bold; fill: #2c3e50; }
                .population-text { font-family: Arial; font-size: 12px; fill: #27ae60; }
                .religion-label { font-family: Arial; font-size: 11px; fill: #34495e; }
                .religion-value { font-family: Arial; font-size: 10px; fill: #7f8c8d; }
                .legend-text { font-family: Arial; font-size: 12px; fill: #2c3e50; }
                .axis-line { stroke: #bdc3c7; stroke-width: 1; }
                .axis-text { font-family: Arial; font-size: 10px; fill: #7f8c8d; }
                ]]>
            </style>
            
            <!-- Titre -->
            <text x="{$margin}" y="40" class="title">Répartition religieuse par pays</text>
            
            <!-- Légende -->
            <g transform="translate(700, 60)">
                <rect x="0" y="0" width="20" height="15" fill="#e74c3c" rx="3"/>
                <text x="25" y="12" class="legend-text">Musulmans</text>
                
                <rect x="0" y="25" width="20" height="15" fill="#3498db" rx="3"/>
                <text x="25" y="37" class="legend-text">Chrétiens</text>
                
                <rect x="0" y="50" width="20" height="15" fill="#f39c12" rx="3"/>
                <text x="25" y="62" class="legend-text">Juifs</text>
                
                <rect x="0" y="75" width="20" height="15" fill="#9b59b6" rx="3"/>
                <text x="25" y="87" class="legend-text">Autres</text>
                
                <rect x="0" y="100" width="20" height="15" fill="#ecf0f1" rx="3" stroke="#bdc3c7" stroke-width="1"/>
                <text x="25" y="112" class="legend-text">Aucune donnée</text>
            </g>
            
            <!-- Échelle de population -->
            <g transform="translate({$margin}, 80)">
                <text x="0" y="-10" class="axis-text">Échelle de population (millions) :</text>
                <line x1="0" y1="0" x2="{$maxBarWidth}" y2="0" class="axis-line"/>
                <xsl:call-template name="drawPopulationScale"/>
            </g>
            
            <!-- Pays triés par population -->
            <g transform="translate({$margin}, 120)">
                <xsl:apply-templates select="monde/pays">
                    <xsl:sort select="population" data-type="number" order="descending"/>
                </xsl:apply-templates>
            </g>
            
        </svg>
    </xsl:template>
    
    <!-- Template pour l'échelle de population -->
    <xsl:template name="drawPopulationScale">
        <xsl:variable name="maxPopulation" select="max(monde/pays/population)"/>
        <xsl:variable name="scaleStep" select="ceiling($maxPopulation div 5000000) * 5000000 div 5"/>
        
        <xsl:for-each select="0 to 5">
            <xsl:variable name="value" select=". * $scaleStep"/>
            <xsl:variable name="x" select="($value div $maxPopulation) * $maxBarWidth"/>
            
            <line x1="{$x}" y1="0" x2="{$x}" y2="5" class="axis-line"/>
            <text x="{$x}" y="15" class="axis-text" text-anchor="middle">
                <xsl:value-of select="format-number($value div 1000000, '#.##')"/>M
            </text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="pays">
        <xsl:variable name="yOffset" select="(position() - 1) * ($barHeight * 4 + $barSpacing * 3)"/>
        <xsl:variable name="maxPopulation" select="max(//pays/population)"/>
        <xsl:variable name="scaleFactor" select="$maxBarWidth div $maxPopulation"/>
        
        <!-- Nom du pays et population -->
        <g transform="translate(0, {$yOffset})">
            <text x="0" y="-5" class="country-name">
                <xsl:value-of select="nom"/> (<xsl:value-of select="@code"/>)
            </text>
            <text x="{$maxBarWidth + 10}" y="-5" class="population-text">
                <xsl:value-of select="format-number(population, '#,##0')"/> hab.
            </text>
            
            <!-- Barre Musulmans -->
            <xsl:call-template name="drawReligionBar">
                <xsl:with-param name="y" select="0"/>
                <xsl:with-param name="value" select="religions/musulman"/>
                <xsl:with-param name="total" select="population"/>
                <xsl:with-param name="scaleFactor" select="$scaleFactor"/>
                <xsl:with-param name="color" select="'#e74c3c'"/>
                <xsl:with-param name="label" select="'Musulmans'"/>
            </xsl:call-template>
            
            <!-- Barre Chrétiens -->
            <xsl:call-template name="drawReligionBar">
                <xsl:with-param name="y" select="$barHeight + $barSpacing"/>
                <xsl:with-param name="value" select="religions/chretien"/>
                <xsl:with-param name="total" select="population"/>
                <xsl:with-param name="scaleFactor" select="$scaleFactor"/>
                <xsl:with-param name="color" select="'#3498db'"/>
                <xsl:with-param name="label" select="'Chrétiens'"/>
            </xsl:call-template>
            
            <!-- Barre Juifs -->
            <xsl:call-template name="drawReligionBar">
                <xsl:with-param name="y" select="2 * ($barHeight + $barSpacing)"/>
                <xsl:with-param name="value" select="religions/juif"/>
                <xsl:with-param name="total" select="population"/>
                <xsl:with-param name="scaleFactor" select="$scaleFactor"/>
                <xsl:with-param name="color" select="'#f39c12'"/>
                <xsl:with-param name="label" select="'Juifs'"/>
            </xsl:call-template>
            
            <!-- Barre Autres -->
            <xsl:call-template name="drawOtherBar">
                <xsl:with-param name="y" select="3 * ($barHeight + $barSpacing)"/>
                <xsl:with-param name="value" select="religions/autre"/>
                <xsl:with-param name="scaleFactor" select="$scaleFactor"/>
                <xsl:with-param name="color" select="'#9b59b6'"/>
                <xsl:with-param name="label" select="'Autres'"/>
            </xsl:call-template>
        </g>
    </xsl:template>
    
    <!-- Template pour dessiner une barre de religion -->
    <xsl:template name="drawReligionBar">
        <xsl:param name="y"/>
        <xsl:param name="value"/>
        <xsl:param name="total"/>
        <xsl:param name="scaleFactor"/>
        <xsl:param name="color"/>
        <xsl:param name="label"/>
        
        <xsl:variable name="barWidth" select="$value * $scaleFactor"/>
        <xsl:variable name="percentage" select="($value div $total) * 100"/>
        
        <g transform="translate(0, {$y})">
            <!-- Étiquette -->
            <text x="0" y="{$barHeight div 2}" class="religion-label" text-anchor="start" dy="0.3em">
                <xsl:value-of select="$label"/>
            </text>
            
            <!-- Barre -->
            <xsl:choose>
                <xsl:when test="$value > 0">
                    <rect x="100" y="0" width="{$barWidth}" height="{$barHeight}" fill="{$color}" rx="3"/>
                    
                    <!-- Valeur et pourcentage dans la barre -->
                    <xsl:if test="$barWidth > 80">
                        <text x="{$barWidth + 100}" y="{$barHeight div 2}" class="religion-value" text-anchor="start" dy="0.3em">
                            <xsl:value-of select="format-number($value, '#,##0')"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="format-number($percentage, '#.##')"/>
                            <xsl:text>%)</xsl:text>
                        </text>
                    </xsl:if>
                    
                    <!-- Valeur à côté si la barre est trop petite -->
                    <xsl:if test="$barWidth &lt;= 80">
                        <text x="{$barWidth + 105}" y="{$barHeight div 2}" class="religion-value" text-anchor="start" dy="0.3em">
                            <xsl:value-of select="format-number($value, '#,##0')"/>
                            <xsl:text> (</xsl:text>
                            <xsl:value-of select="format-number($percentage, '#.##')"/>
                            <xsl:text>%)</xsl:text>
                        </text>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Barre vide pour données manquantes -->
                    <rect x="100" y="0" width="{$maxBarWidth}" height="{$barHeight}" fill="#ecf0f1" rx="3" stroke="#bdc3c7" stroke-width="1"/>
                    <text x="{$maxBarWidth + 105}" y="{$barHeight div 2}" class="religion-value" text-anchor="start" dy="0.3em">
                        Aucune donnée
                    </text>
                </xsl:otherwise>
            </xsl:choose>
        </g>
    </xsl:template>
    
    <!-- Template spécial pour la catégorie "Autres" -->
    <xsl:template name="drawOtherBar">
        <xsl:param name="y"/>
        <xsl:param name="value"/>
        <xsl:param name="scaleFactor"/>
        <xsl:param name="color"/>
        <xsl:param name="label"/>
        
        <g transform="translate(0, {$y})">
            <!-- Étiquette -->
            <text x="0" y="{$barHeight div 2}" class="religion-label" text-anchor="start" dy="0.3em">
                <xsl:value-of select="$label"/>
            </text>
            
            <xsl:choose>
                <xsl:when test="$value != 'NaN' and $value != '0'">
                    <!-- Barre pleine pour la catégorie "Autres" -->
                    <rect x="100" y="0" width="{$maxBarWidth}" height="{$barHeight}" fill="{$color}" rx="3"/>
                    <text x="{$maxBarWidth + 105}" y="{$barHeight div 2}" class="religion-value" text-anchor="start" dy="0.3em">
                        <xsl:value-of select="$value"/>
                    </text>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Barre vide pour données manquantes -->
                    <rect x="100" y="0" width="{$maxBarWidth}" height="{$barHeight}" fill="#ecf0f1" rx="3" stroke="#bdc3c7" stroke-width="1"/>
                    <text x="{$maxBarWidth + 105}" y="{$barHeight div 2}" class="religion-value" text-anchor="start" dy="0.3em">
                        Aucune donnée
                    </text>
                </xsl:otherwise>
            </xsl:choose>
        </g>
    </xsl:template>
    
</xsl:stylesheet>