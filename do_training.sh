#!/bin/sh

ruby generate_lst.rb 
cat generated/*.lst > generated/all.train
/usr/local/fastText/fasttext supervised -input generated/all.train -output generated/all -dim 30 -lr 1.0 -epoch 25
