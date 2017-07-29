

ato_df <- read_excel(file.path(venv,"atoabsgovhack2017.xlsx"),sheet = 2)

ato_names <- names(ato_df)
ato_names <- str_replace_all(ato_names, "\\s+", "_")

ato_ts <- ato_df %>% group_by(`Income year`)

names(ato_ts) <- ato_names

unique(ato_ts$`Income year`)


names(ato_df)
