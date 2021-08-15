#!/bin/bash
NB_USER=jovyan
HOME=/home/${NB_USER}
cd ${HOME} && git clone -b master --single-branch https://github.com/ITAM-DS/analisis-numerico-computo-cientifico.git
mv _toc.yml analisis-numerico-computo-cientifico/libro_optimizacion/temas/ && pip install networkx && jb build . --builder pdfhtml 
exec "$@"
