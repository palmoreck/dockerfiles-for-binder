FROM ubuntu:bionic

ENV JUPYTERLAB_VERSION=1.1.0
ENV USER_BINDER jovyan
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && echo "America/Mexico_City" > /etc/timezone && apt-get install -y tzdata

RUN apt-get update && apt-get install -y \
			build-essential \
			gfortran \
	                sudo \
                        nano \
                        less \
                        git \
			htop \
                        python3-dev \
                        python3-pip \
                        python3-setuptools \
                        nodejs \
                        software-properties-common \
			linux-tools-$(uname -r) linux-tools-generic \
		        valgrind && pip3 install --upgrade pip

RUN groupadd ${USER_BINDER}
RUN useradd ${USER_BINDER} -g ${USER_BINDER} -m -s /bin/bash
RUN echo 'jovyan ALL=(ALL:ALL) NOPASSWD:ALL' | (EDITOR='tee -a' visudo)
RUN echo 'jovyan:qwerty' | chpasswd
RUN pip3 install jupyter jupyterlab==$JUPYTERLAB_VERSION --upgrade

#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | sudo apt-key add - && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'

USER ${USER_BINDER}

RUN jupyter notebook --generate-config && sed -i "s/#c.NotebookApp.password = .*/c.NotebookApp.password = u'sha1:115e429a919f:21911277af52f3e7a8b59380804140d9ef3e2380'/" /home/jovyan/.jupyter/jupyter_notebook_config.py

ENV HOME /home/${USER_BINDER}

COPY run_installations.sh ${HOME}

RUN sudo chmod +x ${HOME}/run_installations.sh

