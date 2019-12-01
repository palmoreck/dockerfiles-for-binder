Instructions to build docker image. Set:

```
JUPYTERLAB_VERSION=1.1.0
REPO_URL=palmoreck/jupyterlab_c_kernel_binder
BUILD_DIR=/home/user/midir
```

Build:

```
docker build $BUILD_DIR --force-rm -t $REPO_URL:$JUPYTERLAB_VERSION
```

Run:

```
docker run -v $(pwd):/datos --name jupyterlab-c-kernel-local -p 8888:8888 -d $REPO_URL:$JUPYTERLAB_VERSION \
/usr/local/bin/jupyter lab --ip=0.0.0.0 --no-browser
```

or:

```
docker run --rm -v $(pwd):/datos --name jupyterlab-c-kernel-local -p 8888:8888 -d $REPO_URL:$JUPYTERLAB_VERSION \
/usr/local/bin/jupyter lab --ip=0.0.0.0 --no-browser
```


## jupyter lab running at localhost:8888 , password: qwerty

(not necessary) Enter to docker container with:

```
docker exec -it -u=jovyan jupyterlab-c-kernel-local bash
```

Stop:

```
docker stop jupyterlab-c-kernel-local
```

Delete (if `--rm` wasn't used):


```
docker rm jupyterlab-c-kernel-local
```


