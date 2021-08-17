#!/bin/bash

cd analisis-numerico-computo-cientifico/libro_optimizacion/temas/
cp old_tocs/_toc4.yml _toc.yml
jb build . --builder pdfhtml
mv _build/pdf/book.pdf _build/pdf/chapter4_opt_book.pdf
