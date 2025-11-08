<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Pays triés par population - Religions (Graphiques)</title>
                <style>
                    body { 
                    font-family: Arial, sans-serif; 
                    margin: 20px; 
                    background-color: #f5f5f5;
                    }
                    h1 { 
                    color: #2c3e50; 
                    text-align: center; 
                    margin-bottom: 30px;
                    }
                    .pays-container {
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
                    }
                    .pays-card {
                    background-color: white;
                    border-radius: 8px;
                    padding: 20px;
                    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                    border-left: 5px solid #3498db;
                    }
                    .pays-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 15px;
                    }
                    .pays-nom {
                    font-size: 20px;
                    font-weight: bold;
                    color: #2c3e50;
                    }
                    .pays-info {
                    display: flex;
                    gap: 15px;
                    color: #7f8c8d;
                    font-size: 14px;
                    }
                    .population {
                    font-size: 18px;
                    font-weight: bold;
                    color: #27ae60;
                    }
                    .graphique-container {
                    margin: 15px 0;
                    }
                    .graphique-titre {
                    font-size: 14px;
                    color: #34495e;
                    margin-bottom: 8px;
                    }
                    .barre-container {
                    display: flex;
                    align-items: center;
                    margin-bottom: 5px;
                    }
                    .barre-label {
                    width: 100px;
                    font-size: 12px;
                    color: #7f8c8d;
                    }
                    .barre {
                    height: 25px;
                    border-radius: 4px;
                    transition: width 0.3s ease;
                    display: flex;
                    align-items: center;
                    padding: 0 10px;
                    color: white;
                    font-size: 11px;
                    font-weight: bold;
                    min-width: 40px;
                    }
                    .barre-musulman {
                    background-color: #e74c3c;
                    }
                    .barre-chretien {
                    background-color: #3498db;
                    }
                    .barre-juif {
                    background-color: #f39c12;
                    }
                    .barre-autre {
                    background-color: #9b59b6;
                    }
                    .barre-vide {
                    background-color: #ecf0f1;
                    color: #7f8c8d;
                    }
                    .barre-valeur {
                    margin-left: 10px;
                    font-size: 12px;
                    color: #2c3e50;
                    min-width: 80px;
                    }
                    .legende {
                    display: flex;
                    gap: 15px;
                    margin-top: 15px;
                    flex-wrap: wrap;
                    }
                    .legende-item {
                    display: flex;
                    align-items: center;
                    gap: 5px;
                    font-size: 12px;
                    }
                    .legende-couleur {
                    width: 15px;
                    height: 15px;
                    border-radius: 3px;
                    }
                    .total-religions {
                    margin-top: 10px;
                    font-size: 12px;
                    color: #7f8c8d;
                    text-align: right;
                    }
                </style>
            </head>
            <body>
                <h1>Pays triés par population - Répartition religieuse</h1>
                <div class="pays-container">
                    <!-- Tri des pays par population décroissante -->
                    <xsl:apply-templates select="monde/pays">
                        <xsl:sort select="population" data-type="number" order="descending"/>
                    </xsl:apply-templates>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="pays">
        <div class="pays-card">
            <div class="pays-header">
                <div>
                    <div class="pays-nom">
                        <xsl:value-of select="nom"/>
                    </div>
                    <div class="pays-info">
                        <span>Code: <xsl:value-of select="@code"/></span>
                        <span>Continent: <xsl:value-of select="@continent"/></span>
                    </div>
                </div>
                <div class="population">
                    <xsl:value-of select="format-number(population, '#,##0')"/>
                    <div style="font-size: 12px; color: #95a5a6;">
                        (année <xsl:value-of select="population/@annee"/>)
                    </div>
                </div>
            </div>
            
            <!-- Graphique des religions -->
            <div class="graphique-container">
                <div class="graphique-titre">Répartition religieuse :</div>
                
                <!-- Musulmans -->
                <div class="barre-container">
                    <div class="barre-label">Musulmans</div>
                    <xsl:variable name="widthMusulman" select="(religions/musulman div population) * 100"/>
                    <div class="barre barre-musulman" style="width: {$widthMusulman}%">
                        <xsl:if test="$widthMusulman >= 10">
                            <xsl:value-of select="format-number($widthMusulman, '#.##')"/>%
                        </xsl:if>
                    </div>
                    <div class="barre-valeur">
                        <xsl:value-of select="format-number(religions/musulman, '#,##0')"/>
                    </div>
                </div>
                
                <!-- Chrétiens -->
                <div class="barre-container">
                    <div class="barre-label">Chrétiens</div>
                    <xsl:variable name="widthChretien" select="(religions/chretien div population) * 100"/>
                    <div class="barre barre-chretien" style="width: {$widthChretien}%">
                        <xsl:if test="$widthChretien >= 10">
                            <xsl:value-of select="format-number($widthChretien, '#.##')"/>%
                        </xsl:if>
                    </div>
                    <div class="barre-valeur">
                        <xsl:value-of select="format-number(religions/chretien, '#,##0')"/>
                    </div>
                </div>
                
                <!-- Juifs -->
                <div class="barre-container">
                    <div class="barre-label">Juifs</div>
                    <xsl:variable name="widthJuif" select="(religions/juif div population) * 100"/>
                    <xsl:choose>
                        <xsl:when test="$widthJuif > 0">
                            <div class="barre barre-juif" style="width: {$widthJuif}%">
                                <xsl:if test="$widthJuif >= 10">
                                    <xsl:value-of select="format-number($widthJuif, '#.##')"/>%
                                </xsl:if>
                            </div>
                            <div class="barre-valeur">
                                <xsl:value-of select="format-number(religions/juif, '#,##0')"/>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="barre barre-vide" style="width: 100%">Aucune donnée</div>
                            <div class="barre-valeur">-</div>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                
                <!-- Autres -->
                <div class="barre-container">
                    <div class="barre-label">Autres</div>
                    <xsl:choose>
                        <xsl:when test="religions/autre != 'NaN' and religions/autre != '0'">
                            <div class="barre barre-autre" style="width: 100%">
                                <xsl:value-of select="religions/autre"/>
                            </div>
                            <div class="barre-valeur">
                                <xsl:value-of select="religions/autre"/>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="barre barre-vide" style="width: 100%">Aucune donnée</div>
                            <div class="barre-valeur">-</div>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                
                <div class="total-religions">
                    Total宗教信仰: 
                    <xsl:value-of select="format-number(religions/musulman + religions/chretien + religions/juif, '#,##0')"/>
                    habitants
                </div>
            </div>
            
            <!-- Légende -->
            <div class="legende">
                <div class="legende-item">
                    <div class="legende-couleur" style="background-color: #e74c3c;"></div>
                    <span>Musulmans</span>
                </div>
                <div class="legende-item">
                    <div class="legende-couleur" style="background-color: #3498db;"></div>
                    <span>Chrétiens</span>
                </div>
                <div class="legende-item">
                    <div class="legende-couleur" style="background-color: #f39c12;"></div>
                    <span>Juifs</span>
                </div>
                <div class="legende-item">
                    <div class="legende-couleur" style="background-color: #9b59b6;"></div>
                    <span>Autres</span>
                </div>
            </div>
        </div>
    </xsl:template>
    
</xsl:stylesheet>