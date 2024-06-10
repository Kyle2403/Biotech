#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
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


# Model function
########################################################
library(torch)
library(torchvision)
tinyVGG <- torch::nn_module(
    "tinyVGG",
    initialize = function(input_shape, hidden_units, output_shape){
        
        self$conv_block_1 <- nn_sequential(
            nn_conv2d(in_channels=input_shape,
                      out_channels=hidden_units,
                      kernel_size=3,
                      stride=1,
                      padding=0),
            nn_relu(),
            nn_conv2d(in_channels=hidden_units,
                      out_channels=hidden_units,
                      kernel_size=3,
                      stride=1,
                      padding=0),
            nn_relu(),
            nn_max_pool2d(kernel_size=2,
                          stride=2) # default stride value is same as kernel_size
        )
        self$conv_block_2 = nn_sequential(
            nn_conv2d(in_channels=hidden_units,
                      out_channels=hidden_units,
                      kernel_size=3,
                      stride=1,
                      padding=0),
            nn_relu(),
            nn_conv2d(in_channels=hidden_units,
                      out_channels=hidden_units,
                      kernel_size=3,
                      stride=1,
                      padding=0),
            nn_relu(),
            nn_max_pool2d(kernel_size=2,
                          stride=2) # default stride value is same as kernel_size
        )
        self$classifier = nn_sequential(
            nn_flatten(), 
            nn_linear(in_features=hidden_units*13*13,
                      out_features=output_shape)
        )
    },
    forward = function(x){
        x |>  self$conv_block_1() |> self$conv_block_2() |> self$classifier()
    }
)

device <- if (cuda_is_available()) torch_device("cuda:0") else "cpu"


state_dict <- load_state_dict("balanced_model_state.pth")

balanced_model <- tinyVGG(3, 10, 6)


balanced_model$load_state_dict(state_dict)

#########################################################

