FROM ubuntu:20.04

ENV TIMEZONE America/Mexico_City
ENV JUPYTERLAB_VERSION 3.1.0
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEB_BUILD_DEPS="python3-dev python3-pip python3-setuptools software-properties-common libgit2-dev dirmngr"
ENV DEB_PACKAGES="sudo nano less time git curl wget htop" 
#ghostscript to compress pdf
ENV PIP_PACKAGES="numpy scipy matplotlib pandas seaborn sympy"

ENV R_KEY="E298A3A825C0D65DFD57CBB651716619E084DAB9"
ENV R_DEB_BUILD_DEPS="focal-cran40 r-base libssl-dev libxml2-dev libcurl4-openssl-dev"
ENV R_SITE_LIBRARY="/usr/local/lib/R/site-library"
ENV R_PACKAGES="var=\"repr IRdisplay evaluate crayon pbdZMQ devtools uuid digest tidyverse\""

ENV USER_BINDER jovyan

RUN apt-get update && export $DEBIAN_FRONTEND && \
    echo $TIMEZONE > /etc/timezone && apt-get install -y tzdata

RUN apt-get update && apt-get install -y $DEB_BUILD_DEPS $DEB_PACKAGES && pip3 install --upgrade pip

# Install nodejs deps
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && apt-get install -y nodejs

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $R_KEY && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" && \
    apt-get update && \
    apt-get install -yt $R_DEB_BUILD_DEPS

#install chrome to build pdf
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt update -y && apt install -y google-chrome-stable
    

RUN groupadd ${USER_BINDER}
RUN useradd ${USER_BINDER} -g ${USER_BINDER} -m -s /bin/bash
RUN echo 'jovyan ALL=(ALL:ALL) NOPASSWD:ALL' | (EDITOR='tee -a' visudo)
RUN echo 'jovyan:qwerty' | chpasswd
RUN pip3 install jupyter jupyterlab==$JUPYTERLAB_VERSION
USER ${USER_BINDER}

RUN jupyter notebook --generate-config && sed -i "s/# c.NotebookApp.password = .*/c.NotebookApp.password = u'sha1:115e429a919f:21911277af52f3e7a8b59380804140d9ef3e2380'/" ~/.jupyter/jupyter_notebook_config.py

RUN pip3 install $PIP_PACKAGES

#r kernel and packages
RUN echo $R_PACKAGES >  ~/.Renviron && \
    sudo chmod gou+w $R_SITE_LIBRARY && \
    R -e 'install.packages(strsplit(system("echo $var", intern=TRUE)," ")[[1]], lib="/usr/local/lib/R/site-library/")' && \
    R -e 'devtools::install_github("IRkernel/IRkernel")' && \
    sudo R -e 'IRkernel::installspec(user=FALSE)'
    
RUN sudo chmod gou+wx -R ~/.local

