FROM joergklein/miniconda:latest

Label Joerg Klein <kwp.klein@gmail.com>

# Install all OS dependencies for fully functional notebook server
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
    git \
    texlive \
    texlive-generic-extra \
    texlive-generic-recommended \
    texlive-latex-recommended \
    texlive-fonts-recommended \
    texlive-xetex \
    lmodern \
    unzip \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install conda and Jupyter
RUN conda update -y conda
RUN conda install -c conda-forge jupyter_nbextensions_configurator \
    jupyterhub \
    jupyterlab \
    numpy \
    matplotlib \
    pandas \
    r-base \
    r-gridextra \
    r-kableextra \
    r-markdown \
    scipy \
    sympy \
    && conda clean -ay

# Install the R kernel
RUN conda install -c r r-irkernel \
    && conda clean -ay

COPY jupyterhub_config.py /

# Create admin user
RUN useradd -ms /bin/bash admin

# Setup application
EXPOSE 8000

CMD ["jupyterhub", "--ip='*'", "--port=8000", "--no-browser", "--allow-root"]

