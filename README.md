Instructions to build docker image.

Version `palmoreck/jupyterlab_prope_r_kernel_tidyverse_binder_test_4:3.4.3` was built from `palmoreck/jupyterlab_prope_r_kernel_tidyverse_binder_test:3.4.3` using `exec` in container, installing:

```
install.packages(c("gss", "fBasics", "combinat"), lib="/usr/local/lib/R/site-library/")

install.packages("fAsianOptions", repos="http://R-Forge.R-project.org",lib="/usr/local/lib/R/site-library/")

install.packages("https://cran.r-project.org/src/contrib/Archive/prob/prob_1.0-1.tar.gz", repo=NULL, type="source",lib="/usr/local/lib/R/site-library/")
```

and then `docker commit`. Possibly if `pyppeteer` is installed before jupyterlab this will solve issue [#6](https://github.com/palmoreck/dockerfiles-for-binder/issues/6)

Set:

```
JUPYTERLAB_VERSION=3.4.3
REPO_URL=palmoreck/jupyterlab_prope_r_kernel_tidyverse_binder_test_4
DIR=/home/<user>/<midir>/
BUILD_DIR=$DIR/3.4.3/
CONTAINER_NAME=jupyterlab-prope-r-kernel-tidyverse
```

Clone:

```
git clone --single-branch -b jupyterlab_prope_r_kernel_tidyverse https://github.com/palmoreck/dockerfiles-for-binder.git $DIR
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
jupyter-nbconvert --to webpdf <name of notebook>.ipynb
```

And if a pdf compressed is wanted then use:

```
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dDownsampleColorImages=true -dColorImageResolution=150 \
-dNOPAUSE -dQUIET -dBATCH -sOutputFile=<name of notebook compressed>.pdf <name of notebook>.pdf
```

according to: [how-can-i-reduce-the-file-size-of-a-scanned-pdf-file](https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file)

