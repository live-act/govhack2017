# Access ACT data API

# actual link https://www.data.act.gov.au/Infrastructure-and-Utilities/Public-Toilets-in-the-ACT/3tyf-txjn

urls  = "https://www.data.act.gov.au/resource/s5ui-t9rd.json"

raw_result <- GET(url = urls)
names(raw_result)

# Check the query status
raw_result$status_code

this.raw.content <- rawToChar(raw_result$content)
nchar(this.raw.content)
substr(this.raw.content, 1, 100)

this.content <- fromJSON(this.raw.content)
head(this.content)

class(this.content) #it's a list
length(this.content) #it's a large list

this.content[,1] #the first element

formatted_content <- str_replace_all()

act_pub_toilet <- do.call(what = "cbind",
                          args = lapply(this.content, as.data.frame))

names(act_pub_toilet) <- names(this.content)

tmp1 <- head(act_pub_toilet,1)
tmp2 <- head(this.content,1)
match(tmp1,tmp2)


act_pub_toilet %>% group_by(location.type) %>% summarise(n = n())

