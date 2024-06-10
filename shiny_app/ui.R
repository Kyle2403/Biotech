#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(ggplot2)
library(EBImage)
astro_imgs <- readRDS("images_R_obj/astro.rds")
empty_imgs <- readRDS("images_R_obj/empty.rds")
endothelial_imgs <- readRDS("images_R_obj/endo.rds")
microglia_imgs <- readRDS("images_R_obj/micro.rds")
neuron_imgs <- readRDS("images_R_obj/neuron.rds")
oligodendrocyte_imgs <- readRDS("images_R_obj/oligo.rds")

astro_imgs_2 <- readRDS("images_R_obj/astro_2.rds")
empty_imgs_2 <- readRDS("images_R_obj/empty_2.rds")
endothelial_imgs_2 <- readRDS("images_R_obj/endo_2.rds")
microglia_imgs_2 <- readRDS("images_R_obj/micro_2.rds")
neuron_imgs_2 <- readRDS("images_R_obj/neuron_2.rds")
oligodendrocyte_imgs_2 <- readRDS("images_R_obj/oligo_2.rds")

all_imgs <- readRDS("images_R_obj/all.rds")

page1 <- page_fluid(
    HTML('<div class="card bg-dark text-white text-center">
          <img src="./brain2.png" class="card-img" alt="...">
          <div class="card-img-overlay d-flex">
            <div class="align-self-center mx-auto text-white">
                <div class="card bg-black text-white text-center">
                    <h1 class="card-title">Interactive Application for Brain Cell Classification</h1>
                </div>
            </div>
          </div>
        </div>'),

    layout_columns(
        col_widths = (c(-2, 4, 4, -2)),
        card(card_header(h3("Aim")),
             p("Imagine being able to look at a cell image and instantly know about its gene expressions.  One approach to do this is to use unsupervised learning to group cells with similar gene expressions, and train deep learning models to identify which cluster a cell image belongs to. 
But these clusters might not convey much meaning, if they aren’t given any specific biological labels. Our dataset with cell images of a mouse brain suffers from this issue. 
Hence, our aim is to give informative labels to these clusters, and build an interpretable model that classifies cell images to these labels.")
             ),
        card(
            card_image(file = "www/xenium_image.png")
        )
    ),
    layout_columns(
        col_widths = (c(-2, 8, -2)),
        card(card_header(h3("Instruction")),
             p("Navigate to 'Cell Visualisation' to see the images of each group, and 'Model Prediction' to use our model to predict the group of a cell.
"))
        ),
    layout_columns(
        col_widths = (c(-2, 8, -2)),
        card(card_header(h3("Our model")),
             p("We have mainly used Convolutional Neural Network as the classifier due to its well known performance for image classification tasks in general."))
        ,card_image("www/cnn.png")
    )
)

page2 <- page_sidebar(
    title = "Cell image display",
    sidebar = sidebar(
        title = "Display options",
        selectInput("cluster_id", "Group",
                    c("Astrocytes" = 1,
                      "Unclassified" = 2,
                      "Endothelial" = 3,
                      "Microglia" = 4,
                      "Neuron" = 5,
                      "Oligodendrocyte" = 6
                      ),
                    selected = 1),
        selectInput("cell_id", "Cell",
                    choices = names(astro_imgs),
                    selected = names(astro_imgs)[1]),
        numericInput("size", "Resized size", value = 40, 30, 80),
        checkboxInput("masked", "Masked with boundary?", value = FALSE)
    ),
    navset_card_pill(
        title = "Image display type:",
        nav_panel(
            "Raster", plotOutput("raster")
        ),
        nav_panel(
            "Interactive", displayOutput("interactive")
        )
    )
)

page3 <- page_sidebar(
    title="CNN classifier",
    sidebar = sidebar(
        title="Options",
        HTML('<div align="center">
            <h5>
                Using our images:
            </h5>
        </div>'),        selectizeInput("cell_id2", "Cell", choices = NULL),
        HTML('<div align="center">
            <h5>
                Or
            </h5>
        </div>'),
        fileInput("file", "Upload your own cell",
                  accept = c(".png", ".tiff", ".jpeg")),
        actionButton("predict", "Predict Image")
    ),
    layout_columns(
        col_widths = (c(6, 6)),
        card(
            card_header("Result"),
            textOutput("prediction"),
            imageOutput("type_img", inline = TRUE),
            textOutput("info")),
        layout_columns(col_widths = c(12, 12), row_heights = c(1,1),
            card(
                card_header("Image"),
                plotOutput("raster2")
            ),
            card(
                card_header("Focus square"),
                plotOutput("raster3"))
        )

    )
)

page_navbar(
    theme = bs_theme(version = 5, "lux"),
    title = "Brain image",
    inverse = TRUE,
    nav_panel(title = "Overview", page1),
    nav_panel(title = "Model Prediction", page3),
    nav_panel(title = "Cell Visualisation", page2),
    nav_spacer(),
    nav_menu(
        title = "References",
        align = "right",
        nav_item(tags$a("Posit", href = "https://posit.co")),
        nav_item(tags$a("Shiny", href = "https://shiny.posit.co")),
        nav_item(tags$a("Dataset", href = "https://www.10xgenomics.com/datasets/fresh-frozen-mouse-brain-for-xenium-explorer-demo-1-standard")),
        nav_item(tags$a("Model", href = "https://poloclub.github.io/cnn-explainer/")),
        
    )
    
)

