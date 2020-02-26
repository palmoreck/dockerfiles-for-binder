FROM ubuntu:bionic

ENV JUPYTERLAB_VERSION 1.1.0
ENV USER_BINDER jovyan
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && echo "America/Mexico_City" > /etc/timezone && apt-get install -y tzdata

RUN apt-get update && apt-get install -y \
            sudo \
            nano \
            less \
            git \
            python3-dev \
            python3-pip \
            python3-setuptools \
            nodejs \
            software-properties-common && pip3 install --upgrade pip
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' && \
    apt-get update && \
    apt-get install -y r-base libssl-dev libxml2-dev libcurl4-openssl-dev

RUN groupadd ${USER_BINDER}
RUN useradd ${USER_BINDER} -g ${USER_BINDER} -m -s /bin/bash
RUN echo 'jovyan ALL=(ALL:ALL) NOPASSWD:ALL' | (EDITOR='tee -a' visudo)
RUN echo 'jovyan:qwerty' | chpasswd
RUN pip3.6 install jupyter jupyterlab==$JUPYTERLAB_VERSION --upgrade
USER ${USER_BINDER}
RUN jupyter notebook --generate-config && sed -i "s/#c.NotebookApp.password = .*/c.NotebookApp.password = u'sha1:115e429a919f:21911277af52f3e7a8b59380804140d9ef3e2380'/" /home/${USER_BINDER}/.jupyter/jupyter_notebook_config.py

RUN sudo chmod gou+wrx -R /usr/local/lib/R/site-library && \
    sudo R -e 'install.packages(c("repr", "IRdisplay", "evaluate", "crayon", "pbdZMQ", "devtools", "uuid", "digest"), lib="/usr/local/lib/R/site-library/")' && \
    R -e 'devtools::install_github("IRkernel/IRkernel")' && \
    sudo R -e 'IRkernel::installspec(user=FALSE)' && \
    sudo R -e 'install.packages("tidyverse")'

RUN sudo chmod gou+wx -R /home/${USER_BINDER}/.local
