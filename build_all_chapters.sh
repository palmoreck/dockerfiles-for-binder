#!/bin/bash

#first argument have number of chapters that we will like to build

number_of_chapters=$(find analisis-numerico-computo-cientifico/libro_optimizacion/temas/ -maxdepth 1 -name "[1-$1]*.*"|wc -l)

for((i = 1; i <= $number_of_chapters; i++));do bash build_chapter.sh $i;done
