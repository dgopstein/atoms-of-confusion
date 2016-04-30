#!/bin/sh

#sqlite3 confusion.db <<!
#.headers on
#.mode csv
#.output out.csv
#select * from $1;
#!

sqlite3 -header -csv confusion.db "select * from $1;"

