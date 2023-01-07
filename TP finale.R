# Ce projet a pour but de créer des fonctions visant à optimiser les indices boursiers de la bourse




# Voici tous les package necessaire pour que le projet puisse se Realiser. 
  install.packages("zoo")
library(zoo)
  
  install.packages("TTR")
library(TTR)
 
   install.packages("caTools")
library(caTools)
 
   install.packages("caret")
library(caret)
  
   install.packages("quantmod")
library(quantmod)  
#En premier lieux nous voulons extraire les donnees directment du site Yahoo Finance. C'est de la que vient l'option get symbol

dataFinaExtract <- function(date_debut, date_fin, NomIndice) {
  
  
  data = getSymbols(NomIndice, src = "yahoo", from = date_debut, to = date_fin, auto.assign = FALSE)
  
  colnames(data) = c("Open", "High", "Low", "Close","Volume","Adj Close")
  
  return(data)
}

#nous allos Prendre comme exemple l'option S&P 500 qui est sous le symbol ^GSPC pour les date que vous voyez en dessous. 
data <- dataFinaExtract("2020-01-01", "2022-01-31", "^GSPC")
View(data)



# Cette fontion a pour but de rajoute plusieur caracteristique que nous allons allons utiliser pour pouvoir faire notre analyste
feature_engin <- function(data) {

  #Ajout du prix d"ouverture de la journee meme 
  data$Open_today <- data$Open
  
  #Ajout du prix d'ouverture de la veille   
  data$Open_yesterday <- c(NA, data$Open[-length(data$Open)])
  
  #Ajout du prix de fermeture de la veille 
  data$Close_yesterday <- c(NA, data$Close[-length(data$Close)])
 
   #Ajout du prix du high de la veille 
  data$High_yesterday <- c(NA, data$High[-length(data$High)])
  
  #Ajout du prix de Low de la veille 
  data$Low_yesterday <- c(NA, data$Low[-length(data$Low)])
  
  #Ajout du pric de volume de la veille 
  data$Volume_yesterday <- c(NA, data$Volume[-length(data$Volume)])
  
  #Ajout du prix de fermeture moyen pour le 5,30, 365 derniers jours 
  data$Close_average_5 <- SMA(data$Close, n = 5)
  data$Close_average_30 <- SMA(data$Close, n = 30)
  data$Close_average_365 <- SMA(data$Close, n = 365)
 
   #Ajout du prix de volume moyen pour les 5,30,365 dernier jours 
  data$volume_average_5 <- SMA(data$Volume, n = 5)
  data$volume_average_30 <- SMA(data$Volume, n = 30)
  data$volume_average_365 <- SMA(data$Volume, n = 365)
  
  #Ajout du rendement quotidien par rapport a la veille 
  data$Quotidien <- (data$Close - data$Close_yesterday) / data$Close_yesterday 
  data$Quotidien<- data$Quotidien*100
  
  #Ajout des ratios des moyennes de fermeture 
  data$Ratio_jou5_sur_30 <- data$Close_average_5 /  data$Close_average_30
  data$Ratio_jou5_sur_365 <-  data$Close_average_5 / data$Close_average_365
  data$Ratio_jou30_sur_365 <- data$Close_average_30 / data$Close_average_365
  
  #Ajout des ecart-type pour les prix de fermeture 
  data$Close_sd_5 <- rollapply(data$Close, width = 5, sd, align = "right")
  data$Close_sd_30 <- rollapply(data$Close, width = 30, sd, align = "right")
  data$Close_sd_365 <- rollapply(data$Close, width = 365, sd, align = "right")

  #Ajout des ecart-types pour le volume 
  data$Volume_sd_5 <- rollapply(data$Volume, width = 5, sd, align = "right")
  data$Volume_sd_30 <- rollapply(data$Volume, width = 30, sd, align = "right")
  data$Volume_sd_365 <- rollapply(data$Volume, width = 365, sd, align = "right")
  
  #Ajout des rendements moyens par semaine, par moi et par annee 
  data$Moyenne_Rendement_semaine <- SMA(data$Quotidien, n = 5)
  data$Moyenne_Rendement_Mensuelle<- SMA(data$Quotidien,n=30)
  data$Moyenne_Rendement_Annuelle<-SMA(data$Quotidien,n=365)
  
      return(data)
}

data <- feature_engin(data)
View(data)

# Set seed for reproducibility
set.seed(3035)

# Select 70% of the data as the sample
sample_size <- floor(0.7 * nrow(data))
sample_indices <- sample(1:nrow(data), size = sample_size)
sample_data <- data[sample_indices, ]

# Fit linear regression model
model_linear <- lm(Close ~ ., data = sample_data)

# View model summary
summary(model_linear)
predictions_model_lin<- predict(model_linear,data=sample_data)

summary(predictions_model_lin)
View(predictions_model_lin)
# Set seed for reproducibility
set.seed(3035)

# Select 70% of the data as the sample
sample_size <- floor(0.7 * nrow(data))
sample_indices <- sample(1:nrow(data), size = sample_size)
sample_data <- data[sample_indices, ]
sample_data<-na.omit(sample_data)
# Create a binary variable indicating whether the price went up (1) or down (0) compared to the open
sample_data$price_direction <- ifelse(sample_data$Close > sample_data$Open, 1, 0)

# Fit logistic regression model
model_logistic <- glm(price_direction ~ ., data = sample_data, family = "binomial", control = list(maxit = 50))
# View model summary
summary(model_logistic)
predictions_model_log <- predict(model_logistic, data=sample_data, type = "response")
View(predictions_model_log)

summary(model_linear)$r.squared

predictions_model_log <- as.factor(predictions_model_log)
sample_data$price_direction <- as.factor(sample_data$price_direction)

# Set the levels of both variables to be the same
predictions_model_log <- factor(predictions_model_log, levels = levels(sample_data$price_direction))
sample_data$price_direction <- factor(sample_data$price_direction, levels = levels(predictions_model_log))

# Now you should be able to use the confusionMatrix function
confusionMatrix(predictions_model_log, sample_data$price_direction)$specificity

