# ==============================================================================
# SCRIPT D'INSTALLATION DES PACKAGES
# Projet : Prédiction du Churn - Fournisseur d'Accès Internet
# ==============================================================================

cat("Installation des packages nécessaires pour le projet Churn...\n\n")

# Configurer le miroir CRAN
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# Liste des packages requis
packages <- c(
  "tidyverse",      # Manipulation de données et visualisation
  "caret",          # Framework de machine learning
  "randomForest",   # Algorithme Random Forest
  "pROC",           # Courbe ROC et calcul de l'AUC
  "corrplot",       # Matrices de corrélation
  "shiny",          # Framework pour applications web interactives
  "shinydashboard", # Extension Shiny pour dashboards
  "DT",             # Tables de données interactives
  "plotly"          # Graphiques interactifs
)

# Fonction pour installer les packages manquants
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installation de %s...\n", package))
    install.packages(package, dependencies = TRUE)
    cat(sprintf("✓ %s installé avec succès!\n\n", package))
  } else {
    cat(sprintf("✓ %s est déjà installé\n", package))
  }
}

# Installer tous les packages
cat("Vérification et installation des packages...\n")
cat("===============================================\n\n")

for (pkg in packages) {
  install_if_missing(pkg)
}

cat("\n===============================================\n")
cat("✓ INSTALLATION TERMINÉE!\n")
cat("===============================================\n\n")

# Vérifier que tous les packages se chargent correctement
cat("Vérification du chargement des packages...\n")
all_loaded <- TRUE

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("✗ Erreur: %s n'a pas pu être chargé\n", pkg))
    all_loaded <- FALSE
  }
}

if (all_loaded) {
  cat("\n✓ Tous les packages sont prêts à l'emploi!\n")
  cat("\nVous pouvez maintenant exécuter:\n")
  cat("1. source('R/01_preprocessing.R')\n")
  cat("2. source('R/02_modeling.R')\n")
  cat("3. shiny::runApp('app.R')\n")
} else {
  cat("\n✗ Certains packages n'ont pas pu être chargés. Veuillez les réinstaller manuellement.\n")
}
