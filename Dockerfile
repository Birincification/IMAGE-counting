FROM rocker/r-ver:3.5.3


RUN apt-get update --fix-missing -qq && \
    apt-get install -y -q \
    vim \
    git \
    python3 \
    python3-pip \
    python \
    python-pip \
    libz-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev \
    libpng-dev \
    libjpeg-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libgl-dev \
    libgsl-dev \
    && apt-get clean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
RUN pip3 install numpy pandas
#
RUN R -e 'install.packages(c("devtools", "BiocManager", "argparse"))'
RUN R -e 'BiocManager::install("tximport")'
RUN R -e 'BiocManager::install("rhdf5")'
#
ADD software /home/software
ADD data /home/data
ADD scripts /home/scripts



