#!/bin/bash

unset DISPLAY

for file in ~/.bash/*.bash; do
	source $file
done
