#!/bin/bash

cd analisis-numerico-computo-cientifico/libro_optimizacion/temas/
mv _toc3.yml _toc.yml
jb build . --builder pdfhtml
mv _build/pdf/book.pdf _build/pdf/chapter3_opt_book.pdf
