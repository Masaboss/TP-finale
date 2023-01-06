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

