# 🎯 Prédiction du Churn - Fournisseur d'Accès Internet

## 📋 Description du Projet

Système de prédiction du churn (désabonnement) pour un fournisseur d'accès internet utilisant le machine learning avec R et une interface web interactive développée avec Shiny.

## 🎯 Objectifs

- ✅ Identifier les clients à risque de désabonnement
- ✅ Comprendre les facteurs influençant le churn
- ✅ Fournir un outil de prédiction en temps réel
- ✅ Visualiser les métriques et performances du modèle

## 🗂️ Structure du Projet

```
Projet/
│
├── app.R                          # Application Shiny (interface web)
├── churn_internet(in).csv         # Données brutes
│
├── R/                             # Scripts R
│   ├── 01_preprocessing.R         # Nettoyage et analyse exploratoire
│   └── 02_modeling.R              # Entraînement du modèle
│
├── data/                          # Données traitées (générées)
│   ├── churn_cleaned.rds
│   └── churn_cleaned.csv
│
├── models/                        # Modèles entraînés (générés)
│   ├── rf_churn_model.rds
│   └── model_metrics.rds
│
└── outputs/                       # Visualisations (générées)
    ├── 01_distribution_target.png
    ├── 02_charges_vs_churn.png
    ├── 03_anciennete_vs_churn.png
    └── ...
```

## 🚀 Installation et Configuration

### Prérequis

- R (version ≥ 4.0.0)
- RStudio (recommandé)

### Packages R Nécessaires

Installez les packages suivants dans R :

```r
install.packages(c(
  "tidyverse",      # Manipulation de données
  "caret",          # Machine learning
  "randomForest",   # Algorithme Random Forest
  "pROC",           # Courbe ROC et AUC
  "corrplot",       # Matrices de corrélation
  "shiny",          # Interface web
  "shinydashboard", # Dashboard Shiny
  "DT",             # Tables interactives
  "plotly"          # Graphiques interactifs
))
```

Ou en une seule commande :

```r
packages <- c("tidyverse", "caret", "randomForest", "pROC", "corrplot", 
              "shiny", "shinydashboard", "DT", "plotly")
install.packages(packages)
```

## 📊 Comment Lancer les Scripts ?

### Option 1 : Exécution Complète (Recommandé)

Pour exécuter l'ensemble du pipeline de A à Z, suivez ces étapes dans l'ordre :

#### 1️⃣ Installation des Packages

Avant toute chose, installez tous les packages nécessaires :

```r
source("install_packages.R")
```

Ou manuellement :
```r
packages <- c("tidyverse", "caret", "randomForest", "pROC", "corrplot", 
              "shiny", "shinydashboard", "DT", "plotly")
install.packages(packages)
```

#### 2️⃣ Prétraitement des Données

Exécutez le script de nettoyage et d'analyse exploratoire :

```r
source("R/01_preprocessing.R")
```

**Ce script va :**
- Charger et nettoyer les données brutes (`churn_internet(in).csv`)
- Générer des statistiques descriptives
- Créer des visualisations exploratoires dans `outputs/`
- Sauvegarder les données nettoyées dans `data/churn_cleaned.rds` et `data/churn_cleaned.csv`

#### 3️⃣ Entraînement du Modèle

Entraînez le modèle de machine learning :

```r
source("R/02_modeling.R")
```

**Ce script va :**
- Diviser les données en ensembles d'entraînement/test (70/30)
- Entraîner un modèle Random Forest avec 500 arbres
- Évaluer les performances (accuracy, AUC, precision, recall, F1-score)
- Sauvegarder le modèle entraîné dans `models/rf_churn_model.rds`
- Sauvegarder les métriques dans `models/model_metrics.rds`

#### 4️⃣ Lancer l'Application Web

Lancez l'interface web interactive Shiny :

```r
shiny::runApp("app.R")
```

L'application s'ouvrira automatiquement dans votre navigateur par défaut à l'adresse `http://127.0.0.1:XXXX`

### Option 2 : Exécution via RStudio

1. Ouvrez RStudio
2. Définissez le répertoire de travail : `Session > Set Working Directory > Choose Directory...`
3. Sélectionnez le dossier du projet
4. Exécutez les scripts dans l'ordre (01 → 02 → app.R)

### Option 3 : Exécution en Ligne de Commande R

