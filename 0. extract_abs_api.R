# ---- Access ABS ----

# ---- Connect to ABS Census and table dynamically 
getProviders()
abs_flows_all <- getFlows("ABS")

abs_flow <- getFlows("ABS", '*Census*')

flow_names <- names(abs_flow)

map(flow_names,getTimeSeries,"ABS")

# Census 2016, Total Personal Income (weekly) by Age by Sex (LGA)
tsList = getTimeSeries('ABS', "ABS_C16_T13_LGA/TOT+01+02+03+04+05+06+07+08+09+10+11+12+13+14+15+Z.TT+A15+A20+A25+A30+A35+A40+A45+A50+A55+A60+A65+A70+A75+A80+A85+A90+A95+A99.3+1+2.1+2+3+4+5+6+7+8+9.LGA2016.10050/")


tt_pop_inc_age_sex = ddf = sdmxdf(tsList, meta=T)
tt_pop_inc_age_sex %>% head

# Get dimension
dims <- getDimensions('ABS','ABS_C16_T13_LGA')

# variable format
lookup <- getCodes('ABS','ABS_C16_T13_LGA','SEX_ABS')
tmp <- tbl_df(unlist((lookup[tt_pop_inc_age_sex$SEX_ABS])))
