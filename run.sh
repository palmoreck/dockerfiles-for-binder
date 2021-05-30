#!/bin/bash
NB_USER=jovyan
HOME=/home/${NB_USER}
cd ${HOME} && git clone -b main --single-branch https://github.com/ITAM-DS/Propedeutico.git

exec "$@"
