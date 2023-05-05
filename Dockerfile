FROM nvidia/cuda:11.7.1-devel-ubuntu20.04

Label Calvaria <Zhiyao20021123@gmail.com>

# Install all OS dependencies for fully functional notebook server
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    python3 \ 
    git \
    texlive \
    texlive-fonts-recommended \
    texlive-plain-generic \
    texlive-xetex \
    unzip \
    vim \
    pip \
    nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Install python and some else
RUN pip install --upgrade pip ipython ipykernel jupyterhub jupyterlab \
     scipy sympy torch torchaudio torchvision tensorflow \
    numpy opencv-python opencv-contrib-python pandas matplotlib cmake \
    jupyter-nbextensions-configurator

RUN npm install -g configurable-http-proxy

COPY jupyterhub_config.py /

# Create admin user
RUN useradd -ms /bin/bash admin

# Setup application
EXPOSE 8000

CMD ["jupyterhub", "--ip='*'", "--port=8000", "--no-browser", "--allow-root"]

