# clima_mun
Imputación de temperatura diaria promedio por municipio en México

Objetivo:
Asignar una temperatura promedio diaria a cada municipio en México de acuerdo a la metodología de Davis & Gertler (2015).

Datos:
Para este ejercicio se usa el Global Summary of the Day, del US National Climatic Data Center https://www.ncei.noaa.gov/access/metadata/landing-page/bin/iso?id=gov.noaa.ncdc:C00516

Procedimiento:
01_clima_prepare <- Descarga, limpieza inicial y filtrado de los datos.
02_QGIS (no reproducible) <- Asignar distancias entre municipios y las estaciones climáticas
03_ipw <- Imputar temperatura media diaria a cada municipio mediante ponderadores de distancia inversos (Inverse Distance Weights).
04_eda <- Visualización de los datos (una parte también fue hecha en QGIS)

Visualización:

![Estaciones](https://github.com/alfredo-lefranc/clima_mun/main/img/climate_stations.png?raw=false)
![Temperaturas Nacionales Promedio](https://github.com/alfredo-lefranc/clima_mun/tree/main/img/mean_temp.png)

Referencias
Davis, L. W., & Gertler, P. J. (2015). Contribution of air conditioning adoption to future energy use under global warming. Proceedings of the National Academy of Sciences, 112(19), 5962-5967.
