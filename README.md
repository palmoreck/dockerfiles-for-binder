Instructions to build docker image. Set:

```
JUPYTERLAB_VERSION=3.1.0
REPO_URL=palmoreck/jupyterlab_jupyter_book
DIR=/home/<user>/<midir>/
BUILD_DIR=$DIR/3.0.0/
CONTAINER_NAME=jupyterlab-jupyter-book
```

Clone:

```
git clone --single-branch -b jupyterlab_jupyter_book https://github.com/palmoreck/dockerfiles-for-binder.git $DIR
```

Build:

```
docker build $BUILD_DIR --force-rm -t $REPO_URL:$JUPYTERLAB_VERSION
```

Run:

```
docker run -v $(pwd):/datos --name ${CONTAINER_NAME} -p 8888:8888 -d $REPO_URL:$JUPYTERLAB_VERSION \
/usr/local/bin/jupyter lab --ip=0.0.0.0 --no-browser
```

or:

```
docker run --rm -v $(pwd):/datos --name ${CONTAINER_NAME} -p 8888:8888 -d $REPO_URL:$JUPYTERLAB_VERSION \
/usr/local/bin/jupyter lab --ip=0.0.0.0 --no-browser
```


## jupyter lab running at localhost:8888 , password: qwerty

(not necessary) Enter to docker container with:

```
docker exec -it -u=jovyan ${CONTAINER_NAME} bash
```

Stop:

```
docker stop ${CONTAINER_NAME}
```

Delete (if `--rm` wasn't used):


```
docker rm ${CONTAINER_NAME}
```

Pdf can be built with:

```
docker run --rm -v $(pwd):/datos --name ${CONTAINER_NAME} -p 8888:8888 -d $REPO_URL:$JUPYTERLAB_VERSION /usr/local/bin/jupyter lab --ip=0.0.0.0 --no-browser
#then go to repo cloned path and:
jb build . --builder pdfhtml
```

And if a pdf compressed is wanted then use:

```
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dDownsampleColorImages=true -dColorImageResolution=150 \
-dNOPAUSE -dQUIET -dBATCH -sOutputFile=libro_optimizacion_compressed.pdf libro_optimizacion.pdf
```

according to: [how-can-i-reduce-the-file-size-of-a-scanned-pdf-file](https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file)

