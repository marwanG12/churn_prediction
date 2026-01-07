# ==============================================================================
# APPLICATION SHINY - PRÉDICTION DU CHURN
# Projet : Prédiction du Churn - Fournisseur d'Accès Internet
# ==============================================================================

library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)
library(randomForest)

# Charger le modèle et les données
model <- readRDS("models/rf_churn_model.rds")
metrics <- readRDS("models/model_metrics.rds")
data <- readRDS("data/churn_cleaned.rds")

# ==============================================================================
# UI - INTERFACE UTILISATEUR
# ==============================================================================

ui <- dashboardPage(
  skin = "blue",
  
  # Header
  dashboardHeader(title = "Prédiction Churn - FAI"),
  
  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("📊 Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("🔮 Prédiction", tabName = "prediction", icon = icon("magic")),
      menuItem("📈 Performance", tabName = "performance", icon = icon("chart-line")),
      menuItem("ℹ️ À propos", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  # Body
  dashboardBody(
    tabItems(
      
      # ========================================================================
      # ONGLET 1 : DASHBOARD
      # ========================================================================
      tabItem(
        tabName = "dashboard",
        h2("Tableau de Bord - Analyse du Churn"),
        
        fluidRow(
          valueBoxOutput("total_clients"),
          valueBoxOutput("churn_rate"),
          valueBoxOutput("revenue_risk")
        ),
        
        fluidRow(
          box(
            title = "Distribution du Churn",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("churn_distribution")
          ),
          box(
            title = "Churn par Type de Contrat",
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("churn_by_contract")
          )
        ),
        
        fluidRow(
          box(
            title = "Ancienneté vs Churn",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("tenure_vs_churn")
          ),
          box(
            title = "Charges Mensuelles vs Churn",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("charges_vs_churn")
          )
        )
      ),
      
      # ========================================================================
      # ONGLET 2 : PRÉDICTION
      # ========================================================================
      tabItem(
        tabName = "prediction",
        h2("Prédiction de Churn pour un Client"),
        
        fluidRow(
          box(
            title = "Caractéristiques du Client",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            
            selectInput("genre", "Genre:", 
                        choices = c("Homme", "Femme")),
            
            selectInput("senior", "Senior:", 
                        choices = c("0", "1")),
            
            selectInput("enfants", "Enfants:", 
                        choices = c("Oui", "Non")),
            
            sliderInput("anciennete", "Ancienneté (mois):", 
                        min = 1, max = 72, value = 12),
            
            selectInput("multi_lignes", "Multi-lignes:", 
                        choices = c("Oui", "Non")),
            
            selectInput("service_internet", "Service Internet:", 
                        choices = c("Fibre optique", "DSL", "Non")),
            
            selectInput("autres_services", "Autres Services:", 
                        choices = c("Oui", "Non")),
            
            selectInput("partenaire", "Partenaire:", 
                        choices = c("Oui", "Non")),
            
            selectInput("contrat", "Type de Contrat:", 
                        choices = c("Mensuel", "Annuel", "Bisannuel")),
            
            selectInput("facturation_elec", "Facturation Électronique:", 
                        choices = c("Oui", "Non")),
            
            selectInput("mode_paiement", "Mode de Paiement:", 
                        choices = c("Carte bancaire", "Virement bancaire", 
                                    "Cheque electronique", "Cheque papier")),
            
            numericInput("charges_mensuelles", "Charges Mensuelles (€):", 
                         value = 50, min = 0),
            
            numericInput("charges_totales", "Charges Totales (€):", 
                         value = 600, min = 0),
            
            actionButton("predict_btn", "Prédire le Churn", 
                         class = "btn-primary btn-lg", 
                         style = "width: 100%; margin-top: 20px;")
          ),
          
          box(
            title = "Résultat de la Prédiction",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            
            uiOutput("prediction_result"),
            hr(),
            plotlyOutput("prediction_prob")
          )
        )
      ),
      
      # ========================================================================
      # ONGLET 3 : PERFORMANCE DU MODÈLE
      # ========================================================================
      tabItem(
        tabName = "performance",
        h2("Performance du Modèle Random Forest"),
        
        fluidRow(
          valueBoxOutput("accuracy_box"),
          valueBoxOutput("auc_box"),
          valueBoxOutput("precision_box")
        ),
        
        fluidRow(
          box(
            title = "Matrice de Confusion",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("confusion_matrix_plot")
          ),
          box(
            title = "Top 10 Variables Importantes",
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("variable_importance_plot")
          )
        ),
        
        fluidRow(
          box(
            title = "Métriques Détaillées",
            status = "info",
            solidHeader = TRUE,
            width = 12,
            verbatimTextOutput("detailed_metrics")
          )
        )
      ),
      
      # ========================================================================
      # ONGLET 4 : À PROPOS
      # ========================================================================
      tabItem(
        tabName = "about",
        h2("À Propos du Projet"),
        
        box(
          title = "Contexte",
          status = "primary",
          solidHeader = TRUE,
          width = 12,
          HTML("
            <h4>Prédiction du Churn - Fournisseur d'Accès Internet</h4>
            <p>Cette application permet de prédire la probabilité qu'un client se désabonne 
            d'un service internet.</p>
            
            <h4>Objectifs</h4>
            <ul>
              <li>Identifier les clients à risque de churn</li>
              <li>Comprendre les facteurs influençant le désabonnement</li>
              <li>Optimiser les actions de fidélisation</li>
            </ul>
            
            <h4>Modèle Utilisé</h4>
            <p><strong>Random Forest</strong> - Un ensemble d'arbres de décision pour une 
            prédiction robuste et précise.</p>
            
            <h4>Données</h4>
            <p>Le modèle a été entraîné sur ~4500 clients avec les caractéristiques suivantes:</p>
            <ul>
              <li>Informations démographiques (genre, senior, enfants)</li>
              <li>Services souscrits (internet, multi-lignes, autres services)</li>
              <li>Informations contractuelles (type de contrat, mode de paiement)</li>
              <li>Informations financières (charges mensuelles et totales)</li>
            </ul>
          ")
        )
      )
    )
  )
)

# ==============================================================================
# SERVER - LOGIQUE SERVEUR
# ==============================================================================

server <- function(input, output, session) {
  
  # ============================================================================
  # DASHBOARD - VALUE BOXES
  # ============================================================================
  
  output$total_clients <- renderValueBox({
    valueBox(
      value = nrow(data),
      subtitle = "Clients Totaux",
      icon = icon("users"),
      color = "blue"
    )
  })
  
  output$churn_rate <- renderValueBox({
    churn_count <- sum(data$target == "Oui")
    churn_rate <- (churn_count / nrow(data)) * 100
    valueBox(
      value = paste0(round(churn_rate, 1), "%"),
      subtitle = "Taux de Churn",
      icon = icon("exclamation-triangle"),
      color = "red"
    )
  })
  
  output$revenue_risk <- renderValueBox({
    churned_revenue <- sum(data$Charges_totales[data$target == "Oui"], na.rm = TRUE)
    valueBox(
      value = paste0(round(churned_revenue / 1000, 0), "K €"),
      subtitle = "Revenus à Risque",
      icon = icon("euro-sign"),
      color = "yellow"
    )
  })
  
  # ============================================================================
  # DASHBOARD - VISUALISATIONS
  # ============================================================================
  
  output$churn_distribution <- renderPlotly({
    churn_counts <- as.data.frame(table(data$target))
    colnames(churn_counts) <- c("Churn", "Count")
    
    plot_ly(churn_counts, x = ~Churn, y = ~Count, type = "bar",
            marker = list(color = c("steelblue", "coral"))) %>%
      layout(title = "",
             xaxis = list(title = "Churn"),
             yaxis = list(title = "Nombre de Clients"))
  })
  
  output$churn_by_contract <- renderPlotly({
    contract_churn <- as.data.frame(prop.table(table(data$Contrat, data$target), 1) * 100)
    colnames(contract_churn) <- c("Contrat", "Churn", "Percentage")
    contract_churn_yes <- contract_churn[contract_churn$Churn == "Oui", ]
    
    plot_ly(contract_churn_yes, x = ~Contrat, y = ~Percentage, type = "bar",
            marker = list(color = "coral")) %>%
      layout(title = "",
             xaxis = list(title = "Type de Contrat"),
             yaxis = list(title = "Taux de Churn (%)"))
  })
  
  output$tenure_vs_churn <- renderPlotly({
    plot_ly(data, x = ~target, y = ~Anciennete, type = "box",
            color = ~target, colors = c("steelblue", "coral")) %>%
      layout(title = "",
             xaxis = list(title = "Churn"),
             yaxis = list(title = "Ancienneté (mois)"),
             showlegend = FALSE)
  })
  
  output$charges_vs_churn <- renderPlotly({
    plot_ly(data, x = ~target, y = ~charges_mensuelles, type = "box",
            color = ~target, colors = c("steelblue", "coral")) %>%
      layout(title = "",
             xaxis = list(title = "Churn"),
             yaxis = list(title = "Charges Mensuelles (€)"),
             showlegend = FALSE)
  })
  
  # ============================================================================
  # PRÉDICTION
  # ============================================================================
  
  prediction_result <- eventReactive(input$predict_btn, {
    # Créer le dataframe avec les inputs
    new_client <- data.frame(
      Genre = factor(input$genre, levels = levels(data$Genre)),
      Senior = factor(input$senior, levels = levels(data$Senior)),
      Enfants = factor(input$enfants, levels = levels(data$Enfants)),
      Anciennete = as.numeric(input$anciennete),
      Multi_lignes = factor(input$multi_lignes, levels = levels(data$Multi_lignes)),
      Service_Internet = factor(input$service_internet, levels = levels(data$Service_Internet)),
      Autres_Services = factor(input$autres_services, levels = levels(data$Autres_Services)),
      Partenaire = factor(input$partenaire, levels = levels(data$Partenaire)),
      Contrat = factor(input$contrat, levels = levels(data$Contrat)),
      Facturation_electronique = factor(input$facturation_elec, 
                                         levels = levels(data$Facturation_electronique)),
      Mode_de_paiement = factor(input$mode_paiement, levels = levels(data$Mode_de_paiement)),
      charges_mensuelles = as.numeric(input$charges_mensuelles),
      Charges_totales = as.numeric(input$charges_totales)
    )
    
    # Prédiction
    pred_class <- predict(model, new_client, type = "class")
    pred_prob <- predict(model, new_client, type = "prob")
    
    list(
      class = as.character(pred_class),
      prob_non = pred_prob[1, "Non"],
      prob_oui = pred_prob[1, "Oui"]
    )
  })
  
  output$prediction_result <- renderUI({
    req(prediction_result())
    result <- prediction_result()
    
    if (result$class == "Oui") {
      box_color <- "danger"
      icon_name <- "exclamation-triangle"
      message <- "⚠️ RISQUE DE CHURN ÉLEVÉ"
      recommendation <- "Ce client présente un risque élevé de désabonnement. 
                         Actions recommandées: contact prioritaire, offre personnalisée."
    } else {
      box_color <- "success"
      icon_name <- "check-circle"
      message <- "✓ RISQUE DE CHURN FAIBLE"
      recommendation <- "Ce client est stable. Continuez les actions de fidélisation standard."
    }
    
    tagList(
      div(
        class = paste0("alert alert-", box_color),
        style = "font-size: 20px; font-weight: bold; text-align: center; padding: 20px;",
        icon(icon_name, style = "font-size: 30px;"),
        br(),
        message
      ),
      div(
        style = "padding: 15px; background-color: #f4f4f4; border-radius: 5px; margin-top: 10px;",
        h4("Probabilités:"),
        p(paste0("• Churn: ", round(result$prob_oui * 100, 2), "%")),
        p(paste0("• Fidélité: ", round(result$prob_non * 100, 2), "%")),
        hr(),
        h4("Recommandation:"),
        p(recommendation)
      )
    )
  })
  
  output$prediction_prob <- renderPlotly({
    req(prediction_result())
    result <- prediction_result()
    
    prob_df <- data.frame(
      Classe = c("Fidèle", "Churn"),
      Probabilite = c(result$prob_non * 100, result$prob_oui * 100)
    )
    
    plot_ly(prob_df, x = ~Classe, y = ~Probabilite, type = "bar",
            marker = list(color = c("steelblue", "coral"))) %>%
      layout(title = "Probabilités de Prédiction",
             xaxis = list(title = ""),
             yaxis = list(title = "Probabilité (%)", range = c(0, 100)))
  })
  
  # ============================================================================
  # PERFORMANCE
  # ============================================================================
  
  output$accuracy_box <- renderValueBox({
    valueBox(
      value = paste0(round(metrics$accuracy * 100, 1), "%"),
      subtitle = "Accuracy",
      icon = icon("bullseye"),
      color = "green"
    )
  })
  
  output$auc_box <- renderValueBox({
    valueBox(
      value = round(metrics$auc, 3),
      subtitle = "AUC Score",
      icon = icon("chart-area"),
      color = "purple"
    )
  })
  
  output$precision_box <- renderValueBox({
    valueBox(
      value = paste0(round(metrics$precision * 100, 1), "%"),
      subtitle = "Precision",
      icon = icon("crosshairs"),
      color = "orange"
    )
  })
  
  output$confusion_matrix_plot <- renderPlotly({
    cm <- metrics$confusion_matrix
    cm_df <- as.data.frame(as.table(cm))
    colnames(cm_df) <- c("Prediction", "Reference", "Freq")
    
    plot_ly(data = cm_df, x = ~Reference, y = ~Prediction, z = ~Freq,
            type = "heatmap", colors = "Blues") %>%
      layout(title = "",
             xaxis = list(title = "Valeur Réelle"),
             yaxis = list(title = "Prédiction"))
  })
  
  output$variable_importance_plot <- renderPlotly({
    imp_df <- metrics$variable_importance[1:10, ]
    imp_df <- imp_df[order(imp_df$MeanDecreaseGini), ]
    
    plot_ly(imp_df, y = ~Variable, x = ~MeanDecreaseGini, type = "bar",
            orientation = "h", marker = list(color = "steelblue")) %>%
      layout(title = "",
             xaxis = list(title = "Importance (Mean Decrease Gini)"),
             yaxis = list(title = ""))
  })
  
  output$detailed_metrics <- renderPrint({
    cat("=== MÉTRIQUES DE PERFORMANCE ===\n\n")
    cat(sprintf("Accuracy:    %.2f%%\n", metrics$accuracy * 100))
    cat(sprintf("Sensitivity: %.2f%%\n", metrics$sensitivity * 100))
    cat(sprintf("Specificity: %.2f%%\n", metrics$specificity * 100))
    cat(sprintf("Precision:   %.2f%%\n", metrics$precision * 100))
    cat(sprintf("AUC:         %.4f\n\n", metrics$auc))
    cat("=== MATRICE DE CONFUSION ===\n\n")
    print(metrics$confusion_matrix)
  })
}

# ==============================================================================
# LANCEMENT DE L'APPLICATION
# ==============================================================================

shinyApp(ui = ui, server = server)
