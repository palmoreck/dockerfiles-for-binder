#!/bin/bash
NB_USER=jovyan
HOME=/home/${NB_USER}
cd ${HOME} && git clone -b master --single-branch https://github.com/ITAM-DS/analisis-numerico-computo-cientifico.git

exec "$@"
