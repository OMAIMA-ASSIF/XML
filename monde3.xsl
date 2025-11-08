<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Données des Pays</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; }
                    .pays { border: 1px solid #ccc; margin: 10px 0; padding: 15px; border-radius: 5px; }
                    .nom-pays { color: #2c3e50; font-size: 24px; margin-bottom: 10px; }
                    .info { margin: 5px 0; }
                    .villes { margin-top: 10px; }
                    .ville { background-color: #f8f9fa; padding: 5px; margin: 2px 0; }
                    .frontieres { margin-top: 10px; }
                    .frontiere { color: #7f8c8d; }
                    .religions { margin-top: 10px; }
                    .religion { display: inline-block; margin-right: 15px; }
                </style>
            </head>
            <body>
                <h1>Liste des Pays</h1>
                <xsl:apply-templates select="monde/pays"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="pays">
        <div class="pays">
            <div class="nom-pays">
                <xsl:value-of select="nom"/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@code"/>
                <xsl:text>)</xsl:text>
            </div>
            
            <div class="info">
                <strong>Continent:</strong> <xsl:value-of select="@continent"/>
            </div>
            
            <div class="info">
                <strong>Population:</strong> 
                <xsl:value-of select="format-number(population, '#,##0')"/>
                <xsl:text> (année </xsl:text>
                <xsl:value-of select="population/@annee"/>
                <xsl:text>)</xsl:text>
            </div>
            
            <xsl:if test="religions">
                <div class="religions">
                    <strong>Religions:</strong>
                    <xsl:if test="religions/musulman > 0">
                        <span class="religion">Musulmans: <xsl:value-of select="format-number(religions/musulman, '#,##0')"/></span>
                    </xsl:if>
                    <xsl:if test="religions/chretien > 0">
                        <span class="religion">Chrétiens: <xsl:value-of select="format-number(religions/chretien, '#,##0')"/></span>
                    </xsl:if>
                    <xsl:if test="religions/juif > 0">
                        <span class="religion">Juifs: <xsl:value-of select="format-number(religions/juif, '#,##0')"/></span>
                    </xsl:if>
                    <xsl:if test="religions/autre != 'NaN'">
                        <span class="religion">Autres: <xsl:value-of select="religions/autre"/></span>
                    </xsl:if>
                </div>
            </xsl:if>
            
            <xsl:if test="ville">
                <div class="villes">
                    <strong>Villes principales:</strong>
                    <xsl:for-each select="ville">
                        <div class="ville">
                            <xsl:value-of select="nom"/>
                            <xsl:text> (Lat: </xsl:text>
                            <xsl:value-of select="latitude"/>
                            <xsl:text>, Long: </xsl:text>
                            <xsl:value-of select="longitude"/>
                            <xsl:text>)</xsl:text>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:if>
            
            <xsl:if test="frontiere">
                <div class="frontieres">
                    <strong>Frontières:</strong>
                    <xsl:for-each select="frontiere">
                        <div class="frontiere">
                            <xsl:text>Pays: </xsl:text>
                            <xsl:value-of select="@pays"/>
                            <xsl:text>, Longueur: </xsl:text>
                            <xsl:value-of select="@longueur"/>
                            <xsl:text> km</xsl:text>
                        </div>
                    </xsl:for-each>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
</xsl:stylesheet>