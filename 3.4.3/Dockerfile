FROM ubuntu:20.04

ENV TIMEZONE America/Mexico_City
ENV JUPYTERLAB_VERSION 3.4.3
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEB_BUILD_DEPS="gfortran python3-dev python3-pip python3-setuptools software-properties-common dirmngr"
ENV DEB_PACKAGES="sudo nano less git nodejs curl wget htop libblas-dev liblapack-dev"
ENV PIP_PACKAGES="numpy scipy matplotlib pandas seaborn plotly sympy pyppeteer"

ENV R_KEY="E298A3A825C0D65DFD57CBB651716619E084DAB9"
ENV R_DEB_BUILD_DEPS="r-base libssl-dev libxml2-dev libcurl4-openssl-dev"
ENV R_SITE_LIBRARY="/usr/local/lib/R/site-library"
ENV R_PACKAGES="var=\"repr IRdisplay evaluate crayon pbdZMQ devtools uuid digest gss fBasics combinat tidyverse\""

ENV USER_BINDER jovyan

RUN apt update && export $DEBIAN_FRONTEND && \
    echo $TIMEZONE > /etc/timezone && apt install -y tzdata

RUN apt update && apt install -y $DEB_BUILD_DEPS $DEB_PACKAGES && \
    pip3 install --upgrade pip
    
# Install nodejs deps
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash - && apt-get install -y nodejs

#R installation
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $R_KEY && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" && \
    apt update && \
    apt install -y --no-install-recommends $R_DEB_BUILD_DEPS
    
    
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
#effectively load password and configs
RUN cp ~/.jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_server_config.py


RUN pip3 install $PIP_PACKAGES

#install chromium and allow no-sandbox flag, see: https://github.com/jupyter/nbconvert/issues/1434
RUN python3 -c 'import pyppeteer; pyppeteer.chromium_downloader.download_chromium()' && \
    sed -i "/'--password-store=basic',/a \ \ \ \ '--no-sandbox'," ~/.local/lib/python3.8/site-packages/pyppeteer/launcher.py

#make some changes according to https://github.com/palmoreck/dockerfiles-for-binder/tree/cc3c524e46ba11f9dbf8895ec2c02c335579ec48#changes-for-palmoreckjupyterlab_optimizacion_2_binder_test_for_pdf300
RUN python_version=$(ls ~/.local/lib/|grep python) && \
    sed -i "s/self._defaultNavigationTimeout = 30000/self._defaultNavigationTimeout = 30000000000/" ~/.local/lib/$python_version/site-packages/pyppeteer/page.py

#c kernel
RUN sudo chmod gou+wrx -R /usr/local/share/jupyter/kernels/
RUN python_version=$(ls ~/.local/lib/|grep python) && pip3 install --user git+https://github.com/brendan-rius/jupyter-c-kernel.git && python3 ~/.local/lib/$python_version/site-packages/jupyter_c_kernel/install_c_kernel --prefix=/usr/local/

#r kernel
#for prob fAsianOptions, gss, fBasics combinat are needed
RUN echo $R_PACKAGES >  ~/.Renviron && \
    sudo chmod gou+w $R_SITE_LIBRARY && \
    R -e 'install.packages(strsplit(system("echo $var", intern=TRUE)," ")[[1]], lib="/usr/local/lib/R/site-library/")' && \
    R -e 'install.packages("fAsianOptions", repos="http://R-Forge.R-project.org", lib="/usr/local/lib/R/site-library/")' && \
    R -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/prob/prob_1.0-1.tar.gz", repo=NULL, type="source", lib="/usr/local/lib/R/site-library/")' && \
    R -e 'devtools::install_github("IRkernel/IRkernel")' && \
    sudo R -e 'IRkernel::installspec(user=FALSE)'

#julia kernel and packages
RUN julia_version=1.7 && julia_version_2=1.7.1 && \
    sudo mkdir /usr/local/julia-$julia_version_2 && cd ~ && \
    wget https://julialang-s3.julialang.org/bin/linux/x64/$julia_version/julia-$julia_version_2-linux-x86_64.tar.gz && \
    tar zxvf julia-$julia_version_2-linux-x86_64.tar.gz && \
    sudo cp -r julia-$julia_version_2/* /usr/local/julia-$julia_version_2/ && \
    /usr/local/julia-$julia_version_2/bin/julia -e 'using Pkg;Pkg.add("IJulia")' && \
    echo 'export PATH=/usr/local/julia-$julia-version/bin/:$PATH' >> $HOME/.bashrc
#last line could also be: using IJulia;installkernel("Julia (4 threads)", env=Dict("JULIA_NUM_THREADS"=>"4"))

RUN sudo chmod gou+wx -R ~/.local
