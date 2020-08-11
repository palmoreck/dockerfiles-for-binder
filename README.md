Instructions to build docker image. Set:

```
JUPYTERLAB_VERSION=2.1.4
REPO_URL=palmoreck/jupyterlab_optimizacion_binder_test
DIR=/home/<user>/<midir>/
BUILD_DIR=$DIR/2.1.4/
CONTAINER_NAME=jupyterlab-optimizacion-binder
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

## Changes for `palmoreck/jupyterlab_optimizacion_binder_test_for_pdf:2.1.4`

Via binder is possible to build pdf using functionality of [jupyter book pdf](https://jupyterbook.org/advanced/pdf.html). Then a new docker image was tagged:

```
JUPYTERLAB_VERSION=2.1.4
REPO_URL=palmoreck/jupyterlab_optimizacion_binder_test_for_pdf
CONTAINER_NAME=jupyterlab-optimizacion-binder
```

Then 

```
docker run --rm -v $(pwd):/datos --name ${CONTAINER_NAME} -p 8888:8888 -d $REPO_URL:$JUPYTERLAB_VERSION \
/usr/local/bin/jupyter lab --ip=0.0.0.0 --no-browser
```

And install some dependencies and make some changes manually (this could be incorporated in [2.1.4/Dockerfile](2.1.4/Dockerfile)):

```
sudo apt install ghostscript #para comprimir pdf

pip3 install --user pyppeteer
```

Change to root:

```
sudo su
```

Using instructions from [pyppeteer-browser-closed-unexpectedly-in-aws-lambda](https://stackoverflow.com/questions/61780476/pyppeteer-browser-closed-unexpectedly-in-aws-lambda)

```
curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt update -y && apt install -y google-chrome-stable
```

Change file: `/home/jovyan/.local/lib/python3.7/site-packages/jupyter_book/pdf.py` in line: `browser=...` to:

```
browser = await launch(executablePath='/usr/bin/google-chrome-stable', headless=True, args=['--no-sandbox'])
```

Change file: `/home/jovyan/.local/lib/python3.7/site-packages/pyppeteer/page.py` in line: `30000 #milliseconds` to:

```
self._defaultNavigationTimeout = 30000000000  # milliseconds
```

Commit and tag docker image:

```
docker commit ${CONTAINER_NAME} palmoreck/jupyterlab_optimizacion_binder_test_for_pdf:2.1.4
```

Push:

```
docker push palmoreck/jupyterlab_optimizacion_binder_test_for_pdf:2.1.4
```

Pdf can be built with:

```
jb build . --builder pdfhtml
```

And if compress pdf is wanted then use:

```
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dDownsampleColorImages=true -dColorImageResolution=150 \
-dNOPAUSE -dQUIET -dBATCH -sOutputFile=libro_optimizacion_compressed.pdf libro_optimizacion.pdf
```

according to: [how-can-i-reduce-the-file-size-of-a-scanned-pdf-file](https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file)

