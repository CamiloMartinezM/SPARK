#!/bin/bash

# Source the mamba configuration
source configure_environment.sh

# Create the environment if it doesn't exist
if ! micromamba env list | awk '{print $1}' | grep -qx "$ENV_NAME"; then
    echo "Creating environment $ENV_NAME..."
    micromamba create -n $ENV_NAME python=3.9 -c conda-forge -c nvidia -c pytorch -y
else
    echo "Environment $ENV_NAME already exists. Skipping creation."
fi

# Activate the environment
eval "$(micromamba shell hook --shell bash)"
micromamba activate $ENV_NAME

#################### MultiFLARE ####################

pip install --upgrade pip wheel 
pip install setuptools==76

# pip install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/$PYTORCH_CUDA_VERSION
# pip install git+https://github.com/facebookresearch/pytorch3d.git

micromamba config set channel_priority flexible
micromamba install -y ffmpeg 
micromamba config set channel_priority strict
micromamba install pytorch=1.13.0 torchvision=0.14.0 pytorch3d pytorch-cuda=11.6 -c pytorch -c nvidia -c pytorch3d -y

pip install iopath
pip install ninja

pip install git+https://github.com/NVlabs/nvdiffrast/
pip install --global-option="--no-networks" git+https://github.com/NVlabs/tiny-cuda-nn#subdirectory=bindings/torch
pip install gpytoolbox opencv-python meshzoo trimesh matplotlib chumpy lpips configargparse open3d wandb
pip install xatlas
pip install git+https://github.com/jonbarron/robust_loss_pytorch

#################### TrackerAdaptation ####################

# Many of these dependencies are not used - they are here so we can import the code of DECA/EMOCA without errors.
pip install mediapipe==0.10.11
pip install timm~=0.9.16 adabound~=0.0.5 compress-pickle~=1.2.0 face-alignment==1.3.4 facenet-pytorch~=2.5.1 imgaug==0.4.0 albumentations==1.4.8 scikit-video==1.1.11
pip install omegaconf pytorch-lightning==1.4.9 torchmetrics==0.6.2 hickle munch torchfile

############################################################

# We need a specific version of numpy to pickle-load FLAME.
# However, our dependencies have likely upgraded numpy, so we need to reinstall the correct version.
# This will probably throw a warning.
pip install 'numpy<2'

# For downloading pre-trained models
pip install gdown

#################### Environment Variables Setup ####################
source setup_envars.sh

