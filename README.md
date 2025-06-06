# SeisSol_Postprocessing
Postprocessing steps for DT-Geo workflow

## Step3.sh: Postprocessing scripts
Run script on the outputs directory of SeisSol_ParamStudies

Depending on your setup, you might need to:
* adjust the path to SeisSol
* adjust the conditions of the for-loop for fewer/more catalogue entries
* adjust the path of the directory in which the outputs from the previous block are stored

## PrepareData4SDLUpload.sh: Select data for SDL upload
The script will copy all necessary files in a new directory 

Adjust:
* input_dir: Directory with all input parameters (typically in /work)
* output_dir: Directory with all SeisSol outputs  (typically in /scratch)
* sdl_dir: Directory that will be uploaded to the SDL (typically in /scratch)

## UploadSDL.sh: Install and Upload data to the SDL
This file explains how to install the SDL and how the SDL wizard can be used to upload the data. So far we are using the SDL Command Line Interface, we might later shift to the Python SDK (https://sdlctl.readthedocs.io/latest/sdk/overview/).
