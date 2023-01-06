# TP-finale

Le but de ce travail final est de démontrer comment les modèles de régression linéaire et logistique peuvent être utilisés pour prédire l'évolution des actions cotées en bourse

### Les Actions 

Les actions cotées en bourse sont des titres financiers qui représentent des parts de propriété dans une entreprise. Elles sont emise par les entreprise et sont proposees a la vente sur le marche boursier.  Ils sont cotees en bourse et elle permettent aux investisseurs de devenir des actionnaires de l'entreprise et de participer au benefices realises par celle-ci.Les actions sont considerees comme une forme d'investissement a haut risque. Donc ce projet a pour but de limite le risque d'investissment. 


## Premiere Etape 
 
 
 Il faut creer un fonction qui nous permet d'extraire les donnees du site Yahoo Finance a l'aide de la fonction 'getSybmbols()' de la librairie 'quantmod' 
  cette fontion doit prendre une date de debut et une date de fin et le symbol de l'action voulu 
 
 Voici le code que vous pouvez copier coller: 
 
install.packages("quantmod")
library(quantmod) 


dataFinaExtract <- function(date_debut, date_fin, NomIndice) {
  
  
  data = getSymbols(NomIndice, src = "yahoo", from = date_debut, to = date_fin, auto.assign = FALSE)
  
  colnames(data) = c("Open", "High", "Low", "Close","Volume","Adj Close")
  
  return(data)
}
