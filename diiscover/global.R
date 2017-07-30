library(dplyr)

allzips <- read.csv(file.path(venv,"data/liveability_final.csv"))


allzips$latitude <- jitter(allzips$latitude, amount = 0) 
allzips$longitude <- jitter(allzips$longitude , amount = 0)
allzips$school <- allzips$school * 100
allzips$postcode <- formatC(allzips$postcode, width = 5, format="d", flag="0")
row.names(allzips) <- allzips$postcode

cleantable <- allzips %>%
    select(
        suburb = suburb.x,
        State = state.x,
        postcode = postcode,
        Rank = rank,
        Score = centile,
        Liveabililty = liveable_h,
        Population = adultpop,
        school = school,
        Income = income,
        Lat = latitude,
        Long = longitude
    )
