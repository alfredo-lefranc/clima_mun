# EDA de datos del Clima

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

# Cargo la lista de estaciones usadas
estaciones <- read_csv("estaciones_final.csv", col_names = TRUE) %>% unlist()

# Para crear el mapa

# creo una base con las estaciones y sus coordenadas
setwd("C:/Users/fredy/Documents/itam/Investigacion2/proyecto2/tmp_gz")

# funcion que extrae info de los csvs
leercsv <- function(file){
  p <- read_csv(file, n_max = 1,
                col_names = TRUE,
                col_types = cols_only(
                  STATION = col_character(),
                  LATITUDE = col_double(),
                  LONGITUDE = col_double(),
                  NAME = col_character()
                ))
}

stations <- estaciones %>% lapply(leercsv) %>% do.call(rbind,.) %>%
  as.data.frame()



# cargo la base
data <- read_csv("temp_data.csv", col_names = TRUE)

# promedio temperaturas para todo el país, por día

medias <- NULL
for(col in seq(2:366)){
  a <- col-1
  medias[a] <- mean(unlist(data[,col]))
}
medias[365] <- NA

temp <- pivot_longer(data, -InputID, names_to = "date") %>%
  select(date) %>%
  unique() %>%
  cbind(medias)


ggplot(temp, aes(y=medias, x=date))+
  geom_point()+
  labs(x="Day", y="Mean Temperature (F)",
       title = "Daily Mean Temperatures in Mexico, 2018")+
  theme_minimal()+
  theme(axis.text.x = element_blank())

