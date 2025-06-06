# ###########################################################################
#                     Install the SDL Command Line Tools 
#                (require python 3.11) in a virtual environment
# see https://sdlctl.readthedocs.io/latest/getting_started/installation/
# ###########################################################################

# That's what I did on our gateway machine sshproxy-m.geophysik...
# 1. Update conda 
#    not sure if this helped, conda is quite outdated on that machine
conda update -n base -c defaults conda
# 2. Create and activate conda environment
conda create --name sdlvenv
conda activate sdlvenv
# 3. Install python 3.11 in the conda environment and check if that worked
conda install python=3.11
python3 -V
# 4. Install sdlctl package from CINECA
#    Check if you're using the right pip path, which pip should be /path_to_venv/bin/pip
pip install sdlctl --index-url https://gitlab.hpc.cineca.it/api/v4/projects/1647/packages/pypi/simple
# 4b. Alternatively one could download the package from gitlab and install via pip
# 5. Activate autocompletion by adding this to ~/.bashrc
# eval "$(_SDLCTL_COMPLETE=bash_source sdlctl)"
# 6. Upgrade the package (inside sdlvenv)
pip install sdlctl -U --index-url https://gitlab.hpc.cineca.it/api/v4/projects/1647/packages/pypi/simple


# ######################################################## #
#                Upload data to the SDL
# ######################################################## #
# Use Skript PrepareData4SDLUpload first, see
# https://github.com/christadler/SeisSol_Postprocessing/blob/main/PrepareData4SDLUpload.sh

# logout first if you want to change the SDL environment
# to revoke automatic user authentication
# sdlctl user logout

# set right SDL environment [prod|dev]
sdlctl setenv prod

# login with your credentials
sdlctl user login

# Use the wizard to create the .json file
sldctl wizard AltoTiberinaCatalog

# Now, create the experiment first (this will return the experiment ID
sdlctl experiment bulk -f metadata.json

# Now Upload all the data (path is empty, version latest:) ... this will take a while
#sdlctl file bulk -id <id> -lp AltoTiberinaCatalog
sdlctl file bulk -id 41 -lp AltoTiberinaCatalog
