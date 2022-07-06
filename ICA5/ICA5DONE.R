mt <- mtcars

colnames(mt) # 1
rownames(mt)

mean(mt[,"mpg"]) # 2
sd(mt[,"mpg"])

mean(mt[,"cyl"])
sd(mt[,"cyl"])

colMeans(mt) # 3

mt["Mazda RX4", "cyl"] # 4
