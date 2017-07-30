# --- ACT data downloaded  <saved in the workspaces folder> ---- 

basketball_court <- read_csv(file.path(venv,"Basketball_Courts.csv"))
names(basketball_court) <- tolower(names(basketball_court))

cyclist_crash <- read_csv(file.path(venv,"Cyclist_Crashes.csv"))
names(cyclist_crash) <- tolower(names(cyclist_crash))

drinking_fountain <- read_csv(file.path(venv,"Drinking_Fountains.csv"))
drinking_fountain$DIVISION <- tolower(drinking_fountain$DIVISION)

fit_site <- read_csv(file.path(venv,"Fitness_Sites.csv"))
names(fit_site) <- tolower(names(fit_site))

public_toilet <- read_csv(file.path(venv,"Public_Toilets_in_the_ACT.csv"))
public_toilet$Location <- tolower(public_toilet$Location)


service_realible <- read_csv(file.path(venv,"Service_Reliability.csv"))
names(service_realible) <- tolower(names(service_realible))

sports_grounds <- read_csv(file.path(venv,"Sports_Grounds_In_The_ACT.csv"))
sports_grounds$ground_name <- tolower(sports_grounds$ground_name)

act_schools <- read_csv(file.path(venv,"ACT_School_Locations.csv"))
act_schools$Suburb <- tolower(act_schools$Suburb)

# regular expression
sports_grounds$ground_name <-str_replace_all(sports_grounds$ground_name,pattern = "[0-9]| ",replacement = '')


lat_lon <- read_csv((file.path(venv,"Australian_Post_Codes_Lat_Lon.csv")))


# Census 2016 income data
census_16_income_act <- read_csv(file.path(venv,"ABS 2016 census household income data Ch.csv"))
colnames(census_16_income_act)[4] <- 'income'
colnames(census_16_income_act)[3] <- 'households'


# ATO data
ato_df <- read_excel(file.path(venv,"atoabsgovhack2017.xlsx"),sheet = 2)

ato_names <- names(ato_df)
ato_names <- str_replace_all(ato_names, "\\s+", "_")

ato_ts <- ato_df %>% group_by(`Income year`)

names(ato_ts) <- ato_names
unique(ato_ts$`Income year`)


names(ato_df)

# NOTE: MANUAL CLEANING HAS BEEN PERFORMED BY THE TEAM MEMBERS

# ---- Clean up the variables ----
tmp_name <- str_replace_all(names(service_realible), pattern = " |%",replacement = "_")
names(service_realible) <- tmp_name

tmp_name <- str_replace_all(names(sports_grounds), pattern = " ",replacement = "_")
names(sports_grounds) <- tmp_name
sports_grounds$suburb <- tolower(sports_grounds$suburb)

service_realible$Date <- as.Date(service_realible$Date, format='%d/%m/%Y')

tmp_name <- str_replace_all(names(census_16_income_act), pattern = " ",replacement = "_")
names(census_16_income_act) <- tmp_name

# ---- Create a lookup map for ACT surburbs ----
lookup_map_tmp <- lat_lon %>% filter(state == "ACT")
    
lokup_map = lookup_map_tmp[!duplicated(lookup_map_tmp$postcode),]

lookup_map$suburb <- tolower(lookup_map$suburb)



# ---- suburb and postcode file for team to manually clean ----
write_csv(tmp,path = file.path(venv,"data/template_more_variables.csv"))

census_16_income_act$Region <- tolower(census_16_income_act$Region)


# ---- summarise statistics ----

drinking_fountain_sum <- drinking_fountain %>% 
    group_by(DIVISION) %>%
    summarise(num_drinking_fountain = n() )


yes_no_format <- function(x) if_else(x == "YES", 1, 0)

sports_grounds$toilets <-  yes_no_format(sports_grounds$toilets)

sports_grounds$training_lights <- yes_no_format(sports_grounds$training_lights)

sports_grounds$comp_lights <- yes_no_format(sports_grounds$comp_lights)

sports_grounds$canteen <- yes_no_format(sports_grounds$canteen)


sports_grounds_sum <- sports_grounds %>% 
    group_by(suburb) %>% 
    dplyr::summarise(num_toilets = sum(toilets),
                     num_toilet = sum(comp_lights),
                     num_canteen = sum(canteen)
    )
                     
                     
                     


