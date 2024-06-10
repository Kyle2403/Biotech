# How to run our code?

## Workflow (Order to run code files)
We use both Python and R for this task

* image_extract_script.Rmd located in data/scripts, is used for retrieving all the image data that we need during this project and saving to data/data_processed directory, the current directory should already have all data needed. If you would like to use it, run every code in this script. 

* plot.ipynb is located in the main directory, where we train, evaluate models. All the plots from the report are from this notebook. If you want to run it, please read the IMPORTANT note at the beginning to avoid wasting time. We also used code to save all our plots in the figures directory.

* shiny_app directory has a lot of code files, all are for the proper function of the application. It needs the model from plot.ipynb to work, which should already be in this directory. To run the shiny app, go to that directory, open ui.R and hit "Run App" at the top right corner to launch.

Thus our workflow is: Extract data using image_extract_script.Rmd -> Train and evaluate using plot.ipynb -> Run ui.R in shiny_app (since the shiny app uses the final model created by the plot.ipynb)


## Libraries
For the plot.ipynb, we install the following libs:

* Install numpy: pip install numpy

* Install pandas: pip install pandas

* Install PyTorch, torchvision, torchaudio, and torchmetrics: pip3 install torch torchvision torchaudio torchmetrics --index-url https://download.pytorch.org/whl/cu118

* Install scikit-learn: pip install scikit-learn

* Install matplotlib (including updates): python -m pip install -U matplotlib

* Install OpenCV: pip install opencv-python

* Install seaborn: pip install seaborn

* Install Pillow: pip install Pillow

For the shiny app, we install the following libs:

* Install torch: install.packages("torch")

* Install torchvision: install.packages("torchvision")
