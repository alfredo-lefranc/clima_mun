# Descarga y filtrado de datos de temperatura

# sitio web: https://www.ncei.noaa.gov/access/metadata/landing-page/bin/iso?id=gov.noaa.ncdc:C00516


file_name <- "DIRECTORIO/2018.tar.gz"

untar(file_name, exdir = "DIRECTORIO/tmp_gz")

# hacer una lista de latitud, longitud y numero y nombre de cada estacion
library(readr)
library(magrittr)
library(dplyr)

# fijar el directorio en la carpeta descomprimida
setwd("DIRECTORIO/tmp_gz")

files <- list.files()

files[1]

stations <- read_csv("01001099999.csv", n_max = 1,
                                   col_names = TRUE,
                                   col_types = cols_only(
                                     STATION = col_character(),
                                     LATITUDE = col_double(),
                                     LONGITUDE = col_double(),
                                     NAME = col_character(),
                                     MAX = col_double(),
                                     MIN = col_double()
                                   ))


leercsv <- function(file){
  p <- read_csv(file, n_max = 1,
           col_names = TRUE,
           col_types = cols_only(
             STATION = col_character(),
             LATITUDE = col_double(),
             LONGITUDE = col_double(),
             NAME = col_character(),
             MAX = col_double(),
             MIN = col_double()
           ))
}

stations <- files[-1] %>% lapply(leercsv) %>% do.call(rbind,.) %>%
  as.data.frame()

# filtrar estaciones que estén cerca de México con latitud y longitud
# extremo Tijuana: -122.0W y 36N
# extremo sureste: -82.0W y 12N


summary(stations)
# los NAs deben estar computados como 9999.9
stations$MAX[stations$MAX>500] <- NA
stations$MIN[stations$MIN>500] <- NA

stations2 <- stations %>% filter(LATITUDE>12 & LATITUDE<36 & 
                                  LONGITUDE>(-122) & LONGITUDE<(-82))


stations2 <- stations2 %>% mutate(mean = (MAX+MIN)/2)

# check que no se hayan calculado promedios con NAs en una de las dos
stations2[is.na(stations2$MAX) | is.na(stations2$MIN),]

# tiro NAs
stations2 <- stations2 %>% filter(!is.na(mean))

summary(stations2$mean)

write_csv(stations2,"stations.csv",col_names = TRUE)


