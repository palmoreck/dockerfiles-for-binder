#!/bin/bash
#first argument number of chapter: build_chapter.sh 1
cd analisis-numerico-computo-cientifico/libro_optimizacion/temas/
cp old_tocs/_toc$(echo $1).yml _toc.yml
jb build . --builder pdfhtml
mv _build/pdf/book.pdf _build/pdf/chapter$(echo $1)_opt_book.pdf
