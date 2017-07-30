
#' Author: Andy Cao
#' 


# ---- Install packages if there is no package---- 


if (!require(devtools))
    install.packages("devtools")
devtools::install_github("rstudio/leaflet")

if (!require(tidyverse))
    install.packages("tidyverse")


if (!require(readxl))
    install.packages("readxl")


if (!require(dplyr))
    install.packages("dplyr")


if (!require(prophet))
    install.packages("prophet")


if (!require(httr))
    install.packages("httr")

if (!require(jsonlite))
    install.packages("jsonlite")

if (!require(lubridate))
    install.packages("lubridate")

if (!require(purrr))
    install.packages("purrr")

if (!require(stringr))
    install.packages("stringr")


if (!require(rsdmx))
    install.packages("rsdmx")


if (!require(RJSDMX))
    install.packages("RJSDMX")


if (!require(zoo))
    install.packages("zoo")


if (!require(RCurl))
    install.packages("RCurl")

if (!require(RJSONIO))
    install.packages("RJSONIO")

if (!require(plyr))
    install.packages("plyr")


# ---- Load packages ---- 

library(tidyverse)
library(readxl)
library(dplyr)
library(prophet)
library(httr)
library(jsonlite)
library(lubridate)
library(purrr)
library(stringr)
library(rsdmx)
library(RJSDMX)
library(XML)
script_list <- list.files(modules,
                          pattern="*.r$|*.R$",
                          full.name = TRUE,
                          recursive = TRUE,ignore.case = TRUE,include.dirs = TRUE)

script_list
map(script_list,source)


csv_list <- list.files(venv,
                       pattern = "*.csv$",
                       full.names = TRUE,
                       recursive = TRUE,
                       ignore.case = TRUE,
                       )




