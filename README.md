# BERTHRAND MASABO MASB14079806


# TP-finale

Le but de ce travail final est de démontrer comment les modèles de régression linéaire et logistique peuvent être utilisés pour prédire l'évolution des actions cotées en bourse

## Les Actions 

Les actions cotées en bourse sont des titres financiers qui représentent des parts de propriété dans une entreprise. Elles sont emise par les entreprise et sont proposees a la vente sur le marche boursier.  Ils sont cotees en bourse et elle permettent aux investisseurs de devenir des actionnaires de l'entreprise et de participer au benefices realises par celle-ci.Les actions sont considerees comme une forme d'investissement a haut risque. Donc ce projet a pour but de limite le risque d'investissment. 


### Extraction des donnes 
 
 
Il faut creer un fonction qui nous permet d'extraire les donnees du site Yahoo Finance a l'aide de la fonction `getSybmbols()` de la librairie `quantmod` 
Cette fontion doit prendre une date de debut et une date de fin et le symbol de l'action voulu 
 
Nous allons donner a notre fonction le nom `dataFinaExtract()`, cette fonction prendra les dates de debut et de fin de l'intervalle de temps voulu ainsi que le nom de l'indiche (dans notre cas nous allons prendre comme exemple "^GSPC" qui est l'indice de S&P 500)

Voici le code complet:
  
`install.packages("quantmod)`

`library(quantmod)`  
Code          | Description 
------------- | -------------
dataFinaExtract <- function(date_debut, date_fin, NomIndice)  | Creation de la fonction dataFinaExtract
{data = getSymbols(NomIndice, src = "yahoo", from = date_debut, to = date_fin, auto.assign = FALSE)colnames(data) = c("Open", "High", "Low", "Close","Volume","Adj Close")| Cette parti du code a comme but de prendre d'extraire directemnt l'action de Yahoo fincae et d'attribuer des tritres au collones 

Voici le code complet:

dataFinaExtract <- function(date_debut, date_fin, NomIndice) {

  data = getSymbols(NomIndice, src = "yahoo", from = date_debut, to = date_fin, auto.assign = FALSE)
  
  colnames(data) = c("Open", "High", "Low", "Close","Volume","Adj Close")
  
  return(data)
}

Voici les options disponibles pour la fonction `dataFinaExtract()`:

- `date_debut`: Date de début de la période d'extraction des données, au format "YYYY-MM-DD".
- `date_fin`: Date de fin de la période d'extraction des données, au format "YYYY-MM-DD".
- `NomIndice`: Nom de l'indice à extraire, sous la forme d'un symbole de bourse (par exemple, "^GSPC" pour l'indice S&P 500).
Vous pouvez vous referez a ce lien  pour meiux comprendre le package quantmod https://www.youtube.com/watch?v=bDXeRofJFTE

data <- dataFinaExtract("2020-01-01", "2022-01-31", "^GSPC")
View(data)

Nous allons travaillez tout au long de ce projet avec l'action S&P 500 qui debute le 2020-01-01 et qui se termine le 2022-01-31

### Optimisation de la prevision des actions en integrant des nouvelles caracteristiques 

Suite à l'extraction des données, nous avons constaté que nous disposons de peu de variables pour effectuer des prévisions. Pour remédier à cela, nous allons utiliser la technique de feature engineering afin de créer de nouvelles caractéristiques qui nous permettront d'améliorer la qualité de nos prévisions.

`feature engeneering`
L'objectif du feature engineering est de sélectionner les caractéristiques qui sont les plus pertinentes pour prédire la variable cible, tout en évitant de sélectionner des caractéristiques qui sont redondantes ou qui ne sont pas corrélées à la variable cible. Le feature engineering peut également inclure la création de nouvelles caractéristiques à partir de celles qui existent déjà, par exemple en effectuant des opérations mathématiques ou en utilisant des techniques de transformation de données.Un feature engineering réussi peut entraîner une augmentation significative de la précision des modèles, tandis qu'un feature engineering inadéquat peut entraîner une baisse de la qualité des modèles Voila donc l'importace critique de cette etape. 

Voici la liste des caractéristiques que nous allons ajouter:
 
 
 * listes
     * prix d'ouverture de la journee presente 
     * prix d'ouverture de la journee precedente
     * prix de fermeture de la journee precedente 
     * prix du high de la journee precedente 
     * prix du low de la journee precedente 
     * prix du volume de la journee precedente 
     * prix de fermeture moyen pour (5,30,365 dernier jour) retourne 3 nouvelles caracteristiques
     * prix de volume moyen pour (5,30,365 dernier jour )  retourne 3 nouvelles caracteristiques
     * Rendement quotidien
     * Les Ratios de fermeture moyen *detaillez pus bas*   retourne 3 nouvelles caracteristiques
     * Les ecart-types pour les prix de fermeture (5,30,365 dernier jour )  retourne 3 nouvelles caracteristiques
     * Les ecart-types pour les volume (5,30,365 dernier jour )  retourne 3 nouvelles caracteristiques
     * Les rendment moyen par semaine, par mois et par annee   retourne 3 nouvelles caracteristiques

Nous avons 25 nouvelles caracteristiques!


Code  | Description
------------- | -------------
feature_engin <- function(data)| Debut de la fonction (nom de la focntion et doit retourne data puisque cest data qu'on utilise comme reference 
data$Open_today <- data$Open  |  prix d'ouverture de la journee presente 
data$Open_yesterday <- c(NA, data$Open[-length(data$Open)])| prix d'ouverture de la journee precedente
data$Close_yesterday <- c(NA, data$Close[-length(data$Close)])  | prix de fermeture de la journee precedente
data$High_yesterday <- c(NA, data$High[-length(data$High)]) | prix du High de la journee precedente 
data$Low_yesterday <- c(NA, data$Low[-length(data$Low)]) | prix du Low de la journee precedente 
data$Volume_yesterday <- c(NA, data$Volume[-length(data$Volume)]) | prix du volume de la journee precedente 
data$Close_average_5 <- SMA(data$Close, n = 5)
data$Close_average_30 <- SMA(data$Close, n = 30)
data$Close_average_365 <- SMA(data$Close, n = 365)  | prix de fermeture moyen pour (5,30,365 dernier jour) retourne 3 nouvelles caracteristique
data$volume_average_5 <- SMA(data$Volume, n = 5)
data$volume_average_30 <- SMA(data$Volume, n = 30)
data$volume_average_365 <- SMA(data$Volume, n = 365)  | prix de volume moyen pour (5,30,365 dernier jour )  retourne 3 nouvelles caracteristiques
data$Quotidien <- (data$Close - data$Close_yesterday) / data$Close_yesterday 
data$Quotidien<- data$Quotidien(100)|Rendement quotidien
data$Ratio_jou5_sur_30 <- data$Close_average_5 /  data$Close_average_30
data$Ratio_jou5_sur_365 <-  data$Close_average_5 / data$Close_average_365
data$Ratio_jou30_sur_365 <- data$Close_average_30 / data$Close_average_365 |Les Ratios de fermeture moyen *detaillez pus bas*   retourne 3 nouvelles caracteristiques
data$Close_sd_5 <- rollapply(data$Close, width = 5, sd, align = "right")
data$Close_sd_30 <- rollapply(data$Close, width = 30, sd, align = "right")
data$Close_sd_365 <- rollapply(data$Close, width = 365, sd, align = "right")| Les ecart-types pour les prix de fermeture (5,30,365 dernier jour )  retourne 3 nouvelles caracteristiques
data$Volume_sd_5 <- rollapply(data$Volume, width = 5, sd, align = "right")
data$Volume_sd_30 <- rollapply(data$Volume, width = 30, sd, align = "right")
data$Volume_sd_365 <- rollapply(data$Volume, width = 365, sd, align = "right") | Les ecart-types pour les volume (5,30,365 dernier jour )  retourne 3 nouvelles caracteristiques
data$Moyenne_Rendement_semaine <- SMA(data$Quotidien, n = 5)
data$Moyenne_Rendement_Mensuelle<- SMA(data$Quotidien,n=30)
data$Moyenne_Rendement_Annuelle<-SMA(data$Quotidien,n=365)  | Les rendment moyen par semaine, par mois et par annee   retourne 3 nouvelles caracteristiques

return(data)}| fin de la fonction (nous retourne les valeurs voulu)


#### Voici le code complet:
feature_engin <- function(data) {

  data$Open_today <- data$Open
  
  
  data$Open_yesterday <- c(NA, data$Open[-length(data$Open)])
  
 
  data$Close_yesterday <- c(NA, data$Close[-length(data$Close)])
 
  
  data$High_yesterday <- c(NA, data$High[-length(data$High)])
  
 
  data$Low_yesterday <- c(NA, data$Low[-length(data$Low)])
  
 
  data$Volume_yesterday <- c(NA, data$Volume[-length(data$Volume)])
  
  
  data$Close_average_5 <- SMA(data$Close, n = 5)
  data$Close_average_30 <- SMA(data$Close, n = 30)
  data$Close_average_365 <- SMA(data$Close, n = 365)
  
  data$volume_average_5 <- SMA(data$Volume, n = 5)
  data$volume_average_30 <- SMA(data$Volume, n = 30)
  data$volume_average_365 <- SMA(data$Volume, n = 365)
  
  
  data$Quotidien <- (data$Close - data$Close_yesterday) / data$Close_yesterday 
  data$Quotidien<- data$Quotidien*100
  
 
  data$Ratio_jou5_sur_30 <- data$Close_average_5 /  data$Close_average_30
  data$Ratio_jou5_sur_365 <-  data$Close_average_5 / data$Close_average_365
  data$Ratio_jou30_sur_365 <- data$Close_average_30 / data$Close_average_365
  
 
  data$Close_sd_5 <- rollapply(data$Close, width = 5, sd, align = "right")
  data$Close_sd_30 <- rollapply(data$Close, width = 30, sd, align = "right")
  data$Close_sd_365 <- rollapply(data$Close, width = 365, sd, align = "right")

 
  data$Volume_sd_5 <- rollapply(data$Volume, width = 5, sd, align = "right")
  data$Volume_sd_30 <- rollapply(data$Volume, width = 30, sd, align = "right")
  data$Volume_sd_365 <- rollapply(data$Volume, width = 365, sd, align = "right")
  

  data$Moyenne_Rendement_semaine <- SMA(data$Quotidien, n = 5)
  data$Moyenne_Rendement_Mensuelle<- SMA(data$Quotidien,n=30)
  data$Moyenne_Rendement_Annuelle<-SMA(data$Quotidien,n=365)
  
      return(data)
}