# Define server logic required to draw a histogram
function(input, output, session) {
    updateSelectizeInput(session,  "cell_id2",
                         choices = names(all_imgs),
                         selected = names(all_imgs)[1], server = TRUE)
    observeEvent(input$cluster_id,{
        
        if (input$masked){
            if (input$cluster_id == 1){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(astro_imgs_2),
                                  selected = names(astro_imgs_2)[1])
            }
            else if (input$cluster_id == 2){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(empty_imgs_2),
                                  selected = names(empty_imgs_2)[1])
            }
            else if (input$cluster_id == 3){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(endothelial_imgs_2),
                                  selected = names(endothelial_imgs_2)[1])
            }
            else if (input$cluster_id == 4){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(microglia_imgs_2),
                                  selected = names(microglia_imgs_2)[1])
            }
            else if (input$cluster_id == 5){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(neuron_imgs_2),
                                  selected = names(neuron_imgs_2)[1])
            }
            else{
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(oligodendrocyte_imgs_2),
                                  selected = names(oligodendrocyte_imgs_2)[1])
            }
        }
        else {
            if (input$cluster_id == 1){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(astro_imgs),
                                  selected = names(astro_imgs)[1])
            }
            else if (input$cluster_id == 2){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(empty_imgs),
                                  selected = names(empty_imgs)[1])
            }
            else if (input$cluster_id == 3){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(endothelial_imgs),
                                  selected = names(endothelial_imgs)[1])
            }
            else if (input$cluster_id == 4){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(microglia_imgs),
                                  selected = names(microglia_imgs)[1])
            }
            else if (input$cluster_id == 5){
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(neuron_imgs),
                                  selected = names(neuron_imgs)[1])
            }
            else{
                updateSelectInput(inputId = "cell_id",
                                  label = "Cell",
                                  choices = names(oligodendrocyte_imgs),
                                  selected = names(oligodendrocyte_imgs)[1])
            }
        }
        

    })
    img <- reactive({
        s <- ifelse(is.na(input$size), 1, input$size)
        s <- ifelse(s <= 0, 1, s)
        if (input$masked){
            if (input$cluster_id == 1){
                astro_imgs_2[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 2){
                empty_imgs_2[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 3){
                endothelial_imgs_2[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 4){
                microglia_imgs_2[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 5){
                neuron_imgs_2[[input$cell_id]] |> resize(s, s)
            }
            else{
                oligodendrocyte_imgs_2[[input$cell_id]] |> resize(s, s)
            }
        }
        else{
            if (input$cluster_id == 1){
                astro_imgs[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 2){
                empty_imgs[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 3){
                endothelial_imgs[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 4){
                microglia_imgs[[input$cell_id]] |> resize(s, s)
            }
            else if (input$cluster_id == 5){
                neuron_imgs[[input$cell_id]] |> resize(s, s)
            }
            else{
                oligodendrocyte_imgs[[input$cell_id]] |> resize(s, s)
            }
        }
    })
    

    output$raster <-renderPlot({
        if (is.null(img())){
            NULL
        }
        else{
            req(img())
            EBImage::display(img(), method = "raster")
        }

    })
    
    output$interactive <- renderDisplay({
        if (is.null(img())){
            NULL
        }
        else{
            req(img())
            EBImage::display(img())
        }
    })
    
    img2 <- reactive ({
        if (is.null(input$file)){
            out <- all_imgs[[input$cell_id2]]
        }
        else{
            path <- input$file$datapath
            out <- EBImage::readImage(path)
        }
        return(out)
    })
    
    observeEvent(input$predict, {
        img_tensor <- as.array(img2())
        img_tensor <-array(img_tensor, dim = c(dim(img_tensor), 1))
        img_tensor <- abind::abind(img_tensor, img_tensor, img_tensor, along =-3) |> drop()
        img_tensor <- img_tensor |> aperm(c(2, 3, 1)) |> transform_to_tensor() |> transform_resize(c(64, 64)) |> torch_unsqueeze(1)
        img_tensor <- img_tensor$to(device = device)
        img_tensor <- img_tensor$requires_grad_()
        balanced_model$to(device = device)
        balanced_model$eval()
        pred <- balanced_model(img_tensor)
        pred_prob <- pred |> nnf_softmax(dim = 2)
        label <- pred_prob |> torch_argmax(dim = 2)
        pred[1, label$item()]$backward()
        my_grad <- img_tensor$grad
        saliency <- torch_abs(my_grad)
        saliency_img <- Image(as.array(saliency$mean(dim = 2)$squeeze()$cpu()))
        saliency_img <- saliency_img / quantile(saliency_img, 0.99)
        output$raster3 <- renderPlot(
            EBImage::display(rgbImage(red = saliency_img), method = "raster")
        )
        label <- label$item()
        if (label == 1){
            output$prediction <- renderText("Astrocyte")
            output$info <- renderText("Astrocytes, a subtype of glial cells, also known as astrocytic glial cells, carry out crucial roles including metabolic support, structural maintenance, homeostasis, and neuroprotection. They help clear excess neurotransmitters, stabilize, and regulate the blood-brain barrier by influencing the behavior and function of endothelial cells, and promote synapse formation. Unlike neurons and other nervous system cells, astrocytes do not conduct electrical signals but instead ensure the proper functioning of neurons, which are responsible for relaying signals. The proportion of astrocytes in the brain is not well defined; depending on the counting technique used.")
            output$type_img <- renderImage({
                    return(list(
                        src = "www/astro.png",
                        filetype = "image/png",
                        alt = "astrocyte"
                    ))
            }, deleteFile = FALSE)
        }
        else if(label == 2){
            output$prediction <- renderText("Unclassified")
            output$info <- renderText("This suggests that this cell image is similar to cells that have their most differential expressed gene that has no label associate within them.")
            output$type_img <- renderImage({
                return(list(
                    src = "www/all.png",
                    filetype = "image/png",
                    alt = "unclassified"
                ))
            }, deleteFile = FALSE)
        }
        else if(label == 3){
            output$prediction <- renderText("Endothelial")
            output$info <- renderText("Endothelial cells constitute a singular cellular lining enveloping all blood vessels, controlling exchanges between the bloodstream and adjacent tissues. These cells emit signals orchestrating the proliferation and maturation of connective tissue cells composing the surrounding layers of the vessel wall. Additionally, they possess the capability to sprout new blood vessels from existing small vessels, even when isolated in laboratory cultures, generating hollow capillary tubes. The creation of new endothelial cells occurs through a straightforward process of duplicating existing endothelial cells.")
            output$type_img <- renderImage({
                return(list(
                    src = "www/endo.png",
                    filetype = "image/png",
                    alt = "endothelial"
                ))
            }, deleteFile = FALSE)
        }
        else if(label == 4){
            output$prediction <- renderText("Microglia")
            output$info <- renderText("Microglia are a type of neuroglia (glial cell) located throughout the brain and spinal cord, they are the immune cells of the central nervous system and consequently play important roles in brain infections and inflammation. Microglial cells are the most prominent immune cells of the central nervous system (CNS), tasked with surveilling the brain environment for signs of injury, infection, or abnormal cellular activity, they are the first to respond when something goes wrong in the brain. As these processes must operate efficiently to prevent potentially life-threatening damage, microglia are extremely sensitive to even small pathological changes in the CNS.")
            output$type_img <- renderImage({
                return(list(
                    src = "www/microglia.png",
                    filetype = "image/png",
                    alt = "microglia"
                ))
            }, deleteFile = FALSE)
        }
        else if(label == 5){
            output$prediction <- renderText("Neuron")
            output$info <- renderText("Neurons are the fundamental building blocks of the nervous system, responsible for sending and receiving neurotransmitters (chemicals that carry information between brain cells). Each neuron may communicate with hundreds of thousands of other neurons. They use electrical and chemical signals to send information between diﬀerent areas of the brain, as well as between the brain, the spinal cord, and the entire body. This activity allows the body to do everything from breathing to eating and moving. There is a wide variety in their shape, size, and electrochemical properties.")
            output$type_img <- renderImage({
                return(list(
                    src = "www/neuron.png",
                    filetype = "image/png",
                    alt = "neuron"
                ))
            }, deleteFile = FALSE)
        }
        else{
            output$prediction <- renderText("Oligodendrocyte")
            output$info <- renderText("Oligodendrocytes are a type of glial cell found in the central nervous system (CNS), including the brain and spinal cord. Oligodendrocytes are the myelinating cells of the CNS that allow the fast and efficient transfer of neuronal communication through the myelination of axons. A single oligodendrocyte can extend its processes to cover around 50 axons, with each axon being wrapped in approximately 1 μm of myelin sheath. In addition to myelination, oligodendrocytes provide metabolic and structural support to neurons and other glial cells in the CNS. ")
            output$type_img <- renderImage({
                return(list(
                    src = "www/oligo.png",
                    filetype = "image/png",
                    alt = "oligodendrocyte"
                ))
            }, deleteFile = FALSE)
        }
    })
    
    output$raster2 <-renderPlot({
        if (is.null(img2())){
            NULL
        }
        else{
            req(img2())
            EBImage::display(img2(), method = "raster")
        }
        
    })
    
}
