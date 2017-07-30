


# ---- Merge data from various data sources ----


final_out_tmp1 <- left_join(lookup_map,census_16_income_act,
          by = c("suburb" = "Region"))


final_out_tmp2 <- left_join(final_out_tmp1,drinking_fountain_sum,
                            by = c("suburb" = "DIVISION"))


final_out_tmp3 <- left_join(final_out_tmp2,sports_grounds_sum,
                            by = c("suburb" = "suburb"))

tmp <- rep("ACT",nrow(final_out_tmp3))


# format the data in an usable structure
final_out_tmp3$suburb.y <-final_out_tmp3$suburb 
final_out_tmp3$suburb.x <- final_out_tmp3$suburb
final_out_tmp4 <- bind_cols(final_out_tmp3,State.x = tmp, State.y = tmp)

# apply statistics TODO: more sophisticated method required 
final_out_tmp4$adultpop <- final_out_tmp4$households * rnorm(1,2.5,1)




write_csv(final_out_tmp4,path = file.path(venv,"test01_impute.csv"))
# TODO: sophisticated methods k