Depuis un terminal/PowerShell, dans le dossier du projet :

```bash
Rscript R/01_preprocessing.R
Rscript R/02_modeling.R
Rscript -e "shiny::runApp('app.R')"
```

## 🌐 WebApp en Ligne

**URL de l'application déployée :** 

🔗 [Insérer l'URL de votre application Shiny déployée ici]

*(Exemples de plateformes de déploiement : shinyapps.io, Posit Cloud, Heroku, etc.)*

## 📊 Gestion de Projet

**Trello - Répartition des Tâches :**

🔗 [Insérer le lien de votre board Trello ici]

Accédez au tableau de suivi du projet pour voir :
- 📋 **À Faire** : Tâches planifiées
- 🔄 **En Cours** : Tâches en développement
- ✅ **Terminé** : Tâches complétées

**Membres de l'équipe et répartition :**
- [Nom Membre 1] : [Rôles/Tâches]
- [Nom Membre 2] : [Rôles/Tâches]
- [Nom Membre 3] : [Rôles/Tâches]

## 📽️ Présentation

**Support de présentation :**

🔗 [Insérer le lien vers votre présentation Google Slides/PowerPoint ici]

## 🌐 Fonctionnalités de l'Application Shiny

### 📊 Dashboard
- Vue d'ensemble des données
- Taux de churn global
- Visualisations interactives (distribution, contrats, ancienneté, charges)

### 🔮 Prédiction
- Saisie des caractéristiques d'un client
- Prédiction en temps réel du risque de churn
- Probabilités détaillées et recommandations

### 📈 Performance du Modèle
- Métriques de performance (Accuracy, AUC, Precision)
- Matrice de confusion
- Importance des variables
- Statistiques détaillées

### ℹ️ À Propos
- Contexte du projet
- Description du modèle
- Informations sur les données

## 📈 Modèle de Machine Learning

**Algorithme :** Random Forest

**Caractéristiques utilisées :**
- Genre
- Senior (oui/non)
- Enfants (oui/non)
- Ancienneté (mois)
- Multi-lignes
- Service Internet (Fibre optique, DSL, Non)
- Autres services
- Partenaire
- Type de contrat (Mensuel, Annuel, Bisannuel)
- Facturation électronique
- Mode de paiement
- Charges mensuelles
- Charges totales

**Variable cible :** Churn (Oui/Non)

## 📊 Métriques de Performance Attendues

Le modèle Random Forest devrait atteindre :
- **Accuracy** : ~80-85%
- **AUC** : ~0.85-0.90
- **Precision** : ~70-75%

*(Les valeurs exactes dépendent des données et du split train/test)*

## 🔧 Personnalisation

### Modifier les Paramètres du Modèle

Dans [R/02_modeling.R](R/02_modeling.R), vous pouvez ajuster :

```r
rf_model <- randomForest(
  target ~ .,
  data = train_data,
  ntree = 500,        # Nombre d'arbres (augmenter pour plus de précision)
  mtry = 4,           # Variables par arbre
  importance = TRUE
)
```

### Changer le Ratio Train/Test

```r
train_index <- createDataPartition(y, p = 0.7, list = FALSE)  # 70% train, 30% test
```

## 🐛 Dépannage

### Problème : Packages manquants
**Solution :** Réinstallez les packages manquants avec `install.packages("nom_du_package")`

### Problème : Erreur de chemin de fichier
**Solution :** Assurez-vous que votre répertoire de travail est le dossier racine du projet :
```r
setwd("C:/Users/mght2/OneDrive/Bureau/IPSSI/IPSSI_COURS_M2/R/Projet")
```

### Problème : Modèle non trouvé dans l'app Shiny
**Solution :** Exécutez d'abord les scripts 1 et 2 pour générer les modèles

## 📝 Notes Importantes

1. **Ordre d'exécution** : Respectez l'ordre des étapes (prétraitement → modélisation → application)
2. **Données** : Le fichier CSV original doit être présent dans le dossier racine
3. **Performance** : Le premier entraînement peut prendre 1-2 minutes selon votre machine

## 👥 Auteur

Projet développé pour IPSSI - Master 2

## 📅 Date

Janvier 2026

## 📄 Licence

Projet académique - IPSSI

---

**🎓 Bon apprentissage et bonne analyse !**
