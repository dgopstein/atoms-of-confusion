test: build
	./test.sh orig_files/prog.c endoh2.c

build: FORCE
	gcc endoh2.c -o bin/endoh2

scratch:
	gcc scratch.c -o bin/scratch && bin/scratch

FORCE:
