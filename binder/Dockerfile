FROM palmoreck/jupyterlab_c_kernel_binder:1.1.0
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

USER ${NB_USER}

COPY run.sh ${HOME}
RUN ["sudo", "chmod", "+x", "/home/jovyan/run.sh"]

ENTRYPOINT ["/home/jovyan/run.sh"]

CMD ["sh", "-c", "jupyter notebook --port=$JUPYTERPORT --ip=0.0.0.0 --no-browser"]

