#!/bin/bash

cd analisis-numerico-computo-cientifico/libro_optimizacion/temas/
mv _toc5.yml _toc.yml
jb build . --builder pdfhtml
mv _build/pdf/book.pdf _build/pdf/chapter5_opt_book.pdf
