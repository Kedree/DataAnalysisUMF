getwd()
setwd('C:/Users/Kedree Proffitt/Downloads/Rscripts')
df = read.delim('titanic.csv', sep = ',', header = TRUE)
head(df)
summary(df)
# Survived gives an average of how many people survived
# Age gives good information
# Fare provides a fun to look at statistic, summary gives good info
# All others are not usefull in the summary method
colnames(df)
rownames(df)

df2 = df[is.na(df['Age'])==F, ]

head(df2)

younger = df[df['Age'] < 30 & df['Survived']==TRUE, ]

older = df[df['Age'] >= 30 & df['Survived']==TRUE, ]

survived <- nrow(younger) + nrow(older)
survived # 394
