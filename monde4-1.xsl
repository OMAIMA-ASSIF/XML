<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!-- Tri des pays par population décroissante -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Pays triés par population - Religions</title>
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
                    table {
                    width: 100%;
                    border-collapse: collapse;
                    background-color: white;
                    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                    }
                    th {
                    background-color: #34495e;
                    color: white;
                    padding: 12px;
                    text-align: left;
                    font-weight: bold;
                    }
                    td {
                    padding: 10px;
                    border-bottom: 1px solid #ecf0f1;
                    }
                    tr:hover {
                    background-color: #f8f9fa;
                    }
                    .pays-nom {
                    font-weight: bold;
                    color: #2c3e50;
                    }
                    .pays-code {
                    color: #7f8c8d;
                    font-size: 0.9em;
                    }
                    .population {
                    text-align: right;
                    font-weight: bold;
                    color: #27ae60;
                    }
                    .religion-chiffre {
                    text-align: right;
                    color: #2980b9;
                    }
                    .religion-label {
                    font-size: 0.9em;
                    color: #7f8c8d;
                    }
                    .continent {
                    text-align: center;
                    font-style: italic;
                    color: #e67e22;
                    }
                    .annee {
                    font-size: 0.8em;
                    color: #95a5a6;
                    }
                </style>
            </head>
            <body>
                <h1>Pays triés par population - Répartition religieuse</h1>
                <table>
                    <thead>
                        <tr>
                            <th>Pays</th>
                            <th>Continent</th>
                            <th>Population</th>
                            <th>Musulmans</th>
                            <th>Chrétiens</th>
                            <th>Juifs</th>
                            <th>Autres</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Application du tri par population décroissante -->
                        <xsl:apply-templates select="monde/pays">
                            <xsl:sort select="population" data-type="number" order="descending"/>
                        </xsl:apply-templates>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="pays">
        <tr>
            <!-- Colonne Pays -->
            <td>
                <div class="pays-nom">
                    <xsl:value-of select="nom"/>
                </div>
                <div class="pays-code">
                    <xsl:value-of select="@code"/>
                </div>
            </td>
            
            <!-- Colonne Continent -->
            <td class="continent">
                <xsl:value-of select="@continent"/>
            </td>
            
            <!-- Colonne Population -->
            <td class="population">
                <xsl:value-of select="format-number(population, '#,##0')"/>
                <div class="annee">
                    (année <xsl:value-of select="population/@annee"/>)
                </div>
            </td>
            
            <!-- Colonne Musulmans -->
            <td class="religion-chiffre">
                <xsl:choose>
                    <xsl:when test="religions/musulman > 0">
                        <xsl:value-of select="format-number(religions/musulman, '#,##0')"/>
                        <div class="religion-label">
                            (<xsl:value-of select="format-number(religions/musulman div population * 100, '#.##')"/>%)
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <span style="color: #bdc3c7;">-</span>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            
            <!-- Colonne Chrétiens -->
            <td class="religion-chiffre">
                <xsl:choose>
                    <xsl:when test="religions/chretien > 0">
                        <xsl:value-of select="format-number(religions/chretien, '#,##0')"/>
                        <div class="religion-label">
                            (<xsl:value-of select="format-number(religions/chretien div population * 100, '#.##')"/>%)
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <span style="color: #bdc3c7;">-</span>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            
            <!-- Colonne Juifs -->
            <td class="religion-chiffre">
                <xsl:choose>
                    <xsl:when test="religions/juif > 0">
                        <xsl:value-of select="format-number(religions/juif, '#,##0')"/>
                        <div class="religion-label">
                            (<xsl:value-of select="format-number(religions/juif div population * 100, '#.##')"/>%)
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <span style="color: #bdc3c7;">-</span>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            
            <!-- Colonne Autres -->
            <td class="religion-chiffre">
                <xsl:choose>
                    <xsl:when test="religions/autre != 'NaN' and religions/autre != '0'">
                        <xsl:value-of select="religions/autre"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <span style="color: #bdc3c7;">-</span>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    
</xsl:stylesheet>