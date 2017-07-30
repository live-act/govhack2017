# ---- Google API matching ----


latlon_point <- paste(public_toilet$LATITUDE,public_toilet$LONGITUDE,sep = ",")
num_row  = 5
test = list()

for(i in 1:10){
    test[i]= paste("https://maps.googleapis.com/maps/api/geocode/xml?",
                    "latlng=",latlon_point[i],"&key=AIzaSyCP5WzAmcVxaU_BzbkqURjkbVk0uThaMLw",sep="")
}
test

duh=list()
link=matrix(NA, nrow=num_row, ncol=1)
semi=list()
add1=matrix(NA, ncol=1, nrow=num_row)
add2=matrix(NA, ncol=1, nrow=num_row)
add3=matrix(NA, ncol=1, nrow=num_row)


for(i in 1:4){
    link[i,1]= paste("https://maps.googleapis.com/maps/api/geocode/xml?",
                     "latlng=",latlon_point[i],"&key=AIzaSyCP5WzAmcVxaU_BzbkqURjkbVk0uThaMLw",sep="")
    duh[i]=list(readLines(link[i,1]))
    duh[[i]] = xmlTreeParse(duh[[i]], useInternalNodes=TRUE)
    duh[[i]]=getNodeSet(duh[[i]], "//formatted_address")
    semi[[i]]= xmlToDataFrame(duh[[i]],stringsAsFactors=FALSE)
    add1[i] = semi[[i]][1,1]
    add2[i] = semi[[i]][2,1]
    add3[i]=semi[[i]][3,1]
    final = cbind(add1,add2,add3)
}


test=matrix(NA, nrow=2, ncol=1)
duh=list()
for(i in 1:2){
    test[i]= paste("https://maps.googleapis.com/maps/api/geocode/xml?", "latlng=",latlon_point[i],"&key=AIzaSyCP5WzAmcVxaU_BzbkqURjkbVk0uThaMLw",sep="")
    duh[i]=list(readLines(test[i,1]))
}



# calling API to match with the name of each suburb