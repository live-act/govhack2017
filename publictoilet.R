urls  = "https://www.data.act.gov.au/resource/s5ui-t9rd.json"

raw_result <- GET(url = urls)
names(raw_result)


raw_result$status_code

head(raw_result$content)

this.raw.content <- rawToChar(raw_result$content)
nchar(this.raw.content)
substr(this.raw.content, 1, 100)

this.content <- fromJSON(this.raw.content)
head(this.content)
typeof(this.content)

class(this.content) #it's a list
length(this.content) #it's a large list

this.content[1,] #the first element

act_pub_toilet <- do.call(what = "cbind",
                           args = lapply(this.content, as.data.frame))

head(act_pub_toilet)
names(act_pub_toilet)

act_pub_toilet %>% group_by(location.type) %>% summarise(n = n())
View(act_pub_toilet)

names(df)
