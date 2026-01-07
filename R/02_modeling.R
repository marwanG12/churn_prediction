# ==============================================================================
# SCRIPT 2 : MODÉLISATION ET PRÉDICTION DU CHURN
# Projet : Prédiction du Churn - Fournisseur d'Accès Internet
# ==============================================================================

# Chargement des bibliothèques
library(tidyverse)
library(caret)
library(randomForest)
library(pROC)

# Fixer la seed pour la reproductibilité
set.seed(123)

# ------------------------------------------------------------------------------
# 1. CHARGEMENT DES DONNÉES NETTOYÉES
# ------------------------------------------------------------------------------

data <- readRDS("data/churn_cleaned.rds")

cat("Dimensions du dataset:", dim(data), "\n")
cat("Distribution de la cible:\n")
print(table(data$target))

# ------------------------------------------------------------------------------
# 2. PRÉPARATION DES DONNÉES POUR LA MODÉLISATION
# ------------------------------------------------------------------------------

# Séparer les features et la cible
X <- data[, -which(names(data) == "target")]
y <- data$target

# Division train/test (70/30)
train_index <- createDataPartition(y, p = 0.7, list = FALSE)
X_train <- X[train_index, ]
X_test <- X[-train_index, ]
y_train <- y[train_index]
y_test <- y[-train_index]

cat("\nTaille du set d'entraînement:", nrow(X_train), "\n")
cat("Taille du set de test:", nrow(X_test), "\n")

# Créer les datasets complets
train_data <- cbind(X_train, target = y_train)
test_data <- cbind(X_test, target = y_test)

# ------------------------------------------------------------------------------
# 3. ENTRAÎNEMENT DU MODÈLE RANDOM FOREST
# ------------------------------------------------------------------------------

cat("\n--- Entraînement du modèle Random Forest ---\n")

# Paramètres du modèle
rf_model <- randomForest(
  target ~ .,
  data = train_data,
  ntree = 500,
  mtry = 4,
  importance = TRUE,
  na.action = na.omit
)

# Résumé du modèle
print(rf_model)

# ------------------------------------------------------------------------------
# 4. ÉVALUATION DU MODÈLE
# ------------------------------------------------------------------------------

# Prédictions sur le set de test
predictions <- predict(rf_model, X_test, type = "class")
predictions_prob <- predict(rf_model, X_test, type = "prob")[, 2]

# Matrice de confusion
conf_matrix <- confusionMatrix(predictions, y_test, positive = "Oui")
print(conf_matrix)

# Métriques de performance
accuracy <- conf_matrix$overall["Accuracy"]
sensitivity <- conf_matrix$byClass["Sensitivity"]
specificity <- conf_matrix$byClass["Specificity"]
precision <- conf_matrix$byClass["Precision"]

cat("\n--- Métriques de Performance ---\n")
cat(sprintf("Accuracy: %.2f%%\n", accuracy * 100))
cat(sprintf("Sensitivity (Recall): %.2f%%\n", sensitivity * 100))
cat(sprintf("Specificity: %.2f%%\n", specificity * 100))
cat(sprintf("Precision: %.2f%%\n", precision * 100))

# ROC et AUC
roc_obj <- roc(as.numeric(y_test == "Oui"), predictions_prob)
auc_value <- auc(roc_obj)
cat(sprintf("AUC: %.4f\n", auc_value))

# ------------------------------------------------------------------------------
# 5. IMPORTANCE DES VARIABLES
# ------------------------------------------------------------------------------

# Extraire l'importance des variables
importance_df <- as.data.frame(importance(rf_model))
importance_df$Variable <- rownames(importance_df)
importance_df <- importance_df[order(-importance_df$MeanDecreaseGini), ]

cat("\n--- Top 10 Variables les plus importantes ---\n")
print(head(importance_df[, c("Variable", "MeanDecreaseGini")], 10))

# Visualisation de l'importance
png("outputs/05_variable_importance.png", width = 1000, height = 800)
varImpPlot(rf_model, main = "Importance des Variables")
dev.off()

# Courbe ROC
png("outputs/06_roc_curve.png", width = 800, height = 800)
plot(roc_obj, main = paste("Courbe ROC - AUC =", round(auc_value, 4)),
     col = "steelblue", lwd = 2)
abline(a = 0, b = 1, lty = 2, col = "red")
dev.off()

# Matrice de confusion visuelle
png("outputs/07_confusion_matrix.png", width = 800, height = 600)
conf_table <- as.table(conf_matrix$table)
fourfoldplot(conf_table, color = c("coral", "steelblue"),
             main = "Matrice de Confusion")
dev.off()

# ------------------------------------------------------------------------------
# 6. SAUVEGARDE DU MODÈLE
# ------------------------------------------------------------------------------

# Créer le dossier models s'il n'existe pas
if (!dir.exists("models")) {
  dir.create("models")
}

# Sauvegarder le modèle
saveRDS(rf_model, "models/rf_churn_model.rds")

# Sauvegarder les métriques
metrics <- list(
  accuracy = accuracy,
  sensitivity = sensitivity,
  specificity = specificity,
  precision = precision,
  auc = auc_value,
  confusion_matrix = conf_matrix$table,
  variable_importance = importance_df
)
saveRDS(metrics, "models/model_metrics.rds")

cat("\n✓ Modèle sauvegardé dans models/rf_churn_model.rds\n")
cat("✓ Métriques sauvegardées dans models/model_metrics.rds\n")
cat("\nMODÉLISATION TERMINÉE AVEC SUCCÈS!\n")
