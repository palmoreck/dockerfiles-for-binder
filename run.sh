#!/bin/bash
NB_USER=jovyan
HOME=/home/${NB_USER}
cd ${HOME} && git clone https://github.com/ITAM-DS/analisis-numerico-computo-cientifico.git
/usr/local/bin/jupyter lab --ip=0.0.0.0 --no-browser
