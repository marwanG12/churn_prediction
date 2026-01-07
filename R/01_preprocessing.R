# ==============================================================================
# SCRIPT 1 : PRÉTRAITEMENT ET ANALYSE EXPLORATOIRE DES DONNÉES
# Projet : Prédiction du Churn - Fournisseur d'Accès Internet
# ==============================================================================

# Chargement des bibliothèques nécessaires
library(tidyverse)
library(caret)
library(corrplot)

# ------------------------------------------------------------------------------
# 1. CHARGEMENT DES DONNÉES
# ------------------------------------------------------------------------------

# Charger les données corrigées
data <- read.csv("data/churn_corrected.csv", stringsAsFactors = FALSE)

# Aperçu des données
cat("Dimensions du dataset:", dim(data), "\n")
cat("Premières lignes:\n")
print(head(data))

# Structure des données
str(data)

# Résumé statistique
summary(data)

# ------------------------------------------------------------------------------
# 2. NETTOYAGE DES DONNÉES
# ------------------------------------------------------------------------------

# Vérifier les valeurs manquantes
cat("\nValeurs manquantes par colonne:\n")
print(colSums(is.na(data)))

# Nettoyer les noms de colonnes
names(data) <- make.names(names(data))

# Les valeurs numériques sont déjà en format correct (point décimal)
# Convertir les variables catégorielles en facteurs
categorical_vars <- c("Genre", "Senior", "Enfants", "Multi_lignes", 
                      "Service_Internet", "Autres_Services", "Partenaire", 
                      "Contrat", "Facturation_electronique", "Mode_de_paiement", 
                      "target")

data[categorical_vars] <- lapply(data[categorical_vars], as.factor)

# Convertir Anciennete en numérique
data$Anciennete <- as.numeric(data$Anciennete)

# Vérifier les résultats
cat("\nStructure après nettoyage:\n")
str(data)

# ------------------------------------------------------------------------------
# 3. STATISTIQUES DESCRIPTIVES
# ------------------------------------------------------------------------------

# Distribution de la variable cible
cat("\nDistribution du Churn:\n")
print(table(data$target))
print(prop.table(table(data$target)))

# Statistiques par groupe
cat("\nTaux de churn par type de contrat:\n")
print(prop.table(table(data$Contrat, data$target), 1))

cat("\nTaux de churn par type de service internet:\n")
print(prop.table(table(data$Service_Internet, data$target), 1))

# ------------------------------------------------------------------------------
# 4. VISUALISATIONS
# ------------------------------------------------------------------------------

# Créer un dossier pour les graphiques
if (!dir.exists("outputs")) {
  dir.create("outputs")
}

# Distribution de la cible
png("outputs/01_distribution_target.png", width = 800, height = 600)
barplot(table(data$target), 
        main = "Distribution du Churn", 
        xlab = "Churn", 
        ylab = "Fréquence",
        col = c("steelblue", "coral"))
dev.off()

# Charges mensuelles vs Churn
png("outputs/02_charges_vs_churn.png", width = 800, height = 600)
boxplot(charges_mensuelles ~ target, data = data,
        main = "Charges Mensuelles vs Churn",
        xlab = "Churn",
        ylab = "Charges Mensuelles",
        col = c("steelblue", "coral"))
dev.off()

# Ancienneté vs Churn
png("outputs/03_anciennete_vs_churn.png", width = 800, height = 600)
boxplot(Anciennete ~ target, data = data,
        main = "Ancienneté vs Churn",
        xlab = "Churn",
        ylab = "Ancienneté (mois)",
        col = c("steelblue", "coral"))
dev.off()

# Type de contrat vs Churn
png("outputs/04_contrat_vs_churn.png", width = 800, height = 600)
mosaicplot(table(data$Contrat, data$target),
           main = "Type de Contrat vs Churn",
           xlab = "Type de Contrat",
           ylab = "Churn",
           color = c("steelblue", "coral"))
dev.off()

# ------------------------------------------------------------------------------
# 5. SAUVEGARDE DES DONNÉES NETTOYÉES
# ------------------------------------------------------------------------------

# Créer le dossier data s'il n'existe pas
if (!dir.exists("data")) {
  dir.create("data")
}

# Sauvegarder les données nettoyées
saveRDS(data, "data/churn_cleaned.rds")
write.csv(data, "data/churn_cleaned.csv", row.names = FALSE)

cat("\n✓ Données nettoyées sauvegardées dans data/churn_cleaned.rds\n")
cat("✓ Visualisations sauvegardées dans outputs/\n")
cat("\nPROCESSUS TERMINÉ AVEC SUCCÈS!\n")
